# public IP address for fronted load balancer

resource "azurerm_public_ip" "frontend-public-ip" {
  name = "frontend-lb-ip"
  resource_group_name = var.rg_name
  location = var.location
  allocation_method = "Static"
  sku = "Standard"
}


# azure load balancers 
resource "azurerm_lb" "api-lb" {
  name = var.api-lb
  location = var.location
  resource_group_name = var.rg_name
  sku = "Standard"

  frontend_ip_configuration {
    name = "backend-ip"
    subnet_id = data.azurerm_subnet.app.id
    private_ip_address = "10.10.1.10"
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_lb" "frontend-lb" {
  name = "frontend-lb"
  location = var.location
  resource_group_name = var.rg_name
  sku = "Standard"

  frontend_ip_configuration {
    name = "fronted-ip"
    public_ip_address_id = azurerm_public_ip.frontend-public-ip.id
  }
}

# backend address pool resource
resource "azurerm_lb_backend_address_pool" "lb-backend-pool" {
  name = "${var.api-lb}-backend-pool"
  loadbalancer_id = azurerm_lb.api-lb.id
}

resource "azurerm_lb_backend_address_pool" "frontend-address-pool" {
  name = "frontend-machine-pool"
  loadbalancer_id = azurerm_lb.frontend-lb.id
}


## Azure load balancer rules
resource "azurerm_lb_rule" "backend-rule" {
  loadbalancer_id = azurerm_lb.api-lb.id
  name = "API-lb-rule"
  protocol = "Tcp"
  probe_id = azurerm_lb_probe.lb-probe.id
  frontend_port = 3032
  backend_port = 3032
  frontend_ip_configuration_name = azurerm_lb.api-lb.frontend_ip_configuration[0].name
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb-backend-pool.id]
}

resource "azurerm_lb_rule" "fronted-vms" {
  loadbalancer_id = azurerm_lb.frontend-lb.id
  name = "frontend-lb-rule"
  protocol = "Tcp"
  probe_id =  azurerm_lb_probe.frontend-probe.id 
  frontend_port = 80
  backend_port = 80 
  frontend_ip_configuration_name = azurerm_lb.frontend-lb.frontend_ip_configuration[0].name
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.frontend-address-pool.id]
}

# health probe for load balancers
resource "azurerm_lb_probe" "lb-probe" {
  loadbalancer_id = azurerm_lb.api-lb.id
  name = "api-probe"
  port = 3032
  protocol = "Http"
  request_path = "/api/v1/auth"
}

resource "azurerm_lb_probe" "frontend-probe" {
  loadbalancer_id = azurerm_lb.frontend-lb.id
  name = "frontend-probe"
  port = 80
  protocol = "Http"
  request_path = "/"
}

# virtual machine scale sets
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name = var.api-vmss-name
  resource_group_name = var.rg_name
  location = var.location
  sku = var.vmss-sku    
  instances = var.instance_count
  admin_username = "azureadmin"
  admin_password = "TestingPassword123_"
  upgrade_mode = "Rolling"
  health_probe_id = azurerm_lb_probe.lb-probe.id
  disable_password_authentication = false

  source_image_id = var.api-image-id

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
      }
  
  }
}

resource "azurerm_linux_virtual_machine_scale_set" "frontend-vmss" {
  name = var.frontend-vmss-name
  resource_group_name = var.rg_name
  location = var.location
  sku = var.vmss-sku 
  instances = var.instance_count 
  admin_username = "azureadmin"
  admin_password = "TestingPassword123_"
  upgrade_mode = "Rolling"
  health_probe_id = azurerm_lb_probe.frontend-probe.id 
  disable_password_authentication = false

  source_image_id = var.frontend-image-id 

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

   network_interface {
     name = "frontend-vmss-nic"
     primary = true 

     ip_configuration { 
       name = "Internal"
       primary = true 
       subnet_id = data.azurerm_subnet.web.id
       load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.frontend-address-pool.id]
     }
   }
}