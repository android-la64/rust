//! This module contains tests for macro expansion. Effectively, it covers `tt`,
//! `mbe`, `proc_macro_api` and `hir_expand` crates. This might seem like a
//! wrong architecture at the first glance, but is intentional.
//!
//! Physically, macro expansion process is intertwined with name resolution. You
//! can not expand *just* the syntax. So, to be able to write integration tests
//! of the "expand this code please" form, we have to do it after name
//! resolution. That is, in this crate. We *could* fake some dependencies and
//! write unit-tests (in fact, we used to do that), but that makes tests brittle
//! and harder to understand.

mod mbe;
mod builtin_fn_macro;
mod builtin_derive_macro;
mod proc_macros;

use std::{iter, ops::Range};

use base_db::{fixture::WithFixture, SourceDatabase};
use expect_test::Expect;
use hir_expand::{db::AstDatabase, InFile, MacroFile};
use stdx::format_to;
use syntax::{
    ast::{self, edit::IndentLevel},
    AstNode,
    SyntaxKind::{COMMENT, EOF, IDENT, LIFETIME_IDENT},
    SyntaxNode, T,
};

use crate::{
    db::DefDatabase, nameres::ModuleSource, resolver::HasResolver, src::HasSource, test_db::TestDB,
    AdtId, AsMacroCall, Lookup, ModuleDefId,
};

#[track_caller]
fn check(ra_fixture: &str, mut expect: Expect) {
    let db = TestDB::with_files(ra_fixture);
    let krate = db.crate_graph().iter().next().unwrap();
    let def_map = db.crate_def_map(krate);
    let local_id = def_map.root();
    let module = def_map.module_id(local_id);
    let resolver = module.resolver(&db);
    let source = def_map[local_id].definition_source(&db);
    let source_file = match source.value {
        ModuleSource::SourceFile(it) => it,
        ModuleSource::Module(_) | ModuleSource::BlockExpr(_) => panic!(),
    };

    // What we want to do is to replace all macros (fn-like, derive, attr) with
    // their expansions. Turns out, we don't actually store enough information
    // to do this precisely though! Specifically, if a macro expands to nothing,
    // it leaves zero traces in def-map, so we can't get its expansion after the
    // fact.
    //
    // This is the usual
    // <https://github.com/rust-analyzer/rust-analyzer/issues/3407>
    // resolve/record tension!
    //
    // So here we try to do a resolve, which is necessary a heuristic. For macro
    // calls, we use `as_call_id_with_errors`. For derives, we look at the impls
    // in the module and assume that, if impls's source is a different
    // `HirFileId`, than it came from macro expansion.

    let mut expansions = Vec::new();
    for macro_call in source_file.syntax().descendants().filter_map(ast::MacroCall::cast) {
        let macro_call = InFile::new(source.file_id, &macro_call);
        let mut error = None;
        let macro_call_id = macro_call
            .as_call_id_with_errors(
                &db,
                krate,
                |path| resolver.resolve_path_as_macro(&db, &path),
                &mut |err| error = Some(err),
            )
            .unwrap()
            .unwrap();
        let macro_file = MacroFile { macro_call_id };
        let mut expansion_result = db.parse_macro_expansion(macro_file);
        expansion_result.err = expansion_result.err.or(error);
        expansions.push((macro_call.value.clone(), expansion_result));
    }

    let mut expanded_text = source_file.to_string();

    for (call, exp) in expansions.into_iter().rev() {
        let mut tree = false;
        let mut expect_errors = false;
        for comment in call.syntax().children_with_tokens().filter(|it| it.kind() == COMMENT) {
            tree |= comment.to_string().contains("+tree");
            expect_errors |= comment.to_string().contains("+errors");
        }

        let mut expn_text = String::new();
        if let Some(err) = exp.err {
            format_to!(expn_text, "/* error: {} */", err);
        }
        if let Some((parse, _token_map)) = exp.value {
            if expect_errors {
                assert!(!parse.errors().is_empty(), "no parse errors in expansion");
                for e in parse.errors() {
                    format_to!(expn_text, "/* parse error: {} */\n", e);
                }
            } else {
                assert!(
                    parse.errors().is_empty(),
                    "parse errors in expansion: \n{:#?}",
                    parse.errors()
                );
            }
            let pp = pretty_print_macro_expansion(parse.syntax_node());
            let indent = IndentLevel::from_node(call.syntax());
            let pp = reindent(indent, pp);
            format_to!(expn_text, "{}", pp);

            if tree {
                let tree = format!("{:#?}", parse.syntax_node())
                    .split_inclusive("\n")
                    .map(|line| format!("// {}", line))
                    .collect::<String>();
                format_to!(expn_text, "\n{}", tree)
            }
        }
        let range = call.syntax().text_range();
        let range: Range<usize> = range.into();
        expanded_text.replace_range(range, &expn_text)
    }

    for decl_id in def_map[local_id].scope.declarations() {
        if let ModuleDefId::AdtId(AdtId::StructId(struct_id)) = decl_id {
            let src = struct_id.lookup(&db).source(&db);
            if src.file_id.is_attr_macro(&db) || src.file_id.is_custom_derive(&db) {
                let pp = pretty_print_macro_expansion(src.value.syntax().clone());
                format_to!(expanded_text, "\n{}", pp)
            }
        }
    }

    for impl_id in def_map[local_id].scope.impls() {
        let src = impl_id.lookup(&db).source(&db);
        if src.file_id.is_builtin_derive(&db).is_some() {
            let pp = pretty_print_macro_expansion(src.value.syntax().clone());
            format_to!(expanded_text, "\n{}", pp)
        }
    }

    expect.indent(false);
    expect.assert_eq(&expanded_text);
}

fn reindent(indent: IndentLevel, pp: String) -> String {
    if !pp.contains('\n') {
        return pp;
    }
    let mut lines = pp.split_inclusive('\n');
    let mut res = lines.next().unwrap().to_string();
    for line in lines {
        if line.trim().is_empty() {
            res.push_str(&line)
        } else {
            format_to!(res, "{}{}", indent, line)
        }
    }
    res
}

fn pretty_print_macro_expansion(expn: SyntaxNode) -> String {
    let mut res = String::new();
    let mut prev_kind = EOF;
    let mut indent_level = 0;
    for token in iter::successors(expn.first_token(), |t| t.next_token()) {
        let curr_kind = token.kind();
        let space = match (prev_kind, curr_kind) {
            _ if prev_kind.is_trivia() || curr_kind.is_trivia() => "",
            (T!['{'], T!['}']) => "",
            (T![=], _) | (_, T![=]) => " ",
            (_, T!['{']) => " ",
            (T![;] | T!['{'] | T!['}'], _) => "\n",
            (_, T!['}']) => "\n",
            (IDENT | LIFETIME_IDENT, IDENT | LIFETIME_IDENT) => " ",
            _ if prev_kind.is_keyword() && curr_kind.is_keyword() => " ",
            (IDENT, _) if curr_kind.is_keyword() => " ",
            (_, IDENT) if prev_kind.is_keyword() => " ",
            (T![>], IDENT) => " ",
            (T![>], _) if curr_kind.is_keyword() => " ",
            (T![->], _) | (_, T![->]) => " ",
            (T![&&], _) | (_, T![&&]) => " ",
            (T![,], _) => " ",
            (T![:], IDENT | T!['(']) => " ",
            (T![:], _) if curr_kind.is_keyword() => " ",
            (T![fn], T!['(']) => "",
            (T![']'], _) if curr_kind.is_keyword() => " ",
            (T![']'], T![#]) => "\n",
            _ if prev_kind.is_keyword() => " ",
            _ => "",
        };

        match prev_kind {
            T!['{'] => indent_level += 1,
            T!['}'] => indent_level -= 1,
            _ => (),
        }

        res.push_str(space);
        if space == "\n" {
            let level = if curr_kind == T!['}'] { indent_level - 1 } else { indent_level };
            res.push_str(&"    ".repeat(level));
        }
        prev_kind = curr_kind;
        format_to!(res, "{}", token)
    }
    res
}
