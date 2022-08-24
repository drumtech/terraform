#!/bin/bash
stroka=$(curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" "https://api.digitalocean.com/v2/account/keys?per_page=200" | jq . | grep -B3 -A2 REBRAIN.SSH.PUB.KEY)
k=${stroka%?}
id=$(jq '.id' <<< "$k")
name=$(jq '.name' <<< "$k")
fingerprint=$(jq '.fingerprint' <<< "$k")
public_key=$(jq '.public_key' <<< "$k")
JSON="{\"id\":\"${id}\",\"public_key\":${public_key},\"name\":${name},\"fingerprint\":${fingerprint}}"
echo $JSON
