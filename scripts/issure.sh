#!/usr/bin/env sh

set -e

ISSURE_DEBUG=""
if [[ ! -z "$DEBUG" ]]; then
    set -x
    ISSURE_DEBUG="--debug"
fi

ISSURE_FORCE=${ISSURE_FORCE:-"false"}
if [ "$ISSURE_FORCE" = "true" ]; then
    FORCE="--force"
fi

if [ -z "$ISSURE_SERVER" ]; then
    echo "> ISSURE_SERVER is empty, use default value: zerossl"
    ISSURE_SERVER="zerossl"
fi

if [ $ISSURE_SERVER = "zerossl" ] && [ ! -z "$ZEROSSL_MAIL" ]; then
    acme.sh --register-account -m $ZEROSSL_MAIL --server zerossl
fi

if [ -z $ISSURE_KEY ]; then
    echo "> ISSURE_KEY is empty, use default value: ec-256"
    echo "> You can set ISSURE_KEY to change it, like: -e ISSURE_KEY=ec-256."
    echo "> You can chose one of: [2048, 3072, 4096, 8192 or ec-256, ec-384, ec-521]."
    ISSURE_KEY="ec-256"
fi
ISSURE_KEY_ARG="--keylength $ISSURE_KEY"

if [ -z "$DNS_PROVIDER" ]; then
    $DNS_PROVIDER="dns_cf"
fi

if [ -z "$INCLUDE_WILDCARD" ]; then
    INCLUDE_WILDCARD="false"
fi
DOMAIN_ARG=$(/convert_to_d_args.sh $DOMAINS $INCLUDE_WILDCARD)

acme.sh --set-default-ca --server $ISSURE_SERVER


acme.sh --issue $DOMAIN_ARG \
        --dns $DNS_PROVIDER \
        $ISSURE_KEY_ARG $FORCE $ISSURE_DEBUG

# acme.sh --issue -d myladder.top -d "*.myladder.top" --dns dns_cf --debug
