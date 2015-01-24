# Class Metamethods

Upperclass supports the following metamethods:

* __index
* __newindex
* __tostring
*__add
*__sub

**WARNING:** utilizing metamethods is a highly advanced Lua topic. Improperly utilizing metamethods can cause race conditions, program locks, and other instabilities if you do not understand what is happending behind the scenes. If you require any clarifications please open a GitHub Issue for additional documentation.

## __index

Upperclass fully supports a user defined __index method within class definitions. This method accepts one parameter **KEY**:

* KEY: The member **name** that was accessed

```lua
local MyClass = upperclass:define("MyClass")

function private:__index(KEY)
    if KEY == 'somekey' then
        return "somevalue"
    end
    
    -- Continue Default Lookup Behavior otherwise
    return UPPERCLASS_DEFAULT_BEHAVIOR
end

MyClass = upperclass:compile(MyClass)
```

When utilizing the __index metamethod of your class, you are permitted to use the **self** reference to your class to retrieve class members.

When utilizing the __index metamethod of your class, the resulting lookup will respect the scope when looking up members of a parent class. For instance, if the __index lookup of a member is of scope **private** in the parent class, upperclass will throw its default error for accessing a parent private member.

**BE VERY CAREFUL USING __index METAMETHODS AS THEY CAN BREAK STRICT CLASS SYMANTICS IF YOU ARE NOT CAREFUL**

## __newindex

Upperclass fully supports a user defined __newndex method within class definitions. This method accepts two parameters **KEY**, **VALUE**:

* KEY: The member **name** that was accessed
* VALUE: The value that was attempting to be set

```lua
local MyClass = upperclass:define("MyClass")

function private:__newindex(KEY, VALUE)
    if KEY == 'somekey' then
        -- Do some custom assignment
    end
    
    -- Continue Default Lookup Behavior otherwise
    return UPPERCLASS_DEFAULT_BEHAVIOR
end

MyClass = upperclass:compile(MyClass)
```

When utilizing the __newindex metamethod of your class, you are permitted to use the **self** reference to your class to retrieve class members.

When utilizing the __newindex metamethod of your class, the resulting lookup will respect the scope when looking up members of a parent class. For instance, if the __index lookup of a member is of scope **private** in the parent class, upperclass will throw its default error for accessing a parent private member.

When utilizing the __newindex metamethod of your class, upperclass will continue to enforce the member property type.

## __tostring

Upperclass fully supports a user defined __tostring method within class definitions. This method accepts no parameters

```lua
local MyClass = upperclass:define("MyClass")

function private:__tostring()
    if [SOME_CONDITION] then
        return "Custom Tostring Value"
    end
   
    -- Continue default tostring behavior
    return UPPERCLASS_DEFAULT_BEHAVIOR   
end

MyClass = upperclass:compile(MyClass)
```

When utilizing the __tostring metamethod of your class, you are permitted to use the **self** reference to your class to retrieve class members.

## __add

Upperclass fully supports a user defined __add method within class definitions. This method accepts one parameters **RIGHT** which is the right side operator of the addition 

```lua
local MyClass = upperclass:define("MyClass")

private.currentValue = 0

function private:__add(RIGHT)
    self.currentValue = self.currentValue + RIGHT
end

MyClass = upperclass:compile(MyClass)
```

## __sub

Upperclass fully supports a user defined __sub method within class definitions. This method accepts one parameters **RIGHT** which is the right side operator of the subtraction 

```lua
local MyClass = upperclass:define("MyClass")

private.currentValue = 0

function private:__sub(RIGHT)
    self.currentValue = self.currentValue - RIGHT
end

MyClass = upperclass:compile(MyClass)
```