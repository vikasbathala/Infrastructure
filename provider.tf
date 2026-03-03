terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "> 3.0.0"
    }
  }
  #required_version = ">= 1.7.0"
}
provider "azurerm" {
  subscription_id = "ADD_SUBSCRIPTION_ID_HERE"
  tenant_id       = "ADD_TENANT_ID_HERE"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
  }
}