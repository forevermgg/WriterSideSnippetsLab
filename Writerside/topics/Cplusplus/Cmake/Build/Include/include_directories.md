# include_directories

在`CMake`中，`include_directories`命令用于指定编译器在查找头文件时搜索的目录。通过将需要包含的头文件所在目录添加到搜索路径中，可以确保编译器能够正确地找到和包含这些头文件。

以下是`include_directories`的使用方法：

```cmake
include_directories([AFTER|BEFORE] [SYSTEM] [DIRECTORY dir1 [dir2 ...]])
```

+ AFTER 或 BEFORE：可选参数，用于指定添加的搜索路径相对于已存在搜索路径的位置。
+ SYSTEM：可选参数，用于标识添加的搜索路径为系统头文件路径。
+ DIRECTORY dir1 [dir2 ...]：指定要添加的搜索路径。

以下是一个示例，展示了如何使用`include_directories`添加头文件搜索路径：

```cmake
# 添加头文件搜索路径
include_directories(
${PROJECT_SOURCE_DIR}/include
${OpenCV_INCLUDE_DIRS}
/usr/include/other_library
)
```

在上述示例中，我们使用`include_directories`命令添加了三个头文件搜索路径。第一个路径`${PROJECT_SOURCE_DIR}/include`是项目源代码目录下的`include`子目录。第二个路径`${OpenCV_INCLUDE_DIRS}`是由`OpenCV`外部包设置的变量，用于指定`OpenCV`的头文件路径。第三个路径 `/usr/include/other_library`是一个系统头文件路径，用于指定其他库的头文件位置。

通过使用`include_directories`命令，可以确保编译器能够正确地找到并包含所需的头文件，以便顺利进行编译和构建。

请注意，从`CMake 3.0`开始，推荐使用`target_include_directories`命令代替`include_directories`。`target_include_directories`可以更好地控制头文件搜索路径的作用范围，并与目标（如可执行文件或库）相关联。

这就是关于`include_directories`的简要介绍。它是`CMake`中用于添加头文件搜索路径的命令，使得编译器能够正确地找到和包含所需的头文件。
