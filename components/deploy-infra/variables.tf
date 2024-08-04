##
# Define variables for location, service principal for AKS and appgw VM Admin
##
variable "location" {
  type = map(string)
}

variable "infra_vars" {
}

variable "env" {
  type    = string
}

variable "app" {
  type = string
  default = "bm"
}