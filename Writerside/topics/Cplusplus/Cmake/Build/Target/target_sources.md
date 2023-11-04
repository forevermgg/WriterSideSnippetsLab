## target_sources
target_sources 是一个 CMake 命令，用于向特定的目标（如可执行程序、静态库或共享库）添加源文件。
以下是 target_sources 命令的示例用法：
```CMake
# 添加源文件到目标
target_sources(myapp PRIVATE main.cpp utils.cpp)

# 添加源文件到多个目标
target_sources(lib1 PUBLIC source1.cpp)
target_sources(lib2 PRIVATE source2.cpp)
```
在第一个示例中，通过使用 target_sources 命令将 main.cpp 和 utils.cpp 两个源文件添加到名为 myapp 的目标中。这可以让 CMake 知道在构建 myapp 目标时需要编译这两个源文件。
在第二个示例中，通过分别使用 target_sources 命令将 source1.cpp 和 source2.cpp 两个源文件添加到名为 lib1 和 lib2 的目标中。使用 PUBLIC 或 PRIVATE 关键字可以设置不同的链接属性，指示这些源文件对其他目标是否可见。
使用 target_sources 命令可以方便地将源文件与特定的目标关联起来，并告知 CMake 构建系统在编译和链接过程中需要考虑这些源文件。它可以用于任何类型的目标，并支持添加单个或多个源文件。

### leveldb target_sources
https://github.com/google/leveldb/blob/main/CMakeLists.txt
```CMake
if (WIN32)
  target_sources(leveldb
    PRIVATE
      "util/env_windows.cc"
      "util/windows_logger.h"
  )
else (WIN32)
  target_sources(leveldb
    PRIVATE
      "util/env_posix.cc"
      "util/posix_logger.h"
  )
endif (WIN32)
```