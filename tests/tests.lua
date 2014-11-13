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

-- Get list of keys
local keyset={}
local n=0

for k,v in pairs(tests) do
  n=n+1
  keyset[n]=k
end

-- Sort our keys
table.sort(keyset, function(A, B)
    return A < B
end)

-- Test stats
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

-- print results
print(" ")
print("TEST", genstring(longest_key + 8), "RESULT", "MESSAGE")
for key, value in pairs(keyset) do
    if tests[value] == nil or tests[value] == true then
        total_failed = total_failed +1
        tests[value] = {result = false, message = "Unknown Failure"}
    elseif type(tests[value]) == "table" then
        if tests[value].result == true then
            total_success = total_success + 1
        elseif tests[value].result == false then
            total_failed = total_failed + 1
        end
    end
    total_tests = total_tests + 1
    print(value, genstring( longest_key + 8 - value:len()  ), tests[value].result, tests[value].message)    
end

print(" ")
print("Total Tests:", total_tests, "Total Success:", total_success, "Total Failed", total_failed, "% Sucess", (total_success / total_tests * 100) )
print(" ")
