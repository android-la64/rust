#!/bin/bash

script_path="$0"
script_dir=$(dirname "$script_path")
script_dir=$(readlink -f "$script_dir")

# generate config file
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

# build and dist
./x.py dist --host x86_64-unknown-linux-gnu --target loongarch64-linux-android

find ./build/dist -name "rust-dev-*" -exec echo Dist binary: {} \;

# dist source for android
tar_android_src_path=./build/tmp/tarball/rust-src-android/
tar_android_stdlibs_src_path=$tar_android_src_path/src/stdlibs

tar_library_src_path=$tar_android_stdlibs_src_path/library/
mkdir -p $tar_library_src_path
libaray_names=(alloc  backtrace  core  panic_abort  panic_unwind  proc_macro  profiler_builtins  std  stdarch  term  test  unwind)
for name in "${libaray_names[@]}"; do
  cp -r  library/$name $tar_library_src_path
done

tar_vendor_src_path=$tar_android_stdlibs_src_path/vendor/
mkdir -p $tar_vendor_src_path
vendor_names=(backtrace  cfg-if  compiler_builtins  getopts  hashbrown  libc  rustc-demangle  unicode-width)
for name in "${vendor_names[@]}"; do
  cp -r  vendor/$name $tar_vendor_src_path
done

tar cfJ build/dist/rust-src-android.tar.xz -C $tar_android_src_path src
find ./build/dist -name "rust-src-android*" -exec echo Dist source: {} \;
