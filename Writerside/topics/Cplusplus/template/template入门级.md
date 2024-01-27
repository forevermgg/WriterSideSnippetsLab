
## 案例1
```
template <typename Function>
class UniqueFunction;

template <typename Functor>
using EnableIfCallable = std::enable_if_t<std::conjunction_v<std::is_invocable_r<RetType, Functor, Args...>,
                                          std::negation<std::is_same<std::decay_t<Functor>, UniqueFunction>>>,
                                          int>;
```c++
利用`std::is_invocable`在编译期间判断函数与传递参数是否匹配
`EnableIfCallable`是一个模板别名`template alias`，用于定义一个类型特性，该特性仅在给定的`Functor`可以被调用并返回`RetType`类型的值时启用。这里的`Functor`是一个通用的函数对象类型,`RetType`是期望的返回类型，而`Args...`是函数对象的参数类型。

`EnableIfCallable`使用了以下两个条件：

`std::is_invocable_r<RetType, Functor, Args...>`：检查`Functor`是否可以接受参数`Args...`并返回`RetType`类型的值。如果可以，则此特性为`std::true_type`；否则为`std::false_type`。

`std::negation<std::is_same<std::decay_t<Functor>, UniqueFunction>>`：检查`Functor`是否与`UniqueFunction`不同。这是为了防止`UniqueFunction`自身被当作构造函数的参数。`std::decay_t`用于移除引用和修饰符（如`const`和`volatile`）。

这两个条件通过`std::conjunction_v`组合在一起，要求它们都为`true`。如果这两个条件都满足,`EnableIfCallable`则为`int`类型；否则，该模板别名不会有类型定义。这使得`EnableIfCallable`可以用作`SFINAE(Substitution Failure Is Not An Error)`技术的一部分，以便在编译时根据函数对象的类型选择合适的函数重载。


## 案例2
```
using CallerType = std::remove_cv_t<std::remove_pointer_t<std::remove_reference_t<decltype(this)>>>;
std::is_base_of_v<ViewModel, CallerType>
```c++
`CallerType`是一个类型别名，它表示去除`const`、`volatile`、指针和引用修饰符后的`decltype(this)`类型。

`decltype(this)`获取当前成员函数所属类的指针类型。

`std::remove_reference_t<decltype(this)>`去除引用修饰符。在本例中，`decltype(this)`是一个指针类型，所以不需要这一步，但这是一个通用的处理方法。

`std::remove_pointer_t<...>`去除指针修饰符。这会将指针类型转换为相应的类类型。

`std::remove_cv_t<...>`去除`const`和`volatile`修饰符。这会得到纯粹的类类型，而不包含任何额外的修饰符。

`CallerType`可以用于在成员函数中获取当前类的类型，而不包含任何修饰符。这在某些情况下，如模板元编程和类型特性中，可能非常有用。

`std::is_base_of_v<ViewModel, CallerType>` 是一个编译时布尔值，用于检查`ViewModel`是否是`CallerType`的基类。

`std::is_base_of_v`是一个模板变量，它是`std::is_base_of`类型特性的一个辅助变量。如果`ViewModel`是`CallerType`的基类或者与`CallerType`相同，则`std::is_base_of_v`的值为`true`；否则为`false`。

这个编译时布尔值可以用于编译时条件判断，如静态断言、`if constexpr`语句或作为 `SFINAE(Substitution Failure Is Not An Error)`技术的一部分。例如，你可以使用这个值来确保`CallerType`继承自`ViewModel`，或者在编译时根据继承关系选择合适的函数重载。


## 小节
关键字。类型特性---》类型支持（基本类型、RTTI、类型特性）（https://c-cpp.com/cpp/types.html）---》类型关系




