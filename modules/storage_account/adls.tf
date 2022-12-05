resource "random_string" "random_suffix" {
  length  = 3
  min_lower = 1
  min_numeric = 1
  special = false
  upper   = false
}

resource "azurerm_storage_account" "adls_updatascience" {
    name                = "dls${var.settings.application}${var.settings.service}${var.settings.environment}${random_string.random_suffix.result}"
    resource_group_name = "${var.resource_group_name}"
    location            = "${var.location}"
    account_replication_type = "LRS"
    account_kind = "StorageV2"
    account_tier = "Standard"
    access_tier = "Hot"    
    min_tls_version = "TLS1_2"
    public_network_access_enabled = true
    enable_https_traffic_only = true
    shared_access_key_enabled = true
    is_hns_enabled = true
    infrastructure_encryption_enabled = true

    blob_properties {
      versioning_enabled = false
      change_feed_enabled = false
    }

    tags = var.tags
}

resource "azurerm_storage_container" "raw" {
  name                  = "raw"
  storage_account_name  = azurerm_storage_account.adls_updatascience.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "master" {
  name                  = "master"
  storage_account_name  = azurerm_storage_account.adls_updatascience.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "business" {
  name                  = "business"
  storage_account_name  = azurerm_storage_account.adls_updatascience.name
  container_access_type = "private"
}