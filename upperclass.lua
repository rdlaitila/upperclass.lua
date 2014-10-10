local upperclass = {}

upperclass.PRIVATE  = 1
upperclass.PUBLIC   = 2
upperclass.CONSTANT = 3


upperclass.PRIVATE  = 1
upperclass.PUBLIC   = 2
upperclass.CONSTANT = 3

function upperclass:define(CLASS_NAME)
    local classdef = {}
    local classmt = {}
    
    -- Create table to hold our class implimentation
    classdef.__imp__ = {}
  
    -- Store the class name
    classdef.__imp__.name = CLASS_NAME
  
    -- Store the class file 
    classdef.__imp__.file = debug.getinfo(2, "S").source:sub(2) 
  
    -- Create table to hold our class properties
    classdef.__imp__.properties = {}
  
    -- Create table to hold our class methods
    -- Schema: {scope=[upperclass.PUBLIC|upperclass.PRIVATE], name="[NAME]"}
    classdef.__imp__.methods = {}
  
    -- During the definition stage, the user pay place property and method definitions in the following tables
    classdef.public = {}
    classdef.private = {}
    classdef.constant = {}
    
    -- Set a reference to classdef in classmt
    classmt.classdef = classdef
    
    --
    -- Classdef Metatable __index
    --
    function classmt.__index(TABLE, KEY)
        
    end
    
    --
    -- Classdef Metatable __newindex
    --
    function classmt.__newindex(TABLE, KEY, VALUE)   
        
        if type(VALUE) == "string" or type(VALUE) == "number" or 
           type(VALUE) == "boolean" or type(VALUE) == "table" then
            
            if TABLE == rawget(classmt.classdef, "public") then
                table.insert(classmt.classdef.__imp__.properties, {
                    scope = upperclass.PUBLIC,
                    name = KEY,
                    value = VALUE
                })
            elseif TABLE == rawget(classmt.classdef, "private") then
                table.insert(classmt.classdef.__imp__.properties, {
                    scope = upperclass.PRIVATE,
                    name = KEY,
                    value = VALUE
                })
            elseif TABLE == rawget(classmt.classdef, "constant") then
                table.insert(classmt.classdef.__imp__.properties, {
                    scope = upperclass.CONSTANT,
                    name = KEY,
                    value = VALUE
                })
            end
            
        elseif type(VALUE) == "function" then            
            if TABLE == rawget(classmt.classdef, "public") then
                table.insert(classmt.classdef.__imp__.methods, {
                    scope = upperclass.PUBLIC,
                    name = KEY,
                    reference = VALUE
                })
            elseif TABLE == rawget(classmt.classdef, "private") then
                table.insert(classmt.classdef.__imp__.methods, {
                    scope = upperclass.PRIVATE,
                    name = KEY,
                    reference = VALUE
                })
            end
        end
        
        print("__NEWINDEX: ", TABLE, KEY, VALUE)
    end
    
    --
    -- Classdef Metatable __call
    --
    function classmt.__call(...)
        print("__CALL: ", ...)        
    end 
  
    -- Set our metatables. 
    setmetatable(classdef,          classmt)
    setmetatable(classdef.public,   classmt)
    setmetatable(classdef.private,  classmt)
    setmetatable(classdef.constant, classmt)
  
    return classdef, rawget(classdef, "public"), rawget(classdef, "private"), rawget(classdef, "constant")
end

function upperclass:compile(CLASS)
    local classdef = CLASS
    local classmt = getmetatable(CLASS)
    
    -- No longer needed
    rawset(CLASS, "public",     nil)
    rawset(CLASS, "private",    nil)
    rawset(CLASS, "constant",   nil)
    
    --
    -- Classdef Metamethod __index
    --
    function classmt.__index(TABLE, KEY)
        local properties = classmt.classdef.__imp__.properties
        for a=1, #properties do
            if properties[a].name == KEY and properties[a].scope == upperclass.PUBLIC then
                return properties[a].value
            end
        end
    end
    
    --
    -- Classdef Metamethod __newindex
    --
    function classmt.__newindex(TABLE, KEY, VALUE)
        local properties = classmt.classdef.__imp__.properties
        for a=1, #properties do
            if properties[a].name == KEY and properties[a].scope == upperclass.PUBLIC then
                properties[a].value = VALUE
            end
        end
    end
    
    return CLASS
end

return upperclass