upperclass = require('..upperclass')

local tests = {
    test_upperclass_define_method                   = require('tests.test_upperclass_define_method'),
    test_upperclass_compile_method                  = require('tests.test_upperclass_compile_method'),
    test_static_class_private_property_string       = require('tests.test_static_class_private_property_string'),
    test_static_class_private_property_boolean      = require('tests.test_static_class_private_property_boolean'),
    test_static_class_private_property_table        = require('tests.test_static_class_private_property_table'),
    test_static_class_private_property_number       = require('tests.test_static_class_private_property_number'),
    test_static_class_private_function              = require('tests.test_static_class_private_function'),
    test_static_class_public_property_string        = require('tests.test_static_class_public_property_string'),
    test_static_class_public_property_boolean       = require('tests.test_static_class_public_property_boolean'),
    test_static_class_public_property_table         = require('tests.test_static_class_public_property_table'),
    test_static_class_public_property_number        = require('tests.test_static_class_public_property_number'),
    test_static_class_public_function               = require('tests.test_static_class_public_function'),
    test_static_class_protected_property_string     = require('tests.test_static_class_protected_property_string'),
    test_static_class_protected_property_boolean    = require('tests.test_static_class_protected_property_boolean'),
    test_static_class_protected_property_table      = require('tests.test_static_class_protected_property_table'),
    test_static_class_protected_property_number     = require('tests.test_static_class_protected_property_number'),
    test_static_class_protected_function            = require('tests.test_static_class_protected_function'),
    test_instance_class_private_property_string     = require('tests.test_instance_class_private_property_string'),
    test_instance_class_private_property_boolean    = require('tests.test_instance_class_private_property_boolean'),
    test_instance_class_private_property_table      = require('tests.test_instance_class_private_property_table'),
    test_instance_class_private_property_number     = require('tests.test_instance_class_private_property_number'),
    test_instance_class_private_function            = require('tests.test_instance_class_private_function'),
    test_instance_class_public_property_string      = require('tests.test_instance_class_public_property_string'),
    test_instance_class_public_property_boolean     = require('tests.test_instance_class_public_property_boolean'),
    test_instance_class_public_property_table       = require('tests.test_instance_class_public_property_table'),
    test_instance_class_public_property_number      = require('tests.test_instance_class_public_property_number'),
    test_instance_class_public_function             = require('tests.test_instance_class_public_function'),
    test_instance_class_protected_property_string   = require('tests.test_instance_class_protected_property_string'),
    test_instance_class_protected_property_boolean  = require('tests.test_instance_class_protected_property_boolean'),
    test_instance_class_protected_property_table    = require('tests.test_instance_class_protected_property_table'),
    test_instance_class_protected_property_number   = require('tests.test_instance_class_protected_property_number'),
    test_instance_class_protected_function          = require('tests.test_instance_class_protected_function'),
    test_inherited_class_private_property_string    = require('tests.test_inherited_class_private_property_string'),
    test_inherited_class_private_property_boolean   = require('tests.test_inherited_class_private_property_boolean'),
    test_inherited_class_private_property_table     = require('tests.test_inherited_class_private_property_table'),
    test_inherited_class_private_property_number    = require('tests.test_inherited_class_private_property_number'),
    test_inherited_class_private_function           = require('tests.test_inherited_class_private_function'),
    test_inherited_class_public_property_string     = require('tests.test_inherited_class_public_property_string'),
    test_inherited_class_public_property_boolean    = require('tests.test_inherited_class_public_property_boolean'),
    test_inherited_class_public_property_table      = require('tests.test_inherited_class_public_property_table'),
    test_inherited_class_public_property_number     = require('tests.test_inherited_class_public_property_number'),
    test_inherited_class_public_function            = require('tests.test_inherited_class_public_function'),
    test_inherited_class_protected_property_string  = require('tests.test_inherited_class_protected_property_string'),
    test_inherited_class_protected_property_boolean = require('tests.test_inherited_class_protected_property_boolean'),
    test_inherited_class_protected_property_table   = require('tests.test_inherited_class_protected_property_table'),
    test_inherited_class_protected_property_number  = require('tests.test_inherited_class_protected_property_number'),
    test_inherited_class_protected_function         = require('tests.test_inherited_class_protected_function')
}

local total_tests = 0
local total_success = 0
local total_failed = 0
local longest_key = 0

-- Get the longest key
for key, value in pairs(tests) do    
    if key:len() > longest_key then        
        longest_key = key:len()
    end
end

local function genstring(len)
    local str = ""
    for a=1, len do
        str = str .. " "
    end
    return str
end

-- Fix bad results
print("KEY", genstring(longest_key + 8), "RESULT", "MESSAGE")

for key, value in pairs(tests) do
    if value == nil or value == true then
        total_failed = total_failed +1
        tests[key] = {result = false, message = "Unknown Failure"}
    elseif type(value) == "table" then
        if value.result == true then
            total_success = total_success + 1
        elseif value.result == false then
            total_failed = total_failed + 1
        end
    end
    
    print(key, genstring( longest_key + 8 - key:len()  ), tests[key].result, tests[key].message)    
end

print("Total Tests:", total_tests, "Total Success:", total_success, "Total Failed", total_failed)
