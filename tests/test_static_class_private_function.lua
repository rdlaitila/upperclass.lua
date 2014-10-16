local MyClass = nil
local status, err = nil

status, err = pcall(function()
    MyClass = require('tests.MyBaseClass')
end)

if status == false then
    return {result = false, message = err}    
end

-- Call a private function from outside of class
status, err = pcall(function () 
    MyClass:privateFunction()
end)

-- If we errored, good deal. We should not be able to call the private function
if status == false then
    return {result = true, message = err}
else
    return {result = false, message = "Should not be able to call private function from outside class"}
end