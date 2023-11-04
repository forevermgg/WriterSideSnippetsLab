### PROJECT_BINARY_DIR
`PROJECT_BINARY_DIR`是一个`CMake`变量，它表示正在构建的项目的二进制目录。在`CMake`构建过程中，源代码和生成的二进制文件（可执行文件、库文件等）可以放在不同的目录中。

`PROJECT_BINARY_DIR`是由`CMake`自动设置的变量，其值是构建过程中生成的目标二进制文件所在的路径。该路径通常是在构建项目时指定的`CMAKE_BINARY_DIR`和项目名称（通过`PROJECT`命令设置）的组合。

可以使用`PROJECT_BINARY_DIR`变量来引用生成的二进制文件的路径，例如：

```CMake
# 打印 PROJECT_BINARY_DIR 变量的值
message("二进制目录: ${PROJECT_BINARY_DIR}")

# 设置生成的可执行文件输出的路径
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)
```
在这个例子中，首先使用`message`函数打印了`PROJECT_BINARY_DIR`变量的值，然后通过将`EXECUTABLE_OUTPUT_PATH`设置为`${PROJECT_BINARY_DIR}/bin`来指定生成的可执行文件的输出路径为二进制目录下的`bin`子目录。

通过使用`PROJECT_BINARY_DIR`变量，您可以在`CMake`中方便地引用项目生成的二进制文件所在的路径，以便进行后续的操作或配置。

### 目录检测
```cmake
if(NOT CMAKE_SOURCE_DIR STREQUAL ${CMAKE_CURRENT_SOURCE_DIR})
    # is being built as part of another project, likely an SDK
endif()

# 其他主项目的构建逻辑
```

### 自定义目录
```cmake
# ==================================================================================================
#  Paths
# ==================================================================================================
# Where our external libs are
set(EXTERNAL ${CMAKE_CURRENT_SOURCE_DIR}/third_party)

# Where our libraries are
set(LIBRARIES ${CMAKE_CURRENT_SOURCE_DIR}/libs)

# Where our filament code is
set(FILAMENT ${CMAKE_CURRENT_SOURCE_DIR})

# Where our tools are
set(TOOLS ${CMAKE_CURRENT_SOURCE_DIR}/tools)
```