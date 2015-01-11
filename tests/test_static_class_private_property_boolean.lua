--========================================================================
local Class = upperclass:define("Class")

property : myPrivateBoolean2 {
    false;
    get='private';
    set='private';
}

Class = upperclass:compile(Class)
--========================================================================
-- Call a private property from outside of class
local status, err = pcall(function () 
    local value = Class.myPrivateBoolean
end)
if status == true then
    return {result = false, message = "Attempt to access static private boolean outside of class was successful. This is bad!"}
end

-- No other failures, return.
return {result = true, message = "Test completed successfully"}