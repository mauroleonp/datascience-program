resource "random_string" "random_suffix" {
  length  = 3
  min_lower = 1
  min_numeric = 1
  special = false
  upper   = false
}

resource "azurerm_data_factory" "adf_updatascience" {
    name                = "adf-${var.settings.application}-${var.settings.service}-${var.settings.environment}-${random_string.random_suffix.result}"
    resource_group_name = "${var.resource_group_name}"
    location            = "${var.location}"
    dynamic  github_configuration {
      for_each = try(var.github_repo, null) != null ? [var.github_repo] : []
      content {
        account_name = "${var.github_repo.account_name}"
        branch_name = "${var.github_repo.branch_name}"
        repository_name = "${var.github_repo.repository_name}"
        root_folder = "/data_factory"
        git_url = "${var.github_repo.git_url}"
      }      
    }
    public_network_enabled = true

    tags = var.tags
}

resource "azurerm_data_factory_pipeline" "raw_know" {
  name   = "raw_know_core"
  folder = "01_raw_source"
  data_factory_id = azurerm_data_factory.adf_updatascience.id
}

resource "azurerm_data_factory_pipeline" "raw_ga4" {
  name   = "raw_ga4_core"
  folder = "01_raw_source"
  data_factory_id = azurerm_data_factory.adf_updatascience.id
}

resource "azurerm_data_factory_pipeline" "master_party" {
  name   = "master_party_core"
  folder = "02_master_models"
  data_factory_id = azurerm_data_factory.adf_updatascience.id
}

resource "azurerm_data_factory_pipeline" "master_transaction" {
  name   = "master_transaction_core"
  folder = "02_master_models"
  data_factory_id = azurerm_data_factory.adf_updatascience.id
}

resource "azurerm_data_factory_pipeline" "business_student_ov" {
  name   = "business_student_overview"
  folder = "03_business_reports"
  data_factory_id = azurerm_data_factory.adf_updatascience.id
}