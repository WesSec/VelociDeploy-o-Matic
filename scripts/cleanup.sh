#!/bin/bash

# Get the app and the current redirect URLS
ID=$(az ad app list --display-name Velociraptor | grep appId | cut -d "\"" -f 4)
array=$(az ad app show --id $ID | jq '.web.redirectUris')


# Domain to remove (passed as an argument)
RANDSTR="$1"
LOCATION="$2"
 
# Generate callback url
url="https://$RANDSTR.$LOCATION.cloudapp.azure.com/gui/auth/azure/callback"

echo Removing $url from app registration

# Remove the entry with the specified domain from the array
new_array=$(echo "$array" | jq --arg domain "$url" '. | map(select(. != $domain)) | join(" ")' | sed 's/"//g')
echo Pushing new list of approved domains: $new_array
# # # update the app array on azure
az ad app update --id $(az ad app list --display-name Velociraptor | grep appId | cut -d "\"" -f 4) --web-redirect-uris $new_array
