##
# Create a resource group for the azure resources
##
resource "azurerm_resource_group" "my_rg" {
  name     = "${local.infra_prefix}-rg"
  location = var.location.value
}