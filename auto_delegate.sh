#!/bin/bash

usage() {
    echo "Usage: $0 [-p <string>]" 1>&2
    exit 1
}

while getopts ":p:" option; do
    case "${option}" in
        p)
            p=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [[ -z "${p}" ]]; then
    usage
fi

PROFILE_PATH=${p}
LOG_PATH=${PWD}/auto_delegate.log

source ${PROFILE_PATH}

echo "Last running: $(date)" > ${LOG_PATH}
echo "Log: ${LOG_PATH}"

while :
do
    if [[ "$KEYRING_BACKEND" = "test" || "$KEYRING_BACKEND" = "memory" ]]; then
        ${PWD}/delegate.sh ${PROFILE_PATH} >> ${LOG_PATH} 2>&1
    else
        ${PWD}/delegate.exp ${PROFILE_PATH} ${PASSWD} >> ${LOG_PATH} 2>&1
    fi

    echo "------ SLEEP 30s ------" >> ${LOG_PATH}
    sleep 30
done
