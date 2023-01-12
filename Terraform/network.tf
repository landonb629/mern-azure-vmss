resource "azurerm_resource_group" "rg" {
  name = var.rg_name
  location = var.location
}

## virtual network ##
resource "azurerm_virtual_network" "vnet" {
  name = "${var.rg_name}-vnet"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = [var.vnet_cidr]
}

## subnets ##

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name = each.key 
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [each.value]
}

## security  groups 
/*
resource "azurerm_network_security_group" "web" {
  name = var.web-nsg
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
      name = "allowAllHTTP"
      priority = 100
      direction = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range = "*"
      destination_port_range = "80"
      source_address_prefix = "*"
      destination_address_prefix = "*"
  }
}
*/ 
/*
resource "azurerm_network_security_group" "app" {
  
}

resource "azurerm_network_security_group" "db" {
  
}
*/

