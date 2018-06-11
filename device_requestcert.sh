#!/bin/bash

set -e
set -x

source common.sh

init
easyrsa_pki_user_init

UUID=`uuidgen`

echo "device uuid will be $UUID"
easyrsa_csr_device_create $UUID

#TODO send request to self service here
