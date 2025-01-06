#!/bin/bash

# Default action, you should set this in your project
# Actions: start, stop, restart, pause, unpause, etc.
ACTION=""

# Check if ACTION_CONTAINER_ID is set
if [ -z "$ACTION_CONTAINER_ID" ]; then
    echo "ACTION_CONTAINER_ID is not set"
    exit 1
fi

if [ -z "$ACTION" ]; then
    echo "ACTION is not set"
    exit 1
fi

# Source the environment variables for the project
if [ -z "$SOURCES_FILE" ]; then
    SOURCES_FILE="/sources.sh"
fi

# Check if SOURCES_FILE exists before sourcing
if [ ! -f "$SOURCES_FILE" ]; then
    echo "Sources file not found: $SOURCES_FILE"
    exit 1
fi

source "$SOURCES_FILE"

# Execute the docker action
docker-action "$ACTION_CONTAINER_ID" "$ACTION"
