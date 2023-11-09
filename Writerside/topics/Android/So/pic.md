# 地址无关代码
## 装载时重定位
动态链接模块被装载映射至虚拟空间后，指令部分是在多个进程之间共享的，由于装载时重定位的方法需要修改指令，所以没有办法做到同一份指令被多个进程共享，因为指令被重定位后对于每个进程来讲是不同的。所以装载时重定位的方法并不适合用来解决共享对象的地址问题。动态连接库中的可修改数据部分对于不同的进程来说有多个副本，所以它们可以采用装载时重定位的方法来解决。如果只使用“-shared”，那么输出的共享对象就是使用装载时重定位的方法。

## 地址无关代码
装载时重定位是解决动态模块中有绝对地址引用的办法之一，缺点是指令部分无法在多个进程之间共享。为解决共享对象指令中对绝对地址的重定位问题，要让程序模块中共享的指令部分在装载时不需要因为装载地址的改变而改变，所以实现的基本想法就是把指令中那些需要被修改的部分分离出来，跟数据部分放在一起，这样指令部分就可以保持不变，而数据部分可以在每个进程中拥有一个副本。这种方案就是目前被称为地址无关代码（PIC, Position-independent Code）的技术。
先来分析模块中各种类型的地址引用方式。把共享对象模块中的地址引用按照是否为跨模块分成两类：模块内部引用和模块外部引用；按照不同的引用方式分为指令引用和数据访问，得到4种情况：

+ 模块内部的函数调用、跳转等。
+ 模块内部的数据访问，比如模块中定义的全局变量、静态变量。
+ 模块外部的函数调用、跳转等。
+ 模块外部的数据访问，比如其他模块中定义的全局变量。