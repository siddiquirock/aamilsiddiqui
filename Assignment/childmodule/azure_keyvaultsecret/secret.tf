

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_key_vault_secret" "username" {
  name         = "vm-admin-username"
  value        = "Admin_username"
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "password" {
  name         = "vm-admin-password"
  value        = "Sol1234"
  key_vault_id = data.azurerm_key_vault.kv.id
}
