output "rg" {
  value = azurerm_resource_group.rg.name
}

output "storage" {
  value = azurerm_storage_account.storage.id
}

output "container" {
  value = azurerm_storage_container.gtstgcont01[*].name
}

output "acr" {
  value = azurerm_container_registry.gtcontreg01[*].name
}

output "mssqldb01" {
  value = azurerm_mssql_server.gttestsqlsr01[*].name
}

# output "keyvault_name" {
#   value       = azurerm_key_vault.vault.name
#   sensitive   = true
#   description = "Name of the Azure Key Vault"
# }

# output "object_id" {
#   value = data.azurerm_client_config.current.object_id
# }

# output "cert_name" {
#   value       = azurerm_key_vault_certificate.kvcert.name
#   description = "Certificate Name"
# }