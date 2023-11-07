# Program Headers
```Bash
readelf -l <filename>
```

每个段类型描述二进制文件的不同组成部分。我们将重点关注PT_LOAD段。

PT_LOAD段描述了加载到内存中的代码。因此，可执行文件应始终至少有一个PT_LOAD段。在上面的屏幕截图中，您将看到训练样本包含 2 个PT_LOAD段。每个段都有不同的标志：

+ RE（读取和执行）标志：这是描述可执行代码的PT_LOAD段。文件的入口点应位于该段内。
+ RW（读和写）标志：这是包含文件的全局变量和动态链接信息的PT_LOAD段。
在段的输出中，我们还按照段表的相应顺序给出了段到段映射的列表。请注意，包含可执行代码指令的.text部分被映射到PT_LOAD RE段。

# Section Headers
```Bash
readelf -S <filename>
```

## .dynsym和.symtab
```Bash
readelf -s <filename>
```
.dynsym表包含动态链接的符号，例如 libc 函数，.symtab表包含源代码中定义的所有符号（包括.dynsym表中的符号）。

符号表可能很长。为简单起见，让我们分别查看每种符号类型。

+ OBJECT：代码中声明的全局变量。
+ FUNC：代码中声明的函数。
+ FILE：在二进制文件中编译的源文件（这是一个调试符号。如果文件从调试符号中剥离，则符号表将不包含此类型）
```Bash
readelf -s <filename> | grep OBJECT
readelf -s <filename> | grep FUNC
readelf -s <filename> | grep FILE
```
## .text
```Bash
objdump -s -d <filename>
```
搜索
Disassembly of section .text:
Contents of section .text

## .data  &&  .bss 
```Bash
objdump -x -s -d <filename>
```
