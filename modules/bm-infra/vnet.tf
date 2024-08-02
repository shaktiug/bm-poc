##
# Create Vnet and subnet for the AKS cluster
##
resource "azurerm_virtual_network" "vnet_cluster" {
  name                = "vnet-private-aks-demo"
  location            = var.location.value
  resource_group_name = azurerm_resource_group.my_rg.name
  address_space       = ["10.1.0.0/16"]
}
resource "azurerm_subnet" "snet_cluster" {
  name                 = "snet-private-aks-demo"
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.vnet_cluster.name
  address_prefixes     = ["10.1.0.0/24"]
  # Enforce network policies to allow Private Endpoint to be added to the subnet
  enforce_private_link_endpoint_network_policies = true
}

##
# Create Vnet and subnet for the Appgw and Postgres
##
resource "azurerm_virtual_network" "vnet_appgw" {
  name                = "vnet-appgw-demo"
  location            = var.location.value
  resource_group_name = azurerm_resource_group.my_rg.name
  address_space       = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "snet_appgw_vm" {
  name                 = "snet-appgw-demo"
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.vnet_appgw.name
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}


##
# Create Vnet peering for the appgw and Postgres VM to be able to access the cluster Vnet and IPs
##
resource "azurerm_virtual_network_peering" "peering_appgw_cluster" {
  name                      = "peering_appgw_cluster"
  resource_group_name       = azurerm_resource_group.my_rg.name
  virtual_network_name      = azurerm_virtual_network.vnet_appgw.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_cluster.id
}
resource "azurerm_virtual_network_peering" "peering_cluster_appgw" {
  name                      = "peering_cluster_appgw"
  resource_group_name       = azurerm_resource_group.my_rg.name
  virtual_network_name      = azurerm_virtual_network.vnet_cluster.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_appgw.id
}