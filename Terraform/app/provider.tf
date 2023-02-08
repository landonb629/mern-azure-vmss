provider "azurerm" {
  features { }
}

terraform {
  backend "azurerm" { 
    resource_group_name = "tf-backend"
    storage_account_name = "mernapptfstate"
    container_name = "tfstate-container"
    key = "mern-app-app.tfstate"
  }
}