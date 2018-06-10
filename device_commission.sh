#!/bin/bash

set -e
set -x

source common.sh

init
easyrsa_pki_init

UUID=`uuidgen`

echo "device uuid will be $UUID"
easyrsa_create_csr $UUID

#TODO send request to self service here
