#!/bin/bash
# ---------------------------------------------------------------
# Pre Configuration
ROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
SOURCE_SH="$ROOT/source.sh"
[[ -f "$SOURCE_SH" ]] && source "$SOURCE_SH"
ROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
# ---------------------------------------------------------------
ACME_CONTAINER_NGINX_RELOAD=""
ACME_DRY_RUN=${ACME_DRY_RUN:-0}
# ---------------------------------------------------------------
# Check if ACME_CONTAINER_NGINX_RELOAD is set
if [ -z "$ACME_CONTAINER_NGINX_RELOAD" ]; then
    mylog "warn" "ACME_CONTAINER_NGINX_RELOAD is not set, skipping the reload"
    exit 0
fi
# call the docker_exec to reload the nginx
docker_exec $ACME_CONTAINER_NGINX_RELOAD "nginx -s reload" "$MYACME_DOCKER_SOCKET" $ACME_DRY_RUN