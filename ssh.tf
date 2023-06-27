# Create an SSH key
resource "tls_private_key" "management_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Write SSH private key to file
resource "local_file" "private_key" {
    content  = tls_private_key.management_ssh.private_key_pem
    filename = "id_rsa"
    file_permission = "0400"
}