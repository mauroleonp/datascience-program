variable location {}

variable tags {}

variable resource_group_name {}

variable settings {}

output id {
    description = "The ID of the Key Vault."
    value       = azurerm_key_vault.kv_updatascience.id
}