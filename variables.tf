variable "ssh-allowed-ip" {
  default = "1.1.1.1/32"
  description = "The external IP-address of the creator, so ssh connections can be established for provisioning."
}

variable "gui-allowed-ip" {
  default = "1.1.1.1/32"
  description = "The external IP-address of the analysts, so the gui is only made available to that range."
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
  default       = "e@mail.com"
  description   = "Email of the default user for velociraptor access (must exist in app registration tenant)"
}

variable "app_clientid" {
  default       = "<clientid>"
  description   = "Application (client) ID, can be found in the app registration you've created"
}

variable "app_clientsecret" {
  default       = "<clientsecret>"
  description   = "Secret value, to be created under Certificates & Secrets in the app registration"
}

variable "tenantID" {
  default       = "<tenantid>"
  description   = "TenantID, can be found in Tenant properties in Azure"
}

variable "le_email" {
  default       = "dump@email.com"
  description   = "Email for letsencrypt, expect a lot of noise here"
}
