local MyBaseClass = nil
local status, err = nil

-- Check for error requiring the class
status, err = pcall(function()
    MyBaseClass = require('tests.MyBaseClass')
end)
if status == false then
    return {result = false, message = err}    
end

-- Call a private property from outside of class
local status, err = pcall(function () 
    local value = MyBaseClass.privateBoolProperty
end)
if status == true then
    return {result = false, message = "Attempt to access static private boolean outside of class was successful. This is bad!"}
end

-- No other failures, return.
return {result = true, message = "Test completed successfully"}