local upperclass = require('..upperclass')

local class = upperclass:define('Base')

--
--
--
class.protected.biz {
    type='string';
    setter='public';
    default='test';
}

--
--
--
class.protected:baz {
    default='Hello, World 2';
}

--
--
--
function class.protected:init()
    print("Base:init")
end

--
-- 
--
function class.protected:__index(key)    
    if key == 'whenever' then
        return 'whenever'
    end
    
    return self[key]
end

--
--
--
local Base = upperclass:compile(class)

--====================================================================================
--====================================================================================

--
--
--
local class = upperclass:define('Extend', Base)

--
--
--
function class.public:init()
    print("Extend:init")
    Base.init(self)
end

--
-- 
--
function class.private:__index(key)  
    if key == 'whatever' then
        return 'whatever'
    end
       
    return Base.__index(self, key)
end

--
--
--
function class.public:getBiz()
    return self.biz
end

--
--
--
local Extend = upperclass:compile(class)

local extend = Extend()
print(extend.whatever)
print(extend.whenever)
extend.biz = "someting"
print(extend:getBiz())