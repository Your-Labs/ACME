#!/bin/bash

# Check if RESTART_CONTAINER_ID is set
if [ -z "$RESTART_CONTAINER_ID" ]; then
    echo "RESTART_CONTAINER_ID is not set"
    exit 0
fi

# Source the Docker Action Script
source '/functions/docker-action.sh'

# call the docker-action function to restart the container
docker-action $RESTART_CONTAINER_ID "restart"