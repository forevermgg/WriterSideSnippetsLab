## CheckCXXCompilerFlag
CheckCXXCompilerFlag 是一个 CMake 函数，用于检查是否可以在 C++ 编译器中启用特定的编译器标志（compiler flag）。它接受一个编译器标志作为参数，并返回一个布尔值，指示该标志是否可用。
以下是 CheckCXXCompilerFlag 函数的示例用法：
```CMake
# 检查 -std=c++11 编译器标志是否可用
include(CheckCXXCompilerFlag)
check_cxx_compiler_flag("-std=c++11" SUPPORTS_CXX11)

if(SUPPORTS_CXX11)
  message("支持 -std=c++11 编译器标志")
else()
  message("不支持 -std=c++11 编译器标志")
endif()
```
在这个例子中，CheckCXXCompilerFlag用来检查函数是否可以在 C++ 编译器中启用 -std=c++11 标志。结果存储在变量 SUPPORTS_CXX11中。如果该标志可用，则打印消息 "支持 -std=c++11 编译器标志"；否则，打印消息 "不支持 -std=c++11 编译器标志"。
这个函数通常在 CMake 脚本中使用，以便根据编译器的支持情况进行条件编译或选择不同的编译选项。
### leveldb check check_cxx_compiler_flag
https://github.com/google/leveldb/blob/main/CMakeLists.txt
```CMake
# Test whether -Wthread-safety is available. See
# https://clang.llvm.org/docs/ThreadSafetyAnalysis.html
include(CheckCXXCompilerFlag)
check_cxx_compiler_flag(-Wthread-safety HAVE_CLANG_THREAD_SAFETY)

# Used by googletest.
check_cxx_compiler_flag(-Wno-missing-field-initializers
                        LEVELDB_HAVE_NO_MISSING_FIELD_INITIALIZERS)

```

```CMake
# When using Ninja, compiler output won't be colorized without this.
include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG(-fdiagnostics-color=always SUPPORTS_COLOR_ALWAYS)
if(SUPPORTS_COLOR_ALWAYS)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fdiagnostics-color=always")
endif()
```


