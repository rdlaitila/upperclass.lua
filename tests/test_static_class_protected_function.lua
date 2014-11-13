-- Attempt class creation
status, err = pcall(function()
    MyClassDefinition = upperclass:define("MyClass")
    
    function protected:protectedFunction()
        return "SUCCESS"
    end
    
    MyClass = upperclass:compile(MyClassDefinition)
end)
if status == false then
    return {result = false, message = err}    
end

-- Attempt to call a public function from outside of class
local value = nil
status, err = pcall(function () 
    value = MyClass:protectedFunction()    
end)
if status == true then
    return {result = false, message = "Attempt to access static protected function outside of class was successful. This is bad!"}
end

-- No other failures, return.
return {result = true, message = "Test completed successfully"}
