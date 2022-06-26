usage() {
    echo "Usage: $0 -p [file]" 1>&2
    exit 1
}

while getopts ":p:" option; do
    case "${option}" in
        p)
            p=${OPTARG}

            if [[ ! -f "$p" ]]; then
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

PROFILE_PATH="${p}"

source ${PROFILE_PATH}

${BINARY} tx authz grant ${RESTAKE} generic --msg-type /cosmos.staking.v1beta1.MsgDelegate --from ${DELEGATOR_NAME} ${GAS_PRICES} ${DETAILS}

