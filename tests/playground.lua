print(collectgarbage('count'))

local upperclass = require('..upperclass')

local Class = upperclass:define('Class')

Class = upperclass:compile(Class)

local objects = {}

for a=1, 100000 do
    table.insert(objects, Class())
end

print('done')

print(collectgarbage('count'))

objects = nil

collectgarbage()

print(collectgarbage('count'))