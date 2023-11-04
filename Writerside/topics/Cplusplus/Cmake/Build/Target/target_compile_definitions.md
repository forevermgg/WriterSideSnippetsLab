## target_compile_definitions
target_compile_definitions 是一个 CMake 命令，用于向特定的目标（如可执行程序、静态库或共享库）添加编译定义（compile definition）。
以下是 target_compile_definitions 命令的示例用法：
```CMake
# 添加编译定义到目标
target_compile_definitions(myapp PRIVATE DEBUG_MODE)

# 添加多个编译定义到目标
target_compile_definitions(mylib PUBLIC VERSION=2.0 LIBNAME="mylib")
```
在第一个示例中，通过使用 target_compile_definitions 命令，将 DEBUG_MODE 编译定义添加到名为 myapp 的目标的私有编译定义中。这意味着在编译 myapp 目标时，会定义 DEBUG_MODE，可以在代码中使用条件编译来处理相应的逻辑。
在第二个示例中，使用 target_compile_definitions 命令，将 VERSION=2.0 和 LIBNAME="mylib" 两个编译定义添加到名为 mylib 的目标的公共编译定义中。这意味着其他目标可以访问 mylib 中定义的这些编译定义。
通过 target_compile_definitions 命令，您可以方便地向特定的目标添加编译定义，以控制编译过程中的预处理指令和宏定义。这对于根据不同的编译选项进行条件编译、配置不同的构建变体等非常有用。
