#!/bin/bash

source common.sh

set -e
#set -x
set -u

checkdeps
init
easyrsa_pki_user_init

UUID=`uuidgen`

echo "device uuid will be $UUID"
easyrsa_device_csr_create $UUID

JSON_REQUEST=`jo csr="$(cat $EASYRSA_PKI_USER/reqs/$UUID.req)"`

set +e
JSON_RESPONSE=`curl --silent --cacert "$THINGYJP_ROOTCERT" \
	-H "Content-Type: application/json" \
	-d "$JSON_REQUEST" "$THINGYJP_SELFSERVICEURL/device/commission"`
if [ "$?" -ne "0" ]; then
	echo "failed to request cert"
	easyrsa_device_csr_abort
	exit 1
fi

ERROR=`echo $JSON_RESPONSE | jq -r .error >\
        $EASYRSA_PKI_USER/issued/$UUID.crt`

if [ ! -z "$ERROR" ]; then
    echo "server returned error; $ERROR"
fi
set -e

ISSUEDCERT=$EASYRSA_PKI_USER/issued/device-$UUID.crt
echo $JSON_RESPONSE | jq -r .bundle >\
	$ISSUEDCERT

easyrsa_device_csr_finalise $UUID

echo "certificate issued and stored in $ISSUEDCERT"
