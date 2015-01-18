--========================================================================
local Class = upperclass:define("Class")

function protected:myProtectedFunction()
    return "Whatever"
end

Class = upperclass:compile(Class)
--========================================================================
-- Call a private property from outside of class
local status, err = pcall(function () 
    local value = Class:myProtectedFunction()
end)
if status == true then
    return {result = false, message = "Attempt to access static protected function outside of class was successful. This is bad!"}
end

-- No other failures, return.
return {result = true, message = "Test completed successfully"}