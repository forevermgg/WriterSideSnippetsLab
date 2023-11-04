## target_sources

`target_sources()`是`CMake`中的一个命令，用于向特定的目标（如可执行程序、静态库或共享库）添加源文件。

以下是`target_sources()`的使用示例：

```cmake
target_sources(target_name PRIVATE source1.cpp source2.cpp)
```
`target_name`表示要添加源文件的目标名称。可以是已经存在的目标，也可以是尚未创建的目标。
`PRIVATE`是一种属性修饰符，表示这些源文件仅对当前目标可见。其他依赖该目标的目标无法访问这些源文件。
`source1.cpp`和`source2.cpp`是要添加的源文件列表。

通过调用`target_sources()`命令，可以将源文件与特定目标关联起来。这些源文件将在构建过程中被编译并链接到目标中，以生成最终的输出文件（例如库文件或可执行文件）。

需要注意的是，`target_sources()`命令应在`add_library()`或`add_executable()`命令之后使用，以确保正确地将源文件与目标进行关联。同时，还可以使用其他命令（如`target_compile_options()`、`target_include_directories()`等）来进一步配置和管理目标。

以下是`target_sources`命令的示例用法：
```CMake
# 添加源文件到目标
target_sources(myapp PRIVATE main.cpp utils.cpp)

# 添加源文件到多个目标
target_sources(lib1 PUBLIC source1.cpp)
target_sources(lib2 PRIVATE source2.cpp)
```
在第一个示例中，通过使用`target_sources`命令将`main.cpp`和`utils.cpp`两个源文件添加到名为`myapp`的目标中。这可以让`CMake`知道在构建`myapp`目标时需要编译这两个源文件。

在第二个示例中，通过分别使用`target_sources`命令将`source1.cpp`和`source2.cpp`两个源文件添加到名为`lib1`和`lib2`的目标中。使用`PUBLIC`或`PRIVATE`关键字可以设置不同的链接属性，指示这些源文件对其他目标是否可见。

使用`target_sources`命令可以方便地将源文件与特定的目标关联起来，并告知`CMake`构建系统在编译和链接过程中需要考虑这些源文件。它可以用于任何类型的目标，并支持添加单个或多个源文件。

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