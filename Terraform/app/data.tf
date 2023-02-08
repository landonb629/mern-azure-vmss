data "azurerm_subnet" "app" {
  name = "app"
  virtual_network_name = "${var.rg_name}-vnet"
  resource_group_name = var.rg_name
}

data "azurerm_application_security_group" "asg" {
  name = var.asg-name
  resource_group_name = var.rg_name
}

