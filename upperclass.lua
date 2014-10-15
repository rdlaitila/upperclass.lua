local upperclass = {}

local SCOPE_STATIC = 1
local SCOPE_PRIVATE = 2
local SCOPE_PROTECTED = 3
local SCOPE_PUBLIC = 4

function upperclass:define(CLASS_NAME)
    local classdef = {}
    local classmt = {}
    
    -- Create table to hold our class implimentation
    classdef.__imp__ = {}
  
    -- Store the class name
    classdef.__imp__.name = CLASS_NAME
  
    -- Store the class file 
    classdef.__imp__.file = debug.getinfo(2, "S").source:sub(2) 
    
    -- Create table to hold our class memebers
    -- Schema: {scope=[PUBLIC|PRIVATE|PROTECTED|STATIC], type=[PROPERTY|METHOD], name="[MEMBER_NAME]", value=[DATA_OR_REFERENCE]}
    classdef.__imp__.members = {}
  
    -- During the definition stage, the user may place property and method definitions in the following tables
    classdef.public = {}
    classdef.private = {}
    classdef.protected = {}
    classdef.static = {}
    
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
                    value = VALUE
                })
            elseif TABLE == rawget(classmt.classdef, "private") then
                table.insert(classmt.classdef.__imp__.members, {
                    scope = SCOPE_PRIVATE,
                    name = KEY,
                    value = VALUE
                })
            elseif TABLE == rawget(classmt.classdef, "protected") then
                table.insert(classmt.classdef.__imp__.members, {
                    scope = SCOPE_PROTECTED,
                    name = KEY,
                    value = VALUE
                })
            elseif TABLE == rawget(classmt.classdef, "static") then
                table.insert(classmt.classdef.__imp__.members, {
                    scope = SCOPE_STATIC,
                    name = KEY,
                    value = VALUE
                })
            end            
        elseif type(VALUE) == "function" then            
            if TABLE == rawget(classmt.classdef, "public") then
                table.insert(classmt.classdef.__imp__.members, {
                    scope = SCOPE_PUBLIC,
                    name = KEY,
                    value = VALUE
                })
            elseif TABLE == rawget(classmt.classdef, "private") then
                table.insert(classmt.classdef.__imp__.members, {
                    scope = SCOPE_PRIVATE,
                    name = KEY,
                    value = VALUE
                })
            elseif TABLE == rawget(classmt.classdef, "protected") then
                table.insert(classmt.classdef.__imp__.members, {
                    scope = SCOPE_PROTECTED,
                    name = KEY,
                    value = VALUE
                })
            elseif TABLE == rawget(classmt.classdef, "static") then
                table.insert(classmt.classdef.__imp__.members, {
                    scope = SCOPE_STATIC,
                    name = KEY,
                    value = VALUE
                })
            end
        end
    end
  
    -- Set our metatables. 
    setmetatable(classdef, classmt)
    setmetatable(classdef.public, classmt)
    setmetatable(classdef.private, classmt)
    setmetatable(classdef.protected, classmt)
    setmetatable(classdef.static, classmt)
  
    return classdef, rawget(classdef, "public"), rawget(classdef, "private"), rawget(classdef, "protected"), rawget(classdef, "static")
end

function upperclass:compile(CLASS)    
    setmetatable(CLASS, nil)    
    local classmt = {}    
    
    -- No longer needed
    rawset(CLASS, "public",     nil)
    rawset(CLASS, "private",    nil)
    rawset(CLASS, "protected",   nil)
    rawset(CLASS, "static",   nil)
    
    --
    -- Classdef new
    --
    function CLASS.new(self)
        local instance = {}
        
        -- Setup reference to class definition
        instance.__class__ = self
        
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
        local caller = debug.getinfo(2)
        if rawget(TABLE, "__class__") ~= nil then --Instance class
            print("INSTANCE CLASS MEMBER LOOKUP")
            local class = rawget(TABLE, "__class__")
            local inst = rawget(TABLE, "__inst__")
            local imp = rawget(class, "__imp__")            
            local members = rawget(imp, "members")
            for a=1, #members do
                if members[a].name == KEY then
                    if members[a].scope == SCOPE_STATIC then
                        error("Attempt to access static member: "..KEY.." within instanced class "..imp.name)
                    elseif members[a].scope == SCOPE_PUBLIC then
                        if inst.member_values[KEY] ~= nil then
                            return inst.member_values[KEY]
                        else
                            return members[a].value
                        end
                    end
                end
            end
            error("Attempt to access non-existant member "..KEY.." within instanced class "..imp.name)
        elseif rawget(TABLE, "__imp__") ~= nil then --Static class
            print("STATIC CLASS MEMBER LOOKUP")            
            local imp = rawget(TABLE, "__imp__")
            local members = rawget(imp, "members")
            for a=1, #members do
                if members[a].name == KEY then
                    if members[a].scope == SCOPE_STATIC then
                        return members[a].value
                    else
                        error("Attempt to access non-static member: "..KEY.." within static class "..imp.name)
                    end
                end
            end
            error("Attempt to access non-existant member "..KEY.." within static class "..imp.name)
        end          
        error("Attempt to access non-existant member: "..KEY)
    end
    
    --
    -- Classdef Metamethod __newindex
    --
    function classmt.__newindex(TABLE, KEY, VALUE)
        if rawget(TABLE, "__class__") ~= nil then --Instance
            -- CONDUCT INSTANCE LOOKUP
        elseif rawget(TABLE, "__imp__") ~= nil then --Class
            -- CONDUCT CLASS STATIC LOOKUP
        end        
    end
    
    setmetatable(CLASS, classmt)
    
    return CLASS
end

return upperclass