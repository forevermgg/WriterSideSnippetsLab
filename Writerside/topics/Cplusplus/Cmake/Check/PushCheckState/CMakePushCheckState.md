## CMakePushCheckState
`include(CMakePushCheckState)`是`CMake`中的一个命令，用于保存并恢复检查状态。它通常与`include(CheckFunctionExists)`或其他检查函数相关的命令一起使用。

在`CMake`中，`CheckFunctionExists`和类似的命令用于检查某个函数是否存在于当前编译环境中。然而，这些命令会影响`CMake`的全局状态，可能会导致后续的检查或构建出现问题。

为了避免这种问题，可以使用`include(CMakePushCheckState)`命令来保存当前的检查状态，然后进行新的检查，最后使用`include(CMakePopCheckState)`命令来恢复之前的检查状态。

以下是一个示例，展示了如何使用`CMakePushCheckState`和`CMakePopCheckState`：

```cmake
# 保存当前的检查状态
include(CMakePushCheckState)

# 进行新的检查
include(CheckFunctionExists)
check_function_exists(my_function HAVE_MY_FUNCTION)

# 恢复之前的检查状态
include(CMakePopCheckState)
```
在上述示例中，我们首先使用`include(CMakePushCheckState)`命令来保存当前的检查状态。然后，我们执行了一个新的检查，使用`CheckFunctionExists`命令检查名为`my_function`的函数是否存在，并将结果存储到变量`HAVE_MY_FUNCTION`中。最后，我们使用`include(CMakePopCheckState)`命令恢复之前保存的检查状态。

通过使用`CMakePushCheckState`和`CMakePopCheckState`，我们可以确保在进行新的检查时不会受到之前的检查状态的影响，从而避免潜在的问题和错误。

请注意，`include(CMakePushCheckState)`和`include(CMakePopCheckState)`必须成对使用，并且在它们之间不应该有其他命令，以确保正确的保存和恢复检查状态。

这就是关于`include(CMakePushCheckState)`的简要说明。它是用于管理`CMake`中检查函数相关命令的检查状态的实用工具。

```CMake
# Basic type
include(CMakePushCheckState)
cmake_push_check_state(RESET)
set(CMAKE_EXTRA_INCLUDE_FILES "cstdint")
include(CheckTypeSize)
check_type_size("long" SIZEOF_LONG LANGUAGE CXX)
message(STATUS "Found long size: ${SIZEOF_LONG}")
check_type_size("long long" SIZEOF_LONG_LONG LANGUAGE CXX)
message(STATUS "Found long long size: ${SIZEOF_LONG_LONG}")
check_type_size("int64_t" SIZEOF_INT64_T LANGUAGE CXX)
message(STATUS "Found int64_t size: ${SIZEOF_INT64_T}")

check_type_size("unsigned long" SIZEOF_ULONG LANGUAGE CXX)
message(STATUS "Found unsigned long size: ${SIZEOF_ULONG}")
check_type_size("unsigned long long" SIZEOF_ULONG_LONG LANGUAGE CXX)
message(STATUS "Found unsigned long long size: ${SIZEOF_ULONG_LONG}")
check_type_size("uint64_t" SIZEOF_UINT64_T LANGUAGE CXX)
message(STATUS "Found uint64_t size: ${SIZEOF_UINT64_T}")

check_type_size("int *" SIZEOF_INT_P LANGUAGE CXX)
message(STATUS "Found int * size: ${SIZEOF_INT_P}")
cmake_pop_check_state()
```