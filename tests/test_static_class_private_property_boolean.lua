local MyBaseClass = nil
local status, err = nil

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

-- If we errored, good deal. We should not be able to retrieve the private property
if status == false then
    return {result = true, message = err}
else
    return {result = false, message = "Should not be able to retrieve private property from outside class"}
end