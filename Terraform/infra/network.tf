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
  service_endpoints = each.key == "app" ? ["Microsoft.AzureCosmosDB"] : []
} 

## application security group ##
resource "azurerm_application_security_group" "asg" {
  name = var.asg-name
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

## security  groups 
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


resource "azurerm_network_security_group" "app" {
  name = var.app-nsg
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule { 
    name = "allowFromToAPI"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "3031"
    source_address_prefix = "*"
    destination_address_prefix = "*"

  }
}

## security group associations ##

resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id = azurerm_subnet.subnets["web"].id
  network_security_group_id = azurerm_network_security_group.web.id
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id = azurerm_subnet.subnets["app"].id
  network_security_group_id = azurerm_network_security_group.app.id
}
