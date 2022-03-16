#!/bin/bash
# Become a Certificate Authority

read -r -e -p "Type root certificate name: " -i "systeme-ca" CERT_NAME

KEY_FILE="$CERT_NAME.key"
while test -f "$KEY_FILE"; do
    read -r -p "$KEY_FILE exists. Rewrite it? [y\n]: " CONFIRMATION
    if [ "$CONFIRMATION" = "y" ]; then break 2; fi
    if [ "$CONFIRMATION" = "n" ]; then exit; fi
done

printf "Generate private key\n"
openssl genrsa -des3 -out "$KEY_FILE" 2048

PEM_FILE="$CERT_NAME.pem"
while test -f "$PEM_FILE"; do
    read -r -p "$PEM_FILE exists. Rewrite it? [y\n]: " CONFIRMATION
    if [ "$CONFIRMATION" = "y" ]; then break 2; fi
    if [ "$CONFIRMATION" = "n" ]; then exit; fi
done

printf "Generate root certificate\n"
>$CERT_NAME.cnf cat <<-EOF
[ req ]
distinguished_name=dn
prompt=no

[ dn ]
countryName=IE
stateOrProvinceName=Ireland
localityName=Dublin
organizationName=ITCWTLocal
organizationalUnitName=Software
commonName=localhost
EOF
openssl req -x509 -new -nodes -key "$KEY_FILE" -sha256 -days 3650 -out "$PEM_FILE" -config "$CERT_NAME.cnf"