
# 1.ndk-stack实时翻译堆栈


解析标识：

```
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
```

解析：

```
adb logcat -v threadtime | ndk-stack -sym ./obj/armeabi-v7a/
cat crash.txt | ndk-stack -sym /obj/armeabi-v7a/
```

### tombstone 文件

```
https://source.android.com/devices/tech/debug/native-crash#tombstones
```

# 2. 怎么检查so动态库的符号? 


linux命令: ldd -r *.so, 看命令的输出是否包含undefined symbol
```
readelf -Ws libcmaketest.so
nm -D -f sysv libcmaketest.so
```

# 3.crash 常见中断类型
```cpp
#define SIGABRT 6 // abort() 调用abort函数生成的信号，表示程序运行异常被中止
#define SIGSEGV 11 // segmentation violation 指针所对应的地址是无效或非法地址，比如访问越界/stack overflow/文件操作不被允许( fault addr 0x0 或者其他小地址 fault addr 0x0000008 一般是空指针错误，访问为null的结构体的成员变量时，报错地址会是小地址)
#define SIGILL 4 // Illegal instruction 执行了非法指令，比如第三方库的兼容性问题，权限问题
#define SIGSYS 31 // bad argument to system call 非法的系统调用
#define SIGBUS 7 // 非法地址，包括内存地址对齐出错，比如访问一个4字节的整数, 但其地址不是4的倍数
#define SIGFPE 8 // 进程执行了一个错误的算术操作，比如除0、溢出
#define SIGKILL 9 // 强制结束程序，本信号不能被捕获
#define SIGPIPE 13 // write on a pipe with no one to read it 管道破裂，通常在进程间通信产生
```

# 4.android linker日志打开
**分析linker代码，发现Android 系统是有日志相关功能。**
Enable logging of dlopen/dlsym and library loading errors for apps (Available in Android O)
Starting with Android O it is possible to enable logging of dynamic linker activity for debuggable apps by setting a property corresponding to the fully-qualified name of the specific app: 针对单个应用
```
adb shell setprop debug.ld.app.com.example.myapp dlerror,dlopen,dlsym
```
adb logcat
Any combination of dlerror, dlopen, and dlsym can be used. There's no separate dlclose option: dlopen covers both loading and unloading of libraries. Note also that dlerror doesn't correspond to actual calls of dlerror(3) but to any time the dynamic linker writes to its internal error buffer, so you'll see any errors the dynamic linker would have reported, even if the code you're debugging doesn't actually call dlerror(3) itself.

On userdebug and eng builds it is possible to enable tracing for the whole system by using the debug.ld.all system property instead of app-specific one. For example, to enable logging of all dlopen(3) (and thus dclose(3)) calls, and all failures, but not dlsym(3) calls:

全局生效
```
adb shell setprop debug.ld.all dlerror,dlopen
```

debug包增加了 -fno-c++-static-destructors 编译选项