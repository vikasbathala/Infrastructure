#!/bin/bash

# Variables
RESOURCE_GROUP="RG_Name_Here"  # Replace with your resource group name
LOCATION="location_name_here"  # Replace with your desired location (e.g., eastus, westus2)
STORAGE_ACCOUNT_NAME="Storage_Account_Name_Here$(date +%s)"  # Must be globally unique
CONTAINER_NAME="Container_Name_Here"  # Replace with your container name

# Create Resource Group (if not exists)
echo "Creating Resource Group..."
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

# Create Storage Account
echo "Creating Storage Account..."
az storage account create \
  --name $STORAGE_ACCOUNT_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS \
  --kind StorageV2

# Get Storage Account Key
STORAGE_KEY=$(az storage account keys list \
  --resource-group $RESOURCE_GROUP \
  --account-name $STORAGE_ACCOUNT_NAME \
  --query '[0].value' -o tsv)

# Create Container
echo "Creating Storage Container..."
az storage container create \
  --name $CONTAINER_NAME \
  --account-name $STORAGE_ACCOUNT_NAME \
  --account-key "$STORAGE_KEY"

echo "Done! Storage Account: $STORAGE_ACCOUNT_NAME, Container: $CONTAINER_NAME"