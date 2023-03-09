variable "rg_name" {
  default = "mern-app"
}
variable "location" {
  default = "eastus"
}
variable "vnet_cidr" {
  default = "10.10.0.0/22"
}

variable "subnets" {
  type = map(string)
  default = { 
      "web" = "10.10.0.0/24",
      "app" = "10.10.1.0/24",
      "db" = "10.10.2.0/24"
  }
}

variable "web-nsg" {
  default = "web-nsg"
}
variable "app-nsg" {
  default = "app-nsg"
}
variable "db-nsg" {
  default = "db-nsg"
}
variable "asg-name" {
  default = "api-asg"
}

variable "cosmos_db_account" {
  default = "mern-app-demo"
}

variable "cosmos_db" {
  default = "mern-app-db"
}

variable "frontend-ip" {
  default = "frontend-lb-ip"
}

variable "api-lb" {
  default = "api-lb"
}

variable "vmss-name" {
  default = "api-vmss"
}

variable "vmss-sku" {
  default = "Standard_B1s"
}

variable "instance_count" {
  default = 2
}

variable "source_image_id" {
  default = ""
}

variable "container_name" {
  default = "mern-frontend1"
}

variable "container_ip_type" {
  default  = "Public"
}

variable "container_image" {
  default = "mernvmss.azurecr.io/mern-frontend:v1.0"
}

variable "container_os_type" {
  default = "Linux"
}


variable "container_registry" {
  default = "mernvmss"
}