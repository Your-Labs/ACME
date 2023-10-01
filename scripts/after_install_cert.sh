#!/usr/bin/env bash
set +e

echo "-------------------------------------------------------------"
echo "> Executing ReloadCMD: $(date)"
echo "-------------------------------------------------------------"

[[ ! -z "$DEBUG" ]] && set -x

# echo "> Execute RELOAD_SHELL"

RELOAD_SHELL_DIR=/reload

chmod +x ${RELOAD_SHELL_DIR}/*.sh

ALL_SHELLS=$(ls -l $RELOAD_SHELL_DIR/ | awk '/^-.*[0-9][0-9][0-9]-.*\.sh$/ {print $NF}')

# echo "> All shell files: $ALL_SHELLS"
i=0
for SHELL_FILE in ${ALL_SHELLS[@]}; 
do
    i=$(expr ${i} + 1)
    echo "> Running Script $i: $SHELL_FILE"
    $RELOAD_SHELL_DIR/$SHELL_FILE || true
done
echo "> finished $i scripts"

echo "> Done"