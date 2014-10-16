# Lua Class Commons Basics

If you are new to lua, please read this section. If you are a seasoned veteran, you can skip ahead.

Lua by iteself does not contain any sort of **Class** functionality. That is to say Lua does not support classes. However, given the extreme flexability of the language we can emulate the common class functionality of other languages in lua fairly easily.

**First**: The lua community has coined a phrase called *[Class Commons](https://github.com/bartbes/Class-Commons)* where which the term is meant to mean the standard syntax to use when working with libraries that emulate class functionality. Example:

Define a standard *Class Commons* class

```lua
-- MyClass.lua
local MyClass = class("MyClass")

MyClass.property = value

function MyClass:method()
    return self.property
end

return MyClass
```

And to use the class

```lua
-- main.lua
MyClass = require("MyClass")

MyClassInstance = MyClass:new()

print(MyClass.property)
print(MyClass:method())
```

**Second:** Many implimentations of *[Class Commons](https://github.com/bartbes/Class-Commons)* exist. Below is a short list of existing libraries that impliment the *[Class Commons](https://github.com/bartbes/Class-Commons)* syntax and provide an emulation of basic class symantics:

* [MiddleClass](https://github.com/kikito/middleclass)
* [30log](https://github.com/Yonaba/30log)

# Upperclass

Upperclass is just another implimentation and variation of the *[Class Commons](https://github.com/bartbes/Class-Commons)* idea. However, Upperclass was built to solve the following limitations of other *[Class Commons](https://github.com/bartbes/Class-Commons)* systems:

* Ability to define class members of scopes **Public**, **Private**, and **Protected**
* Ability to utilize class as a static (singlton) class or as any number of generated instances
* Ability to define and enforce class property types **String**, **Boolean**, **Table**, and **Number** and fail when those constraints are violated.
* Ability to carry class member scopes and through inheritence
* Simply class definition syntax
* Provide strong consistency 
