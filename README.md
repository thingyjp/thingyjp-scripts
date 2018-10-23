# thingy.jp scripts

## bootstrap.sh

Pull in the required submodules etc.

## testing_setupca.sh

Create a crappy CA setup that mirrors what thingy.jp's
self-service uses. This is for testing only and should
never be used.

## device_setup.sh

Creates a sub-CA for signing device certs and installs
the provided certs and keys.

## device_requestcert.sh

Generates a UUID for a new device, creates a CSR and then
sends it to self-service to get a certificate bundle that
can be installed onto the device.

## device_createcert.sh

Takes a CSR for a device in from stdin and outputs a cert
bundle with the device cert and the required intermediate
cert. This is for use by self-service and should never
be used.

## server_setup.h

Creates a sub-CA for signing server certs and installs
the provided certs and keys.

## server_createcert.sh

Takes the FQDN for the server as an argument and generates
a server cert signed with the server CA.

