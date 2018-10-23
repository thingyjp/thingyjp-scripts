#!/bin/bash

source ./common.sh

set -e
set -u
#set -x

if [ "$#" -ne "3" ]; then
    echo "usage: $0 <device signing cert> <device signing private key> <intermediate certs>..."
    exit 1
fi

init

easyrsa_device_pki_doesntexist
easyrsa_device_pki_init

CACERT=$1
CAKEY=$2

$EASYRSA --pki-dir=$EASYRSA_PKI_DEVICE \
            --batch \
            --req-cn="dummy" \
            build-ca nopass subca
git_stamp $EASYRSA_PKI_DEVICE "ca created"
cp $CACERT $EASYRSA_PKI_DEVICE/ca.crt 
cp $CAKEY $EASYRSA_PKI_DEVICE/private/ca.key
rm $EASYRSA_PKI_DEVICE/reqs/ca.req
mkdir $EASYRSA_PKI_DEVICE/intermediates

for i in `seq 3 $#`; do
    cp ${!i} $EASYRSA_PKI_DEVICE/intermediates/
done

git_stamp $EASYRSA_PKI_DEVICE "installed signing certs"
