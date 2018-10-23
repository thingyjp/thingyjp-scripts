easyrsa_pki_init () {
	if [ ! -d "$2" ]; then
		echo "$1 pki doesn't exist, creating..."
		EASYRSA_PKI=$2 $EASYRSA init-pki >> $LOGFILE
		mkdir $2/issued
		git_init $1 $2
	fi
}

easyrsa_device_pki_init () {
	easyrsa_pki_init "device" $EASYRSA_PKI_DEVICE
}

easyrsa_device_pki_exists () {
	if [ ! -d "$EASYRSA_PKI_DEVICE" ]; then
		echo "device pki isn't availble"
		exit 1
	fi
}

easyrsa_device_pki_doesntexist () {
	if [ -d "$EASYRSA_PKI_DEVICE" ]; then
		echo "device pki exists"
		exit 1
	fi
}

easyrsa_device_csr_create () {
    UUID=$1
	EASYRSA_PKI=$EASYRSA_PKI_USER $EASYRSA --batch --req-cn=$UUID gen-req device-$UUID nopass &>> $LOGFILE
	git_stamp $EASYRSA_PKI_USER "creating csr for $UUID"
}

easyrsa_device_csr_abort () {
    git_abort $EASYRSA_PKI_USER
}

easyrsa_device_csr_finalise () {
    UUID=$1
	git_stamp $EASYRSA_PKI_USER "certificate received for $UUID"
}

easyrsa_device_csr_import () {
    UUID=$1
    CSR=$2
    $EASYRSA --pki-dir=$EASYRSA_PKI_DEVICE \
                --batch \
                import-req $CSR $UUID
    git_stamp $EASYRSA_PKI_DEVICE "imported csr for $UUID"
}

easyrsa_device_csr_sign () {
    UUID=$1
    $EASYRSA --pki-dir=$EASYRSA_PKI_DEVICE \
                --batch \
                --req-cn="$UUID" \
                sign-req client "$UUID"
    git_stamp $EASYRSA_PKI_DEVICE "signed csr for $UUID"
}

        
