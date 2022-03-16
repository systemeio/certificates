#!/bin/bash
# Create CA-signed cert
read -r -e -p "Type domain name: " -i "systeme.local" DOMAIN_NAME
read -r -e -p "Type CA name. It's used to find key/pem files and sign certificates that used in nginx: " -i "systeme-ca" CA_NAME

CA_KEY_FILE="$CA_NAME.key"
if [ ! -f "$CA_KEY_FILE" ]; then
  printf "%s does not exist\n" "$CA_KEY_FILE"
  exit
fi

CA_PEM_FILE="$CA_NAME.pem"
if [ ! -f "$CA_PEM_FILE" ]; then
  printf "%s does not exist\n" "$CA_PEM_FILE"
  exit
fi

printf "Generate a private key\n"
openssl genrsa -out "$DOMAIN_NAME.key" 2048

printf "Create a certificate-signing request\n"
openssl req -new -key "$DOMAIN_NAME.key" -out "$DOMAIN_NAME.csr" -config "$CA_NAME.cnf"

printf "Create a config file for the extensions\n"
>$DOMAIN_NAME.ext cat <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1=$DOMAIN_NAME
DNS.2=*.$DOMAIN_NAME
EOF

echo $CA_PEM_FILE
echo $CA_KEY_FILE

# Create the signed certificate
openssl x509 -req -in "$DOMAIN_NAME.csr" -CA "$CA_PEM_FILE" -CAkey "$CA_KEY_FILE" -CAcreateserial -out "$DOMAIN_NAME.crt" -days 825 -sha256 -extfile "$DOMAIN_NAME.ext"
