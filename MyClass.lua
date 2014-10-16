local myclass, public, private, protected = class:define("MyClass")

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
-- A Private string Property
--
private.privateStringProperty = "private"

--
-- A Protected string Property
--
protected.protectedStringProperty = "private"

--
-- Class Constructor
--
function private:__construct()
end

function private:myPrivateFunction()
    return "Hello From Private Function"
end

return class:compile(myclass)