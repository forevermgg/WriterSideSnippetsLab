## target_link_libraries
target_link_libraries 是一个 CMake 命令，用于向特定的目标（如可执行程序、静态库或共享库）添加链接的库。
以下是 target_link_libraries 命令的示例用法：
```CMake
# 向目标添加链接的库
target_link_libraries(myapp PRIVATE lib1 lib2)

# 向多个目标添加链接的库
target_link_libraries(lib1 PUBLIC lib3)
target_link_libraries(lib2 PRIVATE lib4)
```
在第一个示例中，通过使用 target_link_libraries 命令，将 lib1 和 lib2 两个库链接到名为 myapp 的目标上。这意味着在编译和链接 myapp 目标时，需要使用这两个库的功能和符号。
在第二个示例中，分别使用 target_link_libraries 命令将 lib3 和 lib4 两个库链接到名为 lib1 和 lib2 的目标上。使用 PUBLIC 或 PRIVATE 关键字可以设置不同的链接属性，指示这些库对其他目标是否可见。
通过 target_link_libraries 命令，您可以方便地将库与特定的目标关联起来，并告知 CMake 构建系统在链接过程中需要考虑这些库的依赖关系。它可以用于任何类型的目标，并支持添加单个或多个库。

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