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

In upperclass you can define the access scope for both getting the property and setting the property. This effectivly allows you to create property access types such as 'constant', 'public readonly' etc:

```lua
--
-- Property in which public can read, but only the class can modify
--
property : myCustomScopedProperty { "myValue" ; get='public' ; set='private' }

--
-- Property in which is effectivly a constant
--
property : myConstantProperty { "myValue" ; get='public' ; set='nobody' }
```

The schema for this definition is:

* property : [PROPERTY_NAME] {  [INITIAL_VALUE] ; get='public|private|protected|nobody' ; set='public|private|protected|nobody' }

