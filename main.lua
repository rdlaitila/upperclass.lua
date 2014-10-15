class   = require('upperclass')
MyClass = require('MyClass')

MyClassInstance = MyClass:new()

print(MyClass:getLocalVar())
print(MyClassInstance.myPublicProperty[1])

