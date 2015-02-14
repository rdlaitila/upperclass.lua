# Class Metamethods

Upperclass supports the following user defined metamethods:

| METHOD                    | DESCRIPTION
| ------------------------- | ------------
| __index(KEY)              | Fires when table[index] is indexed, if table[index] is nil. Can also be set to a table, in which case that table will be indexed.
| __newindex(KEY, VALUE) 	| Fires when table[index] tries to be set (table[index] = value), if table[index] is nil. Can also be set to a table, in which case that table will be indexed.
| __concat(VALUE) 	        | Fires when the .. concatenation operator is used on the table.
| __unm() 	                | Fires when the unary – operator is used on the table.
| __add(VALUE) 	            | The + addition operator.
| __sub(VALUE) 	            | The – subtraction operator.
| __mul(VALUE) 	            | The * mulitplication operator.
| __div(VALUE) 	            | The / division operator.
| __mod(VALUE) 	            | The % modulus operator.
| __pow(VALUE) 	            | The ^ exponentiation operator.
| __tostring() 	            | Fired when tostring is called on the table.
| __eq(VALUE) 	            | The == equal to operator˚
| __lt(VALUE) 	            | The < less than operator˚; NOTE: Using the >= greater than or equal to operator will invoke this metamethod and return the opposite of what this returns, as greater than or equal to is the same as not less than.
| __le(VALUE) 	            | The <= operator˚; NOTE: Using the > greater than operator will invoke this metamethod and return the opposite of what this returns, as greater than is the same as not less than or equal to.
| __gc() 	                | Fired when the table is garbage-collected.
| __len() 	                | Fired when the # length operator is used on the Object. NOTE: Only userdatas actually respect the __len() metamethod in Lua 5.1 

**WARNING:** utilizing metamethods is a highly advanced Lua topic. Improperly utilizing metamethods can cause race conditions, program locks, and other instabilities if you do not understand what is happending behind the scenes. If you require any clarifications please open a GitHub Issue for additional documentation.

## __index

```lua
local MyClass = upperclass:define("MyClass")

private.numSomeKeyAccessed = 0

function private:__index(KEY)
    if KEY == 'somekey' then
        self.numSomeKeyAccessed = self.numSomeKeyAccessed + 1        
    end
    
    -- Continue Default Lookup Behavior Otherwise
    return UPPERCLASS_DEFAULT_BEHAVIOR
end

MyClass = upperclass:compile(MyClass)
```

## __newindex

```lua
local MyClass = upperclass:define("MyClass")

private.somekey = "somedefault"

function private:__newindex(KEY, VALUE)
    if KEY == 'somekey' then
        self.somekey = VALUE
    end
    
    -- Continue Default Assignment Behavior Otherwise
    return UPPERCLASS_DEFAULT_BEHAVIOR
end

MyClass = upperclass:compile(MyClass)
```

## __tostring

```lua
local MyClass = upperclass:define("MyClass")

private.useCustomClassName = true

private.customClassName = "My Custom Class Name"

function private:__tostring()
    if self.useCustomClassName == true then
        return self.customClassName
    end
   
    -- Continue default tostring behavior
    return UPPERCLASS_DEFAULT_BEHAVIOR   
end

MyClass = upperclass:compile(MyClass)
```

## __add

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