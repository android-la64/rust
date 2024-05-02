use std::path::Path;

use crate::{
    parser::{Condition, ErrorMatchKind, Pattern},
    Error,
};

use super::Comments;

#[test]
fn parse_simple_comment() {
    let s = r"
use std::mem;

fn main() {
    let _x: &i32 = unsafe { mem::transmute(16usize) }; //~ ERROR: encountered a dangling reference (address $HEX is unallocated)
}
    ";
    let comments = Comments::parse(s, Comments::default(), Path::new("")).unwrap();
    println!("parsed comments: {:#?}", comments);
    assert_eq!(comments.revisioned.len(), 1);
    let revisioned = &comments.revisioned[&vec![]];
    let ErrorMatchKind::Pattern { pattern, .. } = &revisioned.error_matches[0].kind else {
        panic!("expected pattern matcher");
    };
    assert_eq!(pattern.line().get(), 5);
    match &**pattern {
        Pattern::SubString(s) => {
            assert_eq!(
                s,
                "encountered a dangling reference (address $HEX is unallocated)"
            )
        }
        other => panic!("expected substring, got {other:?}"),
    }
}

#[test]
fn parse_error_code_comment() {
    let s = r"
fn main() {
    let _x: i32 = 0u32; //~ E0308
}
    ";
    let comments = Comments::parse(s, Comments::default(), Path::new("")).unwrap();
    println!("parsed comments: {:#?}", comments);
    assert_eq!(comments.revisioned.len(), 1);
    let revisioned = &comments.revisioned[&vec![]];
    let ErrorMatchKind::Code(code) = &revisioned.error_matches[0].kind else {
        panic!("expected diagnostic code matcher");
    };
    assert_eq!(code.line().get(), 3);
    assert_eq!(**code, "E0308");
}

#[test]
fn parse_missing_level() {
    let s = r"
use std::mem;

fn main() {
    let _x: &i32 = unsafe { mem::transmute(16usize) }; //~ encountered a dangling reference (address $HEX is unallocated)
}
    ";
    let errors = Comments::parse(s, Comments::default(), Path::new("")).unwrap_err();
    println!("parsed comments: {:#?}", errors);
    assert_eq!(errors.len(), 1);
    match &errors[0] {
        Error::InvalidComment { msg, span } if span.line_start.get() == 5 => {
            assert_eq!(msg, "text found after error code `encountered`")
        }
        _ => unreachable!(),
    }
}

#[test]
fn parse_slash_slash_at() {
    let s = r"
//@  error-in-other-file:  foomp
use std::mem;

    ";
    let comments = Comments::parse(s, Comments::default(), Path::new("")).unwrap();
    println!("parsed comments: {:#?}", comments);
    assert_eq!(comments.revisioned.len(), 1);
    let revisioned = &comments.revisioned[&vec![]];
    let pat = &revisioned.error_in_other_files[0];
    assert_eq!(format!("{:?}", **pat), r#"SubString("foomp")"#);
    assert_eq!(pat.line().get(), 2);
}

#[test]
fn parse_regex_error_pattern() {
    let s = r"
//@  error-in-other-file:  /foomp/
use std::mem;

    ";
    let comments = Comments::parse(s, Comments::default(), Path::new("")).unwrap();
    println!("parsed comments: {:#?}", comments);
    assert_eq!(comments.revisioned.len(), 1);
    let revisioned = &comments.revisioned[&vec![]];
    let pat = &revisioned.error_in_other_files[0];
    assert_eq!(format!("{:?}", **pat), r#"Regex(Regex("foomp"))"#);
    assert_eq!(pat.line().get(), 2);
}

#[test]
fn parse_slash_slash_at_fail() {
    let s = r"
//@  error-patttern  foomp
use std::mem;

    ";
    let errors = Comments::parse(s, Comments::default(), Path::new("")).unwrap_err();
    println!("parsed comments: {:#?}", errors);
    assert_eq!(errors.len(), 2);
    match &errors[0] {
        Error::InvalidComment { msg, span } if span.line_start.get() == 2 => {
            assert!(msg.contains("must be followed by `:`"))
        }
        _ => unreachable!(),
    }
    match &errors[1] {
        Error::InvalidComment { msg, span } if span.line_start.get() == 2 => {
            assert_eq!(msg, "`error-patttern` is not a command known to `ui_test`, did you mean `error-pattern`?");
        }
        _ => unreachable!(),
    }
}

#[test]
fn missing_colon_fail() {
    let s = r"
//@stderr-per-bitwidth hello
use std::mem;

    ";
    let errors = Comments::parse(s, Comments::default(), Path::new("")).unwrap_err();
    println!("parsed comments: {:#?}", errors);
    assert_eq!(errors.len(), 1);
    match &errors[0] {
        Error::InvalidComment { msg, span } if span.line_start.get() == 2 => {
            assert!(msg.contains("must be followed by `:`"))
        }
        _ => unreachable!(),
    }
}

#[test]
fn parse_x86_64() {
    let s = r"//@ only-target-x86_64-unknown-linux";
    let comments = Comments::parse(s, Comments::default(), Path::new("")).unwrap();
    println!("parsed comments: {:#?}", comments);
    assert_eq!(comments.revisioned.len(), 1);
    let revisioned = &comments.revisioned[&vec![]];
    assert_eq!(revisioned.only.len(), 1);
    match &revisioned.only[0] {
        Condition::Target(t) => assert_eq!(t, "x86_64-unknown-linux"),
        _ => unreachable!(),
    }
}
