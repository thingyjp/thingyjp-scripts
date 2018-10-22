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

        
