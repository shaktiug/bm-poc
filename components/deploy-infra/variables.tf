##
# Define variables for location, service principal for AKS and appgw VM Admin
##
variable "location" {
  type = map(string)
  default = {
    value  = "East US 2"
    suffix = "eastus2" # The corresponding value of location that is used by Azure in naming AKS resource groups
  }
}

variable "infra_vars" {
}

variable "env" {
  type    = string
}