/* 
 - static web application 
 - load balancer
 - virtual machine scale set
*/


# ip configuration for load balancer
resource "azurerm_public_ip" "frontend-lb" {
  name = var.frontend-ip
  resource_group_name = var.rg_name
  location = var.location
  allocation_method = "Static"
  sku = "Standard"

}

# azure load balancer
resource "azurerm_lb" "api-lb" {
  name = var.api-lb
  location = var.location
  resource_group_name = var.rg_name
  sku = "Standard"

  frontend_ip_configuration {
    name = var.frontend-ip
    public_ip_address_id = azurerm_public_ip.frontend-lb.id

  }

}

# backend address pool resource
resource "azurerm_lb_backend_address_pool" "lb-backend-pool" {
  name = "${var.api-lb}-backend-pool"
  loadbalancer_id = azurerm_lb.api-lb.id
}

## Load balancer backend pool rule 
resource "azurerm_lb_rule" "backend-rule" {
  loadbalancer_id = azurerm_lb.api-lb.id
  name = "API-lb-rule"
  protocol = "Tcp"
  probe_id = azurerm_lb_probe.lb-probe.id
  frontend_port = 3031
  backend_port = 3031
  frontend_ip_configuration_name = azurerm_lb.api-lb.frontend_ip_configuration[0].name
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb-backend-pool.id]
}

# health probe for load balancer
resource "azurerm_lb_probe" "lb-probe" {
  loadbalancer_id = azurerm_lb.api-lb.id
  name = "api-probe"
  port = 3031
  protocol = "Http"
  request_path = "/api/v1/auth"
}



resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name = var.vmss-name
  resource_group_name = var.rg_name
  location = var.location
  sku = var.vmss-sku    
  instances = var.instance_count
  admin_username = "azureadmin"
  admin_password = "TestingPassword123_"
  upgrade_mode = "Rolling"
  health_probe_id = azurerm_lb_probe.lb-probe.id
  disable_password_authentication = false

  source_image_id = var.image-id

  os_disk { 
      storage_account_type = "Standard_LRS"
      caching = "ReadWrite"
  }

   rolling_upgrade_policy {
       max_batch_instance_percent = 20
       max_unhealthy_instance_percent = 100
       max_unhealthy_upgraded_instance_percent = 100
       pause_time_between_batches = "PT15S"
   }
  # network interface -> ip configuration = how to set the vmss machines to the LB backend pool
  network_interface { 
      name = "vmss-nic"
      primary = true 

      ip_configuration { 
          name = "Internal"
          primary = true 
          subnet_id = data.azurerm_subnet.app.id 
          load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb-backend-pool.id]
          application_security_group_ids = [data.azurerm_application_security_group.asg.id]
      }
  
  }
  depends_on = [
    azurerm_lb.api-lb,
    azurerm_lb_probe.lb-probe,
  ]

}

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

