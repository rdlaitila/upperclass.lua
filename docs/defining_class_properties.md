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

The schema for this definition is:

* [SCOPE].[PROPERTY_NAME] = [INITIAL_VALUE]

Depending on the scope you provide before the '.' dot, will govern how the property may be accesed.

# Advanced property definition

In many cases you need a class property to be accessible by different scopes depending on what action is being invoked on the property. Generally there are only two actions that can be invoked on a Class Property:

* Getting
* Setting

In upperclass you can define the access scope for both getting the property and setting the property. This effectivly allows you to create property types such as 'constant', 'public readonly' etc:

```lua
--
-- Property in which public can read, but only the class can modify
--
property : myCustomScopedProperty { "myValue" ; get='public' ; set='private }

--
-- Property in which is effectivly a constant
--
property : myConstantProperty { "myValue" ; get='public' ; set=nil }
```

The schema for this definition is:

* property : [PROPERTY_NAME] {  [INITIAL_VALUE] ; get='public|private|protected|nil' ; set='public|private|protected|nil' }

