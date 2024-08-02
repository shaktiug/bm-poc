#
#Create an ado-agent VM
#

resource "azurerm_subnet" "vm_subnet" {
  name                 = "vm_subnet"
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.vnet_appgw.name
  address_prefixes     = ["10.0.4.0/24"]
}


resource "azurerm_public_ip" "pip_azure_ado-agent" {
  name                = "pip-azure-ado-agent"
  location            = var.location.value
  resource_group_name = azurerm_resource_group.my_rg.name

  allocation_method = "Static"
  sku               = "Standard"
}

#Create Network Security Group and rule
resource "azurerm_network_security_group" "ado-agent-nsg" {
  name                = "myNetworkSecurityGroup"
  location            = var.location.value
  resource_group_name = azurerm_resource_group.my_rg.name

}


resource "azurerm_network_security_rule" "ado-agent-rules" {
  for_each                    = local.nsgrules
  name                        = each.key
  direction                   = each.value.direction
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.my_rg.name
  network_security_group_name = azurerm_network_security_group.ado-agent-nsg.name

  depends_on = [azurerm_network_security_group.ado-agent-nsg]
}



resource "azurerm_network_interface" "ado-agent_nic" {
  name                = "nic-ado-agent"
  location            = var.location.value
  resource_group_name = azurerm_resource_group.my_rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_azure_ado-agent.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.ado-agent_nic.id
  network_security_group_id = azurerm_network_security_group.ado-agent-nsg.id
}


resource "azurerm_linux_virtual_machine" "ado-agent" {
  name                            = "vm-ado-agent"
  location                        = var.location.value
  resource_group_name             = azurerm_resource_group.my_rg.name
  size                            = "Standard_E2ads_v5"
  admin_username                  = "admin"
  admin_password                  = var.ado_password
  disable_password_authentication = false
  #custom_data                     = "I2Nsb3VkLWNvbmZpZwpwYWNrYWdlX3VwZ3JhZGU6IHRydWUKcnVuY21kOgogIC0gc3VkbyBhcHQgaW5zdGFsbCBvcGVuamRrLTgtamRrIC15CiAgLSB3Z2V0IC1xTyAtIGh0dHBzOi8vcGtnLmplbmtpbnMuaW8vZGViaWFuLXN0YWJsZS9qZW5raW5zLmlvLmtleSB8IHN1ZG8gYXB0LWtleSBhZGQgLQogIC0gc2ggLWMgJ2VjaG8gZGViIGh0dHBzOi8vcGtnLmplbmtpbnMuaW8vZGViaWFuLXN0YWJsZSBiaW5hcnkvID4gL2V0Yy9hcHQvc291cmNlcy5saXN0LmQvamVua2lucy5saXN0JwogIC0gc3VkbyBhcHQtZ2V0IHVwZGF0ZSAmJiBzdWRvIGFwdC1nZXQgaW5zdGFsbCBqZW5raW5zIC15CiAgLSBzdWRvIHNlcnZpY2UgamVua2lucyByZXN0YXJ0"
  network_interface_ids = [
    azurerm_network_interface.ado-agent_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16_04-lts-gen2"
    version   = "latest"
  }
}