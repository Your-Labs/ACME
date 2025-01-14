#!/bin/bash
force_load=${1:-0}
# ---------------------------------------------------------------
# check if the file is loaded(source) already
if [ -n "$_MYACME_LIBS_STRING_LOADED" ] && [ "$force_load" != "--force" ]; then
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
# FUNCTIONS
# ---------------------------------------------------------------
comma2space_trim() {
    # Replace commas with spaces and trim whitespace around each element
    # Usage: comma2space_trim <string> [trim_flag]
    local input="$1"
    local trim=${2:-1}
    local output=""

    # Early exit for empty input
    [ -z "$input" ] && {
        echo ""
        return
    }

    # Replace commas with spaces
    IFS=',' read -ra elements <<<"$input"

    # Loop through each element and trim spaces
    for element in "${elements[@]}"; do
        if [ "$trim" = "1" ]; then
            # Trim leading and trailing spaces using bash string manipulation
            element="${element#"${element%%[![:space:]]*}"}"
            element="${element%"${element##*[![:space:]]}"}"
        fi
        # Append to output
        output+="$element "
    done

    # Print the result with trailing space removed
    echo "${output%% }"
}

lines2comma() {
    # Convert lines to a comma-separated string
    # Usage: lines2comma <multiline-string> [trim_flag]
    #   multiline-string: A string with multiple lines
    #   trim_flag: Optional. 1 to trim whitespace from each line (default: 1)

    local input="$1"
    local trim=${2:-1} # Default to trimming whitespace
    local output=""
    # Read input line by line
    while IFS= read -r line; do
        # Trim whitespace if the flag is enabled
        if [ "$trim" = "1" ]; then
            line="${line#"${line%%[![:space:]]*}"}" # Remove leading spaces
            line="${line%"${line##*[![:space:]]}"}" # Remove trailing spaces
        fi

        # Append the line to the output, separated by a comma
        output+="$line,"
    done <<<"$input"

    # Remove trailing comma and print the result
    echo "${output%,}"
}

trim() {
    # Trim leading and trailing whitespace from a string
    # Usage: trim_string <string>
    local str="$1"
    # Bash parameter expansion to trim leading and trailing whitespace
    str="${str#"${str%%[![:space:]]*}"}" # remove leading whitespace characters
    str="${str%"${str##*[![:space:]]}"}" # remove trailing whitespace characters
    echo "$str"
}


bool2num() {
    # Convert boolean values to numbers
    # Usage: bool2num <boolean>
    #   boolean: A boolean value (true or false, case-insensitive), 'yes' or 'no' or '1' will be converted to 1, otherwise 0
    local bool="${1:-false}"
    bool_str=$(echo "$bool" | tr '[:upper:]' '[:lower:]')
    # Match boolean values
    case "$bool_str" in
    true | yes | on | 1)
        echo 1
        ;;
    *) echo 0 ;;
    esac
}

# ---------------------------------------------------------------
# Mark the file as loaded
export _MYACME_LIBS_STRING_LOADED=1
# ---------------------------------------------------------------
