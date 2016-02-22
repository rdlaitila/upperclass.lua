--[[
The MIT License (MIT)

Copyright (c) 2016 Regan Daniel Laitila

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

--
-- Here We Go :)
--
local upperclass = {}

--
-- Our version: Major.Minor.Patch
--
upperclass.version = "0.4.0-dev"

--
-- Registry holds the implimenation of all
-- defined classes. Upperclass makes heavy
-- use of the registry to locate members, 
-- callers, parents and childs etc
--
local registry = {}

--
-- Move global debug to local debug
--
local rawdebug = debug

--
-- Move global type to local type
--
local rawtype = type

--
-- Runtime metatable
--
local RuntimeMetatable = {}

--
-- expect
--
function upperclass:expect(value) 
    return {
        type = function(self, expected)
            local result = upperclass:type(value)
            if result ~= expected then
                error(string.format("Expected type '%s' recieved type '%s'", expected, result))
            end
            return self
        end;
        
        gt = function(self, expected)
            if value <= expected then
                error(string.format("Expected Greater Than '%s' recieved '%s'", expected, value))
            end
            return self
        end;
    }    
end

--
-- Define
--
function upperclass:define(name, parent)  
    if name == nil then
        upperclass:throw("Attempt to define class without a name is disallowed")
    end
    
    if parent ~= nil then parent = parent.__obj.classdef or nil end
    
    --
    -- Check our registry for a class already defined
    -- with the same name supplied from the user
    --
    if registry[name] ~= nil then
        upperclass:throw("Attempt to re-define existing class '%s' is disallowed", name)
    else
        registry[name] = {
            name      = name;
            parent    = parent;
            childs    = {};
            members   = {};
            callers   = {
                private = {};
                protected = {};
            }
        }
        
        if parent ~= nil then
            registry[name].parent.childs[name] = registry[name]
        end
    end
    
    --
    -- Hold a reference to our spot in the registry
    --
    local classdef = registry[name]
    
    --
    -- hold a reference to our members
    --
    local members = classdef.members
    
    --
    -- Metatables
    --    
    local DefinitionMetatable = {}
    
    --
    -- Scope Tables
    --
    local public, private, protected, static = {scope='public'}, {scope='private'}, {scope='protected'}, {scope='static'};
    setmetatable(public, DefinitionMetatable)
    setmetatable(private, DefinitionMetatable)
    setmetatable(protected, DefinitionMetatable)
    setmetatable(static, DefinitionMetatable)
    
    --
    -- Static Metatable
    --
    function DefinitionMetatable:__index(key)
        if key == 'public' then return public end
        if key == 'private' then return private end
        if key == 'protected' then return protected end
        if key == 'static' then return static end                
        if self == public or self == private or self == protected or self == static then
            return function(scopetable, proptable)
                members[key] = {
                    getter = scopetable.scope or 'public';
                    setter = proptable.setter or scopetable.scope;
                    nullable = proptable.nullable or false;
                    type = proptable.type or 'any';
                    default = proptable.default or proptable[1] or nil;
                    init = proptable.init;
                }
                
                if members[key].type ~= 'any' and members[key].type ~= upperclass:type(members[key].default) then
                    upperclass:throw("default/type mismatch in property '%s' in '%s'", key, classdef.name)
                end
            end
        end
    end
    function DefinitionMetatable:__newindex(key, value)
        if self == public or self == private or self == protected or self == static then
            members[key] = {
                getter = self.scope or 'public';
                setter = 'nobody';
                nullable = false;
                type = 'function';
                default = value;                
            }
            table.insert(classdef.callers.private, value)
            table.insert(classdef.callers.protected, value)
            local parent = classdef.parent
            while parent ~= nil do
                table.insert(parent.callers.protected, value)
                parent = parent.parent
            end
        end
    end
    
    return setmetatable(classdef, DefinitionMetatable)    
end

--
-- Compile
--
function upperclass:compile(classdef)
    --
    -- Strip metatables
    --
    setmetatable(classdef, nil)
    
    --
    -- Object is our static/instantiable table
    --
    local object = {
        __obj = {
            classdef=classdef;
            instance=false;
            mmindex=true;
            mmnewindex=true;
            overrides={};
        }
    }
    
    --
    -- Return
    --
    return setmetatable(object, RuntimeMetatable)
end

--
-- __call
--
function RuntimeMetatable:__call(...)       
    local obj = rawget(self, '__obj')
    
    local instance = setmetatable({
        __obj = {
            classdef=obj.classdef;
            instance=true;
            mmindex=true;
            mmnewindex=true;
            overrides={};
        }
    }, RuntimeMetatable)
    
    if obj.classdef.members['init'] ~= nil then
        instance:init(...)
    end
    
    return instance
end

--
-- __index
--
function RuntimeMetatable:__index(key)
    local obj = self.__obj
    local mdef, member = obj.classdef, obj.classdef.members[key]
        
    if member == nil and key ~= '__index' and obj.mmindex and obj.classdef.members['__index'] ~= nil  then
        obj.mmindex = false
        local val = obj.classdef.members['__index'].default(self, key)
        obj.mmindex = true
        return val
    elseif member == nil and mdef.parent ~= nil then
        mdef = mdef.parent
        while mdef ~= nil do
            if mdef.members[key] ~= nil then
                member = mdef.members[key]
                break
            else
                mdef = mdef.parent
            end
        end
    end
    
    if member == nil then
        upperclass:throw("Attempt to index non-existant member %s is disallowed", key)
    end
    
    -- Check scopes
    if rawdebug == nil or member.getter == 'public' then   
        local override = obj.overrides[key]
        if override == nil then 
            return member.default
        else 
            return override.value
        end 
    elseif member.getter == 'private' or member.getter == 'protected' then
        local caller = rawdebug.getinfo(2, 'f').func
        for _, func in ipairs(mdef.callers[member.getter]) do
            if func == caller then                    
                local override = obj.overrides[key]
                if override == nil then 
                    return member.default
                else 
                    return override.value
                end 
            end
        end
        upperclass:throw("Attempt to access '%s' member '%s' of class '%s' from outside of class is disallowed", member.getter, key, def.name)
    end
    
    upperclass:throw("Attempt to index member failed")
end

--
-- __newindex
--
function RuntimeMetatable:__newindex(key, value)        
    local obj = rawget(self, '__obj')
   
    if key ~= '__newindex' and obj.classdef.members['__newindex'] ~= nil and obj.mmnewindex then
        obj.mmnewindex = false
        local __newindex = obj.classdef.members['__newindex'].default
        __newindex(self, key, value)
        obj.mmnewindex = true
    end
    
    local def, member = upperclass:lookup(obj.classdef, key)                
    
    -- If member is nil and we are not within a __index metamethod
    if member == nil and obj.mmnewindex == true then
        upperclass:throw("Attempt to newindex non-existant member %s is disallowed", key)
    end
    
    -- If member is nil and we are within a __index metamethod
    if member == nil and obj.mmnewindex == false then
        return nil
    end
   
    -- Bool indicating if we are of proper scope
    local scopepermit = false
   
    if rawdebug == nil or member.setter == 'public' then            
        scopepermit = true
    elseif member.setter == 'private' or member.setter == 'protected' then
        local caller = rawdebug.getinfo(2, 'f').func
        for _, func in pairs(def.callers[member.setter]) do
            if func == caller then
                scopepermit = true
                break
            end
        end
        upperclass:throw("Attempt to assign value to '%s' member failed. Caller is not in scope", member.setter)
    else
        upperclass:throw("Attempt to assign value to member with setter scope of '%s' is disallowed", member.setter)
    end
    
    if scopepermit then
        local valuetype = upperclass:type(value)
        if member.type == 'any' or value == nil and member.nullable or upperclass:type(value) == member.type then
            if obj.overrides[key] ~= nil then 
                obj.overrides[key].value = value 
            else 
                obj.overrides[key] = {value=value}
            end
            return
        else
            upperclass:throw("Attempt to assign value of type '%s' to member of type '%s' is disallowed", valuetype, member.type)
        end
    end
    
    upperclass:throw("__newindex failure")
end

--
-- Dumps a table
--
function upperclass:dumptable(t)
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

--
-- Lookup Class member
--
function upperclass:lookup(classdef, key)
    local member = classdef.members[key]
    local parent = classdef.parent
    
    if member ~= nil then
        return classdef, member
    elseif parent ~= nil then
        return upperclass:lookup(parent, key)
    else
        return classdef, nil
    end
end

--
-- Lookup class member of a caller
--
function upperclass:lookupcaller(caller)
    for _, def in pairs(registry) do
        local classdef = def
        while classdef ~= nil do
            for mkey, mvalue in pairs(def.members) do
                if mvalue.default == caller then
                    return def, mvalue, mkey
                end
            end
            classdef = classdef.parent
        end        
    end
end

--
-- Throws an error
--
function upperclass:throw(errstr, ...)
    error(string.format(errstr, ...))
end

--
-- Looks up a class type or data type
--
function upperclass:type(value)
    local t = type(value)
    if t == 'table' then
        local obj = rawget(value, '__obj')
        if obj ~= nil then
            if obj.classdef.members['__type'] ~= nil then
                local __type = obj.classdef.members['__type'].default
                return __type(value)
            else
                return obj.classdef.name
            end
        else
            return t
        end
    else
        return t
    end
end

--
-- Return upperclass
--
upperclass.__registry = registry
return upperclass