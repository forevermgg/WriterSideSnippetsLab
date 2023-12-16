# Skia 动态链接android libc++_shared.so

同步滚动：开

# 背景

> 当app只有一个so时，建议使用静态链接方式，以减小包尺寸；当app包含多个so时，全部使用静态链接，stl代码实现会拷贝多份到不同so中，这会极大增加包大小，因此应该选择动态链接。但是需要注意的是，无论是多个so静态链接同一个STL，还是多个so动态链接多个不同STL，都会导致运行时功能异常，甚至引发crash的风险，因此，最佳方案是：仅使用一种链接方式，同时，仅使用同一个STL。

这里典型的例子是 libc++ 库：如果存在多个 so 都静态依赖 libc++ 库的情况，可以优化为这些 so 都动态依赖于 libc++_shared.so。

Google官方建议存在多个SO时，在编译生成C++ SO文件时选择STL类型为c++_shared，保证扩展性。更多内容，请参见[NDK编译—C++ 库支持](https://developer.android.com/ndk/guides/cpp-support.html?hl=zh-cn)。

安卓系统默认只提供了一个非常简单的 C++ 运行时环境：system。它不包含 STL、异常、RTTI 等特性，那我们的代码里面就不能使用这些特性，例如不能使用 std::string 或者 std::vector，不能使用 try-catch，不能使用 typeid 操作符。不过好在 NDK 提供了其他辅助的运行时环境，它们能提供不同的 STL 实现，异常和 RTTI 支持。

- system：最基本的 C++ 运行时；
- gabi++_static/gabi++_shared：GAbi++ 运行时，包括异常、RTTI 支持；
- stlport_static/stlport_shared：STLport 运行时，包括异常、RTTI、STLport 的 STL 实现；
- gnustl_static/gnustl_shared：GNU STL 运行时，包括异常、RTTI、GNU STL 的实现；
- c++_static/c++_shared：LLVM libc++ 运行时，包括异常、RTTI、LLVM libc++ 的 STL 实现；

链接静态依赖库（英文里叫做 link against）时，会把库中的目标文件打包到自己的库里面来，这样就可以不带着依赖库了，但如果我们有多个库都依赖了同一个库，那链接静态依赖库就会导致同样的目标文件被包含了多份，这样既占用了磁盘空间，也会占用运行时内存，[而且 C++ 运行时库如果同时存在多份，可能会导致各种诡异的问题](https://developer.android.com/ndk/guides/cpp-support.html#sr)。此外，我们使用的依赖库可能别的程序也使用了（尤其是 C++ 运行时库），而如果操作系统中运行的多个程序如果要加载同一个动态库，那实际上只会加载一份，所以链接动态依赖库还有可能减少整个系统的内存占用。

最后，依赖库可以动态与静态混用，只要编译使用的 STL 一致即可，而 C++ 运行时库其实也是我们的依赖库，因此我们使用静态还是动态版本，与其他依赖库没有直接关系，即使用 `c++_shared` 或者 `c++_static` 与其他的依赖库没有直接关系。

# Skia 动态链接android libc++_shared.so

修改skia/gn/BUILD.gn

```
if (is_android) {
    cflags += [ "--sysroot=$ndk/toolchains/llvm/prebuilt/$ndk_host/sysroot" ]
    if (is_component_build) {
      ldflags += [ "-DANDROID_STL=c++_shared" ]
    } else {
      ldflags += [ "-static-libstdc++" ]
      ldflags += [ "-DANDROID_STL=c++_static" ]
    }
  }
readelf -d libskia.so | grep 'NEEDED'
0x0000000000000001 (NEEDED)             Shared library: [libdl.so]
 0x0000000000000001 (NEEDED)             Shared library: [libEGL.so]
 0x0000000000000001 (NEEDED)             Shared library: [libGLESv2.so]
 0x0000000000000001 (NEEDED)             Shared library: [liblog.so]
 0x0000000000000001 (NEEDED)             Shared library: [libc++_shared.so]
 0x0000000000000001 (NEEDED)             Shared library: [libm.so]
 0x0000000000000001 (NEEDED)             Shared library: [libc.so]
```

- libdl.so。动态链接器，提供动态加载其它so能力，Android平台中的so，都会包含此项依；
- libc.so、libm.so。这个可以认为是c语言的基础运行时库，可以认为所有Android中使用的so都包含；
- liblog.so。Android平台logcat日志库，在c/c++代码中如果需要将信息打印到logcat中，就需要动态链接这个库，并在代码中调用相关函数；
- libc++_shared.so。这就是上一小节讲到的LLVM版本标准模版库libc++，动态链接形式的so名称；
- libslimlady_core.so。这是apk中另一个已存在的so，libslimlady.so通过动态链接方式，依赖这个so，从而在代码中可以调用其定义的方法。

# Release AAR packaging doesn't strip symbols

https://issuetracker.google.com/issues/37120201

在打AAR包的过程中，无论是debug版本还是release版本，NDK toolchain不会自动的把方便调试的C++ 符号表(Symbol Table)中数据删除，而只会在打APK包的时候进行这一操作。这就导致了打成的AAR包中的SO体积明显偏大。

详细描述可以参见这个ISSUE: https://code.google.com/p/android/issues/detail?id=222831

找到原因后这个问题就很好解决了，可以手动的在链接选项中加入 strip参数，配置如下所示：

```
SET_TARGET_PROPERTIES(yoga PROPERTIES LINK_FLAGS "-Wl,--gc-sections,--icf=safe,-s")
```

# [pickFirst是存在安全隐患](https://www.imgeek.org/article/825357766)

```
packagingOptions {
    pickFirst '**/libc++_shared.so'
} 
```

![image.png](https://upload-images.jianshu.io/upload_images/23654578-ed5c8956e4c50c8a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

image.png

假如两个c++_shared.so是用不同版本的ndk打出来的，其实内部的库函数是不一样的，pickFirst贸然选择第一个必然导致另外的库不兼容。

# find libc++_shared.so

find ~/Library/Android/sdk/ndk/21.3.6528147/ -name libc++_shared.so

# Use static C++ standard library.

```
cflags_cc = [
    # Use libc++ as the C++ standard library.
    "-stdlib=libc++",
]
ldflags = [
    # Use libc++ as the C++ standard library.
    "-stdlib=libc++",
  ]
if (is_clang) {
    if (current_cpu == "arm") {
      abi_target = "arm-linux-androideabi"
    } else if (current_cpu == "x86") {
      abi_target = "i686-linux-androideabi"
    } else if (current_cpu == "arm64") {
      abi_target = "aarch64-linux-android"
    } else if (current_cpu == "x64") {
      # Place holder for x64 support, not tested.
      # TODO: Enable clang support for Android x64. http://crbug.com/539781
      abi_target = "x86_64-linux-androideabi"
    } else if (current_cpu == "mipsel") {
      abi_target = "mipsel-linux-android"
    } else if (current_cpu == "mips64el") {
      # Place holder for mips64 support, not tested.
      abi_target = "mips64el-linux-androideabi"
    } else {
      assert(false, "Architecture not supported")
    }
    cflags += [ "--target=$abi_target" ]
    ldflags += [ "--target=$abi_target" ]
}
```

# libc++_shared.so库是否不兼容？？？

不同的libc++_shared.so库不兼容。怎么产生的不兼容呢？libc++_shared.so是c++的标准模板库，从ndk18开始成为android唯一支持的标准模板库。每一个NDK版本都会带有它，在用到它(build.gradle中配置了arguments “-DANDROID_STL=shared”)的时候，就会输出产物中带有libc++_shared.so这个共享库；它源自NDK的目录中，可以从c++的build log中发现路径，

# [STL 不匹配导致的 `undefined reference` 错误](https://blog.piasy.com/2017/09/03/Use-WebRTC-Static-Library/index.html#buildgradle)

```
Error:error: undefined reference to 'std::__ndk1::ios_base::getloc() const'
Error:error: undefined reference to 'std::__ndk1::locale::use_facet(std::__ndk1::locale::id&) const'
Error:error: undefined reference to 'std::__ndk1::ctype<char>::id'
Error:error: undefined reference to 'std::__ndk1::ios_base::getloc() const'
Error:error: undefined reference to 'std::__ndk1::locale::use_facet(std::__ndk1::locale::id&) const'
Error:error: undefined reference to 'std::__ndk1::locale::~locale()'
Error:error: undefined reference to 'std::__ndk1::ctype<char>::id'
Error:error: undefined reference to 'std::__ndk1::ios_base::getloc() const'
Error:error: undefined reference to 'std::__ndk1::locale::use_facet(std::__ndk1::locale::id&) const'
Error:error: undefined reference to 'std::__ndk1::locale::~locale()'
Error:error: undefined reference to 'std::__ndk1::ios_base::getloc() const'
Error:error: undefined reference to 'std::__ndk1::locale::use_facet(std::__ndk1::locale::id&) const'
Error:error: undefined reference to 'std::__ndk1::locale::~locale()'
Error:error: undefined reference to 'std::__ndk1::ios_base::clear(unsigned int)'
Error:error: undef
Error:error: undefined reference to 'std::__ndk1::ctype<char>::id'
Error:error: undefined reference to 'std::__ndk1::ios_base::clear(unsigned int)'
Error:error: undefined reference to 'std::__ndk1::num_put<char, std::__ndk1::ostreambuf_iterator<char, std::__ndk1::char_traits<char> > >::id'
Error:error: undefined reference to 'std::__ndk1::ctype<char>::id'
Error:error: undefined reference to 'std::__ndk1::ios_base::clear(unsigned int)'
Error:error: undefined reference to 'std::__ndk1::ios_base::clear(unsigned int)'
Error:error: undefined reference to 'std::__ndk1::ios_base::init(void*)'
Error:error: undefined reference to 'std::__ndk1::num_put<char, std::__ndk1::ostreambuf_iterator<char, std::__ndk1::char_traits<char> > >::id'
Error:error: undefined reference to 'std::__ndk1::ios_base::~ios_base()'
Error:error: undefined reference to 'std::__ndk1::ios_base::~ios_base()'
Error:error: undefined reference to 'std::__ndk1::ios_base::~ios_base()'
Error:error: undefined reference to 'std::__ndk1::ios_base::~ios_base()'
Error:error: undefined reference to 'std::__ndk1::locale::locale()'
Error:error: undefined reference to 'std::__ndk1::ios_base::init(void*)'
Error:error: undefined reference to 'std::__ndk1::ios_base::init(void*)'
Error:error: undefined reference to 'std::__ndk1::ios_base::init(void*)'
Error:error: undefined reference to 'std::__ndk1::num_put<char, std::__ndk1::ostreambuf_iterator<char, std::__ndk1::char_traits<char> > >::id'
```

# [重要注意事项](https://developer.android.com/ndk/guides/cpp-support.html#sr)

- 静态运行时
- 共享运行时
  [ReLinker](https://github.com/KeepSafe/ReLinker) 项目能够解决所有已知的原生库加载问题，而且相较于自行编写解决方法，它通常是更好的选择。
- 每个应用一个 STL
  此规则不仅仅适用于您的代码。您的所有依赖项也必须使用与您所选 STL 相同的 STL。如果您使用闭源第三方依赖项，而该依赖项使用 STL，且不能为每个 STL 分别提供一个库，那么您就无法选择 STL。您必须使用与依赖项相同的 STL。

您有可能依赖两个互不兼容的库。在这种情况下，您只能弃用其中一个依赖项，或请求维护者提供根据另一个 STL 构建的库。

# 参考

- https://juejin.cn/post/7075966822897434632
- https://www.codingsky.com/doc/2022/8/17/133.html
- https://www.jianshu.com/p/4987566b7a9e
- https://stackoverflow.com/questions/39620739/android-studio-cmake-shared-library-missing-libc-shared-so-can-cmake-bundle/57160242#57160242
- https://help.aliyun.com/document_detail/127598.html
- https://android.googlesource.com/toolchain/prebuilts/ndk/r23/+/refs/heads/master/sources/cxx-stl/llvm-libc++/libs
- [Android兼容之libc++_shared.so库冲突方案](https://blog.csdn.net/ixiaoma/article/details/128465070)
- [使用 WebRTC 静态库进行 NDK 开发](https://blog.piasy.com/2017/09/03/Use-WebRTC-Static-Library/index.html#stl--undefined-reference-buildgradle)