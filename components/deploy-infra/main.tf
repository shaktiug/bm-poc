
locals {
  infra_vars = ""
}

module "bm-infra" {
   for_each  = local.infra_vars
   source    = "../../modules/bm-infra"
   acr_name = ""
   aks_service_principal = ""
   pg_username = ""
   pg_password = ""
   ssl_status = "" 
   }