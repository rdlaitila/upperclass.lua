local upperclass = require('..upperclass')

--
-- Define
--
local Observable, public, private, protected = upperclass:define("Observable")

--
-- Holds the actual value of our observable
--
private:value {
    type='any';
}

--
-- Holds a list of callbacks for our observable
--
private:callbacks {
    type='table';
    default={};
}

--
-- Constructor
--
function private:__construct(value)
    self.callbacks = {}
    self.value = value
end

--
-- __call
--
function private:__call(value)
    if value == nil then
        return self:get()
    else   
        self:set(value)
    end
end

--
-- get
--
function public:get()
    return self.value
end

--
-- set
--
function public:set(value)
    local oldval = self.value
    self.value = value
    for a=1, #self.callbacks do
        self.callbacks[a](self.value, oldval)
    end
end

--
-- subscribe
--
function public:subscribe(callback)
    table.insert(self.callbacks, callback)
end

--
-- Return
--
return Observable