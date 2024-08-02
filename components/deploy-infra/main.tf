
locals {
  infra_vars = var.infra_vars[var.env]
}

module "bm-infra" {
  for_each   = local.infra_vars
  source     = "../../modules/bm-infra"
  infra_vars = local.infra_vars[each.key]
  env        = var.env
}