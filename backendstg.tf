# #migrate state file to storage account - block
terraform {
  backend "azurerm" {
    resource_group_name  = "vikassa_rg"
    storage_account_name = "vikasinfrastgacc"
    container_name       = "vikasinfra"
    key                  = "tfstate"
  }
}
