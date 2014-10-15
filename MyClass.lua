local myclass, public, private, protected, static = class:define("MyClass")

--
-- Holds the RPC URL
--
private.rpcUrl = "http://www.something.com/RPC"

--
-- Holds the RPC Username
--
private.rpcUsername = "admin"

--
-- Holds the RPC Password
--
private.rpcPassword = "123"

--
-- Class Constructor
--
function private:__construct(RPCURL, RPCUSERNAME, RPCPASSWORD)
    self.rpcUrl = RPCURL
    self.rpcUsername = RPCUSERNAME
    self.rpcPassword = RPCPASSWORD
end

function public:getRpcUsername()
    return self.rpcUsername
end

return class:compile(myclass)