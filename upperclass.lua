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
UPPERCLASS_SCOPE_PRIVATE = {}
UPPERCLASS_SCOPE_PROTECTED = {}
UPPERCLASS_SCOPE_PUBLIC = {}
UPPERCLASS_SCOPE_NOBODY = {}

--
-- Define some member type properties for use internally
--
UPPERCLASS_MEMBER_TYPE_PROPERTY = {}
UPPERCLASS_MEMBER_TYPE_FUNCTION = {}

-- 
-- Define some types
--
UPPERCLASS_TYPE_ANY         = {string='any'}
UPPERCLASS_TYPE_STRING      = {string='string'}
UPPERCLASS_TYPE_TABLE       = {string='table'}
UPPERCLASS_TYPE_FUNCTION    = {string='function'}
UPPERCLASS_TYPE_NUMBER      = {string='number'}
UPPERCLASS_TYPE_USERDATA    = {string='userdata'}
UPPERCLASS_TYPE_NIL         = {string='nil'}
UPPERCLASS_TYPE_BOOLEAN     = {string='boolean'}

--
-- Global to indicate during metamethod calls that we wish to continue with default lookup behaviors
--
UPPERCLASS_DEFAULT_BEHAVIOR = {}

--
-- Holds the metatable used during the class definition stage
--
local ClassDefinitionMetatable = {classDefinitionTable = nil}

--
-- Holds the metatable used during class runtime operations
--
local ClassRuntimeMetatable = {}

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
    local targetMember = nil
    
    while targetMember == nil do            
        if targetClass.__imp__.members[KEY] ~= nil then
            targetMember = targetClass.__imp__.members[KEY]            
            break
        elseif targetClass.__parent__ ~= nil then
            targetClass = targetClass.__parent__
        elseif targetClass.__parent__ == nil then
            break
        end            
    end
    
    return targetMember
end

--
-- Returns all class members, searching through all parents
--
function upperclass:getClassMembers(CLASS, RECURSE)
    local targetClass = CLASS
    local members = {}
    
    if RECURSE == nil then
        RECURSE = false
    end
    
    while targetClass ~= nil do
        for key, value in pairs(targetClass.__imp__.members) do
            table.insert(members, targetClass.__imp__.members[key])
        end
        
        if RECURSE == true then
            if targetClass.__parent__ ~= nil then
                targetClass = targetClass.__parent__
            else
                targetClass = nil
            end
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
        classdef.__imp__.file = nil
    end
    
    -- Create table to hold our class memebers. table KEY is member name
    classdef.__imp__.members = {}    
    
    -- Create tables to hold instance values
    classdef.__inst__ = {        
        isClassInstance = false,
        memberValueOverrides = {},
        permitMetamethodCalls = true
    }        
  
    -- Create table to hold reference to our parent class, if specified
    classdef.__parent__ = PARENT or nil
  
    -- During the definition stage, the user may place property and method definitions in the following tables
    rawset(_G, "public",    {})
    rawset(_G, "private",   {})
    rawset(_G, "protected", {})
    rawset(_G, "property",  {})   
    
    -- Set our metatables. 
    setmetatable(classdef,  ClassDefinitionMetatable)
    setmetatable(public,    ClassDefinitionMetatable)
    setmetatable(private,   ClassDefinitionMetatable)
    setmetatable(protected, ClassDefinitionMetatable)    
    setmetatable(property,  ClassDefinitionMetatable)
  
    -- The ClassDefinitionMetatable will need a reference to the ClassDefinitionTable
    ClassDefinitionMetatable.classDefinitionTable = classdef
  
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
    
    -- Set the class's metatable to ClassRuntimeMetatable
    setmetatable(CLASS, ClassRuntimeMetatable)
    
    return CLASS
end

--
-- ClassDefinitionMetatable __call method
--
function ClassDefinitionMetatable.__call(...)
    local tables = {...}
        
    -- Get our implimentation table
    local imp = rawget(ClassDefinitionMetatable.classDefinitionTable, "__imp__")
    
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
        members[ClassDefinitionMetatable.last_property_name].member_scope_get = UPPERCLASS_SCOPE_PUBLIC
        members[ClassDefinitionMetatable.last_property_name].member_scope_set = UPPERCLASS_SCOPE_PUBLIC
        members[ClassDefinitionMetatable.last_property_name].value_type = UPPERCLASS_TYPE_ANY
        members[ClassDefinitionMetatable.last_property_name].value_default = nil            
    else
        -- Determine value type & value
        if propertyTypeValue == 'any' then
            members[ClassDefinitionMetatable.last_property_name].value_type = UPPERCLASS_TYPE_ANY
            members[ClassDefinitionMetatable.last_property_name].value_default = propertyDefaultValue
        elseif propertyTypeValue == nil and propertyDefaultValue ~= nil then
            if type(propertyDefaultValue) == "string" then 
                members[ClassDefinitionMetatable.last_property_name].value_type =  UPPERCLASS_TYPE_STRING 
            elseif type(propertyDefaultValue) == "table" then 
                members[ClassDefinitionMetatable.last_property_name].value_type = UPPERCLASS_TYPE_TABLE                    
            elseif type(propertyDefaultValue) == "number" then 
                members[ClassDefinitionMetatable.last_property_name].value_type = UPPERCLASS_TYPE_NUMBER
            elseif type(propertyDefaultValue) == "userdata" then 
                members[ClassDefinitionMetatable.last_property_name].value_type = UPPERCLASS_TYPE_USERDATA
            elseif type(propertyDefaultValue) == "boolean" then 
                members[ClassDefinitionMetatable.last_property_name].value_type = UPPERCLASS_TYPE_BOOLEAN
            elseif type(propertyDefaultValue) == nil then 
                members[ClassDefinitionMetatable.last_property_name].value_type = UPPERCLASS_TYPE_ANY 
            end                
            members[ClassDefinitionMetatable.last_property_name].value_default = propertyDefaultValue
        elseif propertyTypeValue ~= nil and propertyDefaultValue == nil then
            if propertyTypeValue == 'string' then
                members[ClassDefinitionMetatable.last_property_name].value_type = UPPERCLASS_TYPE_STRING
            elseif propertyTypeValue == 'table' then
                members[ClassDefinitionMetatable.last_property_name].value_type = UPPERCLASS_TYPE_TABLE
            elseif propertyTypeValue == 'number' then
                members[ClassDefinitionMetatable.last_property_name].value_type = UPPERCLASS_TYPE_NUMBER
            elseif propertyTypeValue == 'userdata' then
                members[ClassDefinitionMetatable.last_property_name].value_type = UPPERCLASS_TYPE_USERDATA
            elseif propertyTypeValue == 'boolean' then
                members[ClassDefinitionMetatable.last_property_name].value_type = UPPERCLASS_TYPE_BOOLEAN
            end
            members[ClassDefinitionMetatable.last_property_name].value_default = nil
        elseif propertyTypeValue ~= nil and propertyDefaultValue ~= nil and propertyTypeValue == type(propertyDefaultValue) then
            if type(propertyDefaultValue) == "string" then 
                members[ClassDefinitionMetatable.last_property_name].value_type =  UPPERCLASS_TYPE_STRING 
            elseif type(propertyDefaultValue) == "table" then 
               members[ClassDefinitionMetatable.last_property_name].value_type = UPPERCLASS_TYPE_TABLE                    
            elseif type(propertyDefaultValue) == "number" then 
                members[ClassDefinitionMetatable.last_property_name].value_type = UPPERCLASS_TYPE_NUMBER
            elseif type(propertyDefaultValue) == "userdata" then 
                members[ClassDefinitionMetatable.last_property_name].value_type = UPPERCLASS_TYPE_USERDATA
            elseif type(propertyDefaultValue) == "boolean" then 
                members[ClassDefinitionMetatable.last_property_name].value_type = UPPERCLASS_TYPE_BOOLEAN
            elseif type(propertyDefaultValue) == nil then 
                members[ClassDefinitionMetatable.last_property_name].value_type = UPPERCLASS_TYPE_ANY 
            end                
            members[ClassDefinitionMetatable.last_property_name].value_default = propertyDefaultValue
        elseif propertyTypeValue == nil and propertyDefaultValue == nil then
            members[ClassDefinitionMetatable.last_property_name].value_type = UPPERCLASS_TYPE_ANY
            members[ClassDefinitionMetatable.last_property_name].value_default = propertyDefaultValue
        elseif propertyTypeValue == 'function' or type(propertyDefaultValue) == 'function' then
            error("Attempt to define class member property of type 'function' is disallowed. Please define a class member function instead.")
        else
            error("Attempt to define class member property '"..ClassDefinitionMetatable.last_property_name.."' as type '"..tostring(propertyTypeValue).."' when supplied value is of type '"..tostring(type(propertyDefaultValue)).."' is disallowed")              
        end            
        
        -- Determine getter scope
        if propertyGetterValue == 'public' then
            members[ClassDefinitionMetatable.last_property_name].member_scope_get = UPPERCLASS_SCOPE_PUBLIC
        elseif propertyGetterValue == 'private' then
            members[ClassDefinitionMetatable.last_property_name].member_scope_get = UPPERCLASS_SCOPE_PRIVATE
        elseif propertyGetterValue == 'protected' then
            members[ClassDefinitionMetatable.last_property_name].member_scope_get = UPPERCLASS_SCOPE_PROTECTED
        elseif propertyGetterValue == 'nobody' then
            members[ClassDefinitionMetatable.last_property_name].member_scope_get = UPPERCLASS_SCOPE_NOBODY
        else
            members[ClassDefinitionMetatable.last_property_name].member_scope_get = UPPERCLASS_SCOPE_PUBLIC
        end
        
        -- Determine setter scope
        if propertySetterValue == 'public' then
            members[ClassDefinitionMetatable.last_property_name].member_scope_set = UPPERCLASS_SCOPE_PUBLIC
        elseif propertySetterValue == 'private' then
            members[ClassDefinitionMetatable.last_property_name].member_scope_set = UPPERCLASS_SCOPE_PRIVATE
        elseif propertySetterValue == 'protected' then
            members[ClassDefinitionMetatable.last_property_name].member_scope_set = UPPERCLASS_SCOPE_PROTECTED
        elseif propertySetterValue == 'nobody' then
            members[ClassDefinitionMetatable.last_property_name].member_scope_set = UPPERCLASS_SCOPE_NOBODY
        else
            members[ClassDefinitionMetatable.last_property_name].member_scope_set = UPPERCLASS_SCOPE_PUBLIC
        end
    end
end

--
-- ClassDefinitionMetatable __index method
--
function ClassDefinitionMetatable.__index(TABLE, KEY)
    -- Check what kind of index we are retreiving. If requesting table is 'property'
    -- we must create a skeleton member entry with the requested key for later use 
    -- in the __call metamethod.
    if TABLE == property then
        -- Get our implimentation table
        local imp = rawget(ClassDefinitionMetatable.classDefinitionTable, "__imp__")
        
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
        ClassDefinitionMetatable.last_property_name = KEY
           
        return property
    else
        return rawget(TABLE, KEY)
    end
end

--
-- ClassDefinitionMetatable __newindex
--
function ClassDefinitionMetatable.__newindex(TABLE, KEY, VALUE)
    -- Get our implimentation table
    local imp = rawget(ClassDefinitionMetatable.classDefinitionTable, "__imp__")
        
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
-- ClassRuntimeMetatable __call method
--
function ClassRuntimeMetatable.__call(...)
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
        memberValueOverrides = {},
        permitMetamethodCalls = true
    }
        
    -- Set parent reference
    instance.__parent__ = self.__parent__
        
    setmetatable(instance, getmetatable(self))
            
    -- Call class constructor
    local passargs = {}
    if #arguments > 1 then for a=2, #arguments do table.insert(passargs, arguments[a]) end end
    local __construct = imp.members["__construct"].value_default
    __construct(instance, unpack(passargs))
     
    -- Construct parent
    if instance.__parent__ ~= nil and instance.__parent__.__inst__.isClassInstance == false then                         
        instance.__parent__ = self.__parent__()
    end
        
    return instance   
end

--
-- ClassRuntimeMetatable __index method
--
function ClassRuntimeMetatable.__index(TABLE, KEY)    
    -- Ensure we return some important keys.
    if KEY == "__imp__" or KEY == "__inst__" or KEY == "__parent__" then
        return rawget(TABLE, KEY)
    end
        
    -- Attempt to locate a user defined __index member and call it
    if TABLE.__inst__.permitMetamethodCalls == true then
        local indexMetamethodMember = upperclass:getClassMember(TABLE, '__index')                
        if indexMetamethodMember ~= nil then
            -- We must set permitMetamethodCalls to false to stop recursive behavior
            TABLE.__inst__.permitMetamethodCalls = false            
            
            -- Call the __index user defined member
            local indexMetamethodMemberRetVal = indexMetamethodMember.value_default(TABLE, KEY)            
            
            -- Reenable permitMetamethodCalls
            TABLE.__inst__.permitMetamethodCalls = true            
            
            if indexMetamethodMemberRetVal ~= UPPERCLASS_DEFAULT_BEHAVIOR then
                return indexMetamethodMemberRetVal
            end
        end
    end
    
    -- Get caller function for use in private and protected lookups only if the debug library is present        
    local caller = nil
    if debug ~= nil then
        caller = debug.getinfo(2, 'f').func            
    end
    
    -- Attempt to locate a target member
    local targetMember = upperclass:getClassMember(TABLE, KEY) 
    
    -- Halt if our target member is nil
    if targetMember == nil then
        error("Attempt to obtain non-existant class member '"..tostring(KEY).."' in class '"..tostring(TABLE.__imp__.name).."' is disallowed")
    end
    
    --[[
        ANY LOGIC PAST THIS POINT ASSUMES A VALID MEMBER LOOKUP
    --]]
        
    -- Return members based on scope
    if debug == nil or targetMember.member_scope_get == UPPERCLASS_SCOPE_PUBLIC then
        return TABLE.__inst__.memberValueOverrides[KEY] or targetMember.value_default                        
    elseif targetMember.member_scope_get == UPPERCLASS_SCOPE_PRIVATE then
        local members = upperclass:getClassMembers(TABLE, false)
        for a=1, #members do                
            if caller == members[a].value_default then                
                return TABLE.__inst__.memberValueOverrides[KEY] or targetMember.value_default
            end
        end        
        error("Attempt to retrieve private member '"..tostring(KEY).."' from outside of class '"..TABLE.__imp__.name.."' is disallowed")
    elseif targetMember.member_scope_get == UPPERCLASS_SCOPE_PROTECTED then
        local members = upperclass:getClassMembers(TABLE, true)        
        for a=1, #members do                        
            if caller == members[a].value_default then                  
                return TABLE.__inst__.memberValueOverrides[KEY] or targetMember.value_default
            end
        end          
        error("Attempt to retrieve protected member '"..tostring(KEY).."' from outside of class '"..TABLE.__imp__.name.."' is disallowed")
    end
end

--
-- ClassRuntimeMetatable __newindex method
--
function ClassRuntimeMetatable.__newindex(TABLE, KEY, VALUE)
    -- Ensure we return some important keys.
    if KEY == "__imp__" or KEY == "__inst__" or KEY == "__parent__" then
       error("Attempt to set internal class member '"..tostring(KEY).."' is disallowed")
    end
        
    -- Attempt to locate a user defined __newindex member and call it
    if TABLE.__inst__.permitMetamethodCalls == true then
        local newindexMetamethodMember = upperclass:getClassMember(TABLE, '__newindex')                
        if newindexMetamethodMember ~= nil then
            -- We must set permitMetamethodCalls to false to stop recursive behavior
            TABLE.__inst__.permitMetamethodCalls = false            
            
            -- Call the __index user defined member
            local newindexMetamethodMemberRetVal = newindexMetamethodMember.value_default(TABLE, KEY, VALUE)            
            
            -- Reenable permitMetamethodCalls
            TABLE.__inst__.permitMetamethodCalls = true            
            
            if newindexMetamethodMemberRetVal ~= UPPERCLASS_DEFAULT_BEHAVIOR then
                return newindexMetamethodMemberRetVal
            end
        end
    end
    
    -- Get caller function for use in private and protected lookups only if the debug library is present        
    local caller = nil
    if debug ~= nil then
        caller = debug.getinfo(2, 'f').func            
    end
    
    -- Attempt to locate a target member
    local targetMember = upperclass:getClassMember(TABLE, KEY) 
    
    -- Halt if our target member is nil
    if targetMember == nil then
        error("Attempt to obtain non-existant class member '"..tostring(KEY).."' in class '"..tostring(TABLE.__imp__.name).."' is disallowed")
    end
    
    -- Halt if our target member is a method
    if targetMember.member_type == UPPSERCLASS_MEMBER_TYPE_FUNCTION then
        error("Attempt to override member method '"..tostring(KEY).."' is disallowed")
    end
    
    --[[
        ANY LOGIC PAST THIS POINT ASSUMES A VALID MEMBER LOOKUP
    --]]
        
    -- Holds a boolean determining if our scope is proper
    local scopePermitted = false
    
    -- Holds a boolean determining if edit is allowed
    local editPermitted = false
    
    -- Conduct scope check
    if debug == nil or targetMember.member_scope_set == UPPERCLASS_SCOPE_PUBLIC then
        scopePermitted = true        
    elseif targetMember.member_scope_set == UPPERCLASS_SCOPE_PRIVATE then                 
        local members = upperclass:getClassMembers(TABLE, false)
        for a=1, #members do                
            if caller == members[a].value_default then                                        
                scopePermitted = true
            end
        end
        if scopePermitted ~= true then
            error("Attempt to set private member '"..tostring(KEY).."' from outside class '"..TABLE.__imp__.name.."' is disallowed")
        end
    elseif targetMember.member_scope_set == UPPERCLASS_SCOPE_PROTECTED then
        local members = upperclass:getClassMembers(TABLE, true)
        for a=1, #members do                
            if caller == members[a].value_default then                    
                scopePermitted = true
            end
        end         
        if scopePermitted ~= true then
            error("Attempt to set protected member '"..tostring(KEY).."' from outside of class '"..TABLE.__imp__.name.."' is disallowed")
        end
    end
    
    -- Conduct edit allowed check
    if targetMember.value_type == UPPERCLASS_TYPE_ANY then
        editPermitted = true
    elseif targetMember.value_type.string == type(VALUE) then
        editPermitted = true
    else        
        error("Attempt to set member '"..tostring(KEY).."' in class '"..TABLE.__imp__.name.."' of type '"..targetMember.value_type.string.."' with value type '"..tostring(type(VALUE)).."' is disallowed")
    end
    
    -- Conduct edit
    if editPermitted == true then
        TABLE.__inst__.memberValueOverrides[KEY] = VALUE    
    end
end


--
-- Return upperclass
--
return upperclass