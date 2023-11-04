## target_compile_definitions

`target_compile_definitions`是一个`CMake`命令，用于向特定的目标（如可执行程序、静态库或共享库）添加编译定义`compile definition`。

以下是target_compile_definitions()的使用示例：

```cmake
target_compile_definitions(target_name PRIVATE DEFINITION1 DEFINITION2)
```

`target_name`表示要添加编译定义的目标名称。可以是已经存在的目标，也可以是尚未创建的目标。

`PRIVATE`是一种属性修饰符，表示这些编译定义仅对当前目标可见。其他依赖该目标的目标无法访问这些定义。

`DEFINITION1`和`DEFINITION2`是要添加的编译定义。

通过调用`target_compile_definitions()`命令，可以将编译定义与特定目标关联起来。这些定义将被加入到目标的编译过程中，作为预处理器定义传递给源文件。

这些定义可用于控制条件编译、启用或禁用特定功能、设置宏等。在源文件中，可以使用条件语句（如`#ifdef`、`#ifndef`）或直接使用定义的常量和宏。

需要注意的是，`target_compile_definitions()`命令应在`add_library()`或`add_executable()`命令之后使用，以确保正确地将编译定义与目标进行关联。同时，还可以使用其他命令（如`target_sources()`、`target_include_directories()`等）来进一步配置和管理目标。

以下是 target_compile_definitions 命令的示例用法：

```CMake
# 添加编译定义到目标
target_compile_definitions(myapp PRIVATE DEBUG_MODE)

# 添加多个编译定义到目标
target_compile_definitions(mylib PUBLIC VERSION=2.0 LIBNAME="mylib")
```
在第一个示例中，通过使用`target_compile_definitions`命令，将`DEBUG_MODE`编译定义添加到名为`myapp`的目标的私有编译定义中。这意味着在编译`myapp`目标时，会定义`DEBUG_MODE`，可以在代码中使用条件编译来处理相应的逻辑。

在第二个示例中，使用`target_compile_definitions`命令，将`VERSION=2.0`和`LIBNAME="mylib"`两个编译定义添加到名为`mylib`的目标的公共编译定义中。这意味着其他目标可以访问`mylib`中定义的这些编译定义。

通过`target_compile_definitions`命令，您可以方便地向特定的目标添加编译定义，以控制编译过程中的预处理指令和宏定义。这对于根据不同的编译选项进行条件编译、配置不同的构建变体等非常有用。
