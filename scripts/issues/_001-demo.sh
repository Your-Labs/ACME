#!/bin/bash
# ---------------------------------------------------------------
# Must be set to true to enable this configuration
export ACME_ISSUE_ENABLE=false
# ---------------------------------------------------------------
# General configuration
export ACME_ISSUE_DOMAINS=
export ACME_ISSUE_WILDCARD=false
export ACME_ISSUE_FORCE=false
export ACME_ISSUE_SERVER=zerossl
export ACME_CA_MAIL=
export ACME_ISSUE_KEY_LENGTH=ec-256
# ---------------------------------------------------------------
# Debug configuration
export ACME_DRY_RUN=false
export ACME_DEBUG=false
# ---------------------------------------------------------------
# DNS Config
export ACME_DNS_PROVIDER=dns_cf
# if the 'ACME_DNS_PROVIDER' is not 'dns_cf', set the 'ACME_DNS_CONFIG_SH' to the dns provider shell script
export ACME_DNS_CONFIG_SH=
# otherwise, you can set
export CF_Account_ID_FILE=
export CF_Token_FILE=
export CF_Zone_ID_FILE=
# or you can set the values directly
export CF_Account_ID=
export CF_Token=
export CF_Zone_ID=
# ---------------------------------------------------------------
# Permissions
export ACME_CERTS_PREMISSIONS=
export ACME_CERTS_UID=
export ACME_CERTS_GID=
# ---------------------------------------------------------------
# Install cert
export ACME_INSTALL_CERT=true
export ACME_INSTALL_CERT_DIR="/certs"
export ACME_INSTALL_CERT_UNIT_NAME=false 
# ---------------------------------------------------------------
# hooks
# pre-issue hook
export ACME_ISSUE_POST_HOOK_DIR=
export ACME_ISSUE_POST_HOOK_DIABLE_PRE_DEFINED=false
# post-issue hook
export ACME_ISSUE_PRE_HOOK_DIR=
export ACME_ISSUE_PRE_HOOK_DIABLE_PRE_DEFINED=false
# renew hook
export ACME_ISSUE_RENEW_HOOK_DIR=
export ACME_ISSUE_RENEW_HOOK_DIABLE_PRE_DEFINED=false
# ---------------------------------------------------------------
# action to container
export ACME_CONTAINER_RESTART= #which container_id to restart, use comma to separate multiple container_id
export ACME_CONTAINER_NGINX_RELOAD= #which container_id of nginx to reload nginx, use comma to separate multiple container_id