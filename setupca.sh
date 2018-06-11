#!/bin/bash

set -e

source ./common.sh

init
easyrsa_pki_root_init
easyrsa_pki_server_init
easyrsa_pki_device_init

createsubca () {
	EASYRSA_PKI=$1 $EASYRSA --batch --req-cn="$2" build-ca nopass subca
	EASYRSA_PKI=$EASYRSA_PKI_ROOT $EASYRSA --batch import-req $1/reqs/ca.req $3
	EASYRSA_PKI=$EASYRSA_PKI_ROOT $EASYRSA --batch sign-req ca $3
	cp $EASYRSA_PKI_ROOT/issued/$3.crt $1/ca.crt
}

EASYRSA_PKI=$EASYRSA_PKI_ROOT $EASYRSA --batch --req-cn="thingy.jp root CA" build-ca nopass

createsubca $EASYRSA_PKI_SERVER "thingy.jp server CA" "serverca"
createsubca $EASYRSA_PKI_DEVICE	"thingy.jp device CA" "deviceca"
