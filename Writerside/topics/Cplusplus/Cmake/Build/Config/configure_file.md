## configure_file
configure_file 是一个 CMake 的命令，用于通过替换源文件中的变量值来生成目标文件。它可以用来在构建过程中将配置信息动态地传递给生成的文件。
以下是 configure_file 命令的示例用法：
```CMake
# 通过替换变量值生成目标文件
configure_file(input.txt output.txt)

# 将自定义变量值传递给目标文件
set(VERSION_MAJOR 1)
set(VERSION_MINOR 0)
configure_file(config.h.in config.h)

# 生成的目标文件可以引用自定义变量值
# config.h.in 文件中的 @VERSION_MAJOR@ 和 @VERSION_MINOR@ 将被替换为对应的值
```
在这个例子中，第一个 configure_file 命令将源文件 input.txt 复制到生成的文件 output.txt。这种情况下，configure_file 命令只是简单地复制了文件，没有进行替换操作。
第二个 configure_file 命令使用了一个输入文件 config.h.in 和一个输出文件 config.h。在输入文件中，您可以定义自定义变量（如 @VERSION_MAJOR@ 和 @VERSION_MINOR@），然后在输出文件中，这些自定义变量会被对应的变量值替换。这样就可以在生成的文件中引用自定义变量的值。
configure_file 命令常用于生成配置文件、头文件或脚本等需要根据构建环境动态生成的文件。通过将变量值传递给目标文件，您可以以一种灵活和可定制的方式配置生成的文件的内容。