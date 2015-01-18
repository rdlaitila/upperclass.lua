--========================================================================
local Class = upperclass:define("Class")

function public:myPublicFunction()
    return "Whatever"
end

Class = upperclass:compile(Class)
--========================================================================
-- Call a private property from outside of class
local retval = nil
local status, err = pcall(function () 
    retval = Class:myPublicFunction()
end)
if status == true then    
    if retval == "Whatever" then
        return {result = true, message = "Test completed successfully"}
    else        
        return {result = false, message = "Attempt to access static public function failed with invalid retval"}
    end
elseif status == false then
    return {result = false, message = "Attempt to access static public function failed."}
end

