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
[[ -f "$EXEC_LOG_SOURCE_SH" ]] && source "$EXEC_LOG_SOURCE_SH"
ROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
# ---------------------------------------------------------------

# Function to execute all scripts in the scripts directory
# Usage: run_dir <scripts_dir> [use_source] [continue_on_exit] [add_permission] [dry_run]
#   scripts_dir: The directory containing the scripts to execute
#   use_source: Optional. 1 to use `source` to execute the script; 0 to use 'eval' (default: 1)
#   continue_on_exit: Optional. 1 to continue executing scripts even if one fails; 0 to stop on first failure (default: 1); used for source
#   add_permission: Optional. 1 to add executable permission to the script before executing; 0 to skip (default: 0)
#   dry_run: Optional. 1 to enable dry-run mode; 0 to disable (default: 0)
run_dir() {
    local scripts_dir=${1:-$MYNODE_LIBS_DIR/scripts}
    local use_source=${2:-1}
    local continue_on_exit=${3:-1}
    local add_permission=${4:-0}
    local dry_run=${5:-0}
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

    # Determine command for execution
    local exec_cmd=""
    if [ "$use_source" -eq 1 ]; then
        mylog "info" "Using source to execute scripts."
        exec_cmd="source"
    else
        mylog "info" "Using eval to execute scripts."
        exec_cmd="bash"
    fi

    # Execute scripts
    for script in $all_scripts; do
        local script_name=$(basename "$script")

        # Add executable permission if required
        if [ "$add_permission" -eq 1 ]; then
            mylog "info" "Adding executable permission to: $script_name"
            execute_command "chmod +x $script" "Set executable permission for $script_name" "$dry_run"
        fi

        # Construct the execution command
        local cmd="$exec_cmd $script $dry_run_arg"
        cmd=$(trim "$cmd")" --"

        # Execute script
        mylog "info" "Executing: $cmd"
        if [ "$use_source" -eq 1 ] && [ "$continue_on_exit" -eq 1 ]; then
            ($cmd) || {
                mylog "warn" "Skipped: $script_name due to exit 1"
                failure_list+=("$script_name")
                mylog "split"
                continue
            }
        else
            $cmd
        fi

        # Check execution result
        if [ $? -ne 0 ]; then
            mylog "error" "Failed: $script_name"
            failure_list+=("$script_name")
        else
            mylog "success" "Success: $script_name"
            success_list+=("$script_name")
        fi

        mylog "split"
    done

    # Print execution summary
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
    count=$(find "$scripts_dir" -maxdepth 1 -name "[0-9]*.sh" -type f | wc -l)
    echo $count
    return 0
}

# ---------------------------------------------------------------
# Mark the file as loaded
export _MYACME_LIBS_RUN_LOADED=1
# ---------------------------------------------------------------
