# Upperclass

Upperclass is just another implimentation and variation of the *[Class Commons](https://github.com/bartbes/Class-Commons)* idea. However, Upperclass was built to solve the following limitations of other *[Class Commons](https://github.com/bartbes/Class-Commons)* systems:

* Ability to define class members of scopes **Public**, **Private**, and **Protected**
* Ability to utilize class as a static (singlton) class or as any number of generated instances
* Ability to define and enforce class property types **String**, **Boolean**, **Table**, and **Number** and fail when those constraints are violated.
* Ability to carry class member scopes and types through inheritence
* Simplify class definition syntax

# Example

Create a file called **MyClass.lua** in your project directory. Add content:

```lua
local myclass = upperclass:define("MyClass")

--
-- A Private Boolean Property
--
private.isClassConstructed = false

--
-- A Public String Property
--
public.publicStringProperty = "Hello World"

--
-- Class Constructor
--
function private:__construct()
    self.isClassConstructed = true
end

--
-- Get If Class Is Constructed
--
function public:getIsClassConstructed()
    return self.isClassConstructed
end

return upperclass:compile(myclass)
```

Then in your project main.lua, add the following:

```lua
upperclass = require('upperclass')
MyClass = require('MyClass')

-- Create instance of our class
MyClassInstance = MyClass()

-- Should print "Hello World"
print( MyClassInstance.publicStringProperty ) -- "Hello World"

-- Should print true
print( MyClassInstance:getIsClassConstructed() ) -- True

-- Should error with private member access denied
print( MyClassInstance.isClassConstructed ) -- Error

-- We can also access the class statically, which should return false
print( MyClass:getIsClassConstructed() ) -- False
```
