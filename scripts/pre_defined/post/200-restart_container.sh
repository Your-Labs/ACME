#!/bin/bash
# ---------------------------------------------------------------
# Pre Configuration
ROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
SOURCE_SH="$ROOT/source.sh"
[[ -f "$SOURCE_SH" ]] && source "$SOURCE_SH"
ROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
# ---------------------------------------------------------------
RESTART_CONTAINER_ID=${ACME_CONTAINER_RESTART:-}
ACME_DRY_RUN=${ACME_DRY_RUN:-0}
# ---------------------------------------------------------------
# Check if RESTART_CONTAINER_ID is set
if [ -z "$ACME_CONTAINER_RESTART" ]; then
    mylog "warn" "RESTART_CONTAINER_ID is not set, skipping the restart"
    exit 0
fi
# call the docker_ function to restart the container
docker_ $RESTART_CONTAINER_ID "restart" "$MYACME_DOCKER_SOCKET" $ACME_DRY_RUN