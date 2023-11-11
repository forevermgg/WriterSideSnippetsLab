### find_program()

`find_program()`是`CMake`中的一个命令，用于在系统路径中查找指定的可执行程序。

```cmake
find_program(FIREBASE_PYTHON_EXECUTABLE
  NAMES python3 python
  DOC "The Python interpreter to use, such as one from a venv"
  REQUIRED
)
```