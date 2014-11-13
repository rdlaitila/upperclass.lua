local MyBaseClass = upperclass:define("MyBaseClass")

property : testing {"testing advanced syntax" ; get='public' ; set='nobody'}

--
-- A public string property
--
public.publicStringProperty = "public string property"

--
-- A public boolean property
--
public.publicBoolProperty = true

--
-- A public table property
--
public.publicTableProperty = {key1 = "value1", key2 = "value2"}

--
-- A public number property
--
public.publicNumberProperty = 20

--
-- A Private string property
--
private.privateStringProperty = "private string property"

--
-- A Private boolean property
--
private.privateBoolProperty = true

--
-- A Private table property
--
private.privateTableProperty = {key1 = "value1", key2 = "value2"}

--
-- A Private number property
--
private.privateNumberProperty = 20

--
-- Class Constructor
--
function private:__construct(...)   
    print("MyBaseClass Constructor", ...)    
end

--
-- Class __index Metamethod
--
function private:__index(TABLE, KEY)
end

--
-- Class __newindex Metamethod
--
function private:__newindex(TABLE, KEY, VALUE)
end

--
-- Class __tostring Metamethod
--
function private:__tostring()
end

--
-- Get Private Bool Property
--
function public:getPrivateBoolProperty()
    return self.privateBoolProperty
end

--
-- A Public function
--
function public:publicFunction()
    return "Hello From Public Function"
end

--
-- A Private function
--
function private:privateFunction()
    return "Hello From Private Function"
end

--
-- A Protected function
--
function protected:protectedFunction()
    return "Hello From Protected Function"
end

--
-- Return compiled class
--
return upperclass:compile(MyBaseClass, {ALLOW_STATIC=true, ALLOW_INSTANCE=true, STRICT_TYPES=true})