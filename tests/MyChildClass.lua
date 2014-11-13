local MyChildClass = upperclass:define("MyChildClass", MyBaseClass)

--
-- Class Constructor
--
function private:__construct(...)    
    self:__constructparent("arg3", "arg4")
    print("MyChildClass Constructor", ...)    
end

--
-- Return compiled class
--
return upperclass:compile(MyChildClass)