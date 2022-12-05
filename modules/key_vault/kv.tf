resource "random_string" "random_suffix" {
  length  = 3
  min_lower = 1
  min_numeric = 1
  special = false
  upper   = false
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv_updatascience" {
    name = "kv-${var.settings.application}-${var.settings.service}-${var.settings.environment}-${random_string.random_suffix.result}"
    location = "${var.location}"
    resource_group_name = "${var.resource_group_name}"
    tenant_id = data.azurerm_client_config.current.tenant_id
    enabled_for_disk_encryption = true
    sku_name = "standard"
    public_network_access_enabled = true
    soft_delete_retention_days = 7
    purge_protection_enabled = false
    tags = var.tags

    access_policy {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = data.azurerm_client_config.current.object_id
      secret_permissions = [
        "Get", "List", "Set", "Delete", "Purge"
      ]
    }
}