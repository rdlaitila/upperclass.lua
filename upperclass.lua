--[[
The MIT License (MIT)

Copyright (c) 2014 Regan Daniel Laitila

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local upperclass = {}

-- Our version: Major.Minor.Patch
upperclass.version = "0.1.0"

--
-- Define some static scope properties for use internally
--
local UPPERCLASS_SCOPE_PRIVATE = {}
local UPPERCLASS_SCOPE_PROTECTED = {}
local UPPERCLASS_SCOPE_PUBLIC = {}
local UPPERCLASS_SCOPE_NOBODY = {}

--
-- Define some member type properties for use internally
--
local UPPERCLASS_MEMBER_TYPE_PROPERTY = {}
local UPPERCLASS_MEMBER_TYPE_FUNCTION = {}

-- 
-- Define some types
--
local UPPERCLASS_TYPE_ANY = {}
local UPPERCLASS_TYPE_STRING = {}
local UPPERCLASS_TYPE_TABLE = {}
local UPPERCLASS_TYPE_FUNCTION = {}
local UPPERCLASS_TYPE_NUMBER = {}
local UPPERCLASS_TYPE_USERDATA = {}
local UPPERCLASS_TYPE_NIL = {}
local UPPERCLASS_TYPE_boolean = {}

--
-- Dumps class members
--
function upperclass:dumpClassMembers(CLASS, SORT_COLUMN)
    -- Some spacing
    print(" ")
    print("-= MEMBER DUMP START =- ")
    
    -- Sets which colum of output to sort
    if SORT_COLUMN == nil then SORT_COLUMN = 1 end
    
    -- Function to generate a string of specified length
    local genstring = function(LEN)
        local str = ""
        for a=1, LEN do
            str = str .. " "
        end
        return str
    end
    
    -- Holds our table of class members
    local dumpTable = {}
    
    -- Walk the class and its parents obtaining members
    local targetClass = CLASS
    while targetClass ~= nil do
        for key, value in pairs(targetClass.__imp__.members) do
            table.insert(dumpTable, {
                tostring(key),
                targetClass.__imp__.members[key].member_scope_get,
                targetClass.__imp__.members[key].member_scope_set,
                targetClass.__imp__.members[key].member_type,
                targetClass.__imp__.members[key].value_type,
                tostring(targetClass.__imp__.members[key].value_default),
                tostring(targetClass.__inst__.memberValueOverrides[key]),
                tostring(targetClass.__imp__.name),
            })
        end
        
        if targetClass.__parent__ ~= nil then
            targetClass = targetClass.__parent__
        else
            targetClass = nil
        end
    end
    
    -- Replace values in dumptable with friendly names
    for a=1, #dumpTable do
        for b=1, #dumpTable[a] do
            if dumpTable[a][b] == UPPERCLASS_MEMBER_TYPE_FUNCTION then
                dumpTable[a][b] = "method"
            elseif dumpTable[a][b] == UPPERCLASS_MEMBER_TYPE_PROPERTY then
                dumpTable[a][b] = "property"
            elseif dumpTable[a][b] == UPPERCLASS_SCOPE_PUBLIC then
                dumpTable[a][b] = "public"
            elseif dumpTable[a][b] == UPPERCLASS_SCOPE_PRIVATE then
                dumpTable[a][b] = "private"
            elseif dumpTable[a][b] == UPPERCLASS_SCOPE_PROTECTED then
                dumpTable[a][b] = "protected"
            elseif dumpTable[a][b] == UPPERCLASS_SCOPE_NOBODY then
                dumpTable[a][b] = "nobody"
            elseif dumpTable[a][b] == UPPERCLASS_TYPE_STRING then
                dumpTable[a][b] = "string"
            elseif dumpTable[a][b] == UPPERCLASS_TYPE_NUMBER then
                dumpTable[a][b] = "number"
            elseif dumpTable[a][b] == UPPERCLASS_TYPE_TABLE then
                dumpTable[a][b] = "table"
            elseif dumpTable[a][b] == UPPERCLASS_TYPE_BOOLEAN then
                dumpTable[a][b] = "boolean"
            elseif dumpTable[a][b] == UPPERCLASS_TYPE_FUNCTION then
                dumpTable[a][b] = "function"
            elseif dumpTable[a][b] == UPPERCLASS_TYPE_NIL then
                dumpTable[a][b] = "nil"
            elseif dumpTable[a][b] == UPPERCLASS_TYPE_ANY then
                dumpTable[a][b] = "any"            
            end
        end        
    end
    
    -- Determine the longest key for each column    
    local dumpTableColumnSpacing = {0, 0, 0, 0, 0, 0, 0, 0}
    
    -- Our header row
    local header = {"MEMBER_NAME", "MEMBER_SCOPE_GET", "MEMBER_SCOPE_SET", "MEMBER_TYPE", "MEMBER_VALUE_TYPE", "MEMBER_VALUE_DEFAULT", "MEMBER_VALUE_CURRENT", "MEMBER_CLASS_IMPL"}    
    for a=1, #header do
        if header[a]:len() > dumpTableColumnSpacing[a] then
            dumpTableColumnSpacing[a] = header[a]:len()
        end
    end
    
    -- Set the longest key value per column
    for a=1, #dumpTable do       
        for b=1, #dumpTable[a] do            
            if tostring(dumpTable[a][b]):len() > dumpTableColumnSpacing[b] then
                dumpTableColumnSpacing[b] = tostring(dumpTable[a][b]):len() or 0
            end
        end
    end
    
    -- Update the dumpTable values with appropriate spacing
    local dumpTableSpaced = {}
    for a=1, #dumpTable do
        for b=1, #dumpTable[a] do            
            dumpTable[a][b] = tostring(dumpTable[a][b]) .. genstring(dumpTableColumnSpacing[b] + 2 - tostring(dumpTable[a][b]):len())             
        end
    end
    
    -- Update the header values with appropriate spacing
    for a=1, #header do
        header[a] = header[a] .. genstring(dumpTableColumnSpacing[a] + 2 - header[a]:len())
    end
    print(unpack(header))
    
    -- Sort our table
    table.sort(dumpTable, function(A, B)
        return A[SORT_COLUMN] < B[SORT_COLUMN]            
    end)

    -- Print our dump table
    for a=1, #dumpTable do        
       print(unpack(dumpTable[a]))
    end
    
    -- Print additional spacing
    print("-= MEMBER DUMP END =- ")  
    print(" ")
end

--
-- Returns the specified class member, searching through all parents
--
function upperclass:getClassMember(CLASS, KEY)
    local targetClass = CLASS
    
    while targetMember == nil do            
        if targetClass.__imp__.members[KEY] ~= nil then
            return targetClass.__imp__.members[KEY]            
        elseif targetClass.__parent__ ~= nil then
            targetClass = targetClass.__parent__
        elseif targetClass.__parent__ == nil then
            break
        end            
    end
    
    return nil
end

--
-- Returns all class members, searching through all parents
--
function upperclass:getClassMembers(CLASS)
    local targetClass = CLASS
    local members = {}
    
    while targetClass ~= nil do
        for key, value in pairs(targetClass.__imp__.members) do
            table.insert(members, targetClass.__imp__.members[key])
        end
        
        if targetClass.__parent__ ~= nil then
            targetClass = targetClass.__parent__
        else
            targetClass = nil
        end
    end

    return members
end

--
-- Upperclass Define function.
--
function upperclass:define(CLASS_NAME, PARENT)
    local classdef = {}
    local classmt = {}
    
    -- Gracefully take over globals: public, private, protected, property
    -- we will set them back to orig values after definition
    classdef.public_orig_value     = rawget(_G, "public")    
    classdef.private_orig_value    = rawget(_G, "private")
    classdef.protected_orig_value  = rawget(_G, "protected")
    classdef.property_orig_value   = rawget(_G, "property")
    
    -- Create table to hold our class implimentation
    classdef.__imp__ = {}
  
    -- Store the class name
    classdef.__imp__.name = tostring(CLASS_NAME)
  
    -- Store the class file
    if debug ~= nil then
        classdef.__imp__.file = debug.getinfo(2, "S").source:sub(2)
    else
        classdef.__imp__.file = il
    end
    
    -- Create table to hold our class memebers. table KEY is member name
    classdef.__imp__.members = {}
  
    -- Create tables to hold instance values
    classdef.__inst__ = {        
        isClassInstance = false,
        memberValueOverrides = {}
    }        
  
    -- Create table to hold reference to our parent class, if specified
    classdef.__parent__ = PARENT or nil
  
    -- Create table to hold references to our child classes, if this class is inherited
    classdef.__children__ = {}
  
    -- During the definition stage, the user may place property and method definitions in the following tables
    rawset(_G, "public",    {})
    rawset(_G, "private",   {})
    rawset(_G, "protected", {})
    rawset(_G, "property",  {})
    
    --
    -- Classdef Metatable __index
    --
    function classmt.__index(TABLE, KEY)        
        -- Check what kind of index we are retreiving. If requesting table is 'property'
        -- we must create a skeleton member entry with the requested key for later use 
        -- in the __call metamethod.
        if TABLE == property then
            -- Get our implimentation table
            local imp = rawget(classdef, "__imp__")
            
            -- Get our implimentation members table
            local members = rawget(imp, "members")
            
            -- Ensure we are not redefining an existing member
            if members[KEY] ~= nil then
                error("Attempt to redefine existing member '"..KEY.."' in class '"..imp.name.."' is disallowed")
            end
            
            -- Setup our member property table with defaults that will be later thrown away
            -- in the __call metamethod
            members[KEY] = {
                member_scope_get    = UPPERCLASS_SCOPE_NOBODY,                
                member_scope_set    = UPPERCLASS_SCOPE_NOBODY, 
                member_type         = UPPERCLASS_MEMBER_TYPE_PROPERTY,
                value_type          = UPPERCLASS_TYPE_NIL,
                value_default       = nil,                
            }    
            
            -- Set the last property name being defined for use in the __call metamethod
            classmt.last_property_name = KEY
            
            return property
        else
            return rawget(TABLE, KEY)
        end
    end
    
    --
    -- Classdef Metatable __newindex
    --
    function classmt.__newindex(TABLE, KEY, VALUE)
        -- Get our implimentation table
        local imp = rawget(classdef, "__imp__")
        
        -- Get our implimentation members table
        local members = rawget(imp, "members")
        
        -- Ensure we are not redefining an existing member
        if members[KEY] ~= nil then
            error("Attempt to redefine existing member '"..KEY.."' in class '"..imp.name.."' is disallowed")                
        end
                
        -- Create our members based on type and scope
        members[KEY] = {
            member_scope_get = UPPERCLASS_SCOPE_NOBODY,                
            member_scope_set = UPPERCLASS_SCOPE_NOBODY, 
            member_type = (function()
                if type(VALUE) == "function" then 
                    return UPPERCLASS_MEMBER_TYPE_FUNCTION
                else 
                    return UPPERCLASS_MEMBER_TYPE_PROPERTY 
                end
            end)(),
            value_type = (function() 
                if type(VALUE) == "string" then 
                    return UPPERCLASS_TYPE_STRING 
                elseif type(VALUE) == "table" then 
                    return UPPERCLASS_TYPE_TABLE
                elseif type(VALUE) == "function" then 
                    return UPPERCLASS_TYPE_FUNCTION
                elseif type(VALUE) == "number" then 
                    return UPPERCLASS_TYPE_NUMBER
                elseif type(VALUE) == "userdata" then 
                    return UPPERCLASS_TYPE_USERDATA
                elseif type(VALUE) == "boolean" then 
                    return UPPERCLASS_TYPE_BOOLEAN 
                elseif VALUE == nil then 
                    return UPPERCLASS_TYPE_ANY 
                end
            end)(),
            value_default = VALUE                      
        }    
        if TABLE == rawget(_G, "public") then
            members[KEY].member_scope_get = UPPERCLASS_SCOPE_PUBLIC
            members[KEY].member_scope_set = UPPERCLASS_SCOPE_PUBLIC                 
        elseif TABLE == rawget(_G, "private") then
            members[KEY].member_scope_get = UPPERCLASS_SCOPE_PRIVATE
            members[KEY].member_scope_set = UPPERCLASS_SCOPE_PRIVATE   
        elseif TABLE == rawget(_G, "protected") then
            members[KEY].member_scope_get = UPPERCLASS_SCOPE_PROTECTED
            members[KEY].member_scope_set = UPPERCLASS_SCOPE_PROTECTED           
        end
        
        -- If we are defining a function, set setter scope to nobody as you cannot redefine functions at runtime
        if type(VALUE) == "function" then
            members[KEY].member_scope_set = UPPERCLASS_SCOPE_NOBODY
        end
    end
   
    --
    -- Classdef Metamethod __call
    --
    function classmt.__call(...)
        local tables = {...}
        
        -- Get our implimentation table
        local imp = rawget(classdef, "__imp__")
        
        -- Get our implimentation members table
        local members = rawget(imp, "members")
        
        -- Get our property definition values
        local propertyTable = tables[3]
        local propertyGetterValue = propertyTable.get
        local propertySetterValue = propertyTable.set
        local propertyTypeValue = propertyTable.type
        local propertyDefaultValue = propertyTable[1]
        
        -- If property table length is 0, then set member values to defaults
        local proptablelen = 0
        for key, value in pairs(propertyTable) do proptablelen = proptablelen +1 end
        if proptablelen == 0 then
            members[classmt.last_property_name].member_scope_get = UPPERCLASS_SCOPE_PUBLIC
            members[classmt.last_property_name].member_scope_set = UPPERCLASS_SCOPE_PUBLIC
            members[classmt.last_property_name].value_type = UPPERCLASS_TYPE_ANY
            members[classmt.last_property_name].value_default = nil            
        else
            -- Determine value type & value
            if propertyTypeValue == 'any' then
                members[classmt.last_property_name].value_type = UPPERCLASS_TYPE_ANY
                members[classmt.last_property_name].value_default = propertyDefaultValue
            elseif propertyTypeValue == nil and propertyDefaultValue ~= nil then
                if type(propertyDefaultValue) == "string" then 
                    members[classmt.last_property_name].value_type =  UPPERCLASS_TYPE_STRING 
                elseif type(propertyDefaultValue) == "table" then 
                    members[classmt.last_property_name].value_type = UPPERCLASS_TYPE_TABLE                    
                elseif type(propertyDefaultValue) == "number" then 
                    members[classmt.last_property_name].value_type = UPPERCLASS_TYPE_NUMBER
                elseif type(propertyDefaultValue) == "userdata" then 
                    members[classmt.last_property_name].value_type = UPPERCLASS_TYPE_USERDATA
                elseif type(propertyDefaultValue) == "boolean" then 
                    members[classmt.last_property_name].value_type = UPPERCLASS_TYPE_BOOLEAN
                elseif type(propertyDefaultValue) == nil then 
                    members[classmt.last_property_name].value_type = UPPERCLASS_TYPE_ANY 
                end                
                members[classmt.last_property_name].value_default = propertyDefaultValue
            elseif propertyTypeValue ~= nil and propertyDefaultValue == nil then
                if propertyTypeValue == 'string' then
                    members[classmt.last_property_name].value_type = UPPERCLASS_TYPE_STRING
                elseif propertyTypeValue == 'table' then
                    members[classmt.last_property_name].value_type = UPPERCLASS_TYPE_TABLE
                elseif propertyTypeValue == 'number' then
                    members[classmt.last_property_name].value_type = UPPERCLASS_TYPE_NUMBER
                elseif propertyTypeValue == 'userdata' then
                    members[classmt.last_property_name].value_type = UPPERCLASS_TYPE_USERDATA
                elseif propertyTypeValue == 'boolean' then
                    members[classmt.last_property_name].value_type = UPPERCLASS_TYPE_BOOLEAN
                end
                members[classmt.last_property_name].value_default = nil
            elseif propertyTypeValue ~= nil and propertyDefaultValue ~= nil and propertyTypeValue == type(propertyDefaultValue) then
                if type(propertyDefaultValue) == "string" then 
                    members[classmt.last_property_name].value_type =  UPPERCLASS_TYPE_STRING 
                elseif type(propertyDefaultValue) == "table" then 
                    members[classmt.last_property_name].value_type = UPPERCLASS_TYPE_TABLE                    
                elseif type(propertyDefaultValue) == "number" then 
                    members[classmt.last_property_name].value_type = UPPERCLASS_TYPE_NUMBER
                elseif type(propertyDefaultValue) == "userdata" then 
                    members[classmt.last_property_name].value_type = UPPERCLASS_TYPE_USERDATA
                elseif type(propertyDefaultValue) == "boolean" then 
                    members[classmt.last_property_name].value_type = UPPERCLASS_TYPE_BOOLEAN
                elseif type(propertyDefaultValue) == nil then 
                    members[classmt.last_property_name].value_type = UPPERCLASS_TYPE_ANY 
                end                
                members[classmt.last_property_name].value_default = propertyDefaultValue
            elseif propertyTypeValue == nil and propertyDefaultValue == nil then
                members[classmt.last_property_name].value_type = UPPERCLASS_TYPE_ANY
                members[classmt.last_property_name].value_default = propertyDefaultValue
            elseif propertyTypeValue == 'function' or type(propertyDefaultValue) == 'function' then
                error("Attempt to define class member property of type 'function' is disallowed. Please define a class member function instead.")
            else
                error("Attempt to define class member property '"..classmt.last_property_name.."' as type '"..tostring(propertyTypeValue).."' when supplied value is of type '"..tostring(type(propertyDefaultValue)).."' is disallowed")              
            end            
            
            -- Determine getter scope
            if propertyGetterValue == 'public' then
                members[classmt.last_property_name].member_scope_get = UPPERCLASS_SCOPE_PUBLIC
            elseif propertyGetterValue == 'private' then
                members[classmt.last_property_name].member_scope_get = UPPERCLASS_SCOPE_PRIVATE
            elseif propertyGetterValue == 'protected' then
                members[classmt.last_property_name].member_scope_get = UPPERCLASS_SCOPE_PROTECTED
            elseif propertyGetterValue == 'nobody' then
                members[classmt.last_property_name].member_scope_get = UPPERCLASS_SCOPE_NOBODY
            else
                members[classmt.last_property_name].member_scope_get = UPPERCLASS_SCOPE_PUBLIC
            end
            
            -- Determine setter scope
            if propertySetterValue == 'public' then
                members[classmt.last_property_name].member_scope_set = UPPERCLASS_SCOPE_PUBLIC
            elseif propertySetterValue == 'private' then
                members[classmt.last_property_name].member_scope_set = UPPERCLASS_SCOPE_PRIVATE
            elseif propertySetterValue == 'protected' then
                members[classmt.last_property_name].member_scope_set = UPPERCLASS_SCOPE_PROTECTED
            elseif propertySetterValue == 'nobody' then
                members[classmt.last_property_name].member_scope_set = UPPERCLASS_SCOPE_NOBODY
            else
                members[classmt.last_property_name].member_scope_set = UPPERCLASS_SCOPE_PUBLIC
            end
        end
    end
  
  
    -- Set our metatables. 
    setmetatable(classdef,  classmt)
    setmetatable(public,    classmt)
    setmetatable(private,   classmt)
    setmetatable(protected, classmt)    
    setmetatable(property,  classmt)
  
    return classdef
end

--
-- Upperclass Compile Function
--
function upperclass:compile(CLASS)      
    -- Return our stolen globals to original state
    rawset(_G, "public",    CLASS.public_orig_value)
    rawset(_G, "private",   CLASS.private_orig_value)
    rawset(_G, "protected", CLASS.protected_orig_value)
    rawset(_G, "property",  CLASS.property_orig_value)
    
    setmetatable(CLASS, nil)    
    local classmt = {}    
    
    -- If __construct was not defined, define it now
    if CLASS.__imp__.members["__construct"] == nil then
        CLASS.__imp__.members["__construct"] = {
            member_scope_get = UPPERCLASS_SCOPE_PRIVATE,                    
            member_scope_set = UPPERCLASS_SCOPE_NOBODY,                    
            member_type = UPPERCLASS_MEMBER_TYPE_FUNCTION,
            value_type = UPPERCLASS_TYPE_FUNCTION,
            value_default = function() end,            
        }
    end
    
    -- Define __constructparent() method
    CLASS.__imp__.members["__constructparent"] = {
        member_scope_get = UPPERCLASS_SCOPE_PRIVATE,
        member_scope_set = UPPERCLASS_SCOPE_NOBODY,
        member_type = UPPERCLASS_MEMBER_TYPE_FUNCTION,
        value_type = UPPERCLASS_TYPE_FUNCTION,
        value_default = function(...)
            local constructArgs = {...}
            if self.__parent__.__inst__.isClassInstance == false then
                self.__parent__ = self.__parent__(unpack(constructArgs))
            end
        end,
    }
    
    --
    -- Classdef Metamethod __call
    -- This metamethod 
    --
    function classmt.__call(...)        
        -- Pack args
        local arguments = {...}
        
        -- Get table argument, a.k.a 'self'
        local self = arguments[1]
        
        -- Get class implimentation
        local imp = rawget(self, "__imp__")
            
        -- Get caller function
        local caller = debug.getinfo(2).func
            
        -- Check to ensure that we are not calling from within the class itself
        for _, member in pairs(imp.members) do
            if member.value == caller then
                error("Attempt to call class instantiation from within class '"..imp.name.."' is disallowed")
            end
        end
        
        -- Define instance table to return
        local instance = {}
            
        -- Setup reference to class implimentation
        instance.__imp__ = imp
            
        -- Setup table to hold instance implimentation
        instance.__inst__ = {
            isClassInstance = true,
            memberValueOverrides = {}
        }
        
        -- Set parent reference
        instance.__parent__ = self.__parent__
        
        setmetatable(instance, getmetatable(self))
            
        -- Call class constructor
        local passargs = {}
        if #arguments > 1 then for a=2, #arguments do table.insert(passargs, arguments[a]) end end
        local __construct = imp.members["__construct"].value
        __construct(instance, unpack(passargs))
        
        -- Construct parent
        if instance.__parent__ ~= nil and instance.__parent__.__inst__.isClassInstance == false then                         
            instance.__parent__ = self.__parent__()
        end
        
        return instance   
    end
    
    --
    -- Classdef Metamethod __index
    -- This method conducts a member lookup of the target class, or any of its inherited
    -- parent classes.
    --
    function classmt.__index(TABLE, KEY)  
        --print("Entering Class Internal __index Method. Table: '"..tostring(TABLE).."' KEY: '"..tostring(KEY).."'")
        
        -- Ensure we return some important keys.
        if KEY == "__imp__" or KEY == "__inst__" or KEY == "__parent__" then
            return rawget(TABLE, KEY)
        end
        
        -- Get caller function for use in private and protected lookups only if the debug library is present        
        local caller = nil
        if debug ~= nil then
            caller = debug.getinfo(2, 'f').func            
        end
        
        -- Attempt to locate a target member
        local targetMember = upperclass:getClassMember(TABLE, KEY)        
        local indexMetamethodMember = upperclass:getClassMember(TABLE, '__index')
        
        -- IF targetMember is nil AND we have a class __index method, call the __index method with nil member_lookup
        -- ELSE return member lookup failure        
        if targetMember == nil and indexMetamethodMember ~= nil then            
            indexMetamethodMember.value_default(TABLE, tostring(KEY), targetMember)
        elseif targetMember == nil and indexMetamethodMember == nil then
            error("Attempt to obtain non-existant class member '"..tostring(KEY).."' in class '"..tostring(TABLE.__imp__.name).."' is disallowed")
        end
        
        --[[
            ANY LOGIC PAST THIS POINT ASSUMES A VALID MEMBER LOOKUP
        --]]
        
        -- If debug library is missing, then all members are considered PUBLIC so we will just return the member value or call __index if present
        if debug == nil and indexMetamethodMember ~= nil then
            return indexMetamethodMember.value_default(TABLE, tostring(KEY), {
                member_scope_get = targetMember.member_scope_get,
                member_scope_set = targetMember.member_scope_set,
                member_type = targetMember.member_type,
                value_type = targetMember.value_type,
                value_default = targetMember.value_default,
                value_current = TABLE.__inst__.memberValueOverrides[KEY]
            })
        elseif debug == nil and indexMetamethodMember == nil then
            return TABLE.__inst__.memberValueOverrides[KEY] or targetMember.value_default
        end
        
        -- If debug library is present, return members based on scope
        if targetMember.member_scope_get == UPPERCLASS_SCOPE_PUBLIC then
            if indexMetamethodMember ~= nil then
                return indexMetamethodMember.value_default(TABLE, tostring(KEY), {
                    member_scope_get = targetMember.member_scope_get,
                    member_scope_set = targetMember.member_scope_set,
                    member_type = targetMember.member_type,
                    value_type = targetMember.value_type,
                    value_default = targetMember.value_default,
                    value_current = TABLE.__inst__.memberValueOverrides[KEY]
                })
            elseif indexMetamethodMember == nil then
                return TABLE.__inst__.memberValueOverrides[KEY] or targetMember.value_default                
            end
        elseif targetMember.member_scope_get == UPPERCLASS_SCOPE_PRIVATE then
            for key, value in pairs(TABLE.__imp__.members) do
                if targetMember == TABLE.__imp__.members[key] then
                    if caller == TABLE.__imp__.members[key].value_default then
                        if indexMetamethodMember ~= nil then
                            return indexMetamethodMember.value_default(TABLE, tostring(KEY), {
                                member_scope_get = targetMember.member_scope_get,
                                member_scope_set = targetMember.member_scope_set,
                                member_type = targetMember.member_type,
                                value_type = targetMember.value_type,
                                value_default = targetMember.value_default,
                                value_current = TABLE.__inst__.memberValueOverrides[KEY]
                            })
                        elseif indexMetamethodMember == nil then
                            return TABLE.__inst__.memberValueOverrides[KEY] or targetMember.value_default
                        end
                    end
                end
            end
            
            error("Attempt to retrieve inheritied private member '"..tostring(KEY).."' from class '"..TABLE.__imp__.name.."' is disallowed")
        elseif targetMember.member_scope_get == UPPERCLASS_SCOPE_PROTECTED then
            local members = upperclass:getClassMembers(TABLE)
            for a=1, #members do                
                if caller == members[a].value_default then                    
                    if indexMetamethodMember ~= nil then
                        return indexMetamethodMember.value_default(TABLE, tostring(KEY), {
                            member_scope_get = targetMember.member_scope_get,
                            member_scope_set = targetMember.member_scope_set,
                            member_type = targetMember.member_type,
                            value_type = targetMember.value_type,
                            value_default = targetMember.value_default,
                            value_current = TABLE.__inst__.memberValueOverrides[KEY]
                        })
                    elseif indexMetamethodMember == nil then
                        return TABLE.__inst__.memberValueOverrides[KEY] or targetMember.value_default
                    end
                end
            end
            
            error("Attempt to retrieve protected member '"..tostring(KEY).."' from outside of class '"..TABLE.__imp__.name.."' is disallowed")
        end
    end
    
    --
    -- Classdef Metamethod __newindex
    --
    function classmt.__newindex(TABLE, KEY, VALUE)
        --print("Entering Class Internal __index Method. Table: '"..tostring(TABLE).."' KEY: '"..tostring(KEY).."'")
        
        -- Ensure we return some important keys.
        if KEY == "__imp__" or KEY == "__inst__" or KEY == "__parent__" then
            return rawget(TABLE, KEY)
        end
        
        -- Get caller function for use in private and protected lookups only if the debug library is present        
        local caller = nil
        if debug ~= nil then
            caller = debug.getinfo(2, 'f').func            
        end
        
        -- Attempt to locate a target member
        local targetMember = upperclass:getClassMember(TABLE, KEY)        
        local newindexMetamethodMember = upperclass:getClassMember(TABLE, '__newindex')
        
        -- IF targetMember is nil AND we have a class __index method, call the __index method with nil member_lookup
        -- ELSE return member lookup failure        
        if targetMember == nil and newindexMetamethodMember ~= nil then            
            newindexMetamethodMember.value_default(TABLE, tostring(KEY), VALUE, targetMember)
        elseif targetMember == nil and indexMetamethodMember == nil then
            error("Attempt to set non-existant class member '"..tostring(KEY).."' in class '"..tostring(TABLE.__imp__.name).."' is disallowed")
        end
        
        --[[
            ANY LOGIC PAST THIS POINT ASSUMES A VALID MEMBER LOOKUP
        --]]
        
        -- If debug library is missing, then all members are considered PUBLIC so we will just return the member value or call __index if present
        if debug == nil and indexMetamethodMember ~= nil then
            return newindexMetamethodMember.value_default(TABLE, tostring(KEY), VALUE, {
                member_scope_get = targetMember.member_scope_get,
                member_scope_set = targetMember.member_scope_set,
                member_type = targetMember.member_type,
                value_type = targetMember.value_type,
                value_default = targetMember.value_default,
                value_current = TABLE.__inst__.memberValueOverrides[KEY]
            })
        elseif debug == nil and newindexMetamethodMember == nil then
            if targetMember.member_type == UPPERCLASS_MEMBER_TYPE_PROPERTY then
                TABLE.__inst__.memberValueOverrides[KEY] = VALUE
                return
            else
                error("Attempt to set class member method '"..tostring(KEY).."' in class '"..TABLE.__imp__.name.."' during runtime is disallowed")
            end
        end
        
        -- If debug library is present, return members based on scope
        if targetMember.member_scope_get == UPPERCLASS_SCOPE_PUBLIC then
            if newindexMetamethodMember ~= nil then
                return newindexMetamethodMember.value_default(TABLE, tostring(KEY), VALUE, {
                    member_scope_get = targetMember.member_scope_get,
                    member_scope_set = targetMember.member_scope_set,
                    member_type = targetMember.member_type,
                    value_type = targetMember.value_type,
                    value_default = targetMember.value_default,
                    value_current = TABLE.__inst__.memberValueOverrides[KEY]
                })
            elseif newindexMetamethodMember == nil then
                if targetMember.member_type == UPPERCLASS_MEMBER_TYPE_PROPERTY then
                    TABLE.__inst__.memberValueOverrides[KEY] = VALUE
                    return
                else
                    error("Attempt to set class member method '"..tostring(KEY).."' in class '"..TABLE.__imp__.name.."' during runtime is disallowed")
                end
            end
        elseif targetMember.member_scope_get == UPPERCLASS_SCOPE_PRIVATE then
            for key, value in pairs(TABLE.__imp__.members) do
                if targetMember == TABLE.__imp__.members[key] then
                    if caller == TABLE.__imp__.members[key].value_default then
                        if newindexMetamethodMember ~= nil then
                            return newindexMetamethodMember.value_default(TABLE, tostring(KEY), VALUE, {
                                member_scope_get = targetMember.member_scope_get,
                                member_scope_set = targetMember.member_scope_set,
                                member_type = targetMember.member_type,
                                value_type = targetMember.value_type,
                                value_default = targetMember.value_default,
                                value_current = TABLE.__inst__.memberValueOverrides[KEY]
                            })
                        elseif newindexMetamethodMember == nil then
                            if targetMember.member_type == UPPERCLASS_MEMBER_TYPE_PROPERTY then
                                TABLE.__inst__.memberValueOverrides[KEY] = VALUE
                                return
                            else
                                error("Attempt to set class member method '"..tostring(KEY).."' in class '"..TABLE.__imp__.name.."' during runtime is disallowed")
                            end
                        end
                    end
                end
            end
            
            error("Attempt to set inheritied private member '"..tostring(KEY).."' from class '"..TABLE.__imp__.name.."' is disallowed")
        elseif targetMember.member_scope_get == UPPERCLASS_SCOPE_PROTECTED then
            local members = upperclass:getClassMembers(TABLE)
            for a=1, #members do                
                if caller == members[a].value_default then                    
                    if newindexMetamethodMember ~= nil then
                        return newindexMetamethodMember.value_default(TABLE, tostring(KEY), VALUE, {
                            member_scope_get = targetMember.member_scope_get,
                            member_scope_set = targetMember.member_scope_set,
                            member_type = targetMember.member_type,
                            value_type = targetMember.value_type,
                            value_default = targetMembealue_default,
                            value_current = TABLE.__inst__.memberValueOverrides[KEY]
                        })
                    elseif newindexMetamethodMember == nil then
                        if targetMember.member_type == UPPERCLASS_MEMBER_TYPE_PROPERTY then
                            TABLE.__inst__.memberValueOverrides[KEY] = VALUE
                            return
                        else
                            error("Attempt to set class member method '"..tostring(KEY).."' in class '"..TABLE.__imp__.name.."' during runtime is disallowed")
                        end
                    end
                end
            end
            
            error("Attempt to set protected member '"..tostring(KEY).."' from outside of class '"..TABLE.__imp__.name.."' is disallowed")
        end
    end
    
    setmetatable(CLASS, classmt)
    
    return CLASS
end

return upperclass