# Defining Class Properties

Class properties in upperclass can be defined in two distict ways:

* Simple syntax
* Advanced syntax

# Simple property definition

If you know that your class property will be exclusivly 'public', 'private', or 'protected' in scope you can use the Simple syntax to define your property:

```lua
--
-- Defines a public property
--
public.myPublicProperty = "test"

--
-- Defines a private property
--
private.myPrivateProperty = true

--
-- Defines a protected property
--
protected.myProtectedProperty = 200
```

Notes:

* The **public**, **private**, **protected** declaration determines the **scope** of the property. 
* The name after the first '.' dot determines the **name** of the  property.
* The value supplied after the **=** equal sign determines the **default value** and the **type** of the property. The **type** is infered from the type of lua value supplied ex: **string**, **number**, **table**, **boolean**, **userdata**
* If the **default value** supplied is of lua type **nil** then the value type is of **any** meaning the property can accept any value type after class compilation

# Advanced property definition

In many cases you need a class property to be accessible by different scopes depending on what action is being invoked on the property. Generally there are only two actions that can be invoked on a Class Property:

* Getting
* Setting

In addition, in many cases you may wish to explicitly define the **type** of the property and choose whether or not to supply a default value.

```lua
--
-- Property in which public can read, but only the class can modify, and can only accept a value type of string, and has a default value of "myValue"
--
property : myCustomScopedProperty { 
    "myValue"; 
    get='public'; 
    set='private';
    type='string';
}
```

Notes:

* The **property** keyword determines that we are defining a class property
* The name after the first **:** colon character determines the **name** of the property.
* The curly brackets after the property name contain the property definition, which contain values:
** **Default Value:** [LUA_STRING|LUA_NUMBER|LUA_TABLE|LUA_BOOLEAN|LUA_USERDATA](optional)
** **Getter Scope :** get='[public|private|protected|nobody]'(optional)
** **Setter SCope :** set='[public|private|protected|nobody]'(optional)
** **Explicit Type:** type='[string|boolean|number|table|userdata|any]'(optional)
* If you provide a **default value** to the property definition but no **type** value, the property will be strictly typed to the lua type of the default value.
* If you provide no **default value** to the property definition but a explicit **type** the property will be strictly typed to the type value supplied and have a default value of nil.
* If you provide no **default value** and no **type** to the property definition, the property will be strictly typed to **any** value type and have a default value of nil.

