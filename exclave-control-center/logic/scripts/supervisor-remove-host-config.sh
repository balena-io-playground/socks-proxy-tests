#!/bin/bash

sleep 30
source /root/.bashrc
echo $DUT_UUID

# https://www.balena.io/docs/reference/supervisor/supervisor-api/#patch-v1devicehost-config
echo "Removing Host-Configuration of DUT: "
SET_HOST_CONFIG=$(jq -n --arg du "$DUT_UUID" \
     '{ "uuid": $du, "method": "PATCH", "data": { "network": { "proxy": {}, "hostname": "" }}}')
curl -s --request POST \
     --url https://api.balena-cloud.com/supervisor/v1/device/host-config \
     --header "authorization: Bearer ${API_KEY}" \
     --header 'content-type: application/json' \
     --data "${SET_HOST_CONFIG}"

# https://www.balena.io/docs/reference/supervisor/supervisor-api/#get-v1devicehost-config
echo
echo "Current Host-config configuration of DUT:"

GET_HOST_CONFIG=$(jq -n --arg du "$DUT_UUID" '{ "uuid": $du, "method": "GET" }')
curl -s -X POST --header "Content-Type:application/json" \
     --header "authorization: Bearer ${API_KEY}" \
     --data "${GET_HOST_CONFIG}" \
     "https://api.balena-cloud.com/supervisor/v1/device/host-config" | jq
