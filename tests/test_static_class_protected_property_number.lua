--========================================================================
local Class = upperclass:define("Class")

property : myProtectedNumber {
    10;
    get='protected';
    set='protected';
}

Class = upperclass:compile(Class)
--========================================================================
-- Call a private property from outside of class
local status, err = pcall(function () 
    local value = Class.myProtectedNumber
end)
if status == true then
    return {result = false, message = "Attempt to access static protected number outside of class was successful. This is bad!"}
end

-- No other failures, return.
return {result = true, message = "Test completed successfully"}