#!/bin/bash

source .profile

getBalances() {
    echo $(${BINARY} query bank balances ${DELEGATOR} -o json ${SDETAILS} | jq -r '.balances[2].amount')
}
getDelegateAmount () {
    amountFinal=$(getBalances)
    amountFinal=$(expr ${amountFinal} - 100000)
    echo ${amountFinal}
}
withdrawRewardsAction() {
    echo "------ REWARDS ------"
    ${BINARY} tx distribution withdraw-rewards ${VALIDATOR} --from ${DELEGATOR_NAME} --commission ${GAS_PRICES} ${DETAILS} -y
}
delegateAction() {
    echo "------ DELEGATE ------"
    echo "Balance: $(getBalances)"

    amountFinal=$(getDelegateAmount)
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
