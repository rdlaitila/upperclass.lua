--[[
This file is just for quick testing of things and is not apart of the main test suite
]]
local upperclass = require('..upperclass')

local Class = upperclass:define("Class")

function private:__tostring()
    return "Custom Tostring Value"
end

Class = upperclass:compile(Class)

print(Class)