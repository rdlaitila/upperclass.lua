local Observable = require('..examples.Observable')

-- Create Observable instance
local myObservable = Observable(true)
local myObservable2 = Observable(true)

-- Setup a subscription
myObservable:subscribe(function(newval, oldval)
    print("Value Changed: ", newval, oldval)
end)

-- Set the observable a bunch of times
myObservable("Hello")
myObservable("World")
myObservable("I")
myObservable("Can")
myObservable("Change")
myObservable:set("Values")
print("Current Value: ", myObservable())
