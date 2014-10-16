local upperclass = {}

--
-- Define some static scope properties for use internally
--
local SCOPE_PRIVATE = 1
local SCOPE_PROTECTED = 2
local SCOPE_PUBLIC = 3

--
-- Define some member tyep properties for use internally
--
local MEMBER_TYPE_PROPERTY = 1
local MEMBER_TYPE_FUNCTION = 2

--
-- Define error strings
--
local ERRORS = {}
ERRORS[1] = "Cannot dump class members. Supplied class does not contain __imp__ table"

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
    
    -- Create table to hold our class memebers
    -- Schema: {scope=[PUBLIC|PRIVATE|PROTECTED|STATIC], type=[PROPERTY|METHOD], name="[MEMBER_NAME]", value=[DATA_OR_REFERENCE]}
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
        if type(VALUE) == "string" or type(VALUE) == "number" or 
           type(VALUE) == "boolean" or type(VALUE) == "table" then
            
            if TABLE == rawget(classmt.classdef, "public") then
                table.insert(classmt.classdef.__imp__.members, {
                    scope = SCOPE_PUBLIC,
                    name = KEY,
                    value = VALUE,
                    type = MEMBER_TYPE_PROPERTY
                })
            elseif TABLE == rawget(classmt.classdef, "private") then
                table.insert(classmt.classdef.__imp__.members, {
                    scope = SCOPE_PRIVATE,
                    name = KEY,
                    value = VALUE,
                    type = MEMBER_TYPE_PROPERTY
                })
            elseif TABLE == rawget(classmt.classdef, "protected") then
                table.insert(classmt.classdef.__imp__.members, {
                    scope = SCOPE_PROTECTED,
                    name = KEY,
                    value = VALUE,
                    type = MEMBER_TYPE_PROPERTY
                })
            end            
        elseif type(VALUE) == "function" then            
            if TABLE == rawget(classmt.classdef, "public") then
                table.insert(classmt.classdef.__imp__.members, {
                    scope = SCOPE_PUBLIC,
                    name = KEY,
                    value = VALUE,
                    type = MEMBER_TYPE_FUNCTION
                })
            elseif TABLE == rawget(classmt.classdef, "private") then
                table.insert(classmt.classdef.__imp__.members, {
                    scope = SCOPE_PRIVATE,
                    name = KEY,
                    value = VALUE,
                    type = MEMBER_TYPE_FUNCTION
                })
            elseif TABLE == rawget(classmt.classdef, "protected") then
                table.insert(classmt.classdef.__imp__.members, {
                    scope = SCOPE_PROTECTED,
                    name = KEY,
                    value = VALUE,
                    type = MEMBER_TYPE_FUNCTION
                })            
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
    function CLASS.new(self)
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
        print("__INDEX: ", TABLE, KEY)
        
        -- Return new if called
        if KEY == "new" then
            return rawget(TABLE, KEY)
        end
        
        -- Get caller function for use in private and protected lookups
        local caller = debug.getinfo(2)
        print("CALLER:", caller.name, caller.func)
        
        -- Grab reference to class instance table
        local inst = rawget(TABLE, "__inst__")
        
        -- Grab reference to class implimentation table
        local imp = rawget(TABLE, "__imp__")            
        
        -- Grab reference to class implimentation members
        local members = rawget(imp, "members")
        
        -- Loop through class implimentation members, looking for 
        -- a valid match
        for a=1, #members do
            if members[a].name == KEY then
                if members[a].scope == SCOPE_PUBLIC then                  
                    if inst.member_values[KEY] ~= nil then -- If we have a stored value, return it
                        return inst.member_values[KEY]
                    else -- Return value of class implimentation
                        return members[a].value
                    end
                elseif members[a].scope == SCOPE_PRIVATE then                
                    local privatecallerfound = false
                    for b=1, #members do
                        if members[a].type == MEMBER_TYPE_FUNCTION then
                            if members[a].value == caller.func then                                
                            end
                        end
                    end
                    
                    if privatecallerfound == true then
                        if inst.member_values[KEY] ~= nil then -- If we have a stored value, return it
                            return inst.member_values[KEY]
                        else -- Return value of class implimentation
                            return members[a].value
                        end
                    else
                        error("Attempt to access private member from outside of class is disallowed")
                    end                
                elseif members[a].scope == SCOPE_PROTECTED then
                    error("Attempt to access protected member is not implimented")
                end
            end
        end
        
        -- We found no members in class implimentation. We should fail
        error("Attempt to access non-existant member "..KEY.." within class "..imp.name)
    end
    
    --
    -- Classdef Metamethod __newindex
    --
    function classmt.__newindex(TABLE, KEY, VALUE)
        --print("__NEWINDEX: ", TABLE, KEY, VALUE)
        
        -- Get caller function for use in private and protected lookups
        local caller = debug.getinfo(2)
        
        -- Grab reference to class instance table
        local inst = rawget(TABLE, "__inst__")
        
        -- Grab reference to class implimentation table
        local imp = rawget(TABLE, "__imp__")            
        
        -- Grab reference to class implimentation members
        local members = rawget(imp, "members")
        
        -- Loop through class implimentation members, looking for 
        -- a valid match
        local subject_member = nil
        for a=1, #members do            
            if members[a].name == KEY then                
                if members[a].type == MEMBER_TYPE_FUNCTION then
                    error("Attempt to override class member function at runtime is disallowed")
                elseif members[a].type == MEMBER_TYPE_PROPERTY then
                    subject_member = members[a]
                end
            end
        end
        
        -- Fail if we have no subject member
        if subject_member == nil then
            error("Attempt to set member property failed. Unable to locate member property")
        end
        
        -- Ensure that the inboudn value type matches the implimentation type
        if type(VALUE) ~= type(subject_member.value) then
            error("Attmept to overwrite member property of type "..type(subject_member.value).." with a "..type(VALUE).." is disallowed")
        end
        
        -- Set our value
        if subject_member.scope == SCOPE_PUBLIC then
            inst.member_values[KEY] = VALUE
        elseif subject_member.scope == SCOPE_PRIVATE then
            local privatecallerfound = false
            for b=1, #members do
                if members[a].type == MEMBER_TYPE_FUNCTION then
                    if members[a].value == caller.func then
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