global_settings = {
  location = "eastus2"
}

settings = {
    base = {
      application = "upds"
      service = "malp"
      owner = "ma.leonp"
      environment = "dev"
      location = "eastus2"
    }
    sql_admin = {
      login = "mauroleonp"
      login_password = ""
    }
    github_repo = {
      account_name = "mauroleonp"
      branch_name = "main"
      repository_name = "azure_lakehouse_bootcamp"
      git_url = "https://github.com"
    }
}

resource_groups = {
    name = "rg-updatascience-mlap-eastus2-001"
}