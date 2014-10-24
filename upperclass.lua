local upperclass = {}

--
-- Define some static scope properties for use internally
--
local SCOPE_PRIVATE = 1
local SCOPE_PROTECTED = 2
local SCOPE_PUBLIC = 3

--
-- Define some member type properties for use internally
--
local MEMBER_TYPE_PROPERTY = 1
local MEMBER_TYPE_FUNCTION = 2

--
-- Upperclass Define function.
--
function upperclass:define(CLASS_NAME)
    local classdef = {}
    local classmt = {}
    
    -- Create table to hold our class implimentation
    classdef.__imp__ = {}
  
    -- Store the class name
    classdef.__imp__.name = tostring(CLASS_NAME)
  
    -- Store the class file 
    classdef.__imp__.file = debug.getinfo(2, "S").source:sub(2) 
    
    -- Create table to hold our class memebers. table KEY is member name
    -- Schema: {scope=[PUBLIC|PRIVATE|PROTECTED], type=[PROPERTY|FUNCTION], value=[DATA_OR_REFERENCE]}
    classdef.__imp__.members = {}
  
    -- Create tables to hold singlton instance values (a.k.a static class)
    classdef.__inst__ = {}
    classdef.__inst__.member_values = {}
  
    -- During the definition stage, the user may place property and method definitions in the following tables
    classdef.public = {}
    classdef.private = {}
    classdef.protected = {}
    
    -- Set a reference to classdef in classmt
    classmt.classdef = classdef
    
    --
    -- Classdef Metatable __newindex
    --
    function classmt.__newindex(TABLE, KEY, VALUE)
        -- Get our class definition
        local classdef = getmetatable(TABLE).classdef
        
        -- Get our implimentation table
        local imp = rawget(classdef, "__imp__")
        
        -- Get our implimentation members table
        local members = rawget(imp, "members")
        
        -- Ensure we are not redefining an existing member
        if members[KEY] ~= nil then
            error("Attempt to redefine existing member '"..KEY.."' is disallowed")
        end
        
        -- Create our members based on type and scope
        if type(VALUE) == "string" or type(VALUE) == "number" or 
           type(VALUE) == "boolean" or type(VALUE) == "table" then            
            if TABLE == rawget(classdef, "public") then
                members[KEY] = {
                    scope = SCOPE_PUBLIC,                    
                    value = VALUE,
                    type = MEMBER_TYPE_PROPERTY
                }                
            elseif TABLE == rawget(classdef, "private") then
                members[KEY] = {
                    scope = SCOPE_PRIVATE,                    
                    value = VALUE,
                    type = MEMBER_TYPE_PROPERTY
                }
            elseif TABLE == rawget(classdef, "protected") then
                members[KEY] = {
                    scope = SCOPE_PROTECTED,                    
                    value = VALUE,
                    type = MEMBER_TYPE_PROPERTY
                }                
            end            
        elseif type(VALUE) == "function" then            
            if TABLE == rawget(classdef, "public") then
                members[KEY] = {
                    scope = SCOPE_PUBLIC,                    
                    value = VALUE,
                    type = MEMBER_TYPE_FUNCTION
                }                
            elseif TABLE == rawget(classdef, "private") then
                members[KEY] = {
                    scope = SCOPE_PRIVATE,                    
                    value = VALUE,
                    type = MEMBER_TYPE_FUNCTION
                }
            elseif TABLE == rawget(classdef, "protected") then
                members[KEY] = {
                    scope = SCOPE_PROTECTED,                    
                    value = VALUE,
                    type = MEMBER_TYPE_FUNCTION
                }        
            end
        end
    end
  
    -- Set our metatables. 
    setmetatable(classdef, classmt)
    setmetatable(classdef.public, classmt)
    setmetatable(classdef.private, classmt)
    setmetatable(classdef.protected, classmt)    
  
    return classdef, rawget(classdef, "public"), rawget(classdef, "private"), rawget(classdef, "protected")
end

--
-- Upperclass Compile Function
--
function upperclass:compile(CLASS)    
    setmetatable(CLASS, nil)    
    local classmt = {}    
    
    -- No longer needed
    rawset(CLASS, "public",     nil)
    rawset(CLASS, "private",    nil)
    rawset(CLASS, "protected",   nil)
    
    --
    -- Classdef new
    --
    function CLASS.new(self, ...)
        local args = {...}
        local instance = {}
        
        -- Setup reference to class implimentation
        instance.__imp__ = self.__imp__
        
        -- Setup table to hold instance implimentation
        instance.__inst__ = {}
        
        -- Table to hold instance values
        instance.__inst__.member_values = {}
        
        setmetatable(instance, getmetatable(self))
        
        return instance
    end
    
    --
    -- Classdef Metamethod __index
    --
    function classmt.__index(TABLE, KEY)
        -- Return new if called
        if KEY == "new" then
            return rawget(TABLE, KEY)
        end
        
        -- Get caller function for use in private and protected lookups
        local caller = debug.getinfo(2)        
        
        -- Grab reference to class instance table
        local inst = rawget(TABLE, "__inst__")
        
        -- Grab reference to class implimentation table
        local imp = rawget(TABLE, "__imp__")            
        
        -- Grab reference to class implimentation members
        local members = rawget(imp, "members")
        
        -- Attempt to locate a valid member
        if members[KEY] == nil then
            error("Attempt to access non-existant member "..KEY.." within class "..imp.name)
        else
            if members[KEY].scope == SCOPE_PUBLIC then                  
                if inst.member_values[KEY] ~= nil then -- If we have a stored value, return it
                    return inst.member_values[KEY]
                else -- Return value of class implimentation
                    return members[KEY].value
                end
            elseif members[KEY].scope == SCOPE_PRIVATE then                
                local privatecallerfound = false
                for _, member in pairs(members) do
                    if member.type == MEMBER_TYPE_FUNCTION then
                        if member.value == caller.func then
                            privatecallerfound = true
                            break
                        end
                    end
                end
                    
                if privatecallerfound == true then
                    if inst.member_values[KEY] ~= nil then -- If we have a stored value, return it
                        return inst.member_values[KEY]
                    else -- Return value of class implimentation
                        return members[KEY].value
                    end
                else
                    error("Attempt to access private member '".. KEY .."' from outside of class '".. imp.name .."' is disallowed")
                end                
            elseif members[a].scope == SCOPE_PROTECTED then
                error("Attempt to access protected member is not implimented")
            end
        end        
    end
    
    --
    -- Classdef Metamethod __newindex
    --
    function classmt.__newindex(TABLE, KEY, VALUE)
        -- Get caller function for use in private and protected lookups
        local caller = debug.getinfo(2)
        
        -- Grab reference to class instance table
        local inst = rawget(TABLE, "__inst__")
        
        -- Grab reference to class implimentation table
        local imp = rawget(TABLE, "__imp__")            
        
        -- Grab reference to class implimentation members
        local members = rawget(imp, "members")
        
        -- Attempt to locate valid member and ensure we are not attempting set of a member function
        if members[KEY] == nil then
            error("Attempt to set value for non-existant member '"..KEY.."' is disallowed")
        elseif members[KEY].type == MEMBER_TYPE_FUNCTION  then
            error("Attempt to set value of member function '"..KEY.."' is disallowed")        
        end
        
        -- Ensure that the inboudn value type matches the implimentation type
        if type(VALUE) ~= type(members[KEY].value) then
            error("Attmept to overwrite member property of type "..type(members[KEY].value).." with a "..type(VALUE).." is disallowed")
        end
        
        -- Set our value
        if members[KEY].scope == SCOPE_PUBLIC then
            inst.member_values[KEY] = VALUE
        elseif members[KEY].scope == SCOPE_PRIVATE then
            local privatecallerfound = false
            for _, member in pairs(members) do
                if member.type == MEMBER_TYPE_FUNCTION then
                    if member.value == caller.func then
                        privatecallerfound = true
                        break
                    end
                end
            end
            
            if privatecallerfound == true then
                inst.member_values[KEY] = VALUE                        
            else
                error("Attempt to set private class property from outside of class is disallowed")
            end            
        elseif subject_member.scope == SCOPE_PROTECTED then
            error("Attempt to set member property of type protected is not implimented")
        end
    end
    
    setmetatable(CLASS, classmt)
    
    return CLASS
end

--
-- Upperclass Dump Members Function
--
function upperclass:dumpMembers(CLASS)
    if CLASS.__imp__ ~= nil then
        print("NAME", "TYPE", "SCOPE", "VALUE")
        for a=1, #CLASS.__imp__.members do
            local member = CLASS.__imp__.members[a]
            print(member.name, member.type, member.scope, member.value)
        end
    else
       error(ERRORS[1])
    end
end

return upperclass