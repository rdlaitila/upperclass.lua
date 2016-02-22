--[[  
This file is just for quick testing of things and is not apart of the main test suite
]]
local os = require('os')
local upperclass = require('..upperclass')
local middleclass = require('tests.middleclass')

--
-- Define our test timer function
--
function timedTest(NAME, FUNCTION)
    local memstart = collectgarbage('count')
    local ops = 0
    local startTime = os.clock()
    while os.clock() <= startTime + 1 do
        FUNCTION() 
        ops = ops + 1
    end
    local endTime = os.clock()
    local memstop = collectgarbage('count')
    print(NAME, "ops/s", ops / (endTime - startTime), ':', memstart, memstop )
    collectgarbage()
end

--
-- Generate a sample upperclass class
--
local uclass = upperclass:define('Upperclass')
uclass.public:myPublicStringProperty {
    type='string';
    default='Testing';
}
function uclass.public:myPublicFunction()
end
Upperclass = upperclass:compile(uclass)

--
-- Generate a sample middleclass class
--
local Middleclass = middleclass('Middleclass')
Middleclass.myPublicStringProperty = "Testing"
Middleclass.myPublicFunction = function()
end

--
-- Begin instantiation test
--
timedTest("Class Instantiation: upperclass", function()
    Upperclass()
end)
timedTest("Class Instantiation: middleclass", function()
    Middleclass:new()
end)

--
-- Begin property access test
--
local UpperclassInstance = Upperclass()
timedTest("Class Public Property Get: upperclass", function()    
    local var = UpperclassInstance.myPublicStringProperty    
end)
local MiddleclassInstance = Middleclass:new()
timedTest("Class Public Property Get: middleclass", function()
    local var = MiddleclassInstance.myPublicStringProperty
end)

--
-- Begin property assignment test
--
local UpperclassInstance = Upperclass()
timedTest("Class Public Property Set: upperclass", function()
    UpperclassInstance.myPublicStringProperty = "Edited"        
end)
local MiddleclassInstance = Middleclass:new()
timedTest("Class Public Property Set: middleclass", function()
    MiddleclassInstance.myPublicStringProperty = "Edited"
end)

--
-- Begin function call test
--
local UpperclassInstance = Upperclass()
timedTest("Class Public Function Call: upperclass", function()
    UpperclassInstance:myPublicFunction()
end)
local MiddleclassInstance = Middleclass:new()
timedTest("Class Public Function Call: middleclass", function()
    MiddleclassInstance:myPublicFunction()
end)