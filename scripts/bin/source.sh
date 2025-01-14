#!/bin/bash
force_load=${1:-0}
# ---------------------------------------------------------------
# Pre Configuration
# ---------------------------------------------------------------
SOURCE_ROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
_DEFAULT_ENC_SH="$SOURCE_ROOT/_default_env.sh"
[[ -f "$_DEFAULT_ENC_SH" ]] && source "$_DEFAULT_ENC_SH"

# If the MYACME_PROJECT_DIR is not set, set it
if [ -z "$MYACME_PROJECT_DIR" ]; then
    export MYACME_PROJECT_DIR=$(dirname "$SOURCE_ROOT")
fi
MYACME_PROJECT_SOURCE="$MYACME_PROJECT_DIR/source.sh"
[[ -f "$MYACME_PROJECT_SOURCE" ]] && source "$MYACME_PROJECT_SOURCE" $force_load

# If the MYACME_LIBS_DIR is not set, set it
if [ -z "$MYACME_LIBS_DIR" ]; then
    export MYACME_LIBS_DIR="$MYACME_PROJECT_DIR"/libs
fi
MYACME_LIBS_SOURCE="$MYACME_LIBS_DIR/source.sh"
[[ -f "$MYACME_LIBS_SOURCE" ]] && source "$MYACME_LIBS_SOURCE" $force_load
# ---------------------------------------------------------------


