# 关于Linux下gcc 编译 C 源文件时，生成的是Shared object file而不是Executable file
>
> <https://ch3nye.top/Linux%E4%BA%8C%E8%BF%9B%E5%88%B6%E5%88%86%E6%9E%90%E7%AC%94%E8%AE%B0(ELF)/>

最近在`Debian`下写`C`时，发现用`readelf`命令查看编译后的可执行文件类型时，发现文件类型是`DYN`(`Shared object file`)，而不是`EXEC`(`Executable file`)。

```Bash
readelf -h a.out
Type:                              DYN (Shared object file)
```

多方查找，发现`gcc`默认加了`--enable-default-pie`选项（<https://www.v2ex.com/amp/t/481562）>

关于`gcc`中`pie`选项可以参考这篇文章（<https://blog.csdn.net/ivan240/article/details/5363395）>

> `Position-Independent-Executable`是`Binutils`,`glibc`和`gcc`的一个功能，能用来创建介于共享库和通常可执行代码之间的代码–能像共享库一样可重分配地址的程序，这种程序必须连接到`Scrt1.o`。标准的可执行程序需要固定的地址，并且只有被装载到这个地址时，程序才能正确执行。`PIE`能使程序像共享库一样在主存任何位置装载，这需要将程序编译成位置无关，并链接为`ELF`共享对象。

> 引入`PIE`的原因是让程序能装载在随机的地址，通常情况下，内核都在固定的地址运行，如果能改用位置无关，那攻击者就很难借助系统中的可执行码实施攻击了。类似缓冲区溢出之类的攻击将无法实施。而且这种安全提升的代价很小

因此，可以加上`-no-pie`禁用掉该默认选项：

```Bash
readelf -h a.out

Type:                              EXEC (Executable file)
```
