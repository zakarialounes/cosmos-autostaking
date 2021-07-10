#!/bin/bash

source $1

getBalancesFromAccount() {
    coins=$(${BINARY} query account ${DELEGATOR} -o json ${SDETAILS} | jq '.value.coins | to_entries')
    position=$(echo ${coins} | jq -r ".[] | select(.value.denom == \"${DENOM}\") | .key")
    amount=$(echo ${coins} | jq -r ".[${position}].value.amount")
    echo -n ${amount}
}
getBalancesFromBank() {
    coins=$(${BINARY} query bank balances ${DELEGATOR} -o json ${SDETAILS} | jq '.balances | to_entries')
    position=$(echo ${coins} | jq -r ".[] | select(.value.denom == \"${DENOM}\") | .key")
    amount=$(echo ${coins} | jq -r ".[${position}].value.amount")
    echo -n ${amount}
}
getBalances() {
    amount=0
    if [[ "$BALANCES_FROM" == "BANK" ]]; then
        amount=$(getBalancesFromBank)
    elif [[ "$BALANCES_FROM" == "ACCOUNT" ]]; then
        amount=$(getBalancesFromAccount)
    fi
    echo -n ${amount}
}
getDelegateAmount () {
    amountFinal=$(expr ${1} - 100000)
    echo -n ${amountFinal}
}
withdrawRewardsAction() {
    echo "------ REWARDS ------"
    ${BINARY} tx distribution withdraw-rewards ${VALIDATOR} --from ${DELEGATOR_NAME} --commission ${GAS_PRICES} ${DETAILS} -y
}
delegateAction() {
    balance=$(getBalances)
    amountFinal=$(getDelegateAmount ${balance})
    echo "------ DELEGATE ------"
    echo "Balance: ${balance}"
    echo "Amount to delegate: ${amountFinal}"
    if [[ ${amountFinal} -gt 0 ]]; then
        ${BINARY} tx staking delegate ${VALIDATOR} ${amountFinal}${DENOM} --from ${DELEGATOR_NAME} ${GAS_PRICES} ${DETAILS} -y
    elif [[ "$KEYRING_BACKEND" = "os" || "$KEYRING_BACKEND" = "file" ]]; then
        echo -n 'Enter keyring passphrase:'
        read answer
    fi
}

withdrawRewardsAction
sleep 5
delegateAction
