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