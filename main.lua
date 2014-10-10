class   = require('upperclass')
MyClass = require('MyClass')


print(MyClass.myPublicProperty)
MyClass.myPublicProperty = 10
print(MyClass.myPublicProperty)

print("PROPERTIES:")
print("scope", "name", "value")
for a=1, #MyClass.__imp__.properties do
    local prop = MyClass.__imp__.properties[a]
    print(prop.scope, prop.name, prop.value)
end

print("METHODS:")
print("scope", "name", "reference")
for a=1, #MyClass.__imp__.methods do
    local method = MyClass.__imp__.methods[a]
    print(method.scope, method.name, method.reference)
end

print( MyClass:methodCall(ARG1, ARG2))
--print( MyClassInstance.__imp__.name )