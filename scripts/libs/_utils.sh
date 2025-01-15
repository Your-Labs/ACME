#!/bin/bash
force_load=${1:-0}
_is_main=$([[ -z $(caller 0) ]] && echo "true" || echo "false")
# ---------------------------------------------------------------
# check if the file is loaded(source) already
if [ -n "$_MYACME_LIBS_UTILS_LOADED" ] && [ "$force_load" != "--force" ] && [ "$_is_main" != "true" ]; then
    echo "The file \"_utils.sh\" is already loaded."
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
STRING_SOURCE_SH="$MYACME_LIBS_DIR/_string.sh"
[[ -f "$EXEC_LOG_SOURCE_SH" ]] && source "$EXEC_LOG_SOURCE_SH" $force_load
[[ -f "$STRING_SOURCE_SH" ]] && source "$STRING_SOURCE_SH" $force_load
ROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
_is_main=$([[ -z $(caller 0) ]] && echo "true" || echo "false")
# ---------------------------------------------------------------
# FUNCTIONS
# ---------------------------------------------------------------

_get_path_type() {
    local path="$1"
    if [ -d "$path" ]; then
        echo "directory"
    elif [ -f "$path" ]; then
        echo "file"
    else
        echo ""
    fi
}

# Change the owner of the files
# Usage: chown_files <uid> <gid> <recurrence> <dry_run> <file1> [file2] [file3] ...
# Usage: chown_files <uid> <gid> <recurrence> <dry_run> <file1>,[file2],[file3] ...
# Usage: chown_files <uid> <gid> <recurrence> <dry_run> "<file1> [file2] [file3]" ...
chown_files() {
    local uid="${1:-}"
    local gid="${2:-}"
    local recurrence="$3"
    local dry_run=${4:-0}
    shift 4
    local files=("$@")

    if [ -z "$uid" ] && [ -z "$gid" ]; then
        mylog "warn" "Both UID and GID are not set, skipping..."
        return 0
    fi
    local args=''
    recurrence=$(is_true "$recurrence")
    if [ "$recurrence" = "true" ]; then
        args="-R"
    fi
    # Split the domains by comma or space if necessary
    if [[ "${#files[@]}" -eq 1 ]]; then
        IFS=', ' read -r -a files <<<"${files[0]}"
    fi
    local cmd=''
    local type=''
    local file_uid=''
    local file_gid=''
    for file in "${files[@]}"; do
        type=$(_get_path_type "$file")
        if [ -z "$type" ]; then
            mylog "warn" "The path \"$file\" does not exist, skipping..."
            continue
        fi
        file_uid=$(stat -c %u "$file" 2>/dev/null || echo "")
        file_gid=$(stat -c %g "$file" 2>/dev/null || echo "")

        # Fallback to current file owner/group if uid or gid is not set
        uid="${uid:-$file_uid}"
        gid="${gid:-$file_gid}"

        # Check if owner/group already matches
        if [ "$recurrence" != "true" ] && [ "$file_uid" = "$uid" ] && [ "$file_gid" = "$gid" ]; then
            mylog "info" "The owner of the $type \"$file\" is already \"$uid:$gid\", skipping..."
            continue
        fi
        # Prepare the chown command
        cmd="chown $args $uid:$gid \"$file\""
        message="Changing the owner of the $type \"$file\" to \"$uid:$gid\""

        execute_command "$cmd" "$message" "$dry_run"
    done
}

chmod_files() {
    local mode=$1
    local recurrence="${2:-false}"
    local dry_run="${3:-0}"
    shift 3
    local files=("$@")
    local arg=''

    # Determine if recurrence is enabled
    recurrence=$(is_true "$recurrence")
    if [[ "$recurrence" == "true" ]]; then
        arg="-R"
    fi

    # Split files if only one entry exists and it contains commas or spaces
    if [[ "${#files[@]}" -eq 1 ]]; then
        IFS=', ' read -r -a files <<<"${files[0]}"
    fi

    # Ensure files array is not empty
    if [[ "${#files[@]}" -eq 0 ]]; then
        mylog "warn" "No files provided for chmod operation, skipping..."
        return 0
    fi

    local cmd=''
    local type=''
    local file_mode=''
    for file in "${files[@]}"; do
        type=$(_get_path_type "$file")
        if [[ -z "$type" ]]; then
            mylog "warn" "The path \"$file\" does not exist, skipping..."
            continue
        fi

        # Check the current mode if not recursive
        if [[ "$recurrence" != "true" ]]; then
            file_mode=$(stat -c %a "$file" 2>/dev/null || echo "")
            if [[ "$file_mode" == "$mode" ]]; then
                mylog "info" "The mode of the $type \"$file\" is already \"$mode\", skipping..."
                continue
            fi
        fi

        # Construct and execute the chmod command
        cmd="chmod $arg $mode \"$file\""
        message="Changing the mode of the $type \"$file\" to \"$mode\""
        execute_command "$cmd" "$message" "$dry_run"
    done
}
# ---------------------------------------------------------------
# Mark the file as loaded
export _MYACME_LIBS_UTILS_LOADED=1
# ---------------------------------------------------------------
if [[ "$_is_main" = 'true' ]]; then
    # Test the functions
    echo "Test the functions"
    files1="/tmp/test1"
    files2="/tmp/test1,/tmp/test2"
    files3=(/tmp/test1 /tmp/test2)
    dry_run=1
    echo "Test chown_files"
    chown_files "" "11" false $dry_run $files1
    chown_files 1000 1000 true $dry_run $files2
    chown_files 1000 1000 true $dry_run "${files3[@]}"

    echo "Test chmod_files"
    chmod_files 755 false $dry_run $files1
    chmod_files 755 true $dry_run $files2
    chmod_files 755 true $dry_run "${files3[@]}"

fi
