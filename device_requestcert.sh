#!/bin/bash

source common.sh

set -e
set -x
set -u

init
easyrsa_pki_user_init

UUID=`uuidgen`

echo "device uuid will be $UUID"
easyrsa_csr_device_create $UUID

#TODO send request to self service here

JSON=`jo csr="$(cat $EASYRSA_PKI_USER/reqs/$UUID.req)"`
curl -H "Content-Type: application/json" -d "$JSON" "$THINGYJP_SELFSERVICEURL/device/commission"
