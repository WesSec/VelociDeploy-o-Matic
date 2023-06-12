variable "mgmt-rg" {
  default = "Management_RG"
  description = "The name of the resource group that contains the management network."
}

variable "mgmt-net" {
  default = "IR_VPN_net"
  description = "The name of the management network."
}

variable "ssh-allowed-ip" {
  default = "<yourip>/32"
  description = "The external IP-address of the creator, so ssh connections can be established for provisioning."
}

variable "resource_group_name_prefix" {
  default       = "IR_case"
  description   = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_location" {
  default       = "westeurope"
  description   = "Location of the resource group."
}

variable "vm_vm_name" {
  default       = "velociraptor"
  description   = "Name of the virtual machine."
}

variable "vm_vm_user" {
  default       = "management"
  description   = "Name of the virtual machine admin user."
}

variable "default_velo_user" {
  default       = "<Email>"
  description   = "Email of the default user for velociraptor access (must exist in app registration tenant)"
}

variable "dns_domain"{
  default = "<Domain>"
  description = "name of the domain where velociraptor instances will be subhosted, best to use a domain for this that is not used somewhere else, you will need to change the nameservers."
}

variable "app_clientid" {
  default       = "<AppID>"
  description   = "Application (client) ID, can be found in the app registration you've created"
}

variable "app_clientsecret" {
  default       = "<SecretValue>"
  description   = "Secret value, to be created under Certificates & Secrets in the app registration"
}

variable "tenantID" {
  default       = "<TenantID>"
  description   = "TenantID, can be found in Tenant properties in Azure"
}

variable "le_email" {
  default       = "<Email>"
  description   = "Email for letsencrypt, expect a lot of noise here"
}
