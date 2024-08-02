locals {
    infra_prefix   = "${var.app}-${var.infra_vars.env}"
    infra_acr_prefix   = "${var.app}${var.infra_vars.env}"
}