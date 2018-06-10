if [ -z "$THINGYJP_HOME" ]; then
	THINGYJP_HOME="$HOME/.thingyjp"
fi

EASYRSA=./easy-rsa/easyrsa3/easyrsa
EASYRSA_PKI="$THINGYJP_HOME/pki"

init () {
	if [ ! -d "$THINGYJP_HOME" ]; then
		mkdir "$THINGYJP_HOME"
	fi
}

easyrsa_pki_init () {
	if [ ! -d "$EASYRSA_PKI" ]; then
		echo "pki doesn't exist, creating..."
		EASYRSA_PKI=$EASYRSA_PKI $EASYRSA init-pki
	fi
}

easyrsa_create_csr () {
	EASYRSA_PKI=$EASYRSA_PKI $EASYRSA --batch --req-cn=$1 gen-req $1 nopass
}
