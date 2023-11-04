## CheckIncludeFile
CheckIncludeFile 是一个 CMake 函数，用于检查特定的头文件是否可以在项目中找到并包含。它接受头文件的名称作为参数，并返回一个布尔值，指示该文件是否被找到。
以下是 CheckIncludeFile 函数的示例用法：
```CMake
# 检查 math.h 头文件是否可以找到
include(CheckIncludeFile)
check_include_file("math.h" HAVE_MATH_H)

if(HAVE_MATH_H)
  message("找到 math.h")
else()
  message("未找到 math.h")
endif()
```
在这个例子中，CheckIncludeFile 函数被用来检查 "math.h" 头文件是否可以找到。结果存储在变量 HAVE_MATH_H 中。如果找到了该头文件，则打印消息 "找到 math.h"；否则，打印消息 "未找到 math.h"。
这个函数通常在 CMake 脚本中使用，用于根据某些头文件是否可用来进行条件编译。

### leveldb has include
https://github.com/google/leveldb/blob/main/CMakeLists.txt
```CMake
include(CheckIncludeFile)
check_include_file("unistd.h" HAVE_UNISTD_H)
```
