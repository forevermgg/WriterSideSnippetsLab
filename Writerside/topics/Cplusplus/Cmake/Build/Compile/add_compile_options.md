# add_compile_options

`add_compile_options`是一个`CMake`命令，用于向编译器添加额外的编译选项。它可以用来设置编译器的标志或选项，以便控制编译过程中的行为。
以下是`add_compile_options`命令的示例用法：

```CMake
# 向编译器添加编译选项
add_compile_options(-Wall -Wextra)

# 在特定构建类型下添加编译选项
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_options(-O0 -g)
else()
    add_compile_options(-O2)
endif()
```

在这个例子中，
第一个`add_compile_options`命令将`-Wall`和`-Wextra`选项添加到编译器的编译选项中，用于开启更严格的警告。这样可以帮助检测潜在的问题和错误。
第二个`add_compile_options`命令根据构建类型（`Debug`或其他）添加不同的编译选项。在调试模式下，将`-O0`（禁用优化）和 `-g`
（包含调试信息）选项添加到编译选项中，以方便调试。在其他构建类型下，将`-O2`（启用优化级别2）选项添加到编译选项中，以提高代码执行性能。
通过使用`add_compile_options `命令，您可以向`CMake`构建系统传递额外的编译选项，以满足特定的编译需求或优化要求。这样可以灵活地控制编译器的行为，以适应不同的情况和需求。

## add_compile_options(-fvisibility=hidden)

`add_compile_options`(`-fvisibility=hidden`) 是将`-fvisibility=hidden`编译选项添加到`CMake`
项目中的示例。这个编x选项用于设置隐藏符号（`hidden symbol`）的可见性。
在使用`-fvisibility=hidden`编译选项时，编译器会将所有未明确标记为可见的符号设为隐藏。这可以用来控制共享库（`shared
library`）中哪些符号对外部可见，从而尽可能减少共享库的全局符号表，提高库的封装性和安全性。
您可以将 `add_compile_options`(`-fvisibility=hidden`) 添加到`CMakeLists.txt`文件中以启用此编译选项。例如：

```CMake
# 向编译器添加 -fvisibility=hidden 选项
add_compile_options(-fvisibility=hidden)

# 添加目标及其源文件
add_library(mylib SHARED mylib.cpp)
```

在这个示例中，通过使用`add_compile_options`命令将`-fvisibility=hidden`编译选项添加到项目中，然后创建一个名为`mylib`
的共享库目标，其中包含了`mylib.cpp`源文件。这样就能确保在构建共享库时使用了`-fvisibility=hidden`选项。
请注意,`-fvisibility=hidden`编译选项是特定于`GNU`编译器(如`GCC`)
的选项，不同的编译器可能有不同的选项用于设置可见性。因此，在使用时需要考虑目标平台和所使用的编译器是否支持该选项。