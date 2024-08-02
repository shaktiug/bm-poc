locals {
nsgrules = {

    ssh = {
      name                       = "ssh"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "156.107.232.82/32"
      destination_address_prefix = "*"
    }
  }
}