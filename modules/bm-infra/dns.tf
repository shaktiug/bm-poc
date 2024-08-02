resource "azurerm_private_dns_zone" "postgres_zone" {
  name                = "${local.infra_prefix}-db.private.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.my_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_link" {
  name                  = "PostgresVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.postgres_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet_appgw.id
  resource_group_name   = azurerm_resource_group.my_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks_link" {
  name                  = "aksVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.postgres_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet_cluster.id
  resource_group_name   = azurerm_resource_group.my_rg.name
}