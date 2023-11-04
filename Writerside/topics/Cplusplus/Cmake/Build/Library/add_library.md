## add_library

`add_library`是一个`CMake`命令，用于在项目中创建一个库目标。它可以用来创建静态库`(Static Library)`或共享库`(Shared Library)`。

以下是`add_library`命令的示例用法：
```CMake
# 创建一个静态库
add_library(mylib STATIC mylib.cpp)

# 创建一个共享库
add_library(mylib SHARED mylib.cpp)
```
在这个示例中，第一个`add_library`命令创建了一个名为`mylib`的静态库目标，其中包含了`mylib.cpp`源文件。

静态库是在编译时链接到目标程序的库，它会将库的代码和符号拷贝到最终生成的可执行文件中。

第二个`add_library`命令创建了一个名为`mylib`的共享库目标，同样包含了`mylib.cpp`源文件。

共享库是一个独立的二进制文件，可以被多个程序动态加载和使用。

在实际的项目中，您可以根据需要使用不同的选项调用`add_library`命令。

例如，您可以添加更多的源文件、头文件、依赖项等来构建更复杂的库。另外，您还可以通过指定库的属性和安装规则来进一步定制库的行为和使用方式。

通过使用`add_library`命令，您可以方便地在 CMake 项目中创建库目标，从而将代码组织为可重用的模块，并在其他目标中使用它们。

### add_library(snappy "")
`add_library()`函数用于向`CMake`构建系统添加一个库。在这个例子中，我们添加了名为`snappy`的库。

这行代码中的空字符串""是作为库源文件列表的占位符。可以将源文件列表填充到括号内，以指定实际的源文件。如果没有源文件列表，可以使用空字符串来创建一个空的库。

这将创建一个空的库目标，并将其命名为`snappy`。具体的源文件列表和编译选项可以在后续的代码中通过`target_sources()`和`target_compile_options()`等命令进行添加和配置。

请注意，这行代码只是创建了一个空的库目标，需要在后续的代码中添加源文件并进行相关的配置和链接操作，才能最终生成可用的库文件。

### add_library STATIC
```
add_library(utils STATIC IMPORTED)
set_target_properties(utils PROPERTIES IMPORTED_LOCATION
        ${FILAMENT_DIR}/lib/${ANDROID_ABI}/libutils.a)

add_library(archive STATIC archive.cpp zip.cpp lzma.cpp)        
```
### add_library SHARED
```
add_library(filament-jni SHARED
    src/main/cpp/*.cpp
    src/main/cpp/*.cc
    src/main/cpp/*.h
)
```

