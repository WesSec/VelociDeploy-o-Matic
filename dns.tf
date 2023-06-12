# Create DNS A record to VM in parent Resource group, this is set in the general resource group which will not get destroyed by destroying another instance of velo
resource "azurerm_dns_a_record" "dnsrecord" {
  name                = random_string.random.result
  zone_name           = var.dns_domain
  resource_group_name = var.mgmt-rg
  ttl                 = 300
  records             = [azurerm_public_ip.myterraformpublicip.ip_address]
}

# Create DNS record for the gui interface
resource "azurerm_dns_a_record" "gui_dnsrecord" {
  name                = "gui.${random_string.random.result}"
  zone_name           = var.dns_domain
  resource_group_name = var.mgmt-rg
  ttl                 = 300
  records             = [azurerm_public_ip.myterraformpublicip.ip_address]
}