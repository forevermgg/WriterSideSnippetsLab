## Check out Git submodules.

```CMake
if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/.gitmodules")
execute_process (COMMAND git submodule update --init --recursive
WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
endif()
```

.gitmodules

```text
[submodule "third_party/re2"]
	path = third_party/re2
	url = https://github.com/google/re2
[submodule "third_party/googletest"]
	path = third_party/googletest
	url = https://github.com/google/googletest.git
[submodule "third_party/abseil-cpp"]
	path = third_party/abseil-cpp
	url = https://github.com/abseil/abseil-cpp.git
[submodule "third_party/protobuf"]
	path = third_party/protobuf
	url = https://github.com/protocolbuffers/protobuf.git
[submodule "third_party/capstone"]
	path = third_party/capstone
	url = https://github.com/aquynh/capstone.git
[submodule "third_party/demumble"]
	path = third_party/demumble
	url = https://github.com/nico/demumble.git
[submodule "third_party/zlib"]
	path = third_party/zlib
	url = https://github.com/madler/zlib
```

## 使用

https://github.com/google/bloaty/blob/main/CMakeLists.txt

```CMake
add_subdirectory(third_party/re2)
include_directories(third_party/re2)

add_subdirectory(third_party/capstone)
include_directories(third_party/capstone/include)

add_subdirectory(third_party/protobuf/cmake)
include_directories(SYSTEM third_party/protobuf/src)

add_subdirectory(third_party/zlib)
include_directories(SYSTEM third_party/zlib)

set_property(TARGET re2 PROPERTY FOLDER "third_party")
set_property(TARGET zlib PROPERTY FOLDER "third_party")
set_property(TARGET zlibstatic PROPERTY FOLDER "third_party")
set_property(TARGET libprotobuf PROPERTY FOLDER "third_party")
set_property(TARGET libprotobuf-lite PROPERTY FOLDER "third_party")
set_property(TARGET libprotoc PROPERTY FOLDER "third_party")
set_property(TARGET protoc PROPERTY FOLDER "third_party")
```



