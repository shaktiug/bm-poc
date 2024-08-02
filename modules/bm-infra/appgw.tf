resource "azurerm_subnet" "appgw_subnet" {
  name                 = "appgw_subnet"
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.vnet_appgw.name
  address_prefixes     = ["10.0.3.0/24"]

  depends_on = [azurerm_virtual_network.vnet_appgw]
}


resource "azurerm_public_ip" "appgwpip" {
  name                = "appgw-pip"
  sku                 = "Standard"
  resource_group_name = azurerm_resource_group.my_rg.name
  location            = var.location.value
  allocation_method   = "Static"
}

resource "null_resource" "appgw-skeleton" {

  provisioner "local-exec" {
    command = <<-EOT
              az network application-gateway create -n aks-appgw -l $loc -g $rg --sku standard_v2 --public-ip-address $pip --subnet $subnet
    EOT
    environment = {
      subnet = "${azurerm_subnet.appgw_subnet.id}"
      loc    = "${var.location.suffix}"
      rg     = "${azurerm_resource_group.my_rg.name}"
      rgid   = "${azurerm_resource_group.my_rg.id}"
      pip    = "${azurerm_public_ip.appgwpip.name}"
    }
  }

  depends_on = [azurerm_subnet.appgw_subnet]
}


data "azurerm_application_gateway" "appgw" {
  name                = "aks-appgw"
  resource_group_name = azurerm_resource_group.my_rg.name
  depends_on          = [null_resource.appgw-skeleton]
}


data "azurerm_kubernetes_cluster" "aks_data" {
  name                = "aks-my-cluster"
  resource_group_name = azurerm_resource_group.my_rg.name
  depends_on          = [azurerm_kubernetes_cluster.my_aks]
}

resource "azurerm_role_assignment" "role_managed_identity_operator" {
  scope                            = azurerm_resource_group.my_rg.id
  role_definition_name             = "Managed Identity Operator"
  principal_id                     = var.aks_service_principal.client_id
  skip_service_principal_aad_check = true
}


resource "azurerm_role_assignment" "role_vm_contributor" {
  scope                            = azurerm_resource_group.my_rg.id
  role_definition_name             = "Virtual Machine Contributor"
  principal_id                     = var.aks_service_principal.client_id
  skip_service_principal_aad_check = true
}

resource "azurerm_user_assigned_identity" "aad-cid" {
  resource_group_name = data.azurerm_kubernetes_cluster.aks_data.node_resource_group
  location            = var.location.value

  name = "aad-cId"
}


resource "azurerm_role_assignment" "role_aad_contributor" {
  scope                            = data.azurerm_application_gateway.appgw.id
  role_definition_name             = "Contributor"
  principal_id                     = azurerm_user_assigned_identity.aad-cid.client_id
  skip_service_principal_aad_check = true
}


resource "null_resource" "role-aad-contributor" {

  provisioner "local-exec" {
    command = <<-EOT
              appgwId=$(az network application-gateway show -n aks-appgw -g rg-private-aks-demo -o tsv --query "id")
              az role assignment create --role Contributor --assignee $aadId --scope $appgwId
    EOT
    environment = {
      aadId = "${azurerm_user_assigned_identity.aad-cid.client_id}"
    }
  }

  depends_on = [azurerm_user_assigned_identity.aad-cid]
}

resource "azurerm_role_assignment" "role_aad_reader" {
  scope                            = azurerm_resource_group.my_rg.id
  role_definition_name             = "Reader"
  principal_id                     = azurerm_user_assigned_identity.aad-cid.client_id
  skip_service_principal_aad_check = true
}