#####################################
#      Data and Locals Block        #
#####################################

data "azurerm_client_config" "current" {}

# This block is normally used if a KV is added to the code, or if you want to add a locals with data.azurerm_client_config.current.object_id
#   locals {
# #    current_user_id = coalesce(var.msi_id, data.azurerm_client_config.current.object_id)
#      current_user_id = data.azurerm_client_config.current.object_id
# }

################################
#   Random String - Cont Reg   #
################################
# NOTE: Storage Accounts cannot have special characters.
# NOTE: Cannot exceed 24 characters! Must be between 3 and 24 characters.
resource "random_string" "stng01" {
  length  = 7
  upper   = false
  lower   = true
  special = false
  numeric = true
}

####################################################
# Configure the Azure provider
# Generate a random integer to create a globally unique name
####################################################
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

#####################################################
#                  Resource Group
#####################################################
resource "azurerm_resource_group" "rg" {
  name     = "GTRG-${random_integer.ri.result}"
  location = var.location
}

#####################################################
#         Create the Linux App Service Plan
#####################################################
resource "azurerm_service_plan" "appserviceplan" {
  name                = "webapp-asp-${random_integer.ri.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

#####################################################
#                Web App and APP ID
#####################################################
resource "azurerm_linux_web_app" "webapp" {
  name                = "webapp-${random_integer.ri.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  https_only          = true
  site_config {
    minimum_tls_version = "1.2"
  }
}

#  Deploy code from a public GitHub repo - not used as of now.
# resource "azurerm_app_service_source_control" "sourcecontrol" {
#   app_id             = azurerm_linux_web_app.webapp.id
#   repo_url           = "https://github.com/dracman65/dotnet-test-app.git"
#   branch             = "master"
#   use_manual_integration = true
#   use_mercurial      = false
# }

#################################
#        AzureRM Storage
#################################
resource "azurerm_storage_account" "storage" {
  depends_on               = [azurerm_resource_group.rg]
  name                     = var.storagename
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

#################################
#       AzureRM Container
#################################
resource "azurerm_storage_container" "gtstgcont01" {
  depends_on            = [azurerm_storage_account.storage]
  count                 = 1
  name                  = "${var.containername}${count.index}"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}

#  Deploy code from a public GitHub repo
# resource "azurerm_app_service_source_control" "sourcecontrol" {
#   app_id             = azurerm_linux_web_app.webapp.id
#   repo_url           = "https://github.com/dracman65/dotnet-test-app.git"
#   branch             = "master"
#   use_manual_integration = true
#   use_mercurial      = false
# }

#################################
#       Container Registry
#################################
resource "azurerm_container_registry" "gtcontreg01" {
  depends_on          = [azurerm_resource_group.rg]
  name                = "${random_string.stng01.id}gtcontrg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic" # Can be "Basic" or "Standard"

  ## Can only be used with Premium SKU
  #   retention_policy {
  #     days    = 7
  #     enabled = true
  #  }
}

#################################
#          SQL User ID
#################################
resource "azurerm_user_assigned_identity" "gtsqladmin" {
  name                = "gt-sql-admin"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

#################################
#          SQL Server
#################################
resource "azurerm_mssql_server" "gttestsqlsr01" {
  #depends_on                   = [azurerm_resource_group.rg]
  name                         = "${random_string.stng01.id}-gtsqlsvr"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "gtadministrator"
  administrator_login_password = "thisIsGTs11"
  minimum_tls_version          = "1.2"
  depends_on                   = [azurerm_storage_account.storage]

  tags = var.tags2

  azuread_administrator {
    login_username = azurerm_user_assigned_identity.gtsqladmin.name
    object_id      = azurerm_user_assigned_identity.gtsqladmin.principal_id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.gtsqladmin.id]
  }

  primary_user_assigned_identity_id = azurerm_user_assigned_identity.gtsqladmin.id
  #transparent_data_encryption_key_vault_key_id = azurerm_key_vault_key.gtsqlkv01.id
}