## target_include_directories

`target_include_directories()`是`CMake`中的一个命令，用于向特定的目标（如可执行程序、静态库或共享库）添加包含目录（include directory）。

通过使用`target_include_directories`命令，您可以向特定的目标指定包含目录，以确保在编译过程中正确地找到所需的头文件。这对于管理项目中的头文件依赖关系非常重要，并确保代码在不同目标之间正确共享和访问头文件。

以下是`target_include_directories()`的使用示例：

```cmake
target_include_directories(target_name PUBLIC include_dir1 PRIVATE include_dir2)
```

+ `target_name`表示要添加包含目录的目标名称。可以是已经存在的目标，也可以是尚未创建的目标。
+ `PUBLIC`和`PRIVATE`是属性修饰符，用于指定包含目录的可见性。具有`PUBLIC`属性的包含目录将对当前目标及其依赖项可见，而具有`PRIVATE`属性的包含目录仅对当前目标可见。
+ `include_dir1`和`include_dir2`是要添加的包含目录路径列表。
+ 通过调用`target_include_directories()`命令，可以将包含目录与特定目标关联起来。这些包含目录将在编译过程中被设置为目标的包含路径，以供源文件中的`#include`指令使用。

PUBLIC属性的包含目录还会被传递给依赖该目标的其他目标，使它们可以访问相同的包含路径。而`PRIVATE`属性的包含目录只对当前目标可见，不会被传递给其他目标。

需要注意的是，`target_include_directories()`命令应在`add_library()`或`add_executable()`命令之后使用，以确保正确地将包含目录与目标进行关联。同时，还可以使用其他命令（如`target_sources()`、`target_compile_options()`等）来进一步配置和管理目标。