# Defining Class Methods

Defining class methods in upperclass is simple. Class methods can be one of the following scopes:

* Public
* Private
* Protected

To define a class method, indicate the scope:method_name as follows

```lua

-- 
-- Define a public class method
--
function public:myPublicMethod()
    print("I'm accessible anywhere!")
end

-- 
-- Define a private class method
--
function private:myPrivateMethod()
    print("I'm only accessible from the class that defines me!")
end

--
-- Define a protected class method
--
function protected:myProtectedMethod()
    print("I'm only accessible from the class that defines me, or any class that inherits me!")
end```

# Overriding Class Methods at runtime

Class methods cannot be overridden at runtime to maintain strict class symantecs. If you attempt to override a class method you will recieve a runtime error