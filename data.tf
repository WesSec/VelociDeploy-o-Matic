data "azurerm_virtual_network" "IR_VPN_net" {
 name                      = var.mgmt-net
 resource_group_name       = var.mgmt-rg
}

data "azurerm_subnet" "velo-snet" {
 name                    = "Velociraptor_instances"
 resource_group_name     = var.mgmt-rg
 virtual_network_name    = var.mgmt-net
}