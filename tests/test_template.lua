local MyClass = nil
local status, err = nil

-- Check for error requiring the class
status, err = pcall(function()
    MyBaseClass = require('tests.MyBaseClass')
end)
if status == false then
    return {result = false, message = err}    
end

-- DO TESTS HERE

-- No other failures, return.
return {result = true, message = "Test completed successfully"}
