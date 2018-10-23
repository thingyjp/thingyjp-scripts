if [ -z "$THINGYJP_HOME" ]; then
	if [ -z "$HOME" ]; then
		echo "THINGYJP_HOME and HOME are not set, check your environment" >&2
		exit 1
	fi
	THINGYJP_HOME="$HOME/.thingyjp"
fi

THINGYJP_ROOTCERT=$THINGYJP_HOME/thingyjp_root.crt
THINGYJP_SELFSERVICEURL="http://selfservice.thingy.jp/wtf"

EASYRSA=./easy-rsa/easyrsa3/easyrsa
EASYRSA_PKI_USER="$THINGYJP_HOME/pki_user"
EASYRSA_PKI_ROOT="$THINGYJP_HOME/pki_root"
EASYRSA_PKI_SERVER="$THINGYJP_HOME/pki_server"
EASYRSA_PKI_DEVICE="$THINGYJP_HOME/pki_device"
LOGFILE="$THINGYJP_HOME/log"

source git.inc
source easyrsa.inc

init () {
	if [ ! -d "$THINGYJP_HOME" ]; then
		mkdir "$THINGYJP_HOME"
	fi
}

checkdeps () {
	set +e
	which curl &> /dev/null
	if [ "$?" -ne "0" ]; then
		echo "install curl"
		exit 1
	fi
	which uuidgen &> /dev/null
	if [ "$?" -ne "0" ]; then
		echo "install uuid-runtime"
		exit 1
	fi
	which jq &> /dev/null
	if [ "$?" -ne "0" ]; then
		echo "install jq"
		exit 1
	fi
	which jo &> /dev/null
	if [ "$?" -ne "0" ]; then
		echo "install jo"
		exit 1
	fi
	set -e
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



easyrsa_pki_server_check () {
	if [ ! -d "$EASYRSA_PKI_SERVER" ]; then
		echo "server pki isn't available"
		exit 1
	fi
}

