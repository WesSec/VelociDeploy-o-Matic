#!/bin/bash

PUBIP=${1}        # ${self.public_ip_address}
PRIVIP=${2}       # ${azurerm_network_interface.myterraformnic.private_ip_address}
RANDSTR=${3}      # ${random_string.random.result}
DNSDOMAIN=${4}    # ${var.dns_domain}
VUSER=${5}        # ${var.default_velo_user}
SUSER=${6}        # ${var.vm_vm_user}
CLIENTID=${7}     # ${var.app_clientid}
CLIENTSEC=${8}    # ${var.app_clientsecret}
TENANTID=${9}     # ${var.tenantID}
MANAGRG=${10}     # ${var.mgmt-rg}
LEEMAIL=${11}     # ${var.mgmt-rg}

echo "Starting Provisioning of the Application with the following variables"
echo "Public IP: $PUBIP"
echo "Private IP: $PRIVIP"
echo "Random String: $RANDSTR"
echo "DNS Domain: $DNSDOMAIN"
echo "Velo User: $VUSER"
echo "VM User: $SUSER"
echo "Client ID: $CLIENTID"
echo "Client Secret: $CLIENTSEC"
echo "Tenant ID: $TENANTID"
echo "Management RG: $MANAGRG"


ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_TIMEOUT=120 ansible-playbook -u $SUSER -i "$PUBIP," --private-key id_rsa --extra-vars "tf_fqdn=$RANDSTR.$DNSDOMAIN tf_vm_user=$SUSER tf_default_user=$VUSER tf_client_id=$CLIENTID tf_client_secret=$CLIENTSEC tf_tenant_id=$TENANTID tf_le_email=$LEEMAIL" playbook.yml && \
echo "Setting DNS Records" && \
az network dns record-set a add-record -n gui.$RANDSTR -g $MANAGRG -z $DNSDOMAIN -a $PRIVIP && \
az network dns record-set a remove-record -n gui.$RANDSTR -g $MANAGRG -z $DNSDOMAIN -a $PUBIP && \

# Get current list of redirect uris
ID=$(az ad app list --display-name Velociraptor | grep appId | cut -d "\"" -f 4) &&\
array=$(az ad app show --id $ID | jq '.web.redirectUris') &&\

# Generate callback uri
url="https://gui.$RANDSTR.$DNSDOMAIN/auth/azure/callback" &&\

# Append new url to redirect uris
new_array=$(echo "$array" | jq --arg domain "$url" '. + [$domain] | join(" ")' | sed 's/"//g') &&\

# Push new list of redirect uris
az ad app update --id $(az ad app list --display-name Velociraptor | grep appId | cut -d "\"" -f 4) --web-redirect-uris $new_array &&\
echo "$RANDSTR" > ./scripts/.casename;