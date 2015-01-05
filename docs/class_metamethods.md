# Class Metamethods

Upperclass supports the following metamethods:

* __index
* __newindex

**WARNING:** utilizing metamethods is a highly advanced Lua topic. Improperly utilizing metamethods can cause race conditions, program locks, and other instabilities if you do not understand what is happending behind the scenes. If you require any clarifications please open a GitHub Issue for additional documentation.

## __index

Upperclass fully supports a user defined __index method within class definitions. This method accepts two parameters **KEY** and **MEMBER**:

* KEY: The member **name** that was accessed
* MEMBER: A table containing the related Upperclass Class Member Property data (if it exists)

```lua
local MyClass = upperclass:define("MyClass")

function private:__index(KEY, MEMBER)
    -- Print what KEY was accessed, and the member lookup table
    print(tostring(KEY), tostring(MEMBER))
    
    -- Do some custom lookup processing
    
    -- Default to returning the member value
    if MEMBER ~= nil then
        return self.__imp__.memberValueOverrides[KEY] or MEMBER.value_default
    end
end

MyClass = upperclass:compile(MyClass)
```

## __newindex

Upperclass fully supports a user defined __newndex method within class definitions. This method accepts three parameters **KEY**, **VALUE** and **MEMBER**:

* KEY: The member **name** that was accessed
* VALUE: The value that was attempting to be set
* MEMBER: A table containing the related Upperclass Class Member Property data (if it exists)

```lua
local MyClass = upperclass:define("MyClass")

function private:__newindex(KEY, VALUE, MEMBER)
    -- Print what KEY was accessed, the value to be set, and the member lookup table
    print(tostring(KEY), tostring(VALUE), tostring(MEMBER))
    
    -- Do some custom lookup & assignment processing
    
    -- Default to returning the member value
    if MEMBER ~= nil then
        self.__imp__.memberValueOverrides[KEY] = VALUE        
    end
end

MyClass = upperclass:compile(MyClass)
```