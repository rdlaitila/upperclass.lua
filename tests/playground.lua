--[[
This file is just for quick testing of things and is not apart of the main test suite
]]
local upperclass = require('..upperclass')

local Class = upperclass:define("Class")

private.counter = 0

function private:__tostring()
    return tostring(self.counter)
end

function private:__add(RIGHT)
    self.counter = self.counter + RIGHT
    return self.counter
end

Class = upperclass:compile(Class)

upperclass:dumpClassMembers(Class)

print(Class + 1)