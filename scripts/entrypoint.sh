#!/usr/bin/env bash

set +e
[[ "$DEBUG" == 'true' ]] && set -x

SOURCES_FILE="/myacme/source.sh"
[[ -f $SOURCES_FILE ]] && source $SOURCES_FILE


mylog "split" "============================================================="
config_num=$(count_sh $MYACME_ISSUES_CONFIG_DIR)
if [ $config_num -eq 0 ]; then
    mylog "info" "No issue configuration found in $MYACME_ISSUES_CONFIG_DIR"
    mylog "info" "Extracting the environment variables to issue the certificate"
else
    mylog "info" "Found $config_num issue configuration in $MYACME_ISSUES_CONFIG_DIR"
fi
mylog "split" "-------------------------------------------------------------"
mylog "info" "Start issuing the certificate"
source $MYACME_BIN_ISSUE
mylog "info" "Finish issuing the certificate"
mylog "split" "-------------------------------------------------------------"
if [ "$ACME_STARTUP_INSTALL_CERT" = 'true' ]; then
    mylog "info" "Start installing the certificate"
    source $MYACME_BIN_INSTALL_CERTS_DIR --config $MYACME_ISSUES_CONFIG_DIR --run-post-hook
    mylog "split" "-------------------------------------------------------------"
fi

echo "> Start at : $(date)"
echo "> crond -n -s -m off"
mylog "split" "-------------------------------------------------------------"
exec crond -n -s -m off
mylog "split" "============================================================="
