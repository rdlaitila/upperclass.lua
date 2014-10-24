-- Attempt class creation
local MyClassDefinition, MyClass, public, private, protected = nil
status, err = pcall(function()
    MyClassDefinition, public, private, protected = upperclass:define("MyClass")
    
    protected.protectedBoolean = true    
    
    MyClass = upperclass:compile(MyClassDefinition)
end)
if status == false then
    return {result = false, message = err}    
end

-- Attempt to call a public function from outside of class
status, err = pcall(function () 
    local value = MyClass.protectedBoolean  
end)
if status == true then
    return {result = false, message = "Attempt to access static protected boolean outside of class was successful. This is bad!"}
end

-- No other failures, return.
return {result = true, message = "Test completed successfully"}