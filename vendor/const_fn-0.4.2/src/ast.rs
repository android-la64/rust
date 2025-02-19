use proc_macro::{Delimiter, Literal, Span, TokenStream, TokenTree};
use std::iter::Peekable;

use crate::{
    to_tokens::ToTokens,
    utils::{parse_as_empty, tt_span},
    Result,
};

pub(crate) struct Func {
    pub(crate) attrs: Vec<Attribute>,
    pub(crate) sig: Vec<TokenTree>,
    pub(crate) body: TokenTree,
    pub(crate) print_const: bool,
}

pub(crate) fn parse_input(input: TokenStream) -> Result<Func> {
    let mut input = input.into_iter().peekable();

    let attrs = parse_attrs(&mut input)?;
    let sig = parse_signature(&mut input);
    let body = input.next();
    parse_as_empty(input)?;

    if body.is_none()
        || !sig
            .iter()
            .any(|tt| if let TokenTree::Ident(i) = tt { i.to_string() == "fn" } else { false })
    {
        return Err(error!(
            Span::call_site(),
            "#[const_fn] attribute may only be used on functions"
        ));
    }
    if !sig
        .iter()
        .any(|tt| if let TokenTree::Ident(i) = tt { i.to_string() == "const" } else { false })
    {
        let span = sig
            .iter()
            .position(|tt| if let TokenTree::Ident(i) = tt { i.to_string() == "fn" } else { false })
            .map(|i| sig[i].span())
            .unwrap();
        return Err(error!(span, "#[const_fn] attribute may only be used on const functions"));
    }

    Ok(Func { attrs, sig, body: body.unwrap(), print_const: true })
}

impl ToTokens for Func {
    fn to_tokens(&self, tokens: &mut TokenStream) {
        self.attrs.iter().for_each(|attr| attr.to_tokens(tokens));
        if self.print_const {
            self.sig.iter().for_each(|attr| attr.to_tokens(tokens));
        } else {
            self.sig
                .iter()
                .filter(
                    |tt| if let TokenTree::Ident(i) = tt { i.to_string() != "const" } else { true },
                )
                .for_each(|tt| tt.to_tokens(tokens));
        }
        self.body.to_tokens(tokens);
    }
}

fn parse_signature(input: &mut Peekable<impl Iterator<Item = TokenTree>>) -> Vec<TokenTree> {
    let mut sig = Vec::new();
    loop {
        match input.peek() {
            Some(TokenTree::Group(group)) if group.delimiter() == Delimiter::Brace => break,
            None => break,
            _ => sig.push(input.next().unwrap()),
        }
    }
    sig
}

fn parse_attrs(input: &mut Peekable<impl Iterator<Item = TokenTree>>) -> Result<Vec<Attribute>> {
    let mut attrs = Vec::new();
    loop {
        let pound_token = match input.peek() {
            Some(TokenTree::Punct(p)) if p.as_char() == '#' => input.next().unwrap(),
            _ => break,
        };
        let group = match input.peek() {
            Some(TokenTree::Group(g)) if g.delimiter() == Delimiter::Bracket => {
                input.next().unwrap()
            }
            tt => return Err(error!(tt_span(tt), "expected `[`")),
        };
        attrs.push(Attribute { pound_token, group });
    }
    Ok(attrs)
}

pub(crate) struct Attribute {
    // `#`
    pub(crate) pound_token: TokenTree,
    // `[...]`
    pub(crate) group: TokenTree,
}

impl ToTokens for Attribute {
    fn to_tokens(&self, tokens: &mut TokenStream) {
        self.pound_token.to_tokens(tokens);
        self.group.to_tokens(tokens);
    }
}

pub(crate) struct LitStr {
    token: Literal,
    value: String,
}

impl LitStr {
    pub(crate) fn new(token: &Literal) -> Result<Self> {
        let value = token.to_string();
        // unlike `syn::LitStr`, only accepts `"..."`
        if value.starts_with('"') && value.ends_with('"') {
            Ok(Self { token: token.clone(), value })
        } else {
            Err(error!(token.span(), "expected string literal"))
        }
    }

    pub(crate) fn value(&self) -> &str {
        &self.value[1..self.value.len() - 1]
    }

    pub(crate) fn span(&self) -> Span {
        self.token.span()
    }
}

impl ToTokens for LitStr {
    fn to_tokens(&self, tokens: &mut TokenStream) {
        self.token.to_tokens(tokens);
    }
}
