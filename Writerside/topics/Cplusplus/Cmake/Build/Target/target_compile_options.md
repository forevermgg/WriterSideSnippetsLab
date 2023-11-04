## target_compile_options
target_compile_options 是一个 CMake 命令，用于向特定的目标（如可执行程序、静态库或共享库）添加编译选项（compile option）。
以下是 target_compile_options 命令的示例用法：
```CMake
# 添加编译选项到目标
target_compile_options(myapp PRIVATE -Wall -Wextra)

# 添加多个编译选项到目标
target_compile_options(mylib PUBLIC -O2 -std=c++11)
```
在第一个示例中，通过使用 target_compile_options 命令，将 -Wall 和 -Wextra 编译选项添加到名为 myapp 的目标的私有编译选项中。这意味着在编译 myapp 目标时，会应用这些额外的编译选项。
在第二个示例中，使用 target_compile_options 命令，将 -O2 和 -std=c++11 两个编译选项添加到名为 mylib 的目标的公共编译选项中。这意味着其他目标可以访问 mylib 中定义的这些编译选项。
通过 target_compile_options 命令，您可以方便地向特定的目标添加编译选项，以控制编译器的行为和生成的代码。这对于设置优化级别、启用特定的语言功能、开启警告等非常有用。
