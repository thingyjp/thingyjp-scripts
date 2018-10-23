#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "usage; $0 FQDN"
	exit 1
fi

source common.sh

set -e
set -x
set -u

FQDN=$1

easyrsa_pki_server_check
easyrsa_pki_user_init

{
	$EASYRSA --pki-dir=$EASYRSA_PKI_USER \
		 --batch \
		 --req-cn=$FQDN \
		 --subject-alt-name='DNS:public.mqtt.thingy.jp' \
		gen-req $FQDN nopass

	$EASYRSA --pki-dir=$EASYRSA_PKI_SERVER \
		 --batch \
		 import-req $EASYRSA_PKI_USER/reqs/$FQDN.req $FQDN

	$EASYRSA --pki-dir=$EASYRSA_PKI_SERVER \
		 --batch \
		 sign-req server $FQDN
} &>> $LOGFILE

mkdir $EASYRSA_PKI_USER/issued
{
	openssl x509 -inform pem -in $EASYRSA_PKI_SERVER/issued/$FQDN.crt
	openssl x509 -inform pem -in $EASYRSA_PKI_SERVER/ca.crt
} > $EASYRSA_PKI_USER/issued/$FQDN.crt
