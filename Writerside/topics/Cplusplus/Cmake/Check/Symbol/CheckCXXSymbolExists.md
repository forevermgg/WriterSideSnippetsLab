## CheckCXXSymbolExists
CheckCXXSymbolExists 是一个 CMake 函数，用于检查是否可以在 C++ 编译器中找到特定的符号（symbol）。它接受一个函数符号和一个可选的头文件作为参数，并返回一个布尔值，指示是否找到该符号。
以下是 CheckCXXSymbolExists 函数的示例用法：
```CMake
# 检查 std::stoi() 函数是否可用
include(CheckCXXSymbolExists)
check_cxx_symbol_exists(std::stoi "string" HAVE_STOI)

if(HAVE_STOI)
  message("std::stoi() 函数可用")
else()
  message("std::stoi() 函数不可用")
endif()
```
在这个例子中，CheckCXXSymbolExists 函数被用来检查是否可以找到C++编译器中的 std::stoi() 函数。结果存储在变量 HAVE_STOI 中。如果找到了该函数，则打印消息 "std::stoi() 函数可用"；否则，打印消息 "std::stoi() 函数不可用"。
这个函数通常在 CMake 脚本中使用，用于检查特定的函数或符号是否在 C++ 编译器中可用，以便在代码中进行条件编译或运行时处理。
### leveldb check Symbol
https://github.com/google/leveldb/blob/main/CMakeLists.txt
```CMake
include(CheckCXXSymbolExists)
# Using check_cxx_symbol_exists() instead of check_c_symbol_exists() because
# we're including the header from C++, and feature detection should use the same
# compiler language that the project will use later. Principles aside, some
# versions of do not expose fdatasync() in <unistd.h> in standard C mode
# (-std=c11), but do expose the function in standard C++ mode (-std=c++11).
check_cxx_symbol_exists(fdatasync "unistd.h" HAVE_FDATASYNC)
check_cxx_symbol_exists(F_FULLFSYNC "fcntl.h" HAVE_FULLFSYNC)
check_cxx_symbol_exists(O_CLOEXEC "fcntl.h" HAVE_O_CLOEXEC)
```
