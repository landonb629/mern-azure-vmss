variable "container_image" {
  default = "mernvmss.azurecr.io/mern-frontend:v1.0"
}

variable "registry_server" {
  default = "mernvmss.azurecr.io"
}

variable "registry_username" {
  default = "mernvmss"
}

variable "registry_password" {
  default = "89rjJ02NHyW3ALeGzRS0pMzNsznjOIbXrxwyhux1GI+ACRAOw4u2"
}

variable "container_name" {
  default = "frontend"
}

variable "location" {
  default = "eastus"
}

variable "container_ip_type" {
  default = "Public"
}

variable "container_os_type" {
  default = "Linux"
}

variable "rg_name" {
  default = "mern-app"
}