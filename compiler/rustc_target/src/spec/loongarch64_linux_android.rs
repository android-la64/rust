use crate::spec::{Target, TargetOptions};

pub fn target() -> Target {
    Target {
        llvm_target: "loongarch64-linux-android".to_string(),
        pointer_width: 64,
        data_layout: "e-m:e-i8:8:32-i16:16:32-i64:64-n32:64-S128".into(),
        arch: "loongarch64".to_string(),
        options: TargetOptions {
            cpu: "la464".into(),
            llvm_abiname: "lp64".into(),
            max_atomic_width: Some(64),
            ..super::android_base::opts()
        },
    }
}
