local myclass, public, private, constant = class:define("MyClass")

-- Publically accessible property
public.myPublicProperty = {"1", 2, "tree"}

-- Privatly accessible property
private.myPrivateProperty = "test"

-- constant property
constant.myConstantProperty = true

--
-- Class Constructor
--
function private:__construct()
    print("MyClass Private Method __construct()")
end

--
-- Lua index metamethod
--
function private:__index()
end

--
-- Lua newindex metamethod
--
function private:__newindex()
end

--
-- Lua add metamethod
--
function private:__add()
end

--
-- Private method
--
function private:getMyPrivateProperty()
    return self.myPrivateProperty
end


return class:compile(myclass)