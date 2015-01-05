--[[
This file is just for quick testing of things and is not apart of the main test suite
]]

local upperclass = require('..upperclass')
print(upperclass.version)
--==================================================================
local BaseClass = upperclass:define("BaseClass")

public.baseClassProperty = "testing"

function private:__newindex(KEY, VALUE, MEMBER)
    print(tostring(KEY), tostring(VALUE), tostring(MEMBER))
end

BaseClass = upperclass:compile(BaseClass)
--==================================================================
local SubClass = upperclass:define("SubClass", BaseClass)

property : subClassProperty {
    {};
    get='public';
    set='public';
    type='table';
}

SubClass = upperclass:compile(SubClass)
--==================================================================
upperclass:dumpClassMembers(SubClass, 1)
SubClass.baseClassProperty = "whatever"
