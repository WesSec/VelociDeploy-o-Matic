# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "SecurityGroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Security Rule for SSH access
resource "azurerm_network_security_rule" "inbound_ssh" {
  name                       = "SSH"
  priority                   = 1001
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"  
  source_address_prefix      = var.ssh-allowed-ip
  destination_address_prefix = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.myterraformnsg.name
}

# Security Rule for port 443 and 80
resource "azurerm_network_security_rule" "inbound_traffic" {
  name                       = "Inbound80_443"
  priority                   = 1002
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.myterraformnsg.name
}