##
# Create a resource group for the azure resources
##
resource "azurerm_resource_group" "my_rg" {
  name     = "rg-private-aks-demo"
  location = var.location.value
}