#!/bin/bash

# ---------------------------------------------------------------
# Pre Configuration
# If the MYACME_LIBS_DIR is not set, set it
if [ -z "$MYACME_LIBS_DIR" ]; then
    SOURCE_ROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
    export MYACME_LIBS_DIR=$(dirname $(dirname "$SOURCE_ROOT")/libs)
    readonly MYACME_LIBS_DIR
fi
# echo "MYACME_LIBS_DIR: $MYACME_LIBS_DIR"
# ---------------------------------------------------------------
# # Source the libraries
source "$MYACME_LIBS_DIR/source.sh"
MYACME_DOCKER_SOCKET=${MYACME_DOCKER_SOCKET:-"/var/run/docker.sock"}
