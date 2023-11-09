# ELF 

## ELF指令基础

### Header
```Bash
readelf -e /bin/grep  # 显示ELF Header  Program Headers Section Headers
```
###  获取 ELF 文件头
```Bash
readelf -h <path/for/elf>
```
###  获取程序头表（段表）
```Bash
readelf -l <path/for/elf>
```
###  获取节表（获取有哪些节）
```Bash
readelf -S <path/for/elf>
```
###  获取符号表（列出函数、变量符号）
####  获取所有符号表（含`.symtab`和`.dynsym`）
```Bash
readelf -s <path/for/elf>
```
#### 获取动态符号表
```Bash
readelf --dyn-syms <path/for/elf>
```
### 获取节内容

#### 打印节中的字符串，常用于含字符串类型的节，例如`.rodata`节
```Bash
readelf -p <name/of/section> <path/for/elf>
```
####  以二进制打印节，常用于非字符串类型的节，例如`.bss`，`.data` 节
```Bash
readelf -x <name/of/section> <path/for/elf>
```
###  以汇编打印二进制代码
```Bash
objdump -d -j <name/of/section> <path/for/elf>
```

## Program Headers

### 获取程序头表（段表）
```Bash
readelf -l <path/for/elf>
```

每个段类型描述二进制文件的不同组成部分。我们将重点关注`PT_LOAD`段。

`PT_LOAD`段描述了加载到内存中的代码。因此，可执行文件应始终至少有一个`PT_LOAD`段。在上面的屏幕截图中，您将看到训练样本包含`2`个`PT_LOAD`段。每个段都有不同的标志：

+ `RE`（读取和执行）标志：这是描述可执行代码的`PT_LOAD`段。文件的入口点应位于该段内。
+ `RW`（读和写）标志：这是包含文件的全局变量和动态链接信息的`PT_LOAD`段。
在段的输出中，我们还按照段表的相应顺序给出了段到段映射的列表。请注意，包含可执行代码指令的`.text`部分被映射到`PT_LOAD` `RE`段。

## Section Headers
```Bash
readelf -S <filename>
```

### `.dynsym` && `.symtab`
####  符号表
符号表包含用来定位、重定位程序中符号定义和引用的信息，简单的理解就是符号表记录了该文件中的所有符号，所谓的符号就是经过修饰了的函数名或者变量名。
`.symtab`保存了这个可执行文件或者是`.so`中的所有符号信息。 `.dynsym` 是 `.symtab` 的一个子集，实际代码运行中其实只需要`.dynsym`.
#####  获取符号表
`Symbol Table` 包含 `.symtab` 和 `.dynsym`
`.symtab`，俗称的符号表，记录了所有符号，不管是自己定义的变量、函数，还是未定义需要动态库提供实现的所有符号。
```Bash
readelf -s <path/for/elf>
```
##### 获取动态符号表
`.dynsym`，动态链接才需要的符号表，即可包括对外提供调用的符号，也包括需要外面提供实现的符号。
```Bash
readelf --dyn-syms <path/for/elf>
```
`.dynsym`节保存在`text`段中。其保存了从共享库导入的动态符号表。
`.dynsym`表包含动态链接的符号，例如`libc`函数，`.symtab`表包含源代码中定义的所有符号（包括`.dynsym`表中的符号）。

### 符号表 Type
符号表可能很长。为简单起见，让我们分别查看每种符号类型。

+ `OBJECT`：代码中声明的全局变量。
+ `FUNC`：代码中声明的函数。
+ `FILE`：在二进制文件中编译的源文件（这是一个调试符号。如果文件从调试符号中剥离，则符号表将不包含此类型）
```Bash
readelf -s <filename> | grep OBJECT
readelf -s <filename> | grep FUNC
readelf -s <filename> | grep FILE
```

### 前面提到`.symtab`和`.dynsym`两个不同的`symbol table`, 它们有什么区别?
关于两个符号表的区别请参考：动态链接库中的`.symtab`和`.dynsym` https://blog.csdn.net/huangyimo/article/details/82695651
`.dynsym`是`.symtab`的一个子集, 大家都有疑问, 为什么要两个信息重合的结构?
需要先了解`allocable`/`non-allocable` `ELF` `section`, `ELF`文件包含一些`sections`(如`code`和`data`)是在运行时需要的, 这些`sections`被称为`allocable`; 而其他一些`sections`仅仅是`linker`,`debugger`等工具需要, 在运行时并不需要, 这些`sections`被称为`non-allocable`的. 当`linker`构建`ELF`文件时, 它把`allocable`的数据放到一个地方, 将`non-allocable`的数据放到其他地方. 当`OS`加载`ELF`文件时, 仅仅`allocable`的数据被映射到内存, `non-allocable`的数据仍静静地呆在文件里不被处理. `strip`就是用来移除某些`non-allocable` `sections`的.
`.symtab`包含大量`linker`,`debugger`需要的数据, 但并不为`runtime`必需, 它是`non-allocable`的; `.dynsym`包含`.symtab`的一个子集, 比如共享库所需要在`runtime`加载的函数对应的`symbols`, 它是`allocable`的.

因此, 得到答案:
1. `strip`移除的应是`.symtab`.

### `.dynstr`
#### 获取
```
readelf -p .dynstr your_executable_or_library
```
符号表的`st_name`是符号名的字符串表中的索引，那么字符串表中肯定存放着所有符号的名称字符串。 `.dynstr`保存了动态链接字符串表，表中存放了一系列字符串，这些字符串代表了符号名称，以空字符作为终止符。
里面的内容都是字符串，这个字符串表`.dynstr`是给符号表(`.dynsym`)使用的。

这将显示`.dynstr`节中的内容，包括存储在其中的所有字符串。这些字符串通常是动态链接器在运行时需要解析的符号名称。
### `.strtab`
`.strtab`节保存的符号字符串表，表中的内容会被`.symtab`的`ElfN_Sym`结构中的`st_name`引用, 他的内容格式实际上和`.dynstr`是一样的，这里不再具体说明，感兴趣的同学可以自行搜索两者之间的差异。
### `.text`
```Bash
objdump -s -d <filename>
```
搜索
`Disassembly of section .text:`
`Contents of section .text`

### `.data`  &&  `.bss`
```Bash
objdump -x -s -d <filename>
```

### 十六进制显示section的内容
```Bash
# 十六进制显示 section 的内容, 可以使用 section 编号或者名字
# readelf -x --hex-dump=<number|name>
readelf -x 29 /bin/grep  # 查看 .shstrtab section, 编号 29
readelf -x .data /bin/grep  # 查看 .data section
```
### 字符串方式显示section的内容
```Bash
# 字符串方式显示 section 的内容, 可以使用 section 编号或者名字
# readelf -p --string-dump=<number|name>
readelf -p 29 /bin/grep  # 查看 .shstrtab section, 编号 29
readelf -p .data /bin/grep  # 查看 .data section
```

### `.rel.text`

重定位的地方在`.text`段内，以`offset`指定具体要定位位置。在链接时候由链接器完成。 .rel.text 属于普通重定位辅助段 ,它由编译器编译产生，存在于obj文件内。链接器链接时，它用于最终可执行文件或者动态库的重定位。通过它修改源obj文件的 .text 段后，合并到最终可执行文件或者动态文件的.text段。

### .rel.dyn

重定位的地方在.got 段内。主要是针对外部数据变量符号。例如全局数据。定位过程：获得符号对应 value 后，根据 rel.dyn 表中对应的 offset ，修改 .got 表对应位置的 value 。另外， .rel.dyn 含义是指和 dyn 有关，一般是指在程序运行时候，动态加载。区别于rel.plt，rel.plt是指和plt相关，具体是指在某个函数被调用时候加载。在重定位过程中，动态链接器根据 r_offset 找到 .got 对应表项，来完成对 .got 表项值的修改。

### .rel.plt

重定位的地方在 .got.plt 段内（注意也是 .got 内,具体区分而已）。 主要是针对外部函数符号。一般是函数首次被调用时候重定位。首次调用时会重定位函数地址，把最终函数地址放到 .got.plt 内，以后读取该 .got.plt 就直接得到最终函数地址。在重定位过程中，动态链接器根据 r_offset 找到 .got.plt 对应表项，来完成对 .got.plt 表项值的修改。

### .plt 段（过程链接表）

所有外部函数调用都是经过一个对应桩函数，这些桩函数都在 .plt 段内。具体调用外部函数过程是： 调用对应桩函数—>桩函数取出 .got.plt 表表内地址—>然后跳转到这个地址.如果是第一次,这个跳转地址默认是桩函数本身跳转处地址的下一个指令地址(目的是通过桩函数统一集中取地址和加载地址),后续接着把对应函数的真实地址加载进来放到 .got.plt 表对应处,同时跳转执行该地址指令.以后桩函数从 .got.plt 取得地址都是真实函数地址了。

### .got （全局偏移表）

包含 .got （变量）以及 .got.plt (函数)

.rel.dyn 和 .rel.plt 是动态定位辅助段。由链接器产生，存在于可执行文件或者动态库文件内。借助这两个辅助段可以动态修改对应.got和.got.plt段，从而实现运行时重定位。

## 参考
地址无关代码 http://nicephil.blinkenshell.org/my_book/ch07s03.html
延迟绑定 http://nicephil.blinkenshell.org/my_book/ch07s04.html
理解重定位 http://3xp10it.cc/%E4%BA%8C%E8%BF%9B%E5%88%B6/2017/12/05/%E7%90%86%E8%A7%A3%E9%87%8D%E5%AE%9A%E4%BD%8D/
深入理解 Linux 位置无关代码 PIC https://blog.csdn.net/feelabclihu/article/details/108289461