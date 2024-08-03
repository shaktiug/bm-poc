resource "azurerm_public_ip" "appgwpip" {
  name                = "${local.infra_prefix}-appgw-pip"
  sku                 = "Standard"
  resource_group_name = azurerm_resource_group.my_rg.name
  location            = var.location.value
  allocation_method   = "Static"
}

resource "null_resource" "appgw-skeleton" {

  provisioner "local-exec" {
    command = <<-EOT
              az network application-gateway create -n bm-$env-aks-appgw -l $loc -g $rg --sku standard_v2 --public-ip-address $pip --vnet-name $vnet --subnet $subnet --priority 100
    EOT
    environment = {
      vnet   = "${azurerm_virtual_network.vnet_appgw.name}"
      subnet = "${azurerm_subnet.appgw_subnet.name}"
      loc    = "${var.location.suffix}"
      rg     = "${azurerm_resource_group.my_rg.name}"
      rgid   = "${azurerm_resource_group.my_rg.id}"
      pip    = "${azurerm_public_ip.appgwpip.name}"
      env    = "${var.env}"
    }
  }

  depends_on = [azurerm_subnet.appgw_subnet]
}


data "azurerm_application_gateway" "appgw" {
  name                = "${local.infra_prefix}-aks-appgw"
  resource_group_name = azurerm_resource_group.my_rg.name
  depends_on          = [null_resource.appgw-skeleton]
}


# data "azurerm_kubernetes_cluster" "aks_data" {
#   name                = "${local.infra_prefix}-aks"
#   resource_group_name = azurerm_resource_group.my_rg.name
#   depends_on          = [azurerm_kubernetes_cluster.my_aks]
# }

locals {
  aks_rg = azurerm_kubernetes_cluster.my_aks.node_resource_group
  local_appgw_id = data.azurerm_application_gateway.appgw.id
  aks_cluster_rg_id = azurerm_resource_group.my_rg.id
}

resource "azurerm_role_assignment" "role_managed_identity_operator" {
  scope                            = azurerm_resource_group.my_rg.id
  role_definition_name             = "Managed Identity Operator"
  principal_id                     = var.infra_vars.aks_service_principal.client_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "role_vm_contributor" {
  scope                            = azurerm_resource_group.my_rg.id
  role_definition_name             = "Virtual Machine Contributor"
  principal_id                     = var.infra_vars.aks_service_principal.client_id
  skip_service_principal_aad_check = true
}

resource "azurerm_user_assigned_identity" "aad-cid" {
  resource_group_name = local.aks_rg
  location            = var.location.value

  name = "aad-cId"
}

resource "azurerm_role_assignment" "role_aad_contributor" {
  scope                            = local.local_appgw_id  #scope is application gateway
  role_definition_name             = "Contributor"
  principal_id                     = azurerm_user_assigned_identity.aad-cid.principal_id   # aad-client-id
  skip_service_principal_aad_check = true

  depends_on = [azurerm_user_assigned_identity.aad-cid,null_resource.appgw-skeleton]
}
/*
resource "null_resource" "role-aad-contributor" {

  provisioner "local-exec" {
    command = <<-EOT
              #appgwId=$(az network application-gateway show -n bm-$env-aks-appgw -g $rg -o tsv --query "id")
              az role assignment create --role Contributor --assignee $aadId --scope $appgwId
    EOT
    environment = {
      appgwid = "${data.azurerm_application_gateway.appgw.id}"
      vnet   = "${azurerm_virtual_network.vnet_appgw.name}"
      subnet = "${azurerm_subnet.appgw_subnet.name}"
      loc    = "${var.location.suffix}"
      rg     = "${azurerm_resource_group.my_rg.name}"
      rgid   = "${azurerm_resource_group.my_rg.id}"
      pip    = "${azurerm_public_ip.appgwpip.name}"
      env    = "${var.env}"
      aadId = "${azurerm_user_assigned_identity.aad-cid.client_id}"
    }
  }

  depends_on = [azurerm_user_assigned_identity.aad-cid,null_resource.appgw-skeleton]
}
*/

resource "azurerm_role_assignment" "role_aad_reader" {
  scope                            = local.aks_cluster_rg_id
  role_definition_name             = "Reader"
  principal_id                     = azurerm_user_assigned_identity.aad-cid.principal_id
  skip_service_principal_aad_check = true
}