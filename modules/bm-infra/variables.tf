##
# Define variables for location, service principal for AKS and appgw VM Admin
##
variable "location" {
  type = map(string)
}

variable "app" {
  type = string
  default = "bm"
}

variable "env" {
  type = string
}

variable "ado_password" {
  default = "Ishwar@123"
}
/*
variable "aks_service_principal" {
  type      = map(string)
  sensitive = true
}
*/
variable "infra_vars" {
}
