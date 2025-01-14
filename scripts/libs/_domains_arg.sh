#!/bin/bash
force_load=${1:-0}
# ---------------------------------------------------------------
# check if the file is loaded(source) already
if [ -n "$_MYACME_LIBS_DOMAINS_LOADED" ] && [ "$force_load" != "--force" ]; then
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
# Function to convert domains to -d arguments
# usage: domains2args domain1 domain2 domain3 ...
# usage: domains2args domain1 domain2 domain3 ... true
# usage: domains2args domain1 domain2 domain3 ... false
domains2args() {
    local last_arg="${!#}"  # Get the last argument
    local include_wildcard=false  # default to false

    # check if the last argument is "true"
    if [ "$last_arg" == "true" ]; then
        include_wildcard=true
        # if the last argument is "true", then remove it from the list of domains
        local domains=("${@:1:$#-1}")
    elif [ "$last_arg" == "false" ]; then
        include_wildcard=false
        # if the last argument is "false", then remove it from the list of domains
        local domains=("${@:1:$#-1}")
    else
        # if the last argument is not "true", then use all the arguments as domains
        local domains=("$@")
    fi

    local args=""
    for domain in "${domains[@]}"; do
        args="$args --domain $domain"
        # if the last argument is "true", then add the wildcard domain
        if [ "$include_wildcard" == "true" ]; then
            args="$args --domain *.$domain"
        fi
    done

    echo "$args"
}


# ---------------------------------------------------------------
# Mark the file as loaded
export _MYACME_LIBS_DOMAINS_LOADED=1
# ---------------------------------------------------------------