#!/usr/bin/env bash
set +e
[[ ! -z "$DEBUG" ]] && set -x

# COPY_TO=/etc/ssl/certs2
if [ -z "$ACME_HOST_CERTS" ]; then
    COPY_TO=/certs_on_host
else
    COPY_TO=$ACME_HOST_CERTS
fi
cp -f $ACME_CERTS/ca.pem $ACME_CERTS/ca.crt

cp -rf $ACME_CERTS/* $COPY_TO/

