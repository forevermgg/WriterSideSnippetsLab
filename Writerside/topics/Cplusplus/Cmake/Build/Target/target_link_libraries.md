## target_link_libraries

target_link_libraries 是一个 CMake 命令，用于向特定的目标（如可执行程序、静态库或共享库）添加链接的库。

```CMake
target_link_libraries(target_name PUBLIC library1 PRIVATE library2)
```

`target_name`表示要添加链接库的目标名称。可以是已经存在的目标，也可以是尚未创建的目标。

`PUBLIC`和`PRIVATE`是属性修饰符，用于指定库的可见性。具有PUBLIC属性的库将对当前目标及其依赖项可见，而具有`PRIVATE`属性的库仅对当前目标可见。

`library1`和`library2`是要链接的库。

通过调用`target_link_libraries()`命令，可以将需要链接的库与特定目标关联起来。这些库将在链接过程中被连接到目标中，以解析目标代码中对这些库的函数和符号引用。

链接的库可以是静态库（`.a`文件）或动态库（`.so`、`.dll`等文件）。可以链接系统提供的标准库，也可以链接第三方库。

需要注意的是，`target_link_libraries()`命令应在`add_library()`或`add_executable()`命令之后使用，以确保正确地将库与目标进行关联。同时，还可以使用其他命令（如`target_sources()`、`target_include_directories()`等）来进一步配置和管理目标。

以下是 target_link_libraries 命令的示例用法：

```CMake
# 向目标添加链接的库
target_link_libraries(myapp PRIVATE lib1 lib2)

# 向多个目标添加链接的库
target_link_libraries(lib1 PUBLIC lib3)
target_link_libraries(lib2 PRIVATE lib4)
```
在第一个示例中，通过使用`target_link_libraries`命令，将`lib1`和`lib2`两个库链接到名为`myapp`的目标上。这意味着在编译和链接`myapp`目标时，需要使用这两个库的功能和符号。

在第二个示例中，分别使用`target_link_libraries`命令将`lib3`和`lib4`两个库链接到名为`lib1`和`lib2`的目标上。使用`PUBLIC`或`PRIVATE`关键字可以设置不同的链接属性，指示这些库对其他目标是否可见。

通过`target_link_libraries`命令，您可以方便地将库与特定的目标关联起来，并告知`CMake`构建系统在链接过程中需要考虑这些库的依赖关系。它可以用于任何类型的目标，并支持添加单个或多个库。

### leveldb link lib
https://github.com/google/leveldb/blob/main/CMakeLists.txt
```CMake
if(HAVE_CRC32C)
  target_link_libraries(leveldb crc32c)
endif(HAVE_CRC32C)
if(HAVE_SNAPPY)
  target_link_libraries(leveldb snappy)
endif(HAVE_SNAPPY)
if(HAVE_ZSTD)
  target_link_libraries(leveldb zstd)
endif(HAVE_ZSTD)
if(HAVE_TCMALLOC)
  target_link_libraries(leveldb tcmalloc)
endif(HAVE_TCMALLOC)

# Needed by port_stdcxx.h
find_package(Threads REQUIRED)
target_link_libraries(leveldb Threads::Threads)
```