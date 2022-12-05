resource "random_string" "random_suffix" {
  length  = 3
  min_lower = 1
  min_numeric = 1
  special = false
  upper   = false
}

resource "random_password" "sql_admin" {
  count = try(var.settings.sql_administrator_login_password, null) == null ? 1 : 0

  length           = 20
  special          = true
  upper            = true
  numeric          = true
  override_special = "$#%"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "updatascience" {
  name               = "updatascience"
  storage_account_id = var.storage_account_id
}

resource "azurerm_synapse_workspace" "ws" {
    name = "synw-${var.settings.application}-${var.settings.service}-${var.settings.environment}-${random_string.random_suffix.result}"
    resource_group_name = "${var.resource_group_name}"
    location = var.location
    storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.updatascience.id
    sql_administrator_login = var.sql_config.login
    sql_administrator_login_password = random_password.sql_admin.0.result
    managed_virtual_network_enabled = false
    managed_resource_group_name = "rg-${var.settings.application}-synw${random_string.random_suffix.result}-${var.settings.location}-001"
    dynamic github_repo {
      for_each = try(var.github_repo, null) != null ? [var.github_repo] : []
      content {
        account_name = "${var.github_repo.account_name}"
        branch_name = "${var.github_repo.branch_name}"
        repository_name = "${var.github_repo.repository_name}"
        root_folder = "/synapse_workspace"
        git_url = "${var.github_repo.git_url}"
      }
    }
    identity {
      type = "SystemAssigned"
    }
    tags = var.tags
}

resource "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "synapse-sql-admin-password"
  value        = random_password.sql_admin.0.result
  key_vault_id = var.keyvault_id

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "azurerm_key_vault_secret" "sql_admin" {
  name         = "synapse-sql-admin-username"
  value        = var.sql_config.login
  key_vault_id = var.keyvault_id
}