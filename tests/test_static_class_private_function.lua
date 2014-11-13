local MyClass = nil
local status, err = nil

-- Check for error defining the class
status, err = pcall(function()    
    MyClass = upperclass:define("MyClass")
    
    function private:privateFunction()
        return "hello"
    end
end)
if status == false then
    return {result = false, message = err}    
end

-- Attempt to call a private function from outside of class
status, err = pcall(function () 
    value = MyClass:privateFunction()
end)
if status == true then
    return {result = false, message = "Attempt to access static private function outside of class was successful. This is bad!"}
end

-- No other failures, return.
return {result = true, message = "Test completed successfully"}
