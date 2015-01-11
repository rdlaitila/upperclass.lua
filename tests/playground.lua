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

property : myPrivateVar {
    "testing";
    get='protected';
    set='private';
}

Class1 = upperclass:compile(Class1)

--====================================================

local Class2 = upperclass:define("Class2", Class1)

function private:__index(KEY) 
    if KEY == 'blah' then
        return "GO FUCK YOURSELF"
    end
    
    -- Continue Default Lookup Behavior
    return UPPERCLASS_DEFAULT_LOOKUP_BEHAVIOR
end

function public:getPrivateVar()
    return self.myPrivateVar
end

Class2 = upperclass:compile(Class2)

--====================================================
print(Class2.blah)