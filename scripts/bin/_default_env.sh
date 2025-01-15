#!/bin/bash
__DEFAULT_ENV_VERBOSE=${__DEFAULT_ENV_VERBOSE:-false}
# define default environment variables
declare -A default_values=(
    [ACME_ISSUE_ENABLE]="true"
    [ACME_DRY_RUN]="false"
    [ACME_DEBUG]="false"
    [ACME_ISSUE_FORCE]="false"
    [ACME_ISSUE_SERVER]="zerossl"
    [ACME_CA_MAIL]=""
    [ACME_ISSUE_KEY_LENGTH]="ec-256"
    [ACME_ISSUE_WILDCARD]="false"
    [ACME_DNS_PROVIDER]="dns_cf"
    [ACME_DNS_CONFIG_SH]=""
    [CF_Account_ID_FILE]=""
    [CF_Token_FILE]=""
    [CF_Zone_ID_FILE]=""
    [CF_Account_ID]=""
    [CF_Token]=""
    [CF_Zone_ID]=""
    [ACME_CERTS_PREMISSIONS]=""
    [ACME_CERTS_UID]=""
    [ACME_CERTS_GID]=""
    [ACME_INSTALL_CERT]="true"
    [ACME_INSTALL_CERT_DIR]="/certs"
    [ACME_INSTALL_CERT_UNIT_NAME]="false"
    [ACME_ISSUE_POST_HOOK_DIR]=""
    [ACME_ISSUE_POST_HOOK_DIABLE_PRE_DEFINED]="false"
    [ACME_ISSUE_PRE_HOOK_DIR]=""
    [ACME_ISSUE_PRE_HOOK_DIABLE_PRE_DEFINED]="false"
    [ACME_ISSUE_RENEW_HOOK_DIR]=""
    [ACME_ISSUE_RENEW_HOOK_DIABLE_PRE_DEFINED]="false"
    [ACME_CONTAINER_RESTART]=""
    [ACME_CONTAINER_NGINX_RELOAD]=""
)

_default_log() {
    local verbose=${1:-$__DEFAULT_ENV_VERBOSE}
    if [ "$verbose" = "true" ]; then
        echo "$2"
    fi
}

# set default values to environment and export
env2default() {
    local verbose=${1:-$__DEFAULT_ENV_VERBOSE}
    _default_log "$verbose" "Setting default values to environment variables"
    for key in "${!default_values[@]}"; do
        local env_value
        env_value=$(eval echo \$$key)
        export "${key}_DEFAULT=${env_value:-${default_values[$key]}}"
        _default_log "$verbose" "export ${key}_DEFAULT=${env_value:-${default_values[$key]}}"
    done
}

# reset environment variables to default values
default2env() {
    local verbose=${1:-$__DEFAULT_ENV_VERBOSE}
    _default_log "$verbose" "Resetting environment variables to default values"

    for key in "${!default_values[@]}"; do
        local default_key="${key}_DEFAULT"
        local default_value
        default_value=$(eval echo \$$default_key)
        export "$key=$default_value"
        _default_log "$verbose" "export $key=$default_value"
    done
}
