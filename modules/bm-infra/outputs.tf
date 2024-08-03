output "aad-identity-resource-id" {
  value = azurerm_user_assigned_identity.aad-cid.id
}

output "aad-client-id" {
  value = azurerm_user_assigned_identity.aad-cid.client_id
}

output "aks-name" {
  value = azurerm_kubernetes_cluster.my_aks.name
}

output "aks-rg" {
  value = azurerm_resource_group.my_rg.name
}