#!/usr/bin/env bash
set +e

echo "-------------------------------------------------------------"
echo "> Executing ReloadCMD: $(date)"
echo "-------------------------------------------------------------"

[[ ! -z "$DEBUG" ]] && set -x

# echo "> Execute RELOAD_SHELL"

exec_scripts_dir() {
    local scripts_dir=$1
    local message=${2:-"Executing scripts in $scripts_dir"}

    if [ ! -d $scripts_dir ]; then
        echo "> No scripts found in $scripts_dir"
        return
    fi

    echo "> $message"
    chmod +x $scripts_dir/*.sh
    local all_scripts=$(ls -l $scripts_dir | awk '/^-.*[0-9][0-9][0-9]-.*\.sh$/ {print $NF}')
    local i=0
    for script in ${all_scripts[@]}; do
        i=$(expr ${i} + 1)
        echo "> Running Script $i: $script"
        $scripts_dir/$script || true
    done
    echo "> finished $i scripts in $scripts_dir"
}


# Set ACME_CERTS if not already set
ACME_CERTS=${ACME_CERTS:-/certs}
FULLCHAIN_FILE=$ACME_CERTS/fullchain.pem
KEY_FILE=$ACME_CERTS/key.pem
CERT_FILE=$ACME_CERTS/cert.pem
CA_FILE=$ACME_CERTS/ca.pem

# Copy the certs as domain.pem and domain.key if we neet
COPY_AS_DOMAIN=${COPY_AS_DOMAIN:-"true"}
if [ "$COPY_AS_DOMAIN" == "true" ]; then
    echo "-----------"
    for domain in $DOMAINS; do
        echo "Copying certificates for domain: $domain"
        cp -f $FULLCHAIN_FILE $ACME_CERTS/$domain.crt
        cp -f $KEY_FILE $ACME_CERTS/$domain.key
    done
    echo "-----------"
fi


RELOAD_SHELL_DIR=/reload
RELOAD_SHELL_DIR_PRE=/pre_defined_reload

exec_scripts_dir $RELOAD_SHELL_DIR_PRE "Executing pre-defined scripts in $RELOAD_SHELL_DIR_PRE"
echo "-----------"
exec_scripts_dir $RELOAD_SHELL_DIR "Executing user-defined scripts in $RELOAD_SHELL_DIR"


echo "> Done"