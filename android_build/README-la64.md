# How to build rust for loongarch64
```shell
git clone -b a12_larch git@github.com:android-la64/rust.git

cd rust

export CLANG_PATH="/your/clang/path"

export NDK_PATH="/your/ndk/path"

# copy libgcc.a from loongson-gnu-toolchain to ndk
wget https://github.com/android-la64/rust/releases/download/1.51.0/loongson-gnu-toolchain-8.3-x86_64-loongarch64-linux-gnu-rc1.2.tar.xz
tar Jxf loongson-gnu-toolchain-8.3-x86_64-loongarch64-linux-gnu-rc1.2.tar.xz
cp loongson-gnu-toolchain-8.3-x86_64-loongarch64-linux-gnu-rc1.2/lib/gcc/loongarch64-linux-gnu/8.3.0/libgcc.a $CLANG_PATH/toolchains/llvm/prebuilt/linux-x86_64/lib/gcc/loongarch64-linux-android/4.9.x/

./android_build/build.sh
```
