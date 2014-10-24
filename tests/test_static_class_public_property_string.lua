-- Attempt class creation
local MyClassDefinition, MyClass, public, private, protected = nil
status, err = pcall(function()
    MyClassDefinition, public, private, protected = upperclass:define("MyClass")
    
    public.stringProperty = "string"
    
    MyClass = upperclass:compile(MyClassDefinition)
end)
if status == false then
    return {result = false, message = err}    
end

-- Attempt to call a public function from outside of class
local value = nil
status, err = pcall(function () 
    value = MyClass.stringProperty
end)
if status == false then
    return {result = false, message = "Attempt to access static public string outside of class was not successful. err:"..tostring(err)}
elseif status == true then
    if value ~= "string" then
        return {result = false, message = "Return value of static public boolean was not as expected. value:"..tostring(value)}
    end
end

-- No other failures, return.
return {result = true, message = "Test completed successfully"}
