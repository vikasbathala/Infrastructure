# Notes

## Read Current Client Data

- Needed to add data <"azuread_client_config" "current" {}> to the Provider.tf file.
- Needed to add <data "azurerm_client_config" "current" {}> to the main.tf file in order to read client data and pass to main.tf