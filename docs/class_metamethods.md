# Class Metamethods

Upperclass supports the following metamethods:

* __index
* __newindex

**WARNING:** utilizing metamethods is a highly advanced Lua topic. Improperly utilizing metamethods can cause race conditions, program locks, and other instabilities if you do not understand what is happending behind the scenes. If you require any clarifications please open a GitHub Issue for additional documentation.

## __index

Upperclass fully supports a user defined __index method within class definitions. This method accepts one parameter **KEY**:

* KEY: The member **name** that was accessed

```lua
local MyClass = upperclass:define("MyClass")

function private:__index(KEY)
    if KEY == 'some_custom_value' then
        -- DO SOME CUSTOM PROCESSING IF YOU WANT
    end
    
    -- Continue Default Lookup Behavior otherwise
    return UPPERCLASS_DEFAULT_LOOKUP_BEHAVIOR
end

MyClass = upperclass:compile(MyClass)
```

When utilizing the __index metamethod of your class, you are permitted to use the **self** reference to your class to retrieve class members.

When utilizing the __index metamethod of your class, the resulting lookup will respect the scope when looking up members of a parent class. For instance, if the __index lookup of a member is of scope **private** in the parent class, upperclass will throw its default error for accessing a parent private member.

**BE VERY CAREFUL USING __index METAMETHODS AS THEY CAN BREAK STRICT CLASS SYMANTICS IF YOU ARE NOT CAREFUL**

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