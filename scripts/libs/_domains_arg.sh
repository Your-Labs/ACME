#!/bin/bash
force_load=${1:-0}
_is_main=$([[ -z $(caller 0) ]] && echo "true" || echo "false")
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
# Function to convert domains to --domain arguments
# Supports splitting domains by comma or space, and adding wildcard domains
domains2args() {
    local include_wildcard=false  # Default: no wildcard
    local last_arg="${!#}"        # Get the last argument
    local domains=()

    # Check if the last argument is "true" or "false"
    if [[ "$last_arg" == "true" ]]; then
        include_wildcard=true
        domains=("${@:1:$#-1}")  # Exclude the last argument
    elif [[ "$last_arg" == "false" ]]; then
        include_wildcard=false
        domains=("${@:1:$#-1}")  # Exclude the last argument
    else
        domains=("$@")           # Use all arguments as domains
    fi

    # Split the domains by comma or space if necessary
    if [[ "${#domains[@]}" -eq 1 ]]; then
        IFS=', ' read -r -a domains <<< "${domains[0]}"
    fi

    # Construct the --domain arguments
    local args=""
    for domain in "${domains[@]}"; do
        args+=" --domain $domain"
        if [[ "$include_wildcard" == "true" ]]; then
            args+=" --domain *.$domain"
        fi
    done

    # Trim and return the result
    echo "$args" | xargs
}
# ---------------------------------------------------------------
# Mark the file as loaded
export _MYACME_LIBS_DOMAINS_LOADED=1
# ---------------------------------------------------------------
