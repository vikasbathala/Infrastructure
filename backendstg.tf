# #migrate state file to storage account - block
terraform {
  backend "azurerm" {
    resource_group_name  = "RG_Name_Here"
    storage_account_name = "Storage_Account_Name_Here"
    container_name       = "Container_Name_Here"
    key                  = "Key_Name_Here"
  }
}