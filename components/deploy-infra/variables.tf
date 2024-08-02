##
# Define variables for location, service principal for AKS and appgw VM Admin
##
variable "location" {
  type = map(string)
  default = {
    value  = "West Europe"
    suffix = "westeurope" # The corresponding value of location that is used by Azure in naming AKS resource groups
  }
}

variable "acr_name" {
  type = string
}


variable "aks_service_principal" {
  type      = map(string)
  sensitive = true
}

variable "pg_username" {
  type      = string
  sensitive = true
}

variable "pg_password" {
  type      = string
  sensitive = true
}

variable "ssl_status" {
  type = string
}