#!/bin/bash

source common.sh

set -e
set -u

init
easyrsa_device_pki_exists

CSR=/tmp/file

cat > $CSR

UUID=`openssl req -noout -subject -in $CSR | \
	grep -Po "(?<=CN = )[0-9,a-z]{8}-[0-9,a-z]{4}-[0-9,a-z]{4}-[0-9,a-z]{4}-[0-9,a-z]{12}"`

if [ -z "$UUID" ]; then
	exit 1;
fi

{
	easyrsa_device_csr_import $UUID $CSR
	easyrsa_device_csr_sign $UUID
} &>> $LOGFILE

openssl x509 -inform pem -in $EASYRSA_PKI_DEVICE/issued/$UUID.crt
for intermediate in $EASYRSA_PKI_DEVICE/intermediates/*.crt; do
    openssl x509 -inform pem -in $intermediate
done
openssl x509 -inform pem -in $EASYRSA_PKI_DEVICE/ca.crt
