#!/bin/bash

# Check if RESTART_CONTAINER_ID is set
if [ -z "$RESTART_CONTAINER_ID" ]; then
    echo "RESTART_CONTAINER_ID is not set"
    exit 0
fi

SOURCES_FILE=${SOURCES_FILE:-"/sources.sh"}
source "$SOURCES_FILE"
# Execute the docker action
docker-action "$RESTART_CONTAINER_ID" restart
