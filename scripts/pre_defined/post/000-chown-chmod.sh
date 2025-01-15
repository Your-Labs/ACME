#!/bin/bash
# ---------------------------------------------------------------
# Pre Configuration
ROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
SOURCE_SH="$ROOT/source.sh"
[[ -f "$SOURCE_SH" ]] && source "$SOURCE_SH"
ROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
# ---------------------------------------------------------------
ACME_CERTS_PREMISSIONS=${ACME_CERTS_PREMISSIONS:-}
ACME_CERTS_UID=${ACME_CERTS_UID:-}
ACME_CERTS_GID=${ACME_CERTS_GID:-}
ACME_CERTS_DIR=${ACME_CERTS_DIR:-$ACME_INSTALL_CERT_DIR}
ACME_DRY_RUN=${ACME_DRY_RUN:-0}

# ---------------------------------------------------------------
if [ -z "$ACME_CERTS_DIR" ]; then
    mylog "warn" "ACME_CERTS_DIR is not set. Exiting."
    exit 0
fi


if [ -z "$ACME_CERTS_GID" ] && [ -z "$ACME_CERTS_UID" ]; then
    mylog "info" "ACME_CERTS_GID and ACME_CERTS_UID are not set"
    mylog "info" "No need to change permissions"

else
    if [ -z "$ACME_CERTS_GID" ]; then
        mylog "info" "ACME_CERTS_GID is not set"
        mylog "info" "No need to change permissions"
        ACME_CERTS_GID=$(stat -c %g $ACME_CERTS_DIR)
    fi
    if [ -z "$ACME_CERTS_UID" ]; then
        mylog "info" "ACME_CERTS_UID is not set"
        mylog "info" "No need to change permissions"
        ACME_CERTS_UID=$(stat -c %u $ACME_CERTS_DIR)
    fi
    mylog "info" "Changing permissions of "$ACME_CERTS_DIR" to $ACME_CERTS_UID:$ACME_CERTS_GID"
    cmd="chown -R $ACME_CERTS_UID:$ACME_CERTS_GID $ACME_CERTS_DIR"
    execute_command "$cmd" "Set permissions for $ACME_CERTS_DIR" "$DRY_RUN"
fi

if [ -z "$ACME_CERTS_PERMISSION" ]; then
    mylog "info" "ACME_CERTS_PERMISSION is not set"
    mylog "info" "No need to change permissions"
else
    mylog "info" "Changing permissions of "$ACME_CERTS_DIR" to $ACME_CERTS_PERMISSION"
    cmd="chmod -R $ACME_CERTS_PERMISSION $ACME_CERTS_DIR"
    execute_command "$cmd" "Set permissions for $ACME_CERTS_DIR" "$DRY_RUN"
fi


