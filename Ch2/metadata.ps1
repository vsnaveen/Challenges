# Challenge #2
# We need to write code that will query the meta data of an instance within AWS or Azure or GCP
# and provide a json formatted output.
# The choice of language and implementation is up to you.
# Bonus Points
# The code allows for a particular data key to be retrieved individually
# Hints
# ·         Aws Documentation (https://docs.aws.amazon.com/)
# ·         Azure Documentation (https://docs.microsoft.com/en-us/azure/?product=featured)
# ·         Google Documentation (https://cloud.google.com/docs)

# Install and import the Azure PowerShell module
Install-Module -Name Az
Import-Module -Name Az

# Set the Azure context and the name of the VM
$subscriptionId = ""
$resourceGroupName = ""
$vmName = ""

Select-AzSubscription -SubscriptionId $subscriptionId

# Get the VM metadata
$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName -Status

# Convert the VM metadata to JSON format
$jsonOutput = ConvertTo-Json $vm.InstanceView

# Output the JSON
Write-Output $jsonOutput

$Bonus=[json]$jsonOutput.name