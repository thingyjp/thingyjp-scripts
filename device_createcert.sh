#!/bin/bash

source common.sh

set -e
set -u

init
easyrsa_pki_device_check

CSR=/tmp/file

cat > $CSR

UUID=`openssl req -noout -subject -in $CSR | \
	grep -Po "(?<=CN = )[0-9,a-z]{8}-[0-9,a-z]{4}-[0-9,a-z]{4}-[0-9,a-z]{4}-[0-9,a-z]{12}"`

if [ -z "$UUID" ]; then
	exit 1;
fi

{
	$EASYRSA --pki-dir=$EASYRSA_PKI_DEVICE \
		 --batch \
		 import-req $CSR $UUID
	$EASYRSA --pki-dir=$EASYRSA_PKI_DEVICE \
		 --batch \
		 --req-cn="$UUID" \
		 sign-req client "$UUID"
} &>> $LOGFILE

openssl x509 -inform pem -in $EASYRSA_PKI_DEVICE/issued/$UUID.crt
openssl x509 -inform pem -in $EASYRSA_PKI_DEVICE/ca.crt
