#!/bin/bash

source $1

if [[ -z "$TX_PASSWD_CONFIRMATIONS" ]]; then
    TX_PASSWD_CONFIRMATIONS=1
fi

if [[ -z "TX_PASSWD_PRHASE" ]]; then
    TX_PASSWD_PRHASE="Enter keyring passphrase:"
fi

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
    elif [[ "$KEYRING_BACKEND" != "test" && "$KEYRING_BACKEND" != "memory" ]]; then
        for (( i=1; i<=$TX_PASSWD_CONFIRMATIONS; i++ ))
        do
            echo -n "${TX_PASSWD_PRHASE}"
            read answer
        done
    fi
}

withdrawRewardsAction
sleep 15
delegateAction
