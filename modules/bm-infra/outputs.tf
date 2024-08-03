output "aad-identity-resource-id" {
  value = azurerm_user_assigned_identity.aad-cid.id
}

output "aad-client-id" {
  value = azurerm_user_assigned_identity.aad-cid.client_id
}
