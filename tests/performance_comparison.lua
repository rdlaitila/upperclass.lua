--[[
This file is just for quick testing of things and is not apart of the main test suite
]]
local upperclass = require('..upperclass')
local middleclass = require('tests.middleclass')
--========================================================================
function timedTest(NAME, FUNCTION)
    collectgarbage()
    local startTime = os.clock()
    for i=0,10000 do FUNCTION() end
    local endTime = os.clock()
    print(NAME, endTime - startTime )
end
--========================================================================
local Upperclass = upperclass:define('Upperclass')

public.myPublicStringProperty = "Testing"

Upperclass = upperclass:compile(Upperclass)
--========================================================================
local Middleclass = middleclass('Middleclass')

Middleclass.myPublicStringProperty = "Testing"
--========================================================================

timedTest("Class Instantiation: upperclass", function()
    Upperclass()
end)

timedTest("Class Instantiation: middleclass", function()
    Middleclass:new()
end)

local UpperclassInstance = Upperclass()
timedTest("Class Public Property Get: upperclass", function()
    local var = UpperclassInstance.myPublicStringProperty    
end)

local MiddleclassInstance = Middleclass:new()
timedTest("Class Public Property Get: middleclass", function()
    local var = MiddleclassInstance.myPublicStringProperty
end)

local UpperclassInstance = Upperclass()
timedTest("Class Public Property Set: upperclass", function()
    UpperclassInstance.myPublicStringProperty = "Edited"
end)

local MiddleclassInstance = Middleclass:new()
timedTest("Class Public Property Set: middleclass", function()
    MiddleclassInstance.myPublicStringProperty = "Edited"
end)

