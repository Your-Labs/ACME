#!/bin/bash

force_load=${1:-0}

# ---------------------------------------------------------------
# Check if the environment file is already loaded
if [ -n "$_MYACME_ENV_LOADED" ] && [ "$force_load" != "--force" ]; then
    return 0
fi

_VERBOSE=${_VERBOSE:-0}
# ---------------------------------------------------------------
# Function to safely export readonly environment variables
export_readonly_env_safe() {
    local var_name="$1"
    local new_value="$2"
    local verbose=${3:-0}
    # Check if the variable is readonly
    if declare -p "$var_name" 2>/dev/null | grep -q "declare -r"; then
        if [ "$verbose" -eq 1 ]; then
            echo "Variable $var_name is readonly. Skipping export."
        fi
        return
    fi
    # Export the variable and mark it as readonly
    export "$var_name=$new_value"
    readonly "$var_name"
    if [ "$verbose" -eq 1 ]; then
        echo "Variable $var_name exported and set to readonly."
    fi
    
}

# ---------------------------------------------------------------
# Set the project directory
ROOT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

# ---------------------------------------------------------------
# Set readonly environment variables
export_readonly_env_safe "MYACME_PROJECT_DIR" "$ROOT_DIR" $_VERBOSE
export_readonly_env_safe "MYACME_LIBS_DIR" "$MYACME_PROJECT_DIR/libs" $_VERBOSE
export_readonly_env_safe "MYACME_BIN_DIR" "$MYACME_PROJECT_DIR/bin" $_VERBOSE

# Bin-specific paths
export_readonly_env_safe "MYACME_BIN_EXEC_HOOK" "$MYACME_BIN_DIR/exec_hook" $_VERBOSE
export_readonly_env_safe "MYACME_BIN_INSTALL_CERT" "$MYACME_BIN_DIR/install_cert" $_VERBOSE
export_readonly_env_safe "MYACME_BIN_INSTALL_CERTS_DIR" "$MYACME_BIN_DIR/install_certs_dir" $_VERBOSE
export_readonly_env_safe "MYACME_BIN_EXEC_ISSUE" "$MYACME_BIN_DIR/exec_issue" $_VERBOSE
export_readonly_env_safe "MYACME_BIN_ISSUE" "$MYACME_BIN_DIR/issue" $_VERBOSE

# Pre-defined directories
export_readonly_env_safe "MYACME_PRE_DEFINED_DIR" "$MYACME_PROJECT_DIR/pre_defined" $_VERBOSE
mkdir -p "$MYACME_PRE_DEFINED_DIR"

export_readonly_env_safe "MYACME_PRE_DEFINED_POST_DIR" "$MYACME_PRE_DEFINED_DIR/post" $_VERBOSE
mkdir -p "$MYACME_PRE_DEFINED_POST_DIR"

export_readonly_env_safe "MYACME_PRE_DEFINED_PRE_DIR" "$MYACME_PRE_DEFINED_DIR/pre" $_VERBOSE
mkdir -p "$MYACME_PRE_DEFINED_PRE_DIR"

export_readonly_env_safe "MYACME_PRE_DEFINED_RENEW_DIR" "$MYACME_PRE_DEFINED_DIR/renew" $_VERBOSE
mkdir -p "$MYACME_PRE_DEFINED_RENEW_DIR"

# Issue configuration directory
export_readonly_env_safe "MYACME_ISSUES_CONFIG_DIR" "$MYACME_PROJECT_DIR/issues" $_VERBOSE
mkdir -p "$MYACME_ISSUES_CONFIG_DIR"

# Docker socket
export_readonly_env_safe "MYACME_DOCKER_SOCKET" "/var/run/docker.sock" $_VERBOSE

# ---------------------------------------------------------------
# Update PATH to include the bin directory
if [[ ":$PATH:" != *":$MYACME_BIN_DIR:"* ]]; then
    export PATH="$PATH:$MYACME_BIN_DIR"
fi

# ---------------------------------------------------------------
# Load additional libraries if available
LIBS_SOURCE_SH="$MYACME_LIBS_DIR/source.sh"
[[ -f $LIBS_SOURCE_SH ]] && source "$LIBS_SOURCE_SH" "$force_load"

# ---------------------------------------------------------------
# Mark the environment file as loaded
export _MYACME_ENV_LOADED=1
