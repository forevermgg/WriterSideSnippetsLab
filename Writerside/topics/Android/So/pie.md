## 关于Linux下gcc 编译 C 源文件时，生成的是Shared object file而不是Executable file
> https://ch3nye.top/Linux%E4%BA%8C%E8%BF%9B%E5%88%B6%E5%88%86%E6%9E%90%E7%AC%94%E8%AE%B0(ELF)/

最近在Debian下写C时，发现用readelf命令查看编译后的可执行文件类型时，发现文件类型是DYN (Shared object file)，而不是EXEC (Executable file)。

readelf -h a.out

多方查找，发现gcc默认加了--enable-default-pie选项（https://www.v2ex.com/amp/t/481562）

关于gcc中pie选项可以参考这篇文章（https://blog.csdn.net/ivan240/article/details/5363395）

> Position-Independent-Executable是Binutils,glibc和gcc的一个功能，能用来创建介于共享库和通常可执行代码之间的代码–能像共享库一样可重分配地址的程序，这种程序必须连接到Scrt1.o。标准的可执行程序需要固定的地址，并且只有被装载到这个地址时，程序才能正确执行。PIE能使程序像共享库一样在主存任何位置装载，这需要将程序编译成位置无关，并链接为ELF共享对象。

> 引入PIE的原因是让程序能装载在随机的地址，通常情况下，内核都在固定的地址运行，如果能改用位置无关，那攻击者就很难借助系统中的可执行码实施攻击了。类似缓冲区溢出之类的攻击将无法实施。而且这种安全提升的代价很小

因此，可以加上-no-pie 禁用掉该默认选项：

readelf -h a.out
