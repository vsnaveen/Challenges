# Install and import the Azure PowerShell module
Install-Module -Name Az
Import-Module -Name Az

# Set the Azure context and the name of the VM
$subscriptionId = "your-subscription-id"
$resourceGroupName = "your-resource-group-name"
$vmName = "your-vm-name"

Select-AzSubscription -SubscriptionId $subscriptionId

# Get the VM metadata
$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName -Status

# Convert the VM metadata to JSON format
$jsonOutput = ConvertTo-Json $vm.InstanceView

# Output the JSON
Write-Output $jsonOutput