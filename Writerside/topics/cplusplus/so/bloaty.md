# Bloaty简介

Bloaty是一个工具，可以显示二进制文件的大小分布情况，并帮助您了解二进制文件中占用空间的原因。

Bloaty通过深度分析二进制文件来获取这些信息。它使用自定义的ELF、DWARF和Mach-O解析器，致力于将二进制文件的每个字节准确地归属到产生它的符号或编译单元。甚至可以反汇编二进制文件以查找对匿名数据的引用。

Bloaty支持许多功能，包括：

+ 文件格式：ELF、Mach-O、PE/COFF（实验性）、WebAssembly（实验性）
+ 数据源：编译单元（如上所示）、符号、节、段等
+ 层次化概要：将多个数据源组合成单个报告
+ 大小差异：查看二进制文件增长的部分，非常适合持续集成测试
+ 单独调试文件：剥离待测二进制文件，同时保留可供分析的调试数据
+ 灵活的符号重组：解析C++符号，并可选择丢弃函数/模板参数
+ 自定义数据源：对内置数据源进行正则表达式重写，用于自定义修改/分桶
+ 正则表达式过滤：过滤与给定正则表达式匹配或不匹配的二进制文件的部分
+ 易于部署：静态链接的C++二进制文件，轻松复制和使用

## Bloaty安装 {id="Bloaty安装"}
https://github.com/google/bloaty
## brew安装
https://formulae.brew.sh/formula/bloaty
```Bash
brew install bloaty
```
## 校验
```Bash
❯ bloaty --help
Bloaty McBloatface: a size profiler for binaries.

USAGE: bloaty [OPTION]... FILE... [-- BASE_FILE...]

Options:

  --csv              Output in CSV format instead of human-readable.
  --tsv              Output in TSV format instead of human-readable.
  -c FILE            Load configuration from <file>.
  -d SOURCE,SOURCE   Comma-separated list of sources to scan.
  --debug-file=FILE  Use this file for debug symbols and/or symbol table.
  -C MODE            How to demangle symbols.  Possible values are:
  --demangle=MODE      --demangle=none   no demangling, print raw symbols
                       --demangle=short  demangle, but omit arg/return types
                       --demangle=full   print full demangled type
                     The default is --demangle=short.
  --disassemble=FUNCTION
                     Disassemble this function (EXPERIMENTAL)
  --domain=DOMAIN    Which domains to show.  Possible values are:
                       --domain=vm
                       --domain=file
                       --domain=both (the default)
  -n NUM             How many rows to show per level before collapsing
                     other keys into '[Other]'.  Set to '0' for unlimited.
                     Defaults to 20.
  -s SORTBY          Whether to sort by VM or File size.  Possible values
                     are:
                       -s vm
                       -s file
                       -s both (the default: sorts by max(vm, file)).
  -w                 Wide output; don't truncate long labels.
  --help             Display this message and exit.
  --list-sources     Show a list of available sources and exit.
  --source-filter=PATTERN
                     Only show keys with names matching this pattern.

Options for debugging Bloaty:

  --debug-vmaddr=ADDR
  --debug-fileoff=OFF
                     Print extended debugging information for the given
                     VM address and/or file offset.
  -v                 Verbose output.  Dumps warnings encountered during
                     processing and full VM/file maps at the end.
                     Add more v's (-vv, -vvv) for even more.
```

## Running Bloaty 运行Bloaty
## Compile Units 编译单元
以下是使用Bloaty进行分析后得到的二进制文件大小和虚拟内存大小的分布情况：
+ 第一列为文件大小的百分比和实际大小（以MiB表示）
+ 第二列为虚拟内存大小的百分比和实际大小（以MiB表示）
+ 第三列为对应的文件路径或符号
```Bash
❯ file libc++_shared.so
libc++_shared.so: ELF 64-bit LSB shared object, ARM aarch64, version 1 (SYSV), dynamically linked, BuildID[sha1]=9eb617a4c141d9c0422d2c46392d3cfa6c601be1, with debug_info, not stripped
❯ bloaty libc++_shared.so -d compileunits,sections
    FILE SIZE        VM SIZE
 --------------  --------------
  33.5%  1.99Mi  29.4%   264Ki    /Volumes/Android/buildbot/src/android/ndk-release-r21/external/libcxx/src/locale.cpp
    36.1%   736Ki   0.0%       0    .debug_loc
    24.3%   495Ki   0.0%       0    .debug_info
     8.9%   182Ki   0.0%       0    .debug_ranges
     8.8%   179Ki  67.8%   179Ki    .text
     7.0%   143Ki   0.0%       0    .debug_line
     6.7%   136Ki   0.0%       0    .debug_str
     2.7%  55.0Ki   0.0%       0    .strtab
     1.9%  38.2Ki  14.4%  38.2Ki    .dynstr
     1.4%  28.7Ki   0.0%       0    .symtab
     1.1%  22.6Ki   8.5%  22.6Ki    .eh_frame
     0.7%  13.9Ki   5.2%  13.9Ki    .dynsym
     0.3%  5.33Ki   2.0%  5.33Ki    .eh_frame_hdr
     0.0%       0   1.2%  3.05Ki    .bss
     0.1%  2.00Ki   0.8%  2.00Ki    .rodata
  12.8%   778Ki   8.4%  75.9Ki    /Volumes/Android/buildbot/src/android/ndk-release-r21/external/libcxx/../../external/libcxxabi/src/cxa_demangle.cpp
    29.1%   226Ki   0.0%       0    .debug_loc
    24.6%   191Ki   0.0%       0    .debug_info
    13.3%   103Ki   0.0%       0    .debug_str
    11.8%  92.2Ki   0.0%       0    .debug_ranges
     8.7%  67.6Ki  89.0%  67.6Ki    .text
     7.9%  61.1Ki   0.0%       0    .debug_line
     2.2%  17.3Ki   0.0%       0    .strtab
     1.3%  10.1Ki   0.0%       0    .symtab
     0.8%  6.60Ki   8.7%  6.60Ki    .eh_frame
     0.2%  1.68Ki   2.2%  1.68Ki    .eh_frame_hdr
     0.0%      24   0.0%      24    .dynsym
     0.0%      15   0.0%      15    .dynstr
  11.9%   722Ki  26.3%   236Ki    [75 Others]
   9.0%   548Ki   5.1%  45.8Ki    /Volumes/Android/buildbot/src/android/ndk-release-r21/external/libcxx/src/algorithm.cpp
    47.3%   259Ki   0.0%       0    .debug_loc
    21.2%   116Ki   0.0%       0    .debug_info
    10.1%  55.2Ki   0.0%       0    .debug_abbrev
     6.5%  35.8Ki  78.2%  35.8Ki    .text
     6.0%  32.7Ki   0.0%       0    .debug_line
     3.9%  21.3Ki   0.0%       0    .debug_str
     3.0%  16.7Ki   0.0%       0    .debug_ranges
     0.0%       0  10.7%  4.88Ki    .bss
     0.5%  2.99Ki   0.0%       0    .strtab
     0.5%  2.72Ki   0.0%       0    .symtab
     0.4%  2.09Ki   4.6%  2.09Ki    .dynstr
     0.3%  1.70Ki   3.7%  1.70Ki    .eh_frame
     0.2%     936   2.0%     936    .dynsym
     0.1%     400   0.9%     400    .eh_frame_hdr
   8.9%   543Ki   9.8%  87.7Ki    /Volumes/Android/buildbot/src/android/ndk-release-r21/external/libcxx/src/ios.cpp
    29.3%   159Ki   0.0%       0    .debug_loc
    23.1%   125Ki   0.0%       0    .debug_info
     9.5%  51.8Ki  59.1%  51.8Ki    .text
     9.2%  49.9Ki   0.0%       0    .debug_str
     8.6%  46.8Ki   0.0%       0    .debug_line
     7.4%  40.4Ki   0.0%       0    .debug_ranges
     3.7%  19.9Ki   0.0%       0    .strtab
     3.1%  17.1Ki  19.5%  17.1Ki    .dynstr
     2.6%  14.3Ki   0.0%       0    .symtab
     1.8%  9.80Ki  11.2%  9.80Ki    .eh_frame
     1.2%  6.66Ki   7.6%  6.66Ki    .dynsym
     0.4%  2.31Ki   2.6%  2.31Ki    .eh_frame_hdr
     0.0%       0   0.0%      24    .bss
     0.0%       1   0.0%       1    .data
   7.1%   431Ki   5.0%  44.9Ki    /Volumes/Android/buildbot/src/android/ndk-release-r21/external/libcxx/src/string.cpp
    35.6%   153Ki   0.0%       0    .debug_loc
    30.0%   129Ki   0.0%       0    .debug_info
     8.2%  35.3Ki   0.0%       0    .debug_str
     6.4%  27.8Ki  61.9%  27.8Ki    .text
     6.4%  27.7Ki   0.0%       0    .debug_ranges
     6.3%  27.0Ki   0.0%       0    .debug_line
     2.0%  8.82Ki   0.0%       0    .strtab
     2.0%  8.72Ki  19.4%  8.72Ki    .dynstr
     1.1%  4.92Ki   0.0%       0    .symtab
     1.1%  4.60Ki  10.2%  4.60Ki    .eh_frame
     0.7%  2.88Ki   6.4%  2.88Ki    .dynsym
     0.2%     936   2.0%     936    .eh_frame_hdr
   2.1%   129Ki   1.4%  12.5Ki    /Volumes/Android/buildbot/src/android/ndk-release-r21/external/libcxx/src/debug.cpp
    33.0%  42.9Ki   0.0%       0    .debug_info
    22.2%  28.9Ki   0.0%       0    .debug_loc
    20.9%  27.1Ki   0.0%       0    .debug_str
     7.3%  9.46Ki   0.0%       0    .debug_line
     6.1%  7.93Ki  63.4%  7.93Ki    .text
     4.2%  5.45Ki   0.0%       0    .debug_ranges
     1.7%  2.16Ki   0.0%       0    .strtab
     1.4%  1.82Ki  14.5%  1.82Ki    .dynstr
     1.2%  1.52Ki   0.0%       0    .symtab
     1.1%  1.44Ki  11.5%  1.44Ki    .eh_frame
     0.7%     936   7.3%     936    .dynsym
     0.3%     336   2.6%     336    .eh_frame_hdr
     0.0%       0   0.7%      88    .bss
   1.5%  94.3Ki   0.3%  3.02Ki    /Volumes/Android/buildbot/src/android/ndk-release-r21/external/libcxx/src/thread.cpp
    48.3%  45.5Ki   0.0%       0    .debug_str
    35.4%  33.4Ki   0.0%       0    .debug_info
     5.7%  5.37Ki   0.0%       0    .debug_loc
     4.4%  4.19Ki   0.0%       0    .debug_line
     1.5%  1.37Ki  45.4%  1.37Ki    .text
     1.3%  1.20Ki   0.0%       0    .strtab
     1.0%     944   0.0%       0    .debug_ranges
     0.7%     696   0.0%       0    .symtab
     0.7%     655  21.2%     655    .dynstr
     0.6%     560  18.1%     560    .eh_frame
     0.3%     336  10.9%     336    .dynsym
     0.1%     136   4.4%     136    .eh_frame_hdr
     0.0%       0   0.1%       4    .bss
   1.5%  90.9Ki   0.2%  1.53Ki    /Volumes/Android/buildbot/src/android/ndk-release-r21/external/libcxx/src/regex.cpp
    48.5%  44.1Ki   0.0%       0    .debug_str
    43.6%  39.7Ki   0.0%       0    .debug_info
     3.6%  3.23Ki   0.0%       0    .debug_line
     1.9%  1.69Ki   0.0%       0    .debug_loc
     0.7%     656  41.9%     656    .text
     0.5%     420  26.9%     420    .dynstr
     0.5%     420   0.0%       0    .strtab
     0.3%     264   0.0%       0    .symtab
     0.2%     216  13.8%     216    .dynsym
     0.2%     216  13.8%     216    .eh_frame
     0.1%      56   3.6%      56    .eh_frame_hdr
   1.2%  73.1Ki   8.1%  73.1Ki    [section .rela.dyn]
   1.2%  72.9Ki   0.5%  4.57Ki    /Volumes/Android/buildbot/src/android/ndk-release-r21/external/libcxx/src/iostream.cpp
    60.3%  43.9Ki   0.0%       0    .debug_info
    12.4%  9.02Ki   0.0%       0    .debug_line
    10.5%  7.66Ki   0.0%       0    .debug_loc
     5.2%  3.77Ki  82.3%  3.77Ki    .text
     4.5%  3.31Ki   0.0%       0    .debug_str
     4.3%  3.11Ki   0.0%       0    .debug_ranges
     1.0%     720   0.0%       0    .symtab
     0.8%     609   0.0%       0    .strtab
     0.7%     512  10.9%     512    .eh_frame
     0.2%     124   2.6%     124    .dynstr
     0.1%      96   2.0%      96    .dynsym
     0.1%      96   2.0%      96    .eh_frame_hdr
   1.2%  70.8Ki   0.0%       0    [section .symtab]
   1.1%  67.6Ki   0.7%  6.53Ki    /Volumes/Android/buildbot/src/android/ndk-release-r21/external/libcxx/src/system_error.cpp
    48.7%  32.9Ki   0.0%       0    .debug_info
    22.7%  15.4Ki   0.0%       0    .debug_loc
     8.0%  5.43Ki   0.0%       0    .debug_line
     4.6%  3.14Ki  48.1%  3.14Ki    .text
     3.2%  2.18Ki   0.0%       0    .debug_str
     3.2%  2.14Ki   0.0%       0    .debug_ranges
     2.9%  1.99Ki   0.0%       0    .strtab
     2.2%  1.51Ki  23.2%  1.51Ki    .dynstr
     1.6%  1.10Ki   0.0%       0    .symtab
     1.4%     984  14.7%     984    .eh_frame
     1.0%     672  10.1%     672    .dynsym
     0.4%     248   3.7%     248    .eh_frame_hdr
     0.0%       0   0.2%      16    .bss
   1.1%  67.4Ki   0.9%  8.20Ki    /Volumes/Android/buildbot/src/android/ndk-release-r21/external/libcxx/src/strstream.cpp
    49.3%  33.2Ki   0.0%       0    .debug_info
    18.2%  12.3Ki   0.0%       0    .debug_loc
     9.9%  6.68Ki   0.0%       0    .debug_line
     6.1%  4.08Ki  49.8%  4.08Ki    .text
     3.3%  2.24Ki   0.0%       0    .debug_str
     3.0%  2.05Ki   0.0%       0    .debug_ranges
     2.4%  1.58Ki   0.0%       0    .strtab
     2.3%  1.58Ki  19.3%  1.58Ki    .dynstr
     1.7%  1.17Ki  14.3%  1.17Ki    .eh_frame
     1.7%  1.15Ki   0.0%       0    .symtab
     1.6%  1.08Ki  13.1%  1.08Ki    .dynsym
     0.4%     296   3.5%     296    .eh_frame_hdr
   1.0%  62.0Ki   0.8%  7.26Ki    /Volumes/Android/buildbot/src/android/ndk-release-r21/external/libcxx/src/future.cpp
    50.9%  31.5Ki   0.0%       0    .debug_info
    11.9%  7.40Ki   0.0%       0    .debug_loc
     9.9%  6.11Ki   0.0%       0    .debug_str
     9.1%  5.64Ki   0.0%       0    .debug_line
     5.8%  3.58Ki  49.3%  3.58Ki    .text
     2.8%  1.76Ki   0.0%       0    .strtab
     2.4%  1.46Ki  20.1%  1.46Ki    .dynstr
     1.9%  1.20Ki   0.0%       0    .symtab
     1.8%  1.13Ki  15.6%  1.13Ki    .eh_frame
     1.8%  1.09Ki   0.0%       0    .debug_ranges
     1.3%     840  11.3%     840    .dynsym
     0.4%     264   3.6%     264    .eh_frame_hdr
     0.0%       0   0.1%       8    .bss
   1.0%  59.4Ki   0.9%  7.97Ki    /Volumes/Android/buildbot/src/android/ndk-release-r21/external/libcxx/../../external/libcxxabi/src/private_typeinfo.cpp
    30.6%  18.2Ki   0.0%       0    .debug_loc
    23.3%  13.8Ki   0.0%       0    .debug_info
    10.7%  6.39Ki  80.1%  6.39Ki    .text
    10.4%  6.20Ki   0.0%       0    .debug_line
     7.8%  4.66Ki   0.0%       0    .debug_str
     6.4%  3.79Ki   0.0%       0    .strtab
     4.2%  2.48Ki   0.0%       0    .symtab
     3.9%  2.34Ki   0.0%       0    .debug_ranges
     2.0%  1.21Ki  15.2%  1.21Ki    .eh_frame
     0.5%     320   3.9%     320    .eh_frame_hdr
     0.0%      24   0.3%      24    .dynsym
     0.0%      24   0.3%      24    .rodata
     0.0%      15   0.2%      15    .dynstr
   0.9%  55.2Ki   1.1%  10.3Ki    /Volumes/Android/buildbot/src/android/gcc/toolchain/build/../gcc/gcc-4.9/libgcc/unwind-dw2.c
    33.0%  18.2Ki   0.0%       0    .debug_loc
    28.4%  15.7Ki   0.0%       0    .debug_info
    14.2%  7.82Ki  75.9%  7.82Ki    .text
     9.5%  5.26Ki   0.0%       0    .debug_str
     5.1%  2.84Ki   0.0%       0    .debug_line
     3.8%  2.12Ki  20.6%  2.12Ki    .eh_frame
     2.3%  1.30Ki   0.0%       0    .debug_ranges
     1.7%     960   0.0%       0    .symtab
     1.3%     746   0.0%       0    .strtab
     0.5%     272   2.6%     272    .eh_frame_hdr
     0.0%       0   1.0%     102    .bss
   0.9%  54.6Ki   0.0%       0    [section .debug_loc]
   0.9%  51.9Ki   0.0%       0    [section .strtab]
   0.7%  41.1Ki   0.9%  8.12Ki    /Volumes/Android/buildbot/src/android/gcc/toolchain/build/../gcc/gcc-4.9/libgcc/unwind-dw2-fde-dip.c
    37.2%  15.3Ki   0.0%       0    .debug_loc
    27.1%  11.2Ki   0.0%       0    .debug_info
    14.8%  6.09Ki  75.1%  6.09Ki    .text
     5.3%  2.17Ki   0.0%       0    .debug_line
     4.2%  1.73Ki   0.0%       0    .debug_ranges
     3.7%  1.51Ki   0.0%       0    .debug_str
     3.2%  1.34Ki  16.5%  1.34Ki    .eh_frame
     2.3%     984   0.0%       0    .symtab
     1.5%     649   0.0%       0    .strtab
     0.0%       0   5.7%     472    .bss
     0.5%     224   2.7%     224    .eh_frame_hdr
     0.0%       8   0.1%       8    .data
   0.6%  36.3Ki   0.2%  1.46Ki    /Volumes/Android/buildbot/src/android/ndk-release-r21/external/libcxx/src/random.cpp
    70.1%  25.5Ki   0.0%       0    .debug_info
    11.1%  4.03Ki   0.0%       0    .debug_line
    10.0%  3.62Ki   0.0%       0    .debug_loc
     1.8%     680  45.4%     680    .text
     1.8%     659   0.0%       0    .debug_str
     1.2%     464   0.0%       0    .debug_ranges
     1.1%     417   0.0%       0    .strtab
     1.1%     411  27.4%     411    .dynstr
     0.6%     240   0.0%       0    .symtab
     0.5%     200  13.3%     200    .eh_frame
     0.5%     168  11.2%     168    .dynsym
     0.1%      40   2.7%      40    .eh_frame_hdr
 100.0%  5.95Mi 100.0%   899Ki    TOTAL
```
## Bloaty 默认
+ "VM SIZE"列告诉您二进制文件加载到内存时占用的空间大小。
+ "FILE SIZE"列告诉您二进制文件在磁盘上占用的空间大小。这两者之间可能存在很大的差异：

一些数据存在于文件中，但不会加载到内存中，例如调试信息。
一些数据被映射到内存中，但在文件中不存在。主要适用于.bss节（零初始化数据）。
```Bash
❯ bloaty libc++_shared.so
    FILE SIZE        VM SIZE
 --------------  --------------
  29.5%  1.75Mi   0.0%       0    .debug_loc
  26.4%  1.57Mi   0.0%       0    .debug_info
   9.0%   546Ki   0.0%       0    .debug_str
   7.4%   450Ki   0.0%       0    .debug_line
   7.2%   438Ki  48.8%   438Ki    .text
   6.6%   403Ki   0.0%       0    .debug_ranges
   3.0%   181Ki   0.0%       0    .strtab
   2.5%   154Ki   0.0%       0    .symtab
   1.7%   106Ki  11.8%   106Ki    .dynstr
   1.2%  73.5Ki   8.2%  73.5Ki    .rela.dyn
   1.1%  66.2Ki   7.4%  66.1Ki    .eh_frame
   0.9%  56.5Ki   0.0%       0    .debug_abbrev
   0.9%  54.7Ki   6.1%  54.6Ki    .dynsym
   0.5%  28.3Ki   2.8%  24.9Ki    [19 Others]
   0.4%  27.3Ki   3.0%  27.2Ki    .data.rel.ro
   0.4%  23.4Ki   2.6%  23.3Ki    .rodata
   0.3%  21.2Ki   2.3%  21.1Ki    .gcc_except_table
   0.3%  18.7Ki   2.1%  18.6Ki    .gnu.hash
   0.3%  17.2Ki   1.9%  17.1Ki    .hash
   0.3%  15.3Ki   1.7%  15.3Ki    .eh_frame_hdr
   0.0%       0   1.4%  12.8Ki    .bss
 100.0%  5.95Mi 100.0%   899Ki    TOTAL
```
## Range Map
RangeMap（如在range_map.h中定义）是Bloaty的核心数据结构。它是一个稀疏映射，将VM或文件空间的区域[start, end)与一个标签关联起来。
在Bloaty完成时，它会构建二进制文件的完整的VM和文件空间映射。您可以通过使用'-v'运行Bloaty来查看这些映射：
```Bash
-v                 详细输出。在处理过程中，输出遇到的警告和完整的VM/文件映射。
```
```Bash
❯ bloaty libc++_shared.so -v -d sections
FILE MAP:
[0, 200] LOAD #0 [RX], [LOAD #0 [RX]]
[200, 224] LOAD #0 [RX], .note.gnu.build-id
[224, 228] LOAD #0 [RX], [LOAD #0 [RX]]
[228, 46ac] LOAD #0 [RX], .hash
[46ac, 46b0] LOAD #0 [RX], [LOAD #0 [RX]]
[46b0, 9120] LOAD #0 [RX], .gnu.hash
[9120, 16b90] LOAD #0 [RX], .dynsym
[16b90, 314e8] LOAD #0 [RX], .dynstr
[314e8, 3271c] LOAD #0 [RX], .gnu.version
[3271c, 32720] LOAD #0 [RX], [LOAD #0 [RX]]
[32720, 32760] LOAD #0 [RX], .gnu.version_r
[32760, 44d48] LOAD #0 [RX], .rela.dyn
[44d48, 47040] LOAD #0 [RX], .rela.plt
[47040, 487b0] LOAD #0 [RX], .plt
[487b0, b62a0] LOAD #0 [RX], .text
[b62a0, bbffd] LOAD #0 [RX], .rodata
[bbffd, bc000] LOAD #0 [RX], [LOAD #0 [RX]]
[bc000, bfd14] LOAD #0 [RX], .eh_frame_hdr
[bfd14, bfd18] LOAD #0 [RX], [LOAD #0 [RX]]
[bfd18, d0598] LOAD #0 [RX], .eh_frame
[d0598, d59fc] LOAD #0 [RX], .gcc_except_table
[d59fc, d5a94] LOAD #0 [RX], .note.android.ident
[d5a94, d6018] [Unmapped], [Unmapped]
[d6018, d6020] LOAD #1 [RW], .init_array
[d6020, d6030] LOAD #1 [RW], .fini_array
[d6030, dccf8] LOAD #1 [RW], .data.rel.ro
[dccf8, dcee8] LOAD #1 [RW], .dynamic
[dcee8, de000] LOAD #1 [RW], .got
[de000, de0f8] LOAD #1 [RW], .data
[de0f8, de1d4] [Unmapped], .comment
[de1d4, de2c4] [Unmapped], .debug_aranges
[de2c4, 270f19] [Unmapped], .debug_info
[270f19, 27f106] [Unmapped], .debug_abbrev
[27f106, 2efb5f] [Unmapped], .debug_line
[2efb5f, 3784c6] [Unmapped], .debug_str
[3784c6, 5396b0] [Unmapped], .debug_loc
[5396b0, 5396e4] [Unmapped], .debug_macinfo
[5396e4, 59e524] [Unmapped], .debug_ranges
[59e524, 59e528] [Unmapped], [Unmapped]
[59e528, 5c5090] [Unmapped], .symtab
[5c5090, 5f24c9] [Unmapped], .strtab
[5f24c9, 5f263c] [Unmapped], .shstrtab
[5f263c, 5f2640] [Unmapped], [Unmapped]
[5f2640, 5f2680] [ELF Headers], [ELF Headers]
[5f2680, 5f26c0] [ELF Headers], .note.gnu.build-id
[5f26c0, 5f2700] [ELF Headers], .hash
[5f2700, 5f2740] [ELF Headers], .gnu.hash
[5f2740, 5f2780] [ELF Headers], .dynsym
[5f2780, 5f27c0] [ELF Headers], .dynstr
[5f27c0, 5f2800] [ELF Headers], .gnu.version
[5f2800, 5f2840] [ELF Headers], .gnu.version_r
[5f2840, 5f2880] [ELF Headers], .rela.dyn
[5f2880, 5f28c0] [ELF Headers], .rela.plt
[5f28c0, 5f2900] [ELF Headers], .plt
[5f2900, 5f2940] [ELF Headers], .text
[5f2940, 5f2980] [ELF Headers], .rodata
[5f2980, 5f29c0] [ELF Headers], .eh_frame_hdr
[5f29c0, 5f2a00] [ELF Headers], .eh_frame
[5f2a00, 5f2a40] [ELF Headers], .gcc_except_table
[5f2a40, 5f2a80] [ELF Headers], .note.android.ident
[5f2a80, 5f2ac0] [ELF Headers], .init_array
[5f2ac0, 5f2b00] [ELF Headers], .fini_array
[5f2b00, 5f2b40] [ELF Headers], .data.rel.ro
[5f2b40, 5f2b80] [ELF Headers], .dynamic
[5f2b80, 5f2bc0] [ELF Headers], .got
[5f2bc0, 5f2c00] [ELF Headers], .data
[5f2c00, 5f2c40] [ELF Headers], [ELF Headers]
[5f2c40, 5f2c80] [ELF Headers], .comment
[5f2c80, 5f2cc0] [ELF Headers], .debug_aranges
[5f2cc0, 5f2d00] [ELF Headers], .debug_info
[5f2d00, 5f2d40] [ELF Headers], .debug_abbrev
[5f2d40, 5f2d80] [ELF Headers], .debug_line
[5f2d80, 5f2dc0] [ELF Headers], .debug_str
[5f2dc0, 5f2e00] [ELF Headers], .debug_loc
[5f2e00, 5f2e40] [ELF Headers], .debug_macinfo
[5f2e40, 5f2e80] [ELF Headers], .debug_ranges
[5f2e80, 5f2ec0] [ELF Headers], .shstrtab
[5f2ec0, 5f2f00] [ELF Headers], .symtab
[5f2f00, 5f2f40] [ELF Headers], .strtab
VM MAP:
[0, 200] LOAD #0 [RX], [LOAD #0 [RX]]
[200, 224] LOAD #0 [RX], .note.gnu.build-id
[224, 228] LOAD #0 [RX], [LOAD #0 [RX]]
[228, 46ac] LOAD #0 [RX], .hash
[46ac, 46b0] LOAD #0 [RX], [LOAD #0 [RX]]
[46b0, 9120] LOAD #0 [RX], .gnu.hash
[9120, 16b90] LOAD #0 [RX], .dynsym
[16b90, 314e8] LOAD #0 [RX], .dynstr
[314e8, 3271c] LOAD #0 [RX], .gnu.version
[3271c, 32720] LOAD #0 [RX], [LOAD #0 [RX]]
[32720, 32760] LOAD #0 [RX], .gnu.version_r
[32760, 44d48] LOAD #0 [RX], .rela.dyn
[44d48, 47040] LOAD #0 [RX], .rela.plt
[47040, 487b0] LOAD #0 [RX], .plt
[487b0, b62a0] LOAD #0 [RX], .text
[b62a0, bbffd] LOAD #0 [RX], .rodata
[bbffd, bc000] LOAD #0 [RX], [LOAD #0 [RX]]
[bc000, bfd14] LOAD #0 [RX], .eh_frame_hdr
[bfd14, bfd18] LOAD #0 [RX], [LOAD #0 [RX]]
[bfd18, d0598] LOAD #0 [RX], .eh_frame
[d0598, d59fc] LOAD #0 [RX], .gcc_except_table
[d59fc, d5a94] LOAD #0 [RX], .note.android.ident
[d5a94, d7018] NO ENTRY
[d7018, d7020] LOAD #1 [RW], .init_array
[d7020, d7030] LOAD #1 [RW], .fini_array
[d7030, ddcf8] LOAD #1 [RW], .data.rel.ro
[ddcf8, ddee8] LOAD #1 [RW], .dynamic
[ddee8, df000] LOAD #1 [RW], .got
[df000, df0f8] LOAD #1 [RW], .data
[df0f8, df100] LOAD #1 [RW], [LOAD #1 [RW]]
[df100, e2400] LOAD #1 [RW], .bss
    FILE SIZE        VM SIZE
 --------------  --------------
  29.5%  1.75Mi   0.0%       0    .debug_loc
  26.4%  1.57Mi   0.0%       0    .debug_info
   9.0%   546Ki   0.0%       0    .debug_str
   7.4%   450Ki   0.0%       0    .debug_line
   7.2%   438Ki  48.8%   438Ki    .text
   6.6%   403Ki   0.0%       0    .debug_ranges
   3.0%   181Ki   0.0%       0    .strtab
   2.5%   154Ki   0.0%       0    .symtab
   1.7%   106Ki  11.8%   106Ki    .dynstr
   1.2%  73.5Ki   8.2%  73.5Ki    .rela.dyn
   1.1%  66.2Ki   7.4%  66.1Ki    .eh_frame
   0.9%  56.5Ki   0.0%       0    .debug_abbrev
   0.9%  54.7Ki   6.1%  54.6Ki    .dynsym
   0.5%  28.3Ki   2.8%  24.9Ki    [19 Others]
   0.4%  27.3Ki   3.0%  27.2Ki    .data.rel.ro
   0.4%  23.4Ki   2.6%  23.3Ki    .rodata
   0.3%  21.2Ki   2.3%  21.1Ki    .gcc_except_table
   0.3%  18.7Ki   2.1%  18.6Ki    .gnu.hash
   0.3%  17.2Ki   1.9%  17.1Ki    .hash
   0.3%  15.3Ki   1.7%  15.3Ki    .eh_frame_hdr
   0.0%       0   1.4%  12.8Ki    .bss
 100.0%  5.95Mi 100.0%   899Ki    TOTAL
```
## VM空间和文件空间
可加载的二进制文件有两个基本的空间域需要映射：VM空间和文件空间。文件空间是输入文件的字节。
VM空间是在运行时加载可执行文件时所占用的内存字节。
二进制文件的某些区域仅存在于文件空间（如调试信息），而某些区域仅存在于VM空间（如.bss、零初始化数据）。甚至存在于两个空间中的实体在每个空间中的大小也可能不同。
## Hierarchical Profiles（分层概要）
Bloaty支持以许多不同的方式细分二进制文件。您可以将多个数据源合并为单个分层概要。
```Bash
❯ bloaty -d segments,sections libc++_shared.so
    FILE SIZE        VM SIZE
 --------------  --------------
  85.4%  5.08Mi   0.0%       0    [Unmapped]
    34.5%  1.75Mi   NAN%       0    .debug_loc
    31.0%  1.57Mi   NAN%       0    .debug_info
    10.5%   546Ki   NAN%       0    .debug_str
     8.7%   450Ki   NAN%       0    .debug_line
     7.8%   403Ki   NAN%       0    .debug_ranges
     3.5%   181Ki   NAN%       0    .strtab
     3.0%   154Ki   NAN%       0    .symtab
     1.1%  56.5Ki   NAN%       0    .debug_abbrev
     0.0%  1.39Ki   NAN%       0    [Unmapped]
     0.0%     371   NAN%       0    .shstrtab
     0.0%     240   NAN%       0    .debug_aranges
     0.0%     220   NAN%       0    .comment
     0.0%      52   NAN%       0    .debug_macinfo
  14.0%   854Ki  95.0%   854Ki    LOAD #0 [RX]
    51.3%   438Ki  51.3%   438Ki    .text
    12.4%   106Ki  12.4%   106Ki    .dynstr
     8.6%  73.5Ki   8.6%  73.5Ki    .rela.dyn
     7.7%  66.1Ki   7.7%  66.1Ki    .eh_frame
     6.4%  54.6Ki   6.4%  54.6Ki    .dynsym
     2.7%  23.3Ki   2.7%  23.3Ki    .rodata
     2.5%  21.1Ki   2.5%  21.1Ki    .gcc_except_table
     2.2%  18.6Ki   2.2%  18.6Ki    .gnu.hash
     2.0%  17.1Ki   2.0%  17.1Ki    .hash
     1.8%  15.3Ki   1.8%  15.3Ki    .eh_frame_hdr
     1.0%  8.74Ki   1.0%  8.74Ki    .rela.plt
     0.7%  5.86Ki   0.7%  5.86Ki    .plt
     0.5%  4.55Ki   0.5%  4.55Ki    .gnu.version
     0.1%     531   0.1%     531    [LOAD #0 [RX]]
     0.0%     152   0.0%     152    .note.android.ident
     0.0%      64   0.0%      64    .gnu.version_r
     0.0%      36   0.0%      36    .note.gnu.build-id
   0.5%  32.2Ki   5.0%  45.0Ki    LOAD #1 [RW]
    84.4%  27.2Ki  60.5%  27.2Ki    .data.rel.ro
     0.0%       0  28.3%  12.8Ki    .bss
    13.3%  4.27Ki   9.5%  4.27Ki    .got
     1.5%     496   1.1%     496    .dynamic
     0.8%     248   0.5%     248    .data
     0.0%      16   0.0%      16    .fini_array
     0.0%       8   0.0%       8    .init_array
     0.0%       0   0.0%       8    [LOAD #1 [RW]]
   0.0%  2.25Ki   0.0%       0    [ELF Headers]
    41.7%     960   NAN%       0    [15 Others]
     5.6%     128   NAN%       0    [ELF Headers]
     2.8%      64   NAN%       0    .comment
     2.8%      64   NAN%       0    .data
     2.8%      64   NAN%       0    .data.rel.ro
     2.8%      64   NAN%       0    .debug_abbrev
     2.8%      64   NAN%       0    .debug_aranges
     2.8%      64   NAN%       0    .debug_info
     2.8%      64   NAN%       0    .debug_line
     2.8%      64   NAN%       0    .debug_loc
     2.8%      64   NAN%       0    .debug_macinfo
     2.8%      64   NAN%       0    .debug_ranges
     2.8%      64   NAN%       0    .debug_str
     2.8%      64   NAN%       0    .dynamic
     2.8%      64   NAN%       0    .dynstr
     2.8%      64   NAN%       0    .dynsym
     2.8%      64   NAN%       0    .eh_frame
     2.8%      64   NAN%       0    .eh_frame_hdr
     2.8%      64   NAN%       0    .fini_array
     2.8%      64   NAN%       0    .gcc_except_table
     2.8%      64   NAN%       0    .gnu.hash
 100.0%  5.95Mi 100.0%   899Ki    TOTAL
❯ bloaty -d segments,sections libc++_static.a
    FILE SIZE        VM SIZE
 --------------  --------------
  91.7%  10.2Mi   0.0%       0    Section []
    23.1%  2.36Mi   NAN%       0    .rela.debug_loc
    21.3%  2.18Mi   NAN%       0    .rela.debug_info
    14.1%  1.44Mi   NAN%       0    .debug_loc
    12.5%  1.28Mi   NAN%       0    .debug_info
     7.8%   816Ki   NAN%       0    .debug_str
     6.5%   680Ki   NAN%       0    .rela.debug_ranges
     3.4%   353Ki   NAN%       0    .debug_line
     2.9%   304Ki   NAN%       0    .debug_ranges
     2.8%   294Ki   NAN%       0    [1385 Others]
     2.0%   208Ki   NAN%       0    .strtab
     1.9%   194Ki   NAN%       0    .symtab
     0.5%  49.9Ki   NAN%       0    .rela.eh_frame
     0.4%  39.1Ki   NAN%       0    .debug_abbrev
     0.4%  37.5Ki   NAN%       0    .rela.debug_line
     0.1%  14.3Ki   NAN%       0    .rela.text._ZNSt6__ndk16locale5__impC2Em
     0.1%  13.6Ki   NAN%       0    .group
     0.1%  7.71Ki   NAN%       0    .rela.text._ZNSt6__ndk16locale5__impC2ERKS1_S3_i
     0.1%  5.87Ki   NAN%       0    .comment
     0.0%  4.08Ki   NAN%       0    .rela.text.startup
     0.0%  3.56Ki   NAN%       0    .rela.text._ZNKSt6__ndk120__time_get_c_storageIcE8__monthsEv
     0.0%  3.56Ki   NAN%       0    .rela.text._ZNKSt6__ndk120__time_get_c_storageIwE8__monthsEv
   3.2%   362Ki   0.0%       0    [ELF Headers]
    64.7%   234Ki   NAN%       0    [3393 Others]
    21.6%  78.5Ki   NAN%       0    .group
     4.2%  15.3Ki   NAN%       0    [ELF Headers]
     0.6%  2.31Ki   NAN%       0    .debug_line
     0.6%  2.19Ki   NAN%       0    .debug_str
     0.6%  2.06Ki   NAN%       0    .comment
     0.6%  2.06Ki   NAN%       0    .debug_abbrev
     0.6%  2.06Ki   NAN%       0    .debug_info
     0.6%  2.06Ki   NAN%       0    .debug_macinfo
     0.6%  2.06Ki   NAN%       0    .rela.debug_info
     0.6%  2.06Ki   NAN%       0    .strtab
     0.6%  2.06Ki   NAN%       0    .symtab
     0.5%  1.88Ki   NAN%       0    .eh_frame
     0.5%  1.81Ki   NAN%       0    .debug_loc
     0.5%  1.81Ki   NAN%       0    .rela.debug_line
     0.5%  1.81Ki   NAN%       0    .rela.eh_frame
     0.5%  1.69Ki   NAN%       0    .debug_ranges
     0.5%  1.69Ki   NAN%       0    .rela.debug_loc
     0.5%  1.69Ki   NAN%       0    .rela.debug_ranges
     0.4%  1.44Ki   NAN%       0    .data.DW.ref.__gxx_personality_v0
     0.4%  1.44Ki   NAN%       0    .gcc_except_table
   3.0%   344Ki  75.1%   344Ki    Section [AX]
    85.4%   294Ki  85.4%   294Ki    [1466 Others]
     2.1%  7.08Ki   2.1%  7.08Ki    .text._ZNSt6__ndk16locale5__impC2Em
     1.8%  6.36Ki   1.8%  6.36Ki    .text._ZNSt6__ndk16locale5__impC2ERKS1_S3_i
     1.4%  4.75Ki   1.4%  4.75Ki    .text._ZNSt6__ndk19money_getIwNS_19istreambuf_iteratorIwNS_11char_traitsIwEEEEE8__do_getERS4_S4_bRKNS_6localeEjRjRbRKNS_5ctypeIwEERNS_10unique_ptrIwPFvPvEEERPwSM_
     1.3%  4.50Ki   1.3%  4.50Ki    .text._ZNSt6__ndk19money_getIcNS_19istreambuf_iteratorIcNS_11char_traitsIcEEEEE8__do_getERS4_S4_bRKNS_6localeEjRjRbRKNS_5ctypeIcEERNS_10unique_ptrIcPFvPvEEERPcSM_
     0.9%  3.12Ki   0.9%  3.12Ki    .text._ZNSt6__ndk118__time_get_storageIwE4initERKNS_5ctypeIwEE
     0.6%  1.99Ki   0.6%  1.99Ki    .text._ZNSt6__ndk117moneypunct_bynameIwLb0EE4initEPKc
     0.6%  1.99Ki   0.6%  1.99Ki    .text._ZNSt6__ndk117moneypunct_bynameIwLb1EE4initEPKc
     0.5%  1.86Ki   0.5%  1.86Ki    .text._ZNSt6__ndk16__sortIRNS_6__lessIeeEEPeEEvT0_S5_T_
     0.5%  1.83Ki   0.5%  1.83Ki    .text._ZNSt6__ndk16locale5__impC2ERKNS_12basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEEEm
     0.5%  1.77Ki   0.5%  1.77Ki    .text._ZNSt6__ndk112__next_primeEm
     0.5%  1.77Ki   0.5%  1.77Ki    .text._ZNSt6__ndk16locale5__impC2ERKS1_RKNS_12basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEEEi
     0.5%  1.74Ki   0.5%  1.74Ki    .text._ZNSt6__ndk118__time_get_storageIwE9__analyzeEcRKNS_5ctypeIwEE
     0.5%  1.58Ki   0.5%  1.58Ki    .text._ZNKSt6__ndk18time_getIcNS_19istreambuf_iteratorIcNS_11char_traitsIcEEEEE6do_getES4_S4_RNS_8ios_baseERjP2tmcc
     0.5%  1.57Ki   0.5%  1.57Ki    .text._ZNKSt6__ndk18time_getIwNS_19istreambuf_iteratorIwNS_11char_traitsIwEEEEE6do_getES4_S4_RNS_8ios_baseERjP2tmcc
     0.4%  1.49Ki   0.4%  1.49Ki    .text._ZNSt6__ndk118__time_get_storageIcE9__analyzeEcRKNS_5ctypeIcEE
     0.4%  1.47Ki   0.4%  1.47Ki    .text._ZNSt6__ndk19__num_putIwE23__widen_and_group_floatEPcS2_S2_PwRS3_S4_RKNS_6localeE
     0.4%  1.46Ki   0.4%  1.46Ki    .text._ZNSt6__ndk19__num_putIcE23__widen_and_group_floatEPcS2_S2_S2_RS2_S3_RKNS_6localeE
     0.4%  1.32Ki   0.4%  1.32Ki    .text._ZNSt6__ndk16__sortIRNS_6__lessIssEEPsEEvT0_S5_T_
     0.4%  1.32Ki   0.4%  1.32Ki    .text._ZNSt6__ndk16__sortIRNS_6__lessIttEEPtEEvT0_S5_T_
     0.4%  1.29Ki   0.4%  1.29Ki    .text._ZNSt6__ndk16__sortIRNS_6__lessIaaEEPaEEvT0_S5_T_
   1.2%   134Ki   0.0%       0    [AR Symbol Table]
   0.7%  85.4Ki  18.6%  85.4Ki    Section [A]
    59.5%  50.9Ki  59.5%  50.9Ki    .eh_frame
    23.0%  19.6Ki  23.0%  19.6Ki    .gcc_except_table
     6.2%  5.27Ki   6.2%  5.27Ki    [242 Others]
     4.9%  4.21Ki   4.9%  4.21Ki    .rodata.str1.1
     2.3%  2.00Ki   2.3%  2.00Ki    .rodata._ZZNSt6__ndk15ctypeIcE13classic_tableEvE13builtin_table
     1.3%  1.14Ki   1.3%  1.14Ki    .rodata.str4.4
     0.3%     304   0.3%     304    .rodata.cst16
     0.2%     200   0.2%     200    .rodata._ZNSt6__ndk16__itoaL10cDigitsLutE
     0.2%     192   0.2%     192    .rodata._ZNSt6__ndk112_GLOBAL__N_112small_primesE
     0.2%     192   0.2%     192    .rodata._ZNSt6__ndk112_GLOBAL__N_17indicesE
     0.2%     170   0.2%     170    .rodata._ZNKSt6__ndk18time_getIcNS_19istreambuf_iteratorIcNS_11char_traitsIcEEEEE6do_getES4_S4_RNS_8ios_baseERjP2tmcc
     0.2%     170   0.2%     170    .rodata._ZNKSt6__ndk18time_getIwNS_19istreambuf_iteratorIwNS_11char_traitsIwEEEEE6do_getES4_S4_RNS_8ios_baseERjP2tmcc
     0.2%     160   0.2%     160    .rodata._ZNSt6__ndk16__itoaL10__pow10_64E
     0.2%     156   0.2%     156    .rodata._ZTSNSt6__ndk115basic_streambufIcNS_11char_traitsIcEEEE
     0.2%     150   0.2%     150    .rodata._ZTSNSt6__ndk113basic_istreamIcNS_11char_traitsIcEEEE
     0.2%     150   0.2%     150    .rodata._ZTSNSt6__ndk113basic_ostreamIcNS_11char_traitsIcEEEE
     0.2%     135   0.2%     135    .rodata._ZTSNSt6__ndk19basic_iosIcNS_11char_traitsIcEEEE
     0.1%     104   0.1%     104    .rodata._ZTSNSt6__ndk115basic_streambufIwNS_11char_traitsIwEEEE
     0.1%     102   0.1%     102    .rodata._ZTSNSt6__ndk114basic_iostreamIcNS_11char_traitsIcEEEE
     0.1%     100   0.1%     100    .rodata._ZTSNSt6__ndk113basic_istreamIwNS_11char_traitsIwEEEE
     0.1%     100   0.1%     100    .rodata._ZTSNSt6__ndk113basic_ostreamIwNS_11char_traitsIwEEEE
   0.2%  17.3Ki   6.3%  28.7Ki    Section [AW]
    79.5%  13.8Ki  58.9%  16.9Ki    [390 Others]
     0.0%       0  17.0%  4.88Ki    .bss._ZZNSt6__ndk112__rs_defaultclEvE6__rs_g
    10.0%  1.73Ki   6.0%  1.73Ki    .data.rel.ro._ZNSt6__ndk112_GLOBAL__N_112collatenamesE
     0.0%       0   2.2%     640    .bss._ZNSt6__ndk1L8mut_backE
     0.0%       0   2.0%     576    .bss._ZZNSt6__ndk1L11init_monthsEvE6months
     0.0%       0   2.0%     576    .bss._ZZNSt6__ndk1L12init_wmonthsEvE6months
     2.2%     384   1.3%     384    .data.rel.ro._ZTVNSt6__ndk115basic_streambufIcNS_11char_traitsIcEEEE
     0.0%       0   1.1%     336    .bss._ZZNSt6__ndk1L10init_weeksEvE5weeks
     0.0%       0   1.1%     336    .bss._ZZNSt6__ndk1L11init_wweeksEvE5weeks
     0.0%       0   1.1%     320    .bss._ZZNSt6__ndk112_GLOBAL__N_14makeINS_6locale5__impEjEERT_T0_E3buf
     1.4%     256   0.9%     256    .data.rel.ro._ZTVNSt6__ndk115basic_streambufIwNS_11char_traitsIwEEEE
     1.4%     240   0.8%     240    .data.rel.ro._ZNSt6__ndk112_GLOBAL__N_110ClassNamesE
     1.3%     224   0.8%     224    .data.rel.ro._ZTVNSt6__ndk115time_get_bynameIcNS_19istreambuf_iteratorIcNS_11char_traitsIcEEEEEE
     1.3%     224   0.8%     224    .data.rel.ro._ZTVNSt6__ndk115time_get_bynameIwNS_19istreambuf_iteratorIwNS_11char_traitsIwEEEEEE
     1.0%     184   0.6%     184    .data.DW.ref.__gxx_personality_v0
     0.0%       0   0.6%     168    .bss._ZNSt6__ndk13cinE
     0.0%       0   0.6%     168    .bss._ZNSt6__ndk14wcinE
     0.9%     168   0.6%     168    .data.rel.ro._ZTVNSt6__ndk18time_getIcNS_19istreambuf_iteratorIcNS_11char_traitsIcEEEEEE
     0.9%     168   0.6%     168    .data.rel.ro._ZTVNSt6__ndk18time_getIwNS_19istreambuf_iteratorIwNS_11char_traitsIwEEEEEE
     0.0%       0   0.5%     160    .bss._ZNSt6__ndk14cerrE
     0.0%       0   0.5%     160    .bss._ZNSt6__ndk14clogE
   0.0%  2.13Ki   0.0%       0    [AR Headers]
   0.0%     858   0.0%       0    [Unmapped]
 100.0%  11.1Mi 100.0%   458Ki    TOTAL
```
Bloaty在每个层级显示最多20行；
其他值会被分组到一个[Other] bin中。使用-n <num>来覆盖此设置。如果您传递-n 0，所有数据将被输出，不会将任何内容折叠到[Other]中。
```Bash
bloaty -d compileunits -n 0 libc++_shared.so > compileunits.txt
bloaty -d symbols -n 0 libc++_shared.so > symbols.txt
```
## Segments
段是运行时加载器用于确定二进制文件的哪些部分需要被加载/映射到内存中的。通常只有几个段：每个mmap()所需权限的一个段：
```Bash
❯ bloaty -d segments libc++_shared.so
    FILE SIZE        VM SIZE
 --------------  --------------
  85.4%  5.08Mi   0.0%       0    [Unmapped]
  14.0%   854Ki  95.0%   854Ki    LOAD #0 [RX]
   0.5%  32.2Ki   5.0%  45.0Ki    LOAD #1 [RW]
   0.0%  2.25Ki   0.0%       0    [ELF Headers]
 100.0%  5.95Mi 100.0%   899Ki    TOTAL
```
在这里，我们看到一个被映射为[RX]（可读/可执行）的段和一个被映射为[RW]（可读/可写）的段。大部分二进制文件没有被加载到内存中，我们可以看到它们显示为[未映射]。

目标文件和静态库没有段。但是，我们通过根据它们的标志将节进行分组来模拟。这给我们提供了一种类似于真实段的分解。
```Bash
❯ bloaty -d segments libc++_static.a
    FILE SIZE        VM SIZE
 --------------  --------------
  91.7%  10.2Mi   0.0%       0    Section []
   3.2%   362Ki   0.0%       0    [ELF Headers]
   3.0%   344Ki  75.1%   344Ki    Section [AX]
   1.2%   134Ki   0.0%       0    [AR Symbol Table]
   0.7%  85.4Ki  18.6%  85.4Ki    Section [A]
   0.2%  17.3Ki   6.3%  28.7Ki    Section [AW]
   0.0%  2.13Ki   0.0%       0    [AR Headers]
   0.0%     858   0.0%       0    [Unmapped]
 100.0%  11.1Mi 100.0%   458Ki    TOTAL
```
## Sections
节提供了对二进制文件更细粒度的查看。如果我们想要找到符号表、展开信息或调试信息，每种信息都存在于自己的节中。Bloaty的默认输出是节信息。
```Bash
❯ bloaty -d sections libc++_shared.so
    FILE SIZE        VM SIZE
 --------------  --------------
  29.5%  1.75Mi   0.0%       0    .debug_loc
  26.4%  1.57Mi   0.0%       0    .debug_info
   9.0%   546Ki   0.0%       0    .debug_str
   7.4%   450Ki   0.0%       0    .debug_line
   7.2%   438Ki  48.8%   438Ki    .text
   6.6%   403Ki   0.0%       0    .debug_ranges
   3.0%   181Ki   0.0%       0    .strtab
   2.5%   154Ki   0.0%       0    .symtab
   1.7%   106Ki  11.8%   106Ki    .dynstr
   1.2%  73.5Ki   8.2%  73.5Ki    .rela.dyn
   1.1%  66.2Ki   7.4%  66.1Ki    .eh_frame
   0.9%  56.5Ki   0.0%       0    .debug_abbrev
   0.9%  54.7Ki   6.1%  54.6Ki    .dynsym
   0.5%  28.3Ki   2.8%  24.9Ki    [19 Others]
   0.4%  27.3Ki   3.0%  27.2Ki    .data.rel.ro
   0.4%  23.4Ki   2.6%  23.3Ki    .rodata
   0.3%  21.2Ki   2.3%  21.1Ki    .gcc_except_table
   0.3%  18.7Ki   2.1%  18.6Ki    .gnu.hash
   0.3%  17.2Ki   1.9%  17.1Ki    .hash
   0.3%  15.3Ki   1.7%  15.3Ki    .eh_frame_hdr
   0.0%       0   1.4%  12.8Ki    .bss
 100.0%  5.95Mi 100.0%   899Ki    TOTAL
❯ bloaty -d sections libc++_static.a
    FILE SIZE        VM SIZE
 --------------  --------------
  21.2%  2.36Mi   0.0%       0    .rela.debug_loc
  19.6%  2.18Mi   0.0%       0    .rela.debug_info
  13.0%  1.44Mi   0.0%       0    .debug_loc
  11.5%  1.28Mi   0.0%       0    .debug_info
   8.2%   931Ki  84.6%   388Ki    [3547 Others]
   7.2%   818Ki   0.0%       0    .debug_str
   6.0%   681Ki   0.0%       0    .rela.debug_ranges
   3.1%   355Ki   0.0%       0    .debug_line
   2.7%   306Ki   0.0%       0    .debug_ranges
   1.8%   210Ki   0.0%       0    .strtab
   1.7%   196Ki   0.0%       0    .symtab
   1.2%   134Ki   0.0%       0    [AR Symbol Table]
   0.8%  92.1Ki   0.0%       0    .group
   0.5%  52.7Ki  11.1%  50.9Ki    .eh_frame
   0.5%  51.7Ki   0.0%       0    .rela.eh_frame
   0.4%  41.1Ki   0.0%       0    .debug_abbrev
   0.3%  39.4Ki   0.0%       0    .rela.debug_line
   0.2%  21.1Ki   4.3%  19.6Ki    .gcc_except_table
   0.1%  15.3Ki   0.0%       0    [ELF Headers]
   0.1%  14.4Ki   0.0%       0    .rela.text._ZNSt6__ndk16locale5__impC2Em
   0.1%  7.93Ki   0.0%       0    .comment
 100.0%  11.1Mi 100.0%   458Ki    TOTAL
```
节是在链接过程中被链接器视为原子的二进制文件区域。链接器永远不会分割或重新排列节内的数据。
这就是为什么如果您希望链接器删除没有引用的单个函数或变量，
需要使用-ffunction-sections和-fdata-sections进行编译的原因。
然而，链接器通常会将许多输入节合并成一个输出节。
## Symbols
Symbols数据源是Bloaty对二进制文件进行深度解析并提供最大益处的地方，因为它提供了链接器映射或符号表无法获取的详细信息。
```Bash
❯ bloaty libc++_shared.so -d symbols,sections
    FILE SIZE        VM SIZE
 --------------  --------------
  29.5%  1.75Mi   0.0%       0    [section .debug_loc]
  26.4%  1.57Mi   0.0%       0    [section .debug_info]
  16.3%   991Ki  79.1%   711Ki    [1610 Others]
   9.0%   546Ki   0.0%       0    [section .debug_str]
   7.4%   450Ki   0.0%       0    [section .debug_line]
   6.6%   403Ki   0.0%       0    [section .debug_ranges]
   0.9%  56.5Ki   0.0%       0    [section .debug_abbrev]
   0.5%  28.5Ki   0.0%       0    [section .symtab]
   0.4%  23.3Ki   2.4%  21.7Ki    std::__ndk1::__sort<>()
    85.0%  19.8Ki  91.2%  19.8Ki    .text
     3.6%     864   0.0%       0    .symtab
     3.2%     762   0.0%       0    .strtab
     3.1%     750   3.4%     750    .dynstr
     3.0%     720   3.2%     720    .eh_frame
     1.5%     360   1.6%     360    .dynsym
     0.5%     120   0.5%     120    .eh_frame_hdr
   0.4%  22.4Ki   2.1%  18.7Ki    std::__ndk1::basic_ostream<>::operator<<()
    63.0%  14.1Ki  75.6%  14.1Ki    .text
     9.0%  2.02Ki   0.0%       0    .strtab
     8.9%  1.99Ki  10.6%  1.99Ki    .dynstr
     7.6%  1.71Ki   0.0%       0    .symtab
     6.8%  1.52Ki   8.1%  1.52Ki    .eh_frame
     3.6%     816   4.3%     816    .dynsym
     1.2%     272   1.4%     272    .eh_frame_hdr
   0.3%  21.1Ki   2.3%  21.1Ki    [section .gcc_except_table]
   0.3%  19.5Ki   2.0%  18.4Ki    std::__ndk1::locale::__imp::__imp()
    92.6%  18.0Ki  98.0%  18.0Ki    .text
     3.4%     681   0.0%       0    .strtab
     2.2%     432   0.0%       0    .symtab
     1.6%     320   1.7%     320    .eh_frame
     0.2%      48   0.3%      48    .eh_frame_hdr
   0.3%  18.6Ki   2.1%  18.6Ki    [section .gnu.hash]
   0.3%  17.1Ki   1.9%  17.1Ki    [section .hash]
   0.3%  16.7Ki   1.6%  14.3Ki    std::__ndk1::num_put<>::do_put()
    68.2%  11.4Ki  79.6%  11.4Ki    .text
     9.8%  1.64Ki   0.0%       0    .strtab
     9.4%  1.57Ki  10.9%  1.57Ki    .dynstr
     5.1%     880   6.0%     880    .eh_frame
     4.5%     768   0.0%       0    .symtab
     2.2%     384   2.6%     384    .dynsym
     0.7%     128   0.9%     128    .eh_frame_hdr
   0.2%  13.4Ki   1.3%  11.5Ki    std::__ndk1::__insertion_sort_incomplete<>()
    70.7%  9.46Ki  82.5%  9.46Ki    .text
     7.9%  1.06Ki   0.0%       0    .strtab
     7.9%  1.05Ki   9.2%  1.05Ki    .dynstr
     6.5%     888   0.0%       0    .symtab
     3.6%     488   4.2%     488    .eh_frame
     2.6%     360   3.1%     360    .dynsym
     0.9%     120   1.0%     120    .eh_frame_hdr
   0.2%  11.9Ki   1.0%  8.94Ki    std::__ndk1::__input_arithmetic<>()
    66.2%  7.91Ki  88.5%  7.91Ki    .text
    16.6%  1.98Ki   0.0%       0    .strtab
     8.6%  1.03Ki   0.0%       0    .symtab
     7.2%     880   9.6%     880    .eh_frame
     1.4%     176   1.9%     176    .eh_frame_hdr
   0.2%  11.3Ki   1.3%  11.3Ki    [section .rodata]
   0.2%  10.7Ki   0.8%  7.35Ki    std::__ndk1::num_get<>::do_get()
    35.0%  3.76Ki  51.2%  3.76Ki    .text
    21.9%  2.35Ki   0.0%       0    .strtab
    21.1%  2.26Ki  30.8%  2.26Ki    .dynstr
     9.6%  1.03Ki   0.0%       0    .symtab
     6.0%     656   8.7%     656    .eh_frame
     4.8%     528   7.0%     528    .dynsym
     1.6%     176   2.3%     176    .eh_frame_hdr
   0.2%  10.6Ki   1.0%  9.19Ki    std::__ndk1::num_get<>::__do_get_unsigned<>()
    71.2%  7.53Ki  82.0%  7.53Ki    .text
     9.6%  1.02Ki   0.0%       0    .strtab
     9.2%     992  10.5%     992    .dynstr
     4.1%     448   4.8%     448    .eh_frame
     3.5%     384   0.0%       0    .symtab
     1.8%     192   2.0%     192    .dynsym
     0.6%      64   0.7%      64    .eh_frame_hdr
   0.2%  10.1Ki   1.1%  9.73Ki    std::__ndk1::money_get<>::__do_get()
    91.2%  9.25Ki  95.1%  9.25Ki    .text
     3.2%     328   0.0%       0    .strtab
     3.0%     314   3.2%     314    .dynstr
     1.1%     112   1.1%     112    .eh_frame
     0.9%      96   0.0%       0    .symtab
     0.5%      48   0.5%      48    .dynsym
     0.2%      16   0.2%      16    .eh_frame_hdr
 100.0%  5.95Mi 100.0%   899Ki    TOTAL
```
符号确实来自符号表，并表示二进制文件中的单个函数或变量。符号表是一种存储有关代码中定义的符号信息的数据结构，例如它们的名称、地址、大小和其他属性。

符号在程序执行和调试中起着至关重要的作用。它们作为对内存中特定位置的引用，该位置存放着函数或变量。符号表允许链接器和调试器将符号名称与其相应的内存地址关联起来，在程序执行期间调用函数和访问变量。

符号提供了组织和浏览代码库的方式，使得更容易理解程序的结构和不同组件之间的关系。它们通过为各种代码元素提供有意义的标识符，促进了程序分析、优化和调试。
```Bash
❯ bloaty -d symbols libc++_shared.so
    FILE SIZE        VM SIZE
 --------------  --------------
  29.5%  1.75Mi   0.0%       0    [section .debug_loc]
  26.4%  1.57Mi   0.0%       0    [section .debug_info]
  16.3%   991Ki  79.1%   711Ki    [1610 Others]
   9.0%   546Ki   0.0%       0    [section .debug_str]
   7.4%   450Ki   0.0%       0    [section .debug_line]
   6.6%   403Ki   0.0%       0    [section .debug_ranges]
   0.9%  56.5Ki   0.0%       0    [section .debug_abbrev]
   0.5%  28.5Ki   0.0%       0    [section .symtab]
   0.4%  23.3Ki   2.4%  21.7Ki    std::__ndk1::__sort<>()
   0.4%  22.4Ki   2.1%  18.7Ki    std::__ndk1::basic_ostream<>::operator<<()
   0.3%  21.1Ki   2.3%  21.1Ki    [section .gcc_except_table]
   0.3%  19.5Ki   2.0%  18.4Ki    std::__ndk1::locale::__imp::__imp()
   0.3%  18.6Ki   2.1%  18.6Ki    [section .gnu.hash]
   0.3%  17.1Ki   1.9%  17.1Ki    [section .hash]
   0.3%  16.7Ki   1.6%  14.3Ki    std::__ndk1::num_put<>::do_put()
   0.2%  13.4Ki   1.3%  11.5Ki    std::__ndk1::__insertion_sort_incomplete<>()
   0.2%  11.9Ki   1.0%  8.94Ki    std::__ndk1::__input_arithmetic<>()
   0.2%  11.3Ki   1.3%  11.3Ki    [section .rodata]
   0.2%  10.7Ki   0.8%  7.35Ki    std::__ndk1::num_get<>::do_get()
   0.2%  10.6Ki   1.0%  9.19Ki    std::__ndk1::num_get<>::__do_get_unsigned<>()
   0.2%  10.1Ki   1.1%  9.73Ki    std::__ndk1::money_get<>::__do_get()
 100.0%  5.95Mi 100.0%   899Ki    TOTAL
```
您可以使用-C MODE或--demangle=MODE标志来控制符号的解构方式。您还可以在-d开关中明确指定解构模式。我们有三种不同的解构模式：

+ -C none或-d rawsymbols：不进行解构。
+ -C short或-d shortsymbols：简短解构：省略返回类型、模板参数和函数参数类型。
-C full或-d fullsymbols：完全解构。

+ -C short（默认设置）非常方便的一点是，它将所有模板实例化都分组在一起，而不考虑其参数。您可以使用此功能来确定通过多次实例化模板所支付的代码大小。
```Bash
❯ bloaty -d rawsymbols libc++_shared.so
    FILE SIZE        VM SIZE
 --------------  --------------
  29.5%  1.75Mi   0.0%       0    [section .debug_loc]
  26.4%  1.57Mi   0.0%       0    [section .debug_info]
  17.6%  1.04Mi  86.8%   780Ki    [3031 Others]
   9.0%   546Ki   0.0%       0    [section .debug_str]
   7.4%   450Ki   0.0%       0    [section .debug_line]
   6.6%   403Ki   0.0%       0    [section .debug_ranges]
   0.9%  56.5Ki   0.0%       0    [section .debug_abbrev]
   0.5%  28.5Ki   0.0%       0    [section .symtab]
   0.3%  21.1Ki   2.3%  21.1Ki    [section .gcc_except_table]
   0.3%  18.6Ki   2.1%  18.6Ki    [section .gnu.hash]
   0.3%  17.1Ki   1.9%  17.1Ki    [section .hash]
   0.2%  11.3Ki   1.3%  11.3Ki    [section .rodata]
   0.2%  9.45Ki   0.0%       0    [section .strtab]
   0.1%  8.74Ki   1.0%  8.74Ki    [section .rela.plt]
   0.1%  7.25Ki   0.8%  7.14Ki    _ZNSt6__ndk16locale5__impC1Em
   0.1%  7.25Ki   0.8%  7.08Ki    _ZN12_GLOBAL__N_116itanium_demangle22AbstractManglingParserINS0_14ManglingParserINS_16DefaultAllocatorEEES3_E9parseExprEv
   0.1%  6.62Ki   0.7%  6.42Ki    _ZNSt6__ndk16locale5__impC2ERKS1_S3_i
   0.1%  5.86Ki   0.7%  5.86Ki    [section .plt]
   0.1%  5.84Ki   0.6%  5.67Ki    _ZN12_GLOBAL__N_116itanium_demangle22AbstractManglingParserINS0_14ManglingParserINS_16DefaultAllocatorEEES3_E9parseTypeEv
   0.1%  5.20Ki   0.6%  4.99Ki    _ZNSt6__ndk19money_getIwNS_19istreambuf_iteratorIwNS_11char_traitsIwEEEEE8__do_getERS4_S4_bRKNS_6localeEjRjRbRKNS_5ctypeIwEERNS_10unique_ptrIwPFvPvEEERPwSM_
   0.1%  4.95Ki   0.5%  4.74Ki    _ZNSt6__ndk19money_getIcNS_19istreambuf_iteratorIcNS_11char_traitsIcEEEEE8__do_getERS4_S4_bRKNS_6localeEjRjRbRKNS_5ctypeIcEERNS_10unique_ptrIcPFvPvEEERPcSM_
 100.0%  5.95Mi 100.0%   899Ki    TOTAL
 
 ❯ bloaty -d shortsymbols libc++_shared.so
    FILE SIZE        VM SIZE
 --------------  --------------
  29.5%  1.75Mi   0.0%       0    [section .debug_loc]
  26.4%  1.57Mi   0.0%       0    [section .debug_info]
  16.3%   991Ki  79.1%   711Ki    [1610 Others]
   9.0%   546Ki   0.0%       0    [section .debug_str]
   7.4%   450Ki   0.0%       0    [section .debug_line]
   6.6%   403Ki   0.0%       0    [section .debug_ranges]
   0.9%  56.5Ki   0.0%       0    [section .debug_abbrev]
   0.5%  28.5Ki   0.0%       0    [section .symtab]
   0.4%  23.3Ki   2.4%  21.7Ki    std::__ndk1::__sort<>()
   0.4%  22.4Ki   2.1%  18.7Ki    std::__ndk1::basic_ostream<>::operator<<()
   0.3%  21.1Ki   2.3%  21.1Ki    [section .gcc_except_table]
   0.3%  19.5Ki   2.0%  18.4Ki    std::__ndk1::locale::__imp::__imp()
   0.3%  18.6Ki   2.1%  18.6Ki    [section .gnu.hash]
   0.3%  17.1Ki   1.9%  17.1Ki    [section .hash]
   0.3%  16.7Ki   1.6%  14.3Ki    std::__ndk1::num_put<>::do_put()
   0.2%  13.4Ki   1.3%  11.5Ki    std::__ndk1::__insertion_sort_incomplete<>()
   0.2%  11.9Ki   1.0%  8.94Ki    std::__ndk1::__input_arithmetic<>()
   0.2%  11.3Ki   1.3%  11.3Ki    [section .rodata]
   0.2%  10.7Ki   0.8%  7.35Ki    std::__ndk1::num_get<>::do_get()
   0.2%  10.6Ki   1.0%  9.19Ki    std::__ndk1::num_get<>::__do_get_unsigned<>()
   0.2%  10.1Ki   1.1%  9.73Ki    std::__ndk1::money_get<>::__do_get()
 100.0%  5.95Mi 100.0%   899Ki    TOTAL
 
 ❯ bloaty -d fullsymbols libc++_shared.so
    FILE SIZE        VM SIZE
 --------------  --------------
  29.5%  1.75Mi   0.0%       0    [section .debug_loc]
  26.4%  1.57Mi   0.0%       0    [section .debug_info]
  17.6%  1.04Mi  86.8%   780Ki    [2947 Others]
   9.0%   546Ki   0.0%       0    [section .debug_str]
   7.4%   450Ki   0.0%       0    [section .debug_line]
   6.6%   403Ki   0.0%       0    [section .debug_ranges]
   0.9%  56.5Ki   0.0%       0    [section .debug_abbrev]
   0.5%  28.5Ki   0.0%       0    [section .symtab]
   0.3%  21.1Ki   2.3%  21.1Ki    [section .gcc_except_table]
   0.3%  18.6Ki   2.1%  18.6Ki    [section .gnu.hash]
   0.3%  17.1Ki   1.9%  17.1Ki    [section .hash]
   0.2%  11.3Ki   1.3%  11.3Ki    [section .rodata]
   0.2%  9.45Ki   0.0%       0    [section .strtab]
   0.1%  8.74Ki   1.0%  8.74Ki    [section .rela.plt]
   0.1%  7.25Ki   0.8%  7.14Ki    std::__ndk1::locale::__imp::__imp(unsigned long)
   0.1%  7.25Ki   0.8%  7.08Ki    (anonymous namespace)::itanium_demangle::AbstractManglingParser<(anonymous namespace)::itanium_demangle::ManglingParser<(anonymous namespace)::DefaultAllocator>, (anonymous namespace)::DefaultAllocator>::parseExpr()
   0.1%  6.62Ki   0.7%  6.42Ki    std::__ndk1::locale::__imp::__imp(std::__ndk1::locale::__imp const&, std::__ndk1::locale::__imp const&, int)
   0.1%  5.86Ki   0.7%  5.86Ki    [section .plt]
   0.1%  5.84Ki   0.6%  5.67Ki    (anonymous namespace)::itanium_demangle::AbstractManglingParser<(anonymous namespace)::itanium_demangle::ManglingParser<(anonymous namespace)::DefaultAllocator>, (anonymous namespace)::DefaultAllocator>::parseType()
   0.1%  5.20Ki   0.6%  4.99Ki    std::__ndk1::money_get<wchar_t, std::__ndk1::istreambuf_iterator<wchar_t, std::__ndk1::char_traits<wchar_t> > >::__do_get(std::__ndk1::istreambuf_iterator<wchar_t, std::__ndk1::char_traits<wchar_t> >&, std::__ndk1::istreambuf_iterator<wchar_t, std::__ndk1::char_traits<wchar_t> >, bool, std::__ndk1::locale const&, unsigned int, unsigned int&, bool&, std::__ndk1::ctype<wchar_t> const&, std::__ndk1::unique_ptr<wchar_t, void (*)(void*)>&, wchar_t*&, wchar_t*)
   0.1%  4.95Ki   0.5%  4.74Ki    std::__ndk1::money_get<char, std::__ndk1::istreambuf_iterator<char, std::__ndk1::char_traits<char> > >::__do_get(std::__ndk1::istreambuf_iterator<char, std::__ndk1::char_traits<char> >&, std::__ndk1::istreambuf_iterator<char, std::__ndk1::char_traits<char> >, bool, std::__ndk1::locale const&, unsigned int, unsigned int&, bool&, std::__ndk1::ctype<char> const&, std::__ndk1::unique_ptr<char, void (*)(void*)>&, char*&, char*)
 100.0%  5.95Mi 100.0%   899Ki    TOTAL
 
 ❯ bloaty -C full libc++_shared.so
    FILE SIZE        VM SIZE
 --------------  --------------
  29.5%  1.75Mi   0.0%       0    .debug_loc
  26.4%  1.57Mi   0.0%       0    .debug_info
   9.0%   546Ki   0.0%       0    .debug_str
   7.4%   450Ki   0.0%       0    .debug_line
   7.2%   438Ki  48.8%   438Ki    .text
   6.6%   403Ki   0.0%       0    .debug_ranges
   3.0%   181Ki   0.0%       0    .strtab
   2.5%   154Ki   0.0%       0    .symtab
   1.7%   106Ki  11.8%   106Ki    .dynstr
   1.2%  73.5Ki   8.2%  73.5Ki    .rela.dyn
   1.1%  66.2Ki   7.4%  66.1Ki    .eh_frame
   0.9%  56.5Ki   0.0%       0    .debug_abbrev
   0.9%  54.7Ki   6.1%  54.6Ki    .dynsym
   0.5%  28.3Ki   2.8%  24.9Ki    [19 Others]
   0.4%  27.3Ki   3.0%  27.2Ki    .data.rel.ro
   0.4%  23.4Ki   2.6%  23.3Ki    .rodata
   0.3%  21.2Ki   2.3%  21.1Ki    .gcc_except_table
   0.3%  18.7Ki   2.1%  18.6Ki    .gnu.hash
   0.3%  17.2Ki   1.9%  17.1Ki    .hash
   0.3%  15.3Ki   1.7%  15.3Ki    .eh_frame_hdr
   0.0%       0   1.4%  12.8Ki    .bss
 100.0%  5.95Mi 100.0%   899Ki    TOTAL
```
## Archive Members
当您在.a文件上运行Bloaty时，使用armembers数据源可以按照存档中的.o文件对其进行拆分。这样可以提供更详细的信息，让您了解存档中各个目标文件的大小和贡献。
```Bash
❯ bloaty -d armembers libc++_static.a
    FILE SIZE        VM SIZE
 --------------  --------------
  44.4%  4.95Mi  51.4%   235Ki    locale.o
  11.2%  1.25Mi  15.0%  69.0Ki    ios.o
  10.6%  1.18Mi   9.3%  42.5Ki    algorithm.o
   9.9%  1.11Mi   8.3%  38.0Ki    string.o
   2.9%   325Ki   1.6%  7.18Ki    [15 Others]
   2.7%   307Ki   3.0%  14.0Ki    iostream.o
   2.5%   285Ki   2.1%  9.84Ki    debug.o
   2.0%   232Ki   1.9%  8.75Ki    strstream.o
   1.9%   216Ki   1.3%  5.99Ki    system_error.o
   1.8%   201Ki   1.0%  4.79Ki    regex.o
   1.7%   192Ki   1.4%  6.21Ki    future.o
   1.7%   190Ki   0.5%  2.32Ki    thread.o
   1.2%   134Ki   0.0%       0    [AR Symbol Table]
   1.1%   128Ki   0.4%  1.93Ki    random.o
   0.9%   101Ki   0.7%  3.16Ki    mutex.o
   0.8%  96.5Ki   0.3%  1.18Ki    stdexcept.o
   0.6%  63.0Ki   0.5%  2.45Ki    memory.o
   0.5%  61.9Ki   0.2%    1020    condition_variable.o
   0.5%  61.6Ki   0.4%  1.63Ki    charconv.o
   0.5%  60.7Ki   0.3%  1.56Ki    shared_mutex.o
   0.5%  60.0Ki   0.3%  1.37Ki    valarray.o
 100.0%  11.1Mi 100.0%   458Ki    TOTAL
```
## Source filter
有时候，您只对二进制文件的部分内容感兴趣，而不是整个包。这在嵌入式编程中很常见，其中ELF文件仅用作容器格式，实际上只有几个节被加载到设备上。

为此，Bloaty提供了一个--source-filter选项，允许过滤掉不相关的数据。它接受一个正则表达式，应用于数据源中的每个符号名称。只有与正则表达式匹配的符号才会显示在输出中。当与自定义数据源结合使用时，这种功能尤其强大，因为重写发生在过滤之前。

在层次化数据源配置文件的情况下，正则表达式将应用于层次结构中的所有符号名称。如果任何名称匹配，那么它的所有父级也将被显示出来。
