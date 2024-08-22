//! Everything needed to build auxilary files with rustc
// lol we can't name this file `aux.rs` on windows

use bstr::ByteSlice;
use spanned::Spanned;
use std::{ffi::OsString, path::PathBuf, process::Command};

use crate::{
    build_manager::{Build, BuildManager},
    custom_flags::Flag,
    default_per_file_config,
    per_test_config::{Comments, TestConfig},
    status_emitter::SilentStatus,
    CrateType, Error, Errored,
};

impl Flag for AuxBuilder {
    fn must_be_unique(&self) -> bool {
        false
    }
    fn clone_inner(&self) -> Box<dyn Flag> {
        Box::new(self.clone())
    }
    fn apply(
        &self,
        cmd: &mut Command,
        config: &TestConfig<'_>,
        build_manager: &BuildManager<'_>,
    ) -> Result<(), Errored> {
        let aux = &self.aux_file;
        let aux_dir = config.aux_dir;
        let line = aux.line();
        let aux_file = if aux.starts_with("..") {
            aux_dir.parent().unwrap().join(&aux.content)
        } else {
            aux_dir.join(&aux.content)
        };
        let extra_args = build_manager
            .build(AuxBuilder {
                aux_file: Spanned::new(
                    crate::core::strip_path_prefix(
                        &aux_file.canonicalize().map_err(|err| Errored {
                            command: Command::new(format!(
                                "canonicalizing path `{}`",
                                aux_file.display()
                            )),
                            errors: vec![],
                            stderr: err.to_string().into_bytes(),
                            stdout: vec![],
                        })?,
                        &std::env::current_dir().unwrap(),
                    )
                    .collect(),
                    aux.span(),
                ),
            })
            .map_err(
                |Errored {
                     command,
                     errors,
                     stderr,
                     stdout,
                 }| Errored {
                    command,
                    errors: vec![Error::Aux {
                        path: aux_file.to_path_buf(),
                        errors,
                        line,
                    }],
                    stderr,
                    stdout,
                },
            )?;
        cmd.args(extra_args);
        Ok(())
    }
}

/// Build an aux-build.
/// Custom `//@aux-build` flag handler.
#[derive(Clone, Debug)]
pub struct AuxBuilder {
    /// Full path to the file (including `auxiliary` folder prefix)
    pub aux_file: Spanned<PathBuf>,
}

impl Build for AuxBuilder {
    fn build(&self, build_manager: &BuildManager<'_>) -> Result<Vec<OsString>, Errored> {
        let mut config = build_manager.config().clone();
        let file_contents = std::fs::read(&self.aux_file.content).map_err(|err| Errored {
            command: Command::new(format!("reading aux file `{}`", self.aux_file.display())),
            errors: vec![],
            stderr: err.to_string().into_bytes(),
            stdout: vec![],
        })?;
        let comments = Comments::parse(&file_contents, &config, &self.aux_file)
            .map_err(|errors| Errored::new(errors, "parse aux comments"))?;
        assert_eq!(
            comments.revisions, None,
            "aux builds cannot specify revisions"
        );

        default_per_file_config(&mut config, &self.aux_file, &file_contents);

        match CrateType::from_file_contents(&file_contents) {
            // Proc macros must be run on the host
            CrateType::ProcMacro => config.target = config.host.clone(),
            CrateType::Test | CrateType::Bin | CrateType::Lib => {}
        }

        let mut config = TestConfig {
            config,
            comments: &comments,
            aux_dir: self.aux_file.parent().unwrap(),
            status: &SilentStatus {
                revision: String::new(),
                path: self.aux_file.content.clone(),
            },
        };

        config.patch_out_dir();

        let mut aux_cmd = config.build_command(build_manager)?;

        aux_cmd.arg("--emit=link");
        let filename = self.aux_file.file_stem().unwrap().to_str().unwrap();
        let output = aux_cmd.output().unwrap();
        if !output.status.success() {
            let error = Error::Command {
                kind: "compilation of aux build failed".to_string(),
                status: output.status,
            };
            return Err(Errored {
                command: aux_cmd,
                errors: vec![error],
                stderr: config.process(&output.stderr).rendered,
                stdout: output.stdout,
            });
        }

        // Now run the command again to fetch the output filenames
        aux_cmd.arg("--print").arg("file-names");
        let output = aux_cmd.output().unwrap();
        assert!(output.status.success());

        let mut extra_args = vec![];
        for file in output.stdout.lines() {
            let file = std::str::from_utf8(file).unwrap();
            let crate_name = filename.replace('-', "_");
            let path = config.config.out_dir.join(file);
            extra_args.push("--extern".into());
            let mut cname = OsString::from(&crate_name);
            cname.push("=");
            cname.push(path);
            extra_args.push(cname);
            // Help cargo find the crates added with `--extern`.
            extra_args.push("-L".into());
            extra_args.push(config.config.out_dir.as_os_str().to_os_string());
        }
        Ok(extra_args)
    }

    fn description(&self) -> String {
        format!("Building aux file {}", self.aux_file.display())
    }
}
