#!/bin/bash
# ---------------------------------------------------------------
# Pre Configuration
ROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
SOURCE_SH="$ROOT/source.sh"

if [ -f "$SOURCE_SH" ]; then
    source "$SOURCE_SH"
else
    mylog "warn" "Unable to find $SOURCE_SH file. Ignoring source.sh."
fi
ROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
# ---------------------------------------------------------------
MYACME_DOCKER_SOCKET=${MYACME_DOCKER_SOCKET:-"/var/run/docker.sock"}
ACME_CONTAINER_NGINX_RELOAD=""
ACME_DRY_RUN=${ACME_DRY_RUN:-0}
# ---------------------------------------------------------------
# Check if RESTART_CONTAINER_ID is set
if [ -z "$ACME_CONTAINER_NGINX_RELOAD" ]; then
    mylog "warn" "ACME_CONTAINER_NGINX_RELOAD is not set, skipping the reload"
    exit 0
fi
# call the docker_exec to reload the nginx
docker_exec $RESTART_CONTAINER_ID "nginx -s reload" "$MYACME_DOCKER_SOCKET" $ACME_DRY_RUN