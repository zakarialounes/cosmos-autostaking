#!/bin/bash

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

if [[ -z "$AMOUNT_TO_KEEP_AVAILABLE" ]]; then
    AMOUNT_TO_KEEP_AVAILABLE=100000
fi

getDelegateBalanceFromAccount() {
    coins=$(${BINARY} query account ${DELEGATOR} -o json ${SDETAILS} | jq '.value.coins | to_entries')
    position=$(echo ${coins} | jq -r ".[] | select(.value.denom == \"${DENOM}\") | .key")
    amount=$(echo ${coins} | jq -r ".[${position}].value.amount")
    echo -n ${amount}
}
getDelegateBalanceFromBank() {
    coins=$(${BINARY} query bank balances ${DELEGATOR} -o json ${SDETAILS} | jq '.balances | to_entries')
    position=$(echo ${coins} | jq -r ".[] | select(.value.denom == \"${DENOM}\") | .key")
    amount=$(echo ${coins} | jq -r ".[${position}].value.amount")
    echo -n ${amount}
}
getDelegateBalance() {
    amount=0
    if [[ "$BALANCES_FROM" == "BANK" ]]; then
        amount=$(getDelegateBalanceFromBank)
    elif [[ "$BALANCES_FROM" == "ACCOUNT" ]]; then
        amount=$(getDelegateBalanceFromAccount)
    fi
    echo -n ${amount}
}
getFinalDelegateBalance () {
    amountFinal=$(bc <<< "${1} - ${AMOUNT_TO_KEEP_AVAILABLE}")
    echo -n ${amountFinal}
}

withdrawRewardsAction() {
    echo "------ REWARDS ------"
    ${BINARY} tx distribution withdraw-rewards ${VALIDATOR} --from ${DELEGATOR_NAME} --commission ${GAS_PRICES} ${DETAILS} -y
}
delegateAction() {
    balance=$(getDelegateBalance)
    amountFinal=$(getFinalDelegateBalance ${balance})
    echo "------ DELEGATE ------"
    echo "Balance: ${balance}"
    echo "Amount to delegate: ${amountFinal}"
    if [[ ${amountFinal} -gt 0 ]]; then
        ${BINARY} tx staking delegate ${VALIDATOR} ${amountFinal}${DENOM} --from ${DELEGATOR_NAME} ${GAS_PRICES} ${DETAILS} -y
    fi
}

withdrawRewardsAction
sleep 15
delegateAction
