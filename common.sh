if [ -z "$THINGYJP_HOME" ]; then
	THINGYJP_HOME="$HOME/.thingyjp"
fi

THINGYJP_SELFSERVICEURL="http://localhost:5000"

EASYRSA=./easy-rsa/easyrsa3/easyrsa
EASYRSA_PKI_USER="$THINGYJP_HOME/pki_user"
EASYRSA_PKI_ROOT="$THINGYJP_HOME/pki_root"
EASYRSA_PKI_SERVER="$THINGYJP_HOME/pki_server"
EASYRSA_PKI_DEVICE="$THINGYJP_HOME/pki_device"
LOGFILE="$THINGYJP_HOME/log"

init () {
	if [ ! -d "$THINGYJP_HOME" ]; then
		mkdir "$THINGYJP_HOME"
	fi
}

easyrsa_pki_user_init () {
	if [ ! -d "$EASYRSA_PKI_USER" ]; then
		echo "user pki doesn't exist, creating..."
		EASYRSA_PKI=$EASYRSA_PKI_USER $EASYRSA init-pki >> $LOGFILE
	fi
}

easyrsa_pki_root_init () {
	if [ ! -d "$EASYRSA_PKI_ROOT" ]; then
		echo "root pki doesn't exist, creating..."
		EASYRSA_PKI=$EASYRSA_PKI_ROOT $EASYRSA init-pki >> $LOGFILE
	fi
}

easyrsa_pki_server_init () {
	if [ ! -d "$EASYRSA_PKI_SERVER" ]; then
		echo "server pki doesn't exist, creating..."
		EASYRSA_PKI=$EASYRSA_PKI_SERVER $EASYRSA init-pki >> $LOGFILE
	fi
}

easyrsa_pki_device_init () {
        if [ ! -d "$EASYRSA_PKI_DEVICE" ]; then
                echo "device pki doesn't exist, creating..."
                EASYRSA_PKI=$EASYRSA_PKI_DEVICE $EASYRSA init-pki >> $LOGFILE
        fi
}

easyrsa_pki_device_check () {
	if [ ! -d "$EASYRSA_PKI_DEVICE" ]; then
		echo "device pki isn't availble"
		exit 1
	fi
}

easyrsa_csr_device_create () {
	EASYRSA_PKI=$EASYRSA_PKI_USER $EASYRSA --batch --req-cn=$1 gen-req $1 nopass >> $LOGFILE
}
