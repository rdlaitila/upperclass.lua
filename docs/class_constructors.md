# Class Constructors

Your class can have a class constructor that is called when a new instance of your class is created. It is defined as follows:

```lua
local MyClass = upperclass:define("MyClass")

--
-- A private property
--
private.myPrivateProperty = "someval"

--
-- Class Constructor
--
function private:__construct(VALUE)
    self.myPrivateProperty = VALUE
end

--
-- Compile Class
-- 
MyClass = upperclass:compile(MyClass)
```

# Parent Class Constructors

If your class is inheriting another class, you can call the parent's class constructor explicitly with self:__constructparent(ARGS):

```lua
local MyClass = upperclass:define("MyClass", MyBaseClass)

--
-- A private property
--
private.myPrivateProperty = "someval"

--
-- Class Constructor
--
function private:__construct(VALUE)
    self:__constructparent(PARENT_ARG)
    self.myPrivateProperty = VALUE
end

--
-- Compile Class
-- 
MyClass = upperclass:compile(MyClass)
```