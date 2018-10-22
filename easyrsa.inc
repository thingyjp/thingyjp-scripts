easyrsa_device_csr_create () {
    UUID=$1
	EASYRSA_PKI=$EASYRSA_PKI_USER $EASYRSA --batch --req-cn=$UUID gen-req $UUID nopass >> $LOGFILE
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

        
