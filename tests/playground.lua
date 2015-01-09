--[[
This file is just for quick testing of things and is not apart of the main test suite
]]

local upperclass = require('..upperclass')

local Class = upperclass:define("Class")

property : numberProperty {
    0;
    get='public';
    set='private';       
}

function private:__construct(NUM)
    self.numberProperty = NUM
end

Class = upperclass:compile(Class)

local myClass = Class(5)

print(Class.numberProperty)
print(myClass.numberProperty)

upperclass:dumpClassMembers(Class, 1)
upperclass:dumpClassMembers(myClass, 1)