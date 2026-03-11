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
  subscription_id = "d7d608df-45e4-4c0b-b403-52488bb99d55"
  tenant_id       = "0c90027b-7c4e-4870-be8a-38b2bf6cf020"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
  }
}
