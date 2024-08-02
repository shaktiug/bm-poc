##
# Define variables for location, service principal for AKS and appgw VM Admin
##
variable "location" {
  type = map(string)
  default = {
    value  = "East US"
    suffix = "eastus" # The corresponding value of location that is used by Azure in naming AKS resource groups
  }
}

variable "app" {
  type = string
  default = "bm"
}

variable "env" {
  type = string
}

variable "ado_password" {
  default = "admin"
}
/*
variable "aks_service_principal" {
  type      = map(string)
  sensitive = true
}
*/
variable "infra_vars" {
}
