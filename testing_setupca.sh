#!/bin/bash

source ./common.sh

set -e
set -u
set -x

init

easyrsa_device_pki_doesntexist

easyrsa_test_pki_init
easyrsa_server_pki_init
easyrsa_device_pki_init

createsubca () {
	{
        SUBCAPKI=$1
        SUBCACN=$2
		$EASYRSA --pki-dir=$SUBCAPKI \
			 --batch \
		 	 --req-cn="$SUBCACN" \
		 	 build-ca nopass subca
		$EASYRSA --pki-dir=$EASYRSA_PKI_TEST \
			 --batch \
		 	import-req $SUBCAPKI/reqs/ca.req $SUBCACN
		$EASYRSA --pki-dir=$EASYRSA_PKI_TEST \
			 --batch \
		 	sign-req ca $SUBCACN
		cp "$EASYRSA_PKI_TEST/issued/$SUBCACN.crt" $SUBCAPKI/ca.crt
		git_stamp $SUBCAPKI "created subca $SUBCACN" 
	} &>> $LOGFILE
}

createsubca $EASYRSA_PKI_SERVER "serverca"
createsubca $EASYRSA_PKI_DEVICE "deviceca"

easyrsa_csr_create $EASYRSA_PKI_TEST localhost localhost
easyrsa_csr_sign_server $EASYRSA_PKI_TEST localhost localhost

ln -s $EASYRSA_PKI_TEST/ca.crt $THINGYJP_ROOTCERT
