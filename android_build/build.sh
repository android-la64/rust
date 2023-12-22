#!/bin/bash

script_path="$0"
script_dir=$(dirname "$script_path")
script_dir=$(readlink -f "$script_dir")

cat > config.toml << EOF
[llvm]
ninja = true
targets = "AArch64;ARM;X86;RISCV;LoongArch"
experimental-targets = ""
use-libcxx = true
[build]
target = ["x86_64-unknown-linux-gnu", "loongarch64-linux-android"]
verbose = 1
profiler = true
docs = false
submodules = false
locked-deps = true
vendor = true
full-bootstrap = true
extended = true
tools = ["cargo", "clippy", "rustfmt", "rust-analyzer"]
cargo-native-static = true
[install]
prefix = "/"
sysconfdir = "etc"
[rust]
channel = "dev"
remap-debuginfo = true
deny-warnings = false
[target.x86_64-unknown-linux-gnu]
cc = "$script_dir/clang-x86_64-unknown-linux-gnu"
cxx = "$script_dir/clang++-x86_64-unknown-linux-gnu"
ar = "$script_dir/clang-ar"
ranlib = "$script_dir/clang-ar"
linker = "$script_dir/clang++-x86_64-unknown-linux-gnu"

[target.i686-unknown-linux-gnu]
cc = "$script_dir/clang-i686-unknown-linux-gnu"
cxx = "$script_dir/clang++-i686-unknown-linux-gnu"
ar = "$script_dir/clang-ar"
ranlib = "$script_dir/clang-ar"
linker = "$script_dir/clang++-i686-unknown-linux-gnu"

[target.aarch64-linux-android]
cc="$script_dir/clang-aarch64-linux-android"
ar="$script_dir/clang-ar"

[target.armv7-linux-androideabi]
cc="$script_dir/clang-armv7-linux-androideabi"
ar="$script_dir/clang-ar"

[target.x86_64-linux-android]
cc="$script_dir/clang-x86_64-linux-android"
ar="$script_dir/clang-ar"

[target.i686-linux-android]
cc="$script_dir/clang-i686-linux-android"
ar="$script_dir/clang-ar"

[target.loongarch64-unknown-linux-gnu]
cc = "$script_dir/clang-loongarch64-unknown-linux-gnu"
cxx = "$script_dir/clang++-loongarch64-unknown-linux-gnu"
ar = "$script_dir/clang-ar"
ranlib = "$script_dir/clang-ar"
linker = "$script_dir/clang++-loongarch64-unknown-linux-gnu"

[target.loongarch64-linux-android]
cc="$script_dir/clang-loongarch64-linux-android"
ar="$script_dir/clang-ar"
EOF

#./x.py dist --host x86_64-unknown-linux-gnu --target loongarch64-linux-android
./x.py dist
