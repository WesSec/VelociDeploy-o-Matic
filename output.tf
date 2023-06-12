output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.velovm.public_ip_address
}

output "public_domain" {
  value = azurerm_dns_a_record.dnsrecord.fqdn
}

output "tls_private_key" {
  value     = tls_private_key.management_ssh.private_key_pem
  sensitive = true
}