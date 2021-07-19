#!/bin/bash

usage() {
    echo "Usage: $0 -p [file]" 1>&2
    exit 1
}

while getopts ":p:" option; do
    case "${option}" in
        p)
            p=${OPTARG}

            if [[ ! -f "p" ]]; then
                usage
            fi
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

SCRIPT_DIR=$(dirname $(readlink -f "$0"))
PROFILE_PATH="${p}"
LOG_PATH="${SCRIPT_DIR}/auto_delegate.log"

source ${PROFILE_PATH}

if [[ -z "$TX_PASSWD_CONFIRMATIONS" ]]; then
    TX_PASSWD_CONFIRMATIONS=1
fi

if [[ -z "TX_PASSWD_PRHASE" ]]; then
    TX_PASSWD_PRHASE="Enter keyring passphrase:"
fi

echo "Last running: $(date)" > "${LOG_PATH}"
echo "Log: ${LOG_PATH}"

while :
do
    if [[ "$KEYRING_BACKEND" = "test" || "$KEYRING_BACKEND" = "memory" ]]; then
        ${SCRIPT_DIR}/delegate.sh "${PROFILE_PATH}" >> "${LOG_PATH}" 2>&1
    else
        ${SCRIPT_DIR}/delegate.exp "${PROFILE_PATH}" "${PASSWD}" "${TX_PASSWD_CONFIRMATIONS}" "${TX_PASSWD_PRHASE}" >> "${LOG_PATH}" 2>&1
    fi

    echo "------ SLEEP 30s ------" >> "${LOG_PATH}"
    sleep 30
done
