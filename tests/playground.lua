--[[
This file is just for quick testing of things and is not apart of the main test suite
]]

local upperclass = require('..upperclass')
print(upperclass.version)
--==================================================================
local BaseClass = upperclass:define("BaseClass")

private.baseClassProperty = "testing"

function public:setValue()
    print(self.baseClassProperty)
    self.baseClassProperty = "edited"
    print(self.baseClassProperty)
end

BaseClass = upperclass:compile(BaseClass)
--==================================================================
upperclass:dumpClassMembers(BaseClass, 1)
BaseClass:setValue()
