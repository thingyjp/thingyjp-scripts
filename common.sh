if [ -z "$THINGYJP_HOME" ]; then
	THINGYJP_HOME="$HOME/.thingyjp"
fi

THINGYJP_ROOTCERT=$THINGYJP_HOME/thingyjp_root.crt
THINGYJP_SELFSERVICEURL="http://selfservice.thingy.jp"

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

easyrsa_pki_init () {
	if [ ! -d "$2" ]; then
		echo "$1 pki doesn't exist, creating..."
		EASYRSA_PKI=$2 $EASYRSA init-pki >> $LOGFILE
		git -C $2 init
		git -C $2 add -A
		git -C $2 commit --allow-empty -a -m "create pki"
	fi
}

easyrsa_pki_user_init () {
	easyrsa_pki_init "user" $EASYRSA_PKI_USER
}

easyrsa_pki_root_init () {
	easyrsa_pki_init "root" $EASYRSA_PKI_ROOT
}

easyrsa_pki_server_init () {
	easyrsa_pki_init "server" $EASYRSA_PKI_SERVER
}

easyrsa_pki_device_init () {
	easyrsa_pki_init "device" $EASYRSA_PKI_DEVICE
}

easyrsa_pki_device_check () {
	if [ ! -d "$EASYRSA_PKI_DEVICE" ]; then
		echo "device pki isn't availble"
		exit 1
	fi
}

easyrsa_pki_server_check () {
	if [ ! -d "$EASYRSA_PKI_SERVER" ]; then
		echo "server pki isn't available"
		exit 1
	fi
}

easyrsa_pki_stamp () {
	git -C $2 add -A
	git -C $2 commit --allow-empty -a -m "$1"
}

easyrsa_pki_abort () {
	git -C $1 reset HEAD^
}

easyrsa_csr_device_create () {
	EASYRSA_PKI=$EASYRSA_PKI_USER $EASYRSA --batch --req-cn=$1 gen-req $1 nopass >> $LOGFILE
	easyrsa_pki_stamp "creating csr for $1" $EASYRSA_PKI_USER
}

easyrsa_csr_device_abort () {
	easyrsa_pki_abort $EASYRSA_PKI_USER
}
