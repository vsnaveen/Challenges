# Challenge #3
# We have a nested object. We would like a function where you pass in the object and a key and
# get back the value.
# The choice of language and implementation is up to you.
# Example Inputs
# object = {“a”:{“b”:{“c”:”d”}}}
# key = a/b/c
# object = {“x”:{“y”:{“z”:”a”}}}
# key = x/y/z
# value = a

function Get-NestedValue {
    param(
        [Parameter(Mandatory=$true)]
        [Object]$Object,
        [Parameter(Mandatory=$true)]
        [String]$Key
    )

    $keys = $Key.split(‘/‘)
    $value = $Object
    foreach ($k in $keys) {
        $value = $value.$k
    }
    return $value
}