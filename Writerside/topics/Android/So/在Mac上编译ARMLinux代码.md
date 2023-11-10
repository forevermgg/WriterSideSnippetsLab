# macos-cross-toolchains
![macos-cross-toolchains](https://github.com/messense/homebrew-macos-cross-toolchains)

## install using Homebrew:
```Bash
brew tap messense/macos-cross-toolchains
# install x86_64-unknown-linux-gnu toolchain
brew install x86_64-unknown-linux-gnu
# install aarch64-unknown-linux-gnu toolchain
brew install aarch64-unknown-linux-gnu
```

## check
```Bash
aarch64-linux-gnu-cc -v
Using built-in specs.
COLLECT_GCC=aarch64-linux-gnu-cc
COLLECT_LTO_WRAPPER=/opt/homebrew/Cellar/aarch64-unknown-linux-gnu/11.2.0_1/toolchain/bin/../libexec/gcc/aarch64-unknown-linux-gnu/11.2.0/lto-wrapper
Target: aarch64-unknown-linux-gnu
Configured with: /Volumes/build/.build/aarch64-unknown-linux-gnu/src/gcc/configure --build=aarch64-build_apple-darwin21.6.0 --host=aarch64-build_apple-darwin21.6.0 --target=aarch64-unknown-linux-gnu --prefix=/Volumes/tools/aarch64-unknown-linux-gnu --exec_prefix=/Volumes/tools/aarch64-unknown-linux-gnu --with-sysroot=/Volumes/tools/aarch64-unknown-linux-gnu/aarch64-unknown-linux-gnu/sysroot --enable-languages=c,c++,fortran --enable-__cxa_atexit --disable-libmudflap --enable-libgomp --enable-libssp --enable-libquadmath --enable-libquadmath-support --enable-libsanitizer --disable-libmpx --disable-libstdcxx-verbose --with-gmp=/Volumes/build/.build/aarch64-unknown-linux-gnu/buildtools --with-mpfr=/Volumes/build/.build/aarch64-unknown-linux-gnu/buildtools --with-mpc=/Volumes/build/.build/aarch64-unknown-linux-gnu/buildtools --with-isl=/Volumes/build/.build/aarch64-unknown-linux-gnu/buildtools --enable-lto --enable-threads=posix --enable-target-optspace --with-linker-hash-style=both --enable-plugin --enable-gold --disable-nls --disable-multilib --with-local-prefix=/Volumes/tools/aarch64-unknown-linux-gnu/aarch64-unknown-linux-gnu/sysroot --enable-long-long
Thread model: posix
Supported LTO compression algorithms: zlib
gcc version 11.2.0 (GCC) 

x86_64-linux-gnu-cc -v
Using built-in specs.
COLLECT_GCC=x86_64-linux-gnu-cc
COLLECT_LTO_WRAPPER=/opt/homebrew/Cellar/x86_64-unknown-linux-gnu/11.2.0_1/toolchain/bin/../libexec/gcc/x86_64-unknown-linux-gnu/11.2.0/lto-wrapper
Target: x86_64-unknown-linux-gnu
Configured with: /Volumes/build/.build/x86_64-unknown-linux-gnu/src/gcc/configure --build=aarch64-build_apple-darwin21.6.0 --host=aarch64-build_apple-darwin21.6.0 --target=x86_64-unknown-linux-gnu --prefix=/Volumes/tools/x86_64-unknown-linux-gnu --exec_prefix=/Volumes/tools/x86_64-unknown-linux-gnu --with-sysroot=/Volumes/tools/x86_64-unknown-linux-gnu/x86_64-unknown-linux-gnu/sysroot --enable-languages=c,c++,fortran --enable-__cxa_atexit --disable-libmudflap --enable-libgomp --enable-libssp --enable-libquadmath --enable-libquadmath-support --enable-libsanitizer --enable-libmpx --disable-libstdcxx-verbose --with-gmp=/Volumes/build/.build/x86_64-unknown-linux-gnu/buildtools --with-mpfr=/Volumes/build/.build/x86_64-unknown-linux-gnu/buildtools --with-mpc=/Volumes/build/.build/x86_64-unknown-linux-gnu/buildtools --with-isl=/Volumes/build/.build/x86_64-unknown-linux-gnu/buildtools --enable-lto --enable-threads=posix --enable-target-optspace --with-linker-hash-style=both --enable-plugin --enable-gold --disable-nls --disable-multilib --with-local-prefix=/Volumes/tools/x86_64-unknown-linux-gnu/x86_64-unknown-linux-gnu/sysroot --enable-long-long
Thread model: posix
Supported LTO compression algorithms: zlib
gcc version 11.2.0 (GCC) 
```

## build 
```Bash
aarch64-linux-gnu-gcc -c training_sample.c
```
