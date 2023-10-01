#!/usr/bin/env bash
set +e
[[ ! -z "$DEBUG" ]] && set -x

# COPY_TO=/etc/ssl/certs2
if [ -z "$ACME_HOST_CERTS" ]; then
    COPY_TO=/certs_on_host
else
    COPY_TO=$ACME_HOST_CERTS
fi


CERT_FILE=$ACME_CERTS/cert.pem
DHPARAM_FILR=$ACME_CERTS/dhparam.pem
if [[ ! -f $DHPARAM_FILR ]]; then
    echo "Generating dhparam file..."
    openssl dhparam -out $DHPARAM_FILR 2048
else
    echo "dhparam file already exists"
fi
# openssl dhparam -out $DHPARAM_FILR -outform PEM -2 2048 -pubin -in $CERT_FILE
# openssl dhparam -out /certs/dhparam.pem -outform PEM -2 2048 -pubin -in /certs/cert.pem  -inform PEM