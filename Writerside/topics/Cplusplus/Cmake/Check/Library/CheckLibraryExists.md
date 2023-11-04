## CheckLibraryExists
CheckLibraryExists 是一个 CMake 函数，用于检查特定的库文件是否可以在系统中找到并链接到项目中。它接受库文件的函数符号（symbol）和可能包含该函数的库名称作为参数，并返回一个布尔值，指示是否找到该库。
以下是 CheckLibraryExists 函数的示例用法：
```CMake
# 检查数学库 libm 是否可用
include(CheckLibraryExists)
check_library_exists(m sin "" HAVE_LIBM)

if(HAVE_LIBM)
  message("数学库 libm 可用")
else()
  message("数学库 libm 不可用")
endif()
```
在这个例子中，CheckLibraryExists 函数被用来检查数学库 libm 是否可用。结果存储在变量 HAVE_LIBM 中。如果找到了该库，则打印消息 "数学库 libm 可用"；否则，打印消息 "数学库 libm 不可用"。
这个函数通常在 CMake 脚本中使用，用于检查依赖的外部库是否存在，以便在构建过程中正确链接这些库。
### leveldb check library
https://github.com/google/leveldb/blob/main/CMakeLists.txt
```CMake
include(CheckLibraryExists)
check_library_exists(crc32c crc32c_value "" HAVE_CRC32C)
check_library_exists(snappy snappy_compress "" HAVE_SNAPPY)
check_library_exists(zstd zstd_compress "" HAVE_ZSTD)
check_library_exists(tcmalloc malloc "" HAVE_TCMALLOC)
```
