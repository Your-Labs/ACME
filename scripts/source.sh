#!/bin/bash

# ---------------------------------------------------------------
# check if the file is loaded(source) already
if [ -n "$_MYACME_ENV_LOADED" ]; then
    return 0
fi

# set the project directory
ROOT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
# ================================================================
# set the readonly environment variables
export MYACME_PROJECT_DIR="$ROOT_DIR"
readonly MYACME_PROJECT_DIR

# set the libs directory
export MYACME_LIBS_DIR="$MYACME_PROJECT_DIR/libs"
readonly MYACME_LIBS_DIR

# set the bin directory
export MYACME_BIN_DIR="$MYACME_PROJECT_DIR/bin"
readonly MYACME_BIN_DIR
# set the exec_hook
export MYACME_BIN_EXEC_HOOK="$MYACME_BIN_DIR/exec_hook"
readonly MYACME_BIN_EXEC_HOOK
# set install_cert
export MYACME_BIN_INSTALL_CERT="$MYACME_BIN_DIR/install_cert"
readonly MYACME_BIN_INSTALL_CERT
# set exec_issue
export MYACME_BIN_EXEC_ISSUE="$MYACME_BIN_DIR/exec_issue"
readonly MYACME_BIN_EXEC_ISSUE
# set issue
export MYACME_BIN_ISSUE="$MYACME_BIN_DIR/issue"
readonly MYACME_BIN_ISSUE

# set the pre-defined directory
export MYACME_PRE_DEFINED_DIR="$MYACME_PROJECT_DIR/pre_defined"
readonly MYACME_PRE_DEFINED_DIR
mkdir -p "$MYACME_PRE_DEFINED_DIR"
export MYACME_PRE_DEFINED_POST_DIR="$MYACME_PRE_DEFINED_DIR/post"
readonly MYACME_PRE_DEFINED_POST_DIR
mkdir -p "$MYACME_PRE_DEFINED_POST_DIR"
export MYACME_PRE_DEFINED_PRE_DIR="$MYACME_PRE_DEFINED_DIR/pre"
readonly MYACME_PRE_DEFINED_PRE_DIR
mkdir -p "$MYACME_PRE_DEFINED_PRE_DIR"
export MYACME_PRE_DEFINED_RENEW_DIR="$MYACME_PRE_DEFINED_DIR/renew"
readonly MYACME_PRE_DEFINED_RENEW_DIR
mkdir -p "$MYACME_PRE_DEFINED_RENEW_DIR"

# set the issue configuration directory
export MYACME_ISSUES_CONFIG_DIR="$MYACME_PROJECT_DIR/issues"
readonly MYACME_ISSUES_CONFIG_DIR
mkdir -p "$MYACME_ISSUES_CONFIG_DIR"

# docker socket
export MYACME_DOCKER_SOCKET="/var/run/docker.sock"
readonly MYACME_DOCKER_SOCKET

# ================================================================
# Set the PATH
if [[ ":$PATH:" != *":$MYACME_BIN_DIR:"* ]]; then
    export PATH="$PATH:$MYACME_BIN_DIR"
fi

# ================================================================
# set some default environment variables
# see bin/issue
# ================================================================
# ---------------------------------------------------------------
# Mark the file as loaded
export _MYACME_ENV_LOADED=1
# ---------------------------------------------------------------
