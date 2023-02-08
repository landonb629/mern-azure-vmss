resource "azurerm_container_group" "frontend-container" {
  name = var.container_name 
  location = var.location
  resource_group_name = var.rg_name
  ip_address_type = var.container_ip_type
  os_type = var.container_os_type 
  
  image_registry_credential {
    server = var.registry_server
    username = var.registry_username
    password = var.registry_password
  }

  container { 
    name = var.container_name 
    image = var.container_image
    cpu = "1.0"
    memory = "1.5"

    ports { 
      port = 3000
      protocol = "TCP"
    }
  }
  lifecycle {
    ignore_changes = [
      container
    ]
  }
}