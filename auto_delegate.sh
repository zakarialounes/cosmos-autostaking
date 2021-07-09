#!/bin/bash

usage() { echo "Usage: $0 [-p <string>]" 1>&2; exit 1; }

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
    p="${PWD}/.profile"
fi

source ${p}

echo "Last running: $(date)" > ${PWD}/auto_delegate.log
echo "Log: ${PWD}/auto_delegate.log"

while :
do
    if [[ "$KEYRING_BACKEND" = "test" || "$KEYRING_BACKEND" = "memory" ]]; then
        ${PWD}/delegate.sh >> ${PWD}/output.log
    else
        ${PWD}/delegate.exp $(cat ${PWD}/.passwd) >> ${PWD}/auto_delegate.log
    fi

    echo "------ SLEEP 30s ------" >> ${PWD}/auto_delegate.log
    sleep 30
done
