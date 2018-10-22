#!/bin/bash

source common.sh

set -e
set -x
set -u

checkdeps
init
easyrsa_pki_user_init

UUID=`uuidgen`

echo "device uuid will be $UUID"
easyrsa_csr_device_create $UUID

JSON_REQUEST=`jo csr="$(cat $EASYRSA_PKI_USER/reqs/$UUID.req)"`

set +e
JSON_RESPONSE=`curl --cacert "$THINGYJP_ROOTCERT" \
	-H "Content-Type: application/json" \
	-d "$JSON_REQUEST" "$THINGYJP_SELFSERVICEURL/device/commission"`
if [ "$?" -ne "0" ]; then
	echo "failed to request cert"
	easyrsa_csr_device_abort
	exit 1
fi
set -e

echo $JSON_RESPONSE | jq -r .bundle >\
	$EASYRSA_PKI_USER/issued/$UUID.crt

easyrsa_csr_device_finalise $UUID
