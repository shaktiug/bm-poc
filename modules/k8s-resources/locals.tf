variable "env" {
  type    = string
}


variable "values" {
  type    = string
}

locals {
    infra_prefix   = "bm-${var.env}"
    infra_acr_prefix   = "bm${var.env}"
}