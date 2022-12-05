variable location {}

variable tags {}

variable resource_group_name {}

variable settings {}

output id {
    description = "The ID of the Storage Account."
    value       = azurerm_storage_account.adls_updatascience.id
}