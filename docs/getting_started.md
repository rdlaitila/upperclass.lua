# Lua Class Commons Basics

If you are new to lua, please read this section. If you are a seasoned veteran, you can skip ahead.

Lua by iteself does not contain any sort of **Class** functionality. That is to say Lua does not support classes. However, given the extreme flexability of the language we can emulate the common class functionality of other languages in lua fairly easily.

First: The lua community has coined a phrase called *Class Commons* where which the term is meant to mean the standard syntax to use when working with libraries that emulate class functionality. Example:

```lua
local MyClass = class("MyClass")

MyClass.property = value

function MyClass:method()
    return MyClass.property
end
```