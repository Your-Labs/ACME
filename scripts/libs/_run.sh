#!/bin/bash
# ---------------------------------------------------------------
# check if the file is loaded(source) already
if [ -n "$_MYACME_LIBS_RUN_LOADED" ]; then
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
if [ -f "$EXEC_LOG_SOURCE_SH" ]; then
    source "$EXEC_LOG_SOURCE_SH"
else
    echo "Warn: Unable to find $EXEC_LOG_SOURCE_SH file"
    echo "Warn: Ignoring source.sh file"
fi
ROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
# ---------------------------------------------------------------

# Function to execute all scripts in the scripts directory
run_dir() {
    local scripts_dir=${1}
    local add_permission=${2:-0}
    local dry_run=${3:-0}
    local success_list=()
    local failure_list=()

    # Ensure the directory exists
    if [ ! -d "$scripts_dir" ]; then
        mylog "error" "Directory $scripts_dir does not exist."
        exit 1
    fi

    # Get all scripts with `.sh` extension
    local all_scripts
    all_scripts=$(find "$scripts_dir" -maxdepth 1 -name "[0-9]*.sh" -type f | sort)

    # Add Dry-Run argument if enabled
    local dry_run_arg=""
    if [ "$dry_run" -eq 1 ]; then
        dry_run_arg="--dry-run"
    fi

    # Execute scripts
    for script in $all_scripts; do
        local script_name=$(basename "$script")
        if [ "$add_permission" -eq 1 ]; then
            mylog "info" "Adding executable permission to: $script_name"
            execute_command "chmod +x $script" "Set executable permission for $script_name" "$dry_run"
        fi
        mylog "info" "Executing: $script_name"
        local cmd="source $script $dry_run_arg"
        if $cmd; then
            mylog "success" "Success: $script_name"
            success_list+=("$script_name")
        else
            mylog "error" "Failed: $script_name"
            failure_list+=("$script_name")
        fi
        mylog "split"
    done

    # Print execution summary if not in dry-run mode
    mylog "split" "\n===== Execution Report ====="
    if [ ${#success_list[@]} -gt 0 ]; then
        mylog "success" "Successful executions:"
        for file in "${success_list[@]}"; do
            echo "  - $file"
        done
    else
        mylog "warn" "No successful executions."
    fi

    if [ ${#failure_list[@]} -gt 0 ]; then
        mylog "error" "Failed executions:"
        for file in "${failure_list[@]}"; do
            echo "  - $file"
        done
    else
        mylog "success" "No failed executions."
    fi
    mylog "split" "============================="

}

count_sh() {
    local scripts_dir=${1}
    # Check if the directory exists
    if [ ! -d "$scripts_dir" ]; then
        echo "0"
        return 0
    fi
    # Find and count matching files
    local count
    count=$(find "$dir" -maxdepth 1 -name "[0-9]*.sh" -type f | wc -l)
    echo $count
    return 0
}

# ---------------------------------------------------------------
# Mark the file as loaded
export _MYACME_LIBS_RUN_LOADED=1
# ---------------------------------------------------------------
