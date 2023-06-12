# Create public IPs
resource "azurerm_public_ip" "myterraformpublicip" {
  name                = random_pet.rg-name.id
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}


##########################################
# Uncomment this for non VPN Setup (WIP) #
##########################################

# resource "azurerm_virtual_network" "velo_vnet" {
#   name                = "network"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
# }

# resource "azurerm_subnet" "velo_subnet" {
#   name                 = "internal"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.velo_vnet.name
#   address_prefixes     = ["10.0.2.0/24"]
# }

########################
# End of non-vpn setup #
########################

# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
  name                = "velociNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "velocNICConfiguration"
    # VPN Setup (change to vpn subnet name)
    subnet_id                     = data.azurerm_subnet.velo-snet.id
    # Non VPN Setup
    #subnet_id                     = azurerm_subnet.velo_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.myterraformnic.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}