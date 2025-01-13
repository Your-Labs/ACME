#!/bin/bash

# ---------------------------------------------------------------
# check if the file is loaded(source) already
if [ -n "$_MYACME_LIBS_ALL_LOADED" ]; then
    return 0
fi
# ---------------------------------------------------------------
# Pre Configuration
# If the MYACME_LIBS_DIR is not set, set it
if [ -z "$MYACME_LIBS_DIR" ]; then
    SOURCE_ROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
    export MYACME_LIBS_DIR=$SOURCE_ROOT
    readonly MYACME_LIBS_DIR
fi
# echo "MYACME_LIBS_DIR: $MYACME_LIBS_DIR"
# ---------------------------------------------------------------
# if the MYACME_LIBS_DIR does not exist, exit the script
if [ ! -d "$MYACME_LIBS_DIR" ]; then
    echo "Error: MYACME_LIBS_DIR not found: $MYACME_LIBS_DIR"
    exit 1
fi

# Load all the libraries which name starts with _
for file in "$MYACME_LIBS_DIR"/_*.sh; do
    if [ -f "$file" ]; then
        # echo "Sourcing: $file"
        source "$file" || {
            echo "Failed to source $file"
            exit 1
        }
    else
        echo "No matching files found in $MYACME_LIBS_DIR"
    fi
done

# ---------------------------------------------------------------
# set the flag to indicate all libs are loaded
export _MYACME_LIBS_ALL_LOADED=1
# ---------------------------------------------------------------