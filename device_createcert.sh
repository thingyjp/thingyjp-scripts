#!/bin/bash

set -e
set -x

if [ $# -ne 1 ]; then
	exit 1
fi

source common.sh

init
easyrsa_pki_device_check

cat > /tmp/file

EASYRSA_PKI=$EASYRSA_PKI_DEVICE $EASYRSA import-req /tmp/file $1
EASYRSA_PKI=$EASYRSA_PKI_DEVICE $EASYRSA --batch --req-cn="$1" sign-req client "$1"

cat $EASYRSA_PKI_DEVICE/issued/$1.crt
cat $EASYRSA_PKI_DEVICE/ca.crt
