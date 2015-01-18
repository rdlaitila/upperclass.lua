--========================================================================
local Class = upperclass:define("Class")

property : myPublicBoolean {
    true;
    get='public';
    set='public';
}

Class = upperclass:compile(Class)
--========================================================================
-- Call a private property from outside of class
local retval = nil
local status, err = pcall(function () 
    retval = Class.myPublicBoolean
end)
if status == true then    
    if retval == true then
        return {result = true, message = "Test completed successfully"}
    else        
        return {result = false, message = "Attempt to access static public boolean failed with invalid retval"}
    end
elseif status == false then
    return {result = false, message = "Attempt to access static public boolean failed."}
end

