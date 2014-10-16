class   = require('upperclass')
MyClass = require('MyClass')

MyClassInstance = MyClass:new()

class:dumpMembers(MyClassInstance)

print(MyClassInstance:getPrivateBoolProperty())
--print(MyClassInstance.getPrivateBoolProperty())