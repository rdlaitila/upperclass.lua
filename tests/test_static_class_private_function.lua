local MyClass = require('tests.MyBaseClass')

-- Call a private function from outside of class
local status, err = pcall(function () 
    MyClass:privateFunction()
end)

-- If we errored, good deal. We should not be able to call the private function
if status == false then
    return {result = true, message = err}
else
    return {result = false, message = "Should not be able to call private function from outside class"}
end