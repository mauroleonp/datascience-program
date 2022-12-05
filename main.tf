locals {
  # Common tags to be assigned to all resources
  common_tags = {
    environment = var.settings.base.environment
    application = var.settings.base.application
    owner   = var.settings.base.owner
  }
}

module "data_factory" {
    source = "./modules/data_factory"
    location = "${var.global_settings.location}"
    resource_group_name = "${var.resource_groups.name}"
    settings = var.settings.base    
    github_repo = var.settings.github_repo
    tags = "${merge(local.common_tags,{layer="processing"})}"
}

module "storage_account" {
    source = "./modules/storage_account"
    location = "${var.global_settings.location}"
    resource_group_name = "${var.resource_groups.name}"
    settings = var.settings.base
    tags = "${merge(local.common_tags,{layer="storing"})}"
}

module "key_vault" {
    source = "./modules/key_vault"
    location = "${var.global_settings.location}"
    resource_group_name = "${var.resource_groups.name}"
    settings = var.settings.base
    tags = "${merge(local.common_tags,{layer="security"})}"
}

module "synapse_workspace" {
    source     = "./modules/synapse_workspace"
    depends_on = [module.key_vault, module.storage_account]
    location = "${var.global_settings.location}"
    resource_group_name = "${var.resource_groups.name}"
    settings = var.settings.base
    sql_config = var.settings.sql_admin
    keyvault_id = module.key_vault.id
    github_repo = var.settings.github_repo
    storage_account_id = module.storage_account.id
    tags = "${merge(local.common_tags,{layer="analytics"})}"
}