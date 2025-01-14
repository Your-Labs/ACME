#!/bin/bash
force_load=${1:-0}
# ---------------------------------------------------------------
# check if the file is loaded(source) already
if [ -n "$_MYACME_LIBS_DNS_LOADED" ] && [ "$force_load" != "--force" ]; then
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
EXEC_LOG_SOURCE_SH="$MYACME_LIBS_DIR/_exec_log.sh"
[[ -f "$EXEC_LOG_SOURCE_SH" ]] && source "$EXEC_LOG_SOURCE_SH" $force_load
ROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
# ---------------------------------------------------------------

export_cf_env() {
    if [ -f "$CF_Account_ID_FILE" ]; then
        mylog "info" "CF_Account_ID_FILE: $CF_Account_ID_FILE exists, loading the content"
        export CF_Account_ID=$(cat $CF_Account_ID_FILE)
    fi

    if [ -f "$CF_Token_FILE" ]; then
        mylog "info" "CF_Token_FILE: $CF_Token_FILE exists, loading the content"
        export CF_Token=$(cat $CF_Token_FILE)
    fi

    if  [ -f "$CF_Zone_ID_FILE" ]; then
        mylog "info" "CF_Zone_ID_FILE: $CF_Zone_ID_FILE exists, loading the content"
        export CF_Zone_ID=$(cat $CF_Zone_ID_FILE)
    fi
}

# ---------------------------------------------------------------
# Mark the file as loaded
export _MYACME_LIBS_DNS_LOADED=1
# ---------------------------------------------------------------