#!/usr/bin/env bash
set -e
[[ ! -z "$DEBUG" ]] && set -x

# Set ACME_CERTS if not already set
ACME_CERTS=${ACME_CERTS:-/certs}

FULLCHAIN_FILE=$ACME_CERTS/fullchain.pem
KEY_FILE=$ACME_CERTS/key.pem
CERT_FILE=$ACME_CERTS/cert.pem
CA_FILE=$ACME_CERTS/ca.pem
RELOAD_SHELL=/after_install_cert.sh

INCLUDE_WILDCARD=${INCLUDE_WILDCARD:-"false"}
DOMAIN_ARG=$(/convert_to_d_args.sh $DOMAINS $INCLUDE_WILDCARD)

acme.sh --install-cert      $DOMAIN_ARG \
        --cert-file         $CERT_FILE \
        --ca-file           $CA_FILE \
        --key-file          $KEY_FILE \
        --fullchain-file    $FULLCHAIN_FILE \
        --reloadcmd         $RELOAD_SHELL

# Copy the certs as domain.pem and domain.key if we neet
COPY_AS_DOMAIN=${COPY_AS_DOMAIN:-false}
if [ "$COPY_AS_DOMAIN" == "true" ]; then
    for domain in $DOMAINS; do
        echo "Copying certificates for domain: $domain"
        cp $FULLCHAIN_FILE $ACME_CERTS/$domain.crt
        cp $KEY_FILE $ACME_CERTS/$domain.key
    done
fi