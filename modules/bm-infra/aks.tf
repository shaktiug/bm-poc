##
# Create the AKS Cluster
##
resource "azurerm_kubernetes_cluster" "my_aks" {
  name                = "${local.infra_prefix}-aks"
  location            = var.location.value
  resource_group_name = azurerm_resource_group.my_rg.name
  dns_prefix          = "${local.infra_prefix}-aks-cluster"
  # Make the cluster private
  private_cluster_enabled = false
  # Improve security using Azure AD, K8s roles and rolebindings. 
  # Each Azure AD user can gets his personal kubeconfig and permissions managed through AD Groups and Rolebindings
  role_based_access_control_enabled = true
  
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = "standard_d2ads_v5"
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 2
    vnet_subnet_id      = azurerm_subnet.snet_cluster.id
  }

  service_principal {
    client_id     = var.infra_vars.aks_service_principal.client_id
    client_secret = var.infra_vars.aks_service_principal.client_secret
  }
}

resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = var.infra_vars.aks_service_principal.client_id
  skip_service_principal_aad_check = true
}

resource "azurerm_container_registry" "acr" {
  name                = "${local.infra_acr_prefix}acr"
  resource_group_name = azurerm_resource_group.my_rg.name
  location            = var.location.value
  sku                 = "Standard"
  admin_enabled       = true
}