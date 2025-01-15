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
ACME_DRY_RUN=${ACME_DRY_RUN:-0}
ACME_CERTS_FILE_NAMES=${ACME_CERTS_FILE_NAMES:-}

# ---------------------------------------------------------------
if [ -z "$ACME_CERTS_FILE_NAMES" ]; then
    mylog "warn" "ACME_CERTS_FILE_NAMES is not set. Exiting."
    exit 0
fi


if [ -z "$ACME_CERTS_GID" ] && [ -z "$ACME_CERTS_UID" ]; then
    mylog "info" "ACME_CERTS_GID and ACME_CERTS_UID are not set"
    mylog "info" "No need to change permissions"
else
    chown_files "$ACME_CERTS_UID" "$ACME_CERTS_GID" false "$ACME_DRY_RUN" "$ACME_CERTS_FILE_NAMES"
fi

if [ -z "$ACME_CERTS_PERMISSION" ]; then
    mylog "info" "ACME_CERTS_PERMISSION is not set"
    mylog "info" "No need to change permissions"
else
    chmod_files "$ACME_CERTS_PERMISSION" false "$ACME_DRY_RUN" "$ACME_CERTS_FILE_NAMES"
fi


