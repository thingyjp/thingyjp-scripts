#!/bin/bash

source common.sh

set -e
set -u
#set -x

checkdeps
init
easyrsa_user_pki_init

UUID=`uuidgen`

echo "device uuid will be $UUID"
easyrsa_device_csr_create $UUID

JSON_REQUEST=`jo csr="$(cat $EASYRSA_PKI_USER/reqs/device-$UUID.req)"`

set +e
JSON_RESPONSE=`curl --silent --cacert "$THINGYJP_ROOTCERT" \
	-H "Content-Type: application/json" \
	-d "$JSON_REQUEST" "$THINGYJP_SELFSERVICEURL/device/commission"`
if [ "$?" -ne "0" ]; then
	echo "failed to request cert"
	easyrsa_device_csr_abort
	exit 1
fi

ERROR=`echo $JSON_RESPONSE | jq -e -r .error`

if [ "$?" -eq "0" ]; then
    echo "server returned error; $ERROR"
    easyrsa_device_csr_abort
    exit 1
fi
set -e

ISSUEDCERT=$EASYRSA_PKI_USER/issued/device-$UUID.crt
echo $JSON_RESPONSE | jq -r .bundle >\
	$ISSUEDCERT

easyrsa_device_csr_finalise $UUID

echo "certificate issued and stored in $ISSUEDCERT"
