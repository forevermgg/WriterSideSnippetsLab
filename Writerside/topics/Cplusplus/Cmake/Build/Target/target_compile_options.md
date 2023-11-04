### target_compile_options
target_compile_options命令用于为目标设置编译器选项。它的语法如下：
```cmake
target_compile_options(<target> <INTERFACE|PUBLIC|PRIVATE> [options...])
```
其中，target是目标的名称，可以是可执行文件、库或自定义目标。INTERFACE、PUBLIC和PRIVATE是可选的关键字，用于指定选项的可见性。options是编译器选项，可以是单个选项或选项列表。

INTERFACE、PUBLIC和PRIVATE关键字用于指定选项的可见性。如果选项是INTERFACE级别的，则它将应用于目标的所有依赖项。如果选项是PUBLIC级别的，则它将应用于目标和其公共依赖项。如果选项是PRIVATE级别的，则它将仅应用于目标本身。

例如，以下命令为名为my_library的库设置编译器选项：
```cmake
target_compile_options(my_library PRIVATE -Wall -Wextra)
```
这将为my_library库设置-Wall和-Wextra编译器选项。这些选项将仅应用于my_library库本身，而不会应用于my_library库的依赖项。

```cmake
# set minimum cmake version
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# project name and language
project(recipe-08 LANGUAGES CXX)

message("C++ compiler flags: ${CMAKE_CXX_FLAGS}")

list(APPEND flags "-fPIC" "-Wall")
if(NOT WIN32)
  list(APPEND flags "-Wextra" "-Wpedantic")
endif()

add_library(geometry
  STATIC
    geometry_circle.cpp
    geometry_circle.hpp
    geometry_polygon.cpp
    geometry_polygon.hpp
    geometry_rhombus.cpp
    geometry_rhombus.hpp
    geometry_square.cpp
    geometry_square.hpp
  )

target_compile_options(geometry
  PRIVATE
    ${flags}
  )

add_executable(compute-areas compute-areas.cpp)

target_compile_options(compute-areas
  PRIVATE
    "-fPIC"
  )

target_link_libraries(compute-areas geometry)
```


