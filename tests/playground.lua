--[[
This file is just for quick testing of things and is not apart of the main test suite
]]

if debug == nil then
    print("NO DEBUG LIBRARY")
end

local upperclass = require('..upperclass')

upperclass.DEBUG_ENABLED = true

--====================================================

local Class1 = upperclass:define("Class1")



Class1 = upperclass:compile(Class1)

--====================================================

local Class2 = upperclass:define("Class2", Class1)

property : myPrivateVar {
    "testing";
    get='private';
    set='private';
}

function private:__newindex(KEY, VALUE)
    print("__newindex", KEY, VALUE)
    return UPPERCLASS_DEFAULT_LOOKUP_BEHAVIOR
end

function public:getPrivateVar()
    return self.myPrivateVar
end

function public:setPrivateVar(VALUE)
    self.myPrivateVar = VALUE
end

Class2 = upperclass:compile(Class2)

--====================================================
Class2:setPrivateVar("edited")
print(Class2:getPrivateVar())