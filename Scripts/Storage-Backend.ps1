## Basic Storage account and container setup using Azure PowerShell.

# Variables
$resourceGroup = "rg_name_here" # Replace with your resource group name
$location = "localion_name_here" # Replace with your desired location (e.g., eastus, westus2)
$storageAccountName = "stg_name_here$(Get-Random)"
$containerName = "container_name_here"

# Create Resource Group
Write-Host "Creating Resource Group..."
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Storage Account
Write-Host "Creating Storage Account..."
$storageAccount = New-AzStorageAccount `
  -ResourceGroupName $resourceGroup `
  -Name $storageAccountName `
  -Location $location `
  -SkuName "Standard_LRS" `
  -Kind "StorageV2"

# Create Storage Context
$ctx = $storageAccount.Context

# Create Container
Write-Host "Creating Storage Container..."
New-AzStorageContainer -Name $containerName -Context $ctx

Write-Host "Done! Storage Account: $storageAccountName, Container: $containerName"