#!/bin/bash
force_load=${1-0}
# ---------------------------------------------------------------
# Pre Configuration
# If the MYACME_LIBS_DIR is not set, set it
if [ -z "$MYACME_LIBS_DIR" ]; then
    SOURCE_ROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
    PRJ_ROOT=$(dirname $(dirname "$SOURCE_ROOT"))
    export MYACME_LIBS_DIR="$PRJ_ROOT"/libs
    readonly MYACME_LIBS_DIR
fi
# echo "MYACME_LIBS_DIR: $MYACME_LIBS_DIR"
# ---------------------------------------------------------------
# # Source the libraries
source "$MYACME_LIBS_DIR/source.sh" $force_load