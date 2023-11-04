### 输出目标文件到指定目录
```cmake
# 设置静态库文件目录
# set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../output/snappy/jniLibs/${ANDROID_ABI})

# 动态库文件目录
# set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../output/snappy/jniLibs/${ANDROID_ABI})

execute_process(
        COMMAND
        ${CMAKE_COMMAND}
        -E
        copy
        ${CMAKE_CURRENT_BINARY_DIR}/libsnappy.a
        ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../output/snappy/jniLibs/${ANDROID_ABI}/libsnappy.a)
```

### 加载依赖文件
```cmake
# loading dependencies properties
file(STRINGS "${CMAKE_SOURCE_DIR}/../../../../../dependencies.list" DEPENDENCIES)
foreach(LINE IN LISTS DEPENDENCIES)

    string(REGEX MATCHALL "([^=]+)" KEY_VALUE "${LINE}")
    list(LENGTH KEY_VALUE matches_count)
    if(matches_count STREQUAL 2)
        list(GET KEY_VALUE 0 KEY)
        list(GET KEY_VALUE 1 VALUE)
        set(DEP_${KEY} ${VALUE})
    endif()
endforeach()
```
### MAKE_DIRECTORY
https://github.com/google/bloaty/blob/main/CMakeLists.txt
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/src)
```CMake
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/src)
if(PROTOC_FOUND)
add_custom_command(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/src/bloaty.pb.cc
  DEPENDS protoc ${CMAKE_CURRENT_SOURCE_DIR}/src/bloaty.proto
  COMMAND protoc ${CMAKE_CURRENT_SOURCE_DIR}/src/bloaty.proto
      --cpp_out=${CMAKE_CURRENT_BINARY_DIR}/src
      -I${CMAKE_CURRENT_SOURCE_DIR}/src
)
else()
add_custom_command(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/src/bloaty.pb.cc
  COMMAND protoc ${CMAKE_CURRENT_SOURCE_DIR}/src/bloaty.proto
      --cpp_out=${CMAKE_CURRENT_BINARY_DIR}/src
      -I${CMAKE_CURRENT_SOURCE_DIR}/src
)
endif()
```
### COPY
```CMake
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/src/bloaty_package.bloaty
DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
```
