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
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = IE
ST = Ireland
L = Dublin
O = ITACWT
OU = Software
CN = systeme.local

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = systeme.local
DNS.2 = *.systeme.local
EOF
openssl req -x509 -new -nodes -key "$KEY_FILE" -days 3650 -out "$PEM_FILE" -config "$CERT_NAME.cnf"