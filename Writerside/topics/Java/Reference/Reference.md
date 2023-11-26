# Reference

`java.lang.ref.Reference`#`reachabilityFence`(`Object`) 是`Java9`中新增的方法，它用于确保对象的引用状态得到正确的刷新。在`Java9`之前，Java虚拟机可能会对对象的引用状态进行一些优化，这可能导致程序中的某些操作在多线程环境下出现意外的行为。`reachabilityFence`方法可以用来避免这种情况的发生，它确保在调用该方法之前的引用操作都已经完成，从而避免出现意外情况。

需要注意的是，`reachabilityFence`方法通常用于处理一些比较底层的、对引用状态非常敏感的情况，对于一般的应用程序开发来说，通常不需要直接使用这个方法。
