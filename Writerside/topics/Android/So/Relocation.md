# 重定位（Relocation）

重定位（`Relocation`）指的是将符号定义（`Symbol Definition`）和符号引用（`Symbol Reference`）进行`连接`的`过程`。这个`过程``发生`在`编译`、`链接`和`运行`阶段，以确保`程序`可以在`不同的内存地址``运行`，同时保持对`全局变量`和`函数`的`正确引用`。

在编译时重定位阶段，编译器为每个符号引用生成一个重定位条目，存储在对象文件的重定位表中。
链接时重定位阶段，链接编辑器处理输入模块（对象文件和共享库）中的重定位表，将符号定义和符号引用进行连接。
运行时重定位阶段，动态链接器处理共享库中的重定位表，根据程序的实际加载地址计算符号引用的实际地址。

通过这些阶段的重定位，程序可以在不同的内存地址运行，同时保持对全局变量和函数的正确引用。


总结:重定位（`Relocation`）是`编译`、`链接`和`运行``过程`中`处理``符号引用`和`地址偏移`的一种`机制`。在程序的`生命周期`中，有三个阶段涉及到重定位：编译时重定位、链接时重定位和运行时重定位。

## 编译时重定位

编译时重定位主要涉及将源代码编译成对象文件（如 .o 文件）。在这个阶段，编译器会为每个符号引用（如全局变量和函数调用）生成一个重定位条目。这些重定位条目会存储在对象文件的重定位表（Relocation Table）中。重定位表中的每个条目包含以下信息：

+ 符号引用的类型（如绝对地址、相对地址等）。
+ 符号引用所在的位置（如代码或数据段中的偏移量）。
+ 被引用的符号（如全局变量或函数名称）。

## 链接时重定位

链接时重定位主要涉及将多个对象文件和共享库链接成可执行文件或共享库。在这个阶段，链接编辑器（Linker）会处理输入模块（对象文件和共享库）中的重定位表。对于每个重定位条目，链接编辑器会执行以下步骤：

+ 在全局符号表（Global Symbol Table）中查找被引用的符号的地址。全局符号表是由链接编辑器在链接过程中构建的，它包含了所有输入模块中的符号。
+ 根据重定位类型和被引用符号的地址，计算符号引用的实际值（如绝对地址或相对地址）。
+ 将实际值填充到符号引用所在的位置（如代码或数据段中的偏移量）。

## 运行时重定位

运行时重定位主要发生在动态链接库和共享库中，它允许库在运行时解析全局变量和函数的实际地址。运行时重定位由动态链接器（如 ld.so）负责处理，它会在程序启动时或按需加载时（懒加载）处理共享库中的重定位表。

在运行时重定位阶段，动态链接器根据程序的实际加载地址和共享库中的重定位表来计算符号引用的实际地址。然后，动态链接器将这些地址填充到全局偏移表（GOT）和过程链接表（PLT）等数据结构中。程序在运行时可以通过访问这些数据结构来间接引用全局变量和函数。

总之，重定位是程序在不同阶段处理符号引用和地址偏移的机制。这些重定位机制确保了程序可以在不同的内存地址运行，同时保持对全局变量和函数的正确引用。

## 重定位文件

重定位文件需要提供一些描述如何修改section内容的相关信息，从而保证可执行文件和共享目标文件能够在程序镜像中存储正确的信息。
这就是重定位表项做的工作。重定位表项的格式如下：

```C
typedef struct {  
Elf32_Addr r_offset;     //重定位动作所适用的位置（受影响的存储单位的第一个字节的偏移或者虚拟地址）
Elf32_Word r_info;       //要进行重定位的符号表索引，以及将实施的重定位类型（哪些位需要修改，以及如何计算它们的取值）
//其中 .rel.dyn 重定位类型一般为R_386_GLOB_DAT和R_386_COPY；.rel.plt为R_386_JUMP_SLOT
} Elf32_Rel;

typedef struct {
Elf32_Addr r_offset;      //指向了需要重定位的位置
uint32_t   r_info;        //存储了需要重定位符号表的索引和重定位类型。
int32_t    r_addend;      //用于计算存储在可定位字段中的值。
} Elf32_Rela;
```

在程序加载时，会通过自己的.rel section，告诉连接器需要重定位的位置

```Bash
readelf -r <filename> # 来读出重定位表内容
```

## RELRO

确保链接器在执行开始时解析所有动态链接的函数，然后将 `GOT`设置为只读。这种技术称为`RELRO`，可确保`GOT`不会在易受攻击的`ELF`二进制文件中被覆盖。
