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