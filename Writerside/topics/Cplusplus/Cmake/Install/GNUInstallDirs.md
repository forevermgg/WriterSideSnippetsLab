# GNUInstallDirs

`include(GNUInstallDirs)`是一个`CMake`的命令，用于包含`GNUInstallDirs`模块。该模块提供了一组预定义的变量，用于在不同操作系统上安装软件时确定标准目录。

`GNUInstallDirs`模块中定义的变量包括：

+ CMAKE_INSTALL_PREFIX：安装根目录
+ CMAKE_INSTALL_FULL_BINDIR：可执行文件安装目录
+ CMAKE_INSTALL_FULL_INCLUDEDIR：头文件安装目录
+ CMAKE_INSTALL_FULL_LIBDIR：库文件安装目录
+ CMAKE_INSTALL_FULL_DATADIR：数据文件安装目录
+ 等等...

通过使用`include(GNUInstallDirs)`，可以在`CMakeLists.txt`文件中访问这些预定义的变量，以便在构建过程中正确地安装文件到适当的目录中。

以下是一个简单的示例，展示了如何使用`GNUInstallDirs`模块和相关变量：

```cmake
cmake_minimum_required(VERSION 3.0)
project(MyProject)

# 包含 GNUInstallDirs 模块
include(GNUInstallDirs)

# 定义可执行文件
add_executable(my_executable main.cpp)

# 安装可执行文件到指定目录
install(TARGETS my_executable
DESTINATION ${CMAKE_INSTALL_FULL_BINDIR})

# 定义库文件
add_library(my_library my_source.cpp)

# 安装库文件到指定目录
install(TARGETS my_library
DESTINATION ${CMAKE_INSTALL_FULL_LIBDIR})
```

在上面的示例中，我们通过`include(GNUInstallDirs)`导入了`GNUInstallDirs`模块，然后使用其中定义的变量来指定安装目录。这样，在执行安装命令时，`CMake`将根据当前操作系统和配置自动确定正确的目录位置，并将相关文件安装到相应的目录中。

注意：`include(GNUInstallDirs)`的可用性取决于你所使用的 CMake 版本和平台。如果该命令无法正常工作，可能需要手动设置相关的目录变量。
