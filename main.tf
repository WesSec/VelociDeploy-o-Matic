# Random pet name for azure instances
resource "random_pet" "rg-name" {
  prefix    = var.resource_group_name_prefix
}

# Random string for domain name
resource "random_string" "random" {
  length           = 8
  special          = false
  upper = false
}


# Create resource group
resource "azurerm_resource_group" "rg" {
  name      = random_pet.rg-name.id
  location  = var.resource_group_location
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "velovm" {
  name                  = var.vm_vm_name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.myterraformnic.id]
  size                  = "Standard_B2s"

  os_disk {
    name                 = "VeloDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = var.vm_vm_name
  admin_username                  = var.vm_vm_user
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.vm_vm_user
    public_key = tls_private_key.management_ssh.public_key_openssh
  }

 # boot_diagnostics {
 #   storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
 # }
  # Ansible provisioning
  # Do default updates and install python 
  # provisioner "remote-exec" {
  #   inline = ["sudo apt update", "sudo apt install python3 jq -y", "echo Done!"]
  # }

  #Create connection with previously generated ssh pk
  connection {
        host = self.public_ip_address
        user = var.vm_vm_user
        type = "ssh"
        private_key = tls_private_key.management_ssh.private_key_pem
        timeout = "4m"
        agent = false
    }
  
  #Run ansible playblook on dest, including disgusting provisioning step to change the DNS record after creation because TF doesn't let us do so
  provisioner "local-exec" {
    command = "./scripts/setup.sh ${self.public_ip_address} ${azurerm_network_interface.myterraformnic.private_ip_address} ${random_string.random.result} ${var.dns_domain} ${var.default_velo_user} ${var.vm_vm_user} ${var.app_clientid} ${var.app_clientsecret} ${var.tenantID} ${var.mgmt-rg} ${var.le_email}"
  }

  depends_on = [
    null_resource.post-destroy
  ]
}

resource "null_resource" "post-destroy" {
  triggers = {
    random_string      = random_string.random.result
    dns_domain         = var.dns_domain
  }
  provisioner "local-exec" {
    command = "./scripts/cleanup.sh ${self.triggers.random_string} ${self.triggers.dns_domain}"
    when    = destroy
  }
}