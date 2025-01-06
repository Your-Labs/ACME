#!/bin/bash

# This script is used to source the environment variables for the project

# Set ACME_ROOT if not already set
if [ -z "$ACME_ROOT" ]; then
    ACME_ROOT="/root/acme.sh"
fi

# Check if ACME_ROOT is a valid directory
if [ ! -d "$ACME_ROOT" ]; then
    echo "ACME_ROOT is not a valid directory: $ACME_ROOT"
    echo "No Action Taken"
else
    # Set DEPLOY_DIR based on ACME_ROOT
    DEPLOY_DIR="$ACME_ROOT/deploy"

    # Example deploy sources string (uncomment and modify as needed)
    # ACME_DEPLOY_SOURCES="docker.sh apache.sh nginx.sh"

    # Source each deploy script if ACME_DEPLOY_SOURCES is set
    if [ ! -z "$ACME_DEPLOY_SOURCES" ]; then
        # Convert the string to an array using space as a delimiter
        IFS=' ' read -r -a deploy_sources_array <<< "$ACME_DEPLOY_SOURCES"

        for i in "${deploy_sources_array[@]}"; do
            source "$DEPLOY_DIR/$i"
        done
    fi
fi

# Set FUNCTIONS_DIR if not already set
if [ -z "$FUNCTIONS_DIR" ]; then
    FUNCTIONS_DIR="/functions"
fi

# Check if FUNCTIONS_DIR is a valid directory
if [ ! -d "$FUNCTIONS_DIR" ]; then
    echo "FUNCTIONS_DIR is not a valid directory: $FUNCTIONS_DIR"
    echo "No Action Taken"
else
    # Source all shell script files in FUNCTIONS_DIR
    for script in "$FUNCTIONS_DIR"/*.sh; do
        if [ -f "$script" ]; then
            echo "Sourcing $FUNCTIONS_DIR/$script"
            source "$script"
        fi
    done
fi
