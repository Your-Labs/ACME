#!/usr/bin/env bash

set +e
[[ ! -z "$DEBUG" ]] && set -x

ACME_CERTS=${ACME_CERTS:-"/certs"}

if [ -z "$CERTS_GID" ] && [ -z "$CERTS_UID" ]; then
    echo "CERTS_GID and CERTS_UID are not set"
    echo "No need to change permissions"

else
    if [ -z "$CERTS_GID" ]; then
        echo "CERTS_GID is not set"
        echo "No need to change permissions"
        CERTS_GID=$(stat -c %g $ACME_CERTS)
    fi
    if [ -z "$CERTS_UID" ]; then
        echo "CERTS_UID is not set"
        echo "No need to change permissions"
        CERTS_UID=$(stat -c %u $ACME_CERTS)
    fi
    echo "Changing permissions of "$ACME_CERTS" to $CERTS_UID:$CERTS_GID"
    chown -R $CERTS_UID:$CERTS_GID $ACME_CERTS
fi

if [ -z "$CERTS_PERMISSION" ]; then
    echo "CERTS_PERMISSION is not set"
    echo "No need to change permissions"
else
    echo "Changing permissions of "$ACME_CERTS" to $CERTS_PERMISSION"
    chmod -R $CERTS_PERMISSION $ACME_CERTS
fi
