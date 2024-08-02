##
# Create Postgres Database
##

resource "azurerm_postgresql_flexible_server" "postgresdb" {
  name                         = "${local.infra_prefix}-db"
  resource_group_name          = azurerm_resource_group.my_rg.name
  location                     = var.location.value
  version                      = "12"
  delegated_subnet_id          = azurerm_subnet.snet_appgw_vm.id
  private_dns_zone_id          = azurerm_private_dns_zone.postgres_zone.id
  administrator_login          = var.infra_vars.pg_username
  administrator_password       = var.infra_vars.pg_password
  zone                         = "2"
  backup_retention_days        = "7"
  geo_redundant_backup_enabled = "true"
  storage_mb                   = 32768

  sku_name   = "B_Standard_B1ms"
  depends_on = [azurerm_private_dns_zone_virtual_network_link.postgres_link]

}

resource "azurerm_postgresql_flexible_server_configuration" "postgres_ssl" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.postgresdb.id
  value     = var.infra_vars.ssl_status
}