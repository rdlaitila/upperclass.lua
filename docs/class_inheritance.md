# Class Inheritance 

Upperclass currently supports single inheritance

# Single Inheritance 

Class inheritance is invoked by passing the Class Object as a second parameter to the upperclass:define method.

First, define your base class:

```lua
local BaseClass = upperclass:define("BaseClass")

-- Class Code...

BaseClass = upperclass:compile(BaseClass)
```

Then define your child class:

```lua
local ChildClass = upperclass:define("ChildClass", BaseClass)

-- Class Code...

ChildClass = upperclass:compile(ChildClass)
```

Your 'ChildClass' now has access to all the properties and methods of the 'BaseClass' where the scope is appropriate.