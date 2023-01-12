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