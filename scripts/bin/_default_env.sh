#!/bin/bash

# 定义环境变量和默认值
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

# 从当前环境导入默认值
env2default() {
    for key in "${!default_values[@]}"; do
        local env_value
        env_value=$(eval echo \$$key)
        export "${key}_DEFAULT=${env_value:-${default_values[$key]}}"
    done
}

# 恢复默认值到环境
default2env() {
    for key in "${!default_values[@]}"; do
        local default_key="${key}_DEFAULT"
        local default_value
        default_value=$(eval echo \$$default_key)
        export "$key=$default_value"
    done
}