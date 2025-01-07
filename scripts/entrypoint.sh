#!/usr/bin/env bash

set -e

export ACME_CERTS=/certs

[[ ! -z "$DEBUG" ]] && set -x

if [ -f "$CF_Account_ID_FILE" ]; then
    export CF_Account_ID=$(cat $CF_Account_ID_FILE)
fi

if [ -f "$CF_Token_FILE" ]; then
    export CF_Token=$(cat $CF_Token_FILE)
fi

if  [ -f "$CF_Zone_ID_FILE" ]; then
    export CF_Zone_ID=$(cat $CF_Zone_ID_FILE)
fi

SOURCES_FILE="/sources.sh"

if [ -f "$SOURCES_FILE" ]; then
    source $SOURCES_FILE
fi


# Set default values for the variables if not already set
ISSURE_CERT="${ISSURE_CERT:-true}"
INSTALL_CERT="${INSTALL_CERT:-true}"

# Execute ISSURE_CERT logic
if [ "$ISSURE_CERT" = "true" ] ; then
    echo "> Execute ISSURE_CERT"
    if [ -x /issure.sh ]; then
        /issure.sh || true
    else
        echo "Error: /issure.sh not found or not executable" >&2
    fi
fi

# Execute INSTALL_CERT logic
if [ "$INSTALL_CERT" = "true" ] ; then
    echo "> Execute INSTALL_CERT"
    if [ -x /install_cert.sh ]; then
        /install_cert.sh || true
    else
        echo "Error: /install_cert.sh not found or not executable" >&2
    fi
fi


if [ ! -z "$DEBUG" ]; then
    echo "=========================DEBUG=============================="
    echo "> CF_Token: $CF_Token"
    echo "> CF_Account_ID: $CF_Account_ID"
    echo "> CF_Zone_ID: $CF_Zone_ID"
    echo "> CA_EMAIL: $CA_EMAIL"
fi
echo "-------------------------------------------------------------"
echo "> Start at : $(date)"
echo "> crond -n -s -m off"
echo "============================================================="
exec crond -n -s -m off
