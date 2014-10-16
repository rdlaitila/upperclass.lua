class   = require('upperclass')
MyClass = require('MyClass')

print(MyClass.publicBoolProperty)
MyClass.publicBoolProperty = false
print(MyClass.publicBoolProperty)
