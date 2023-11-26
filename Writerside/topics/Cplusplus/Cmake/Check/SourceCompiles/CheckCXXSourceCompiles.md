## CheckCXXSourceCompiles

CheckCXXSourceCompiles 是一个 CMake 函数，用于检查是否可以编译通过给定的 C++ 源代码。它接受一个 C++ 代码字符串作为参数，并返回一个布尔值，指示是否能够成功编译该代码。
以下是 CheckCXXSourceCompiles 函数的示例用法：

```CMake
# 检查某个 C++ 代码片段是否可以成功编译
include(CheckCXXSourceCompiles)
set(CODE "#include <iostream>\n
           int main() {\n
             std::cout << \"Hello, World!\" << std::endl;\n
             return 0;\n
           }")
check_cxx_source_compiles("${CODE}" COMPILES)

if(COMPILES)
  message("代码片段可以成功编译")
else()
  message("代码片段无法成功编译")
endif()
```

在这个例子中，CheckCXXSourceCompiles 函数被用来检查是否可以成功编译给定的 C++ 代码片段。代码片段存储在变量 CODE 中，并将结果存储在变量 COMPILES 中。如果代码片段可以成功编译，则打印消息 "代码片段可以成功编译"；否则，打印消息 "代码片段无法成功编译"。

这个函数通常在 CMake 脚本中使用，以便检查特定的 C++ 代码片段是否可被编译，以便根据结果进行条件编译或处理。

### leveldb check check_cxx_source_compiles
https://github.com/google/leveldb/blob/main/CMakeLists.txt

```CMake
# Test whether C++17 __has_include is available.
check_cxx_source_compiles("
#if defined(__has_include) &&  __has_include(<string>)
#include <string>
#endif
int main() { std::string str; return 0; }
" HAVE_CXX17_HAS_INCLUDE)
```
