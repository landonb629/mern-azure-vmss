resource "azurerm_container_registry" "registry" {
  name = var.container_registry
  resource_group_name = var.rg_name
  location = var.location
  admin_enabled = true 
  sku = "Standard"
}
