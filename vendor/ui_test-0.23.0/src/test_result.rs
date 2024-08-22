//! Various data structures used for carrying information about test success or failure

use crate::{status_emitter::TestStatus, Error};
use color_eyre::eyre::Result;
use std::process::Command;

/// The possible non-failure results a single test can have.
pub enum TestOk {
    /// The test passed
    Ok,
    /// The test was ignored due to a rule (`//@only-*` or `//@ignore-*`)
    Ignored,
}

/// The possible results a single test can have.
pub type TestResult = Result<TestOk, Errored>;

/// Information about a test failure.
#[derive(Debug)]
pub struct Errored {
    /// Command that failed
    pub(crate) command: Command,
    /// The errors that were encountered.
    pub(crate) errors: Vec<Error>,
    /// The full stderr of the test run.
    pub(crate) stderr: Vec<u8>,
    /// The full stdout of the test run.
    pub(crate) stdout: Vec<u8>,
}

impl Errored {
    /// If no command was executed for this error, use a message instead.
    pub fn new(errors: Vec<Error>, message: &str) -> Self {
        Self {
            errors,
            stderr: vec![],
            stdout: vec![],
            command: Command::new(message),
        }
    }
}

pub(crate) struct TestRun {
    pub(crate) result: TestResult,
    pub(crate) status: Box<dyn TestStatus>,
}
