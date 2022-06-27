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
shift $((OPTIND - 1))

if [[ -z "${p}" ]]; then
  usage
fi

PROFILE_PATH="${p}"

source ${PROFILE_PATH}

if [[ -z "$AMOUNT_TO_KEEP_AVAILABLE" ]]; then
  AMOUNT_TO_KEEP_AVAILABLE=100000
fi

getBalance() {
  coins=$(${BINARY} query bank balances ${DELEGATOR} -o json ${SDETAILS} | jq '.balances | to_entries')
  position=$(echo ${coins} | jq -r ".[] | select(.value.denom == \"${DENOM}\") | .key")
  amount=$(echo ${coins} | jq -r ".[${position}].value.amount")
  echo -n ${amount}
}
getRewardsBalance() {
  coins=$(${BINARY} q distribution rewards ${DELEGATOR} ${VALIDATOR} -o json ${SDETAILS} | jq '.rewards | to_entries')
  position=$(echo ${coins} | jq -r ".[] | select(.value.denom == \"${DENOM}\") | .key")
  amount=$(echo ${coins} | jq -r ".[${position}].value.amount")
  amountArr=(${amount//./ })
  echo -n ${amountArr[0]}
}
getFinalBalance() {
  amountFinal=$(bc <<<"${1} + ${2} - ${AMOUNT_TO_KEEP_AVAILABLE}")
  echo -n ${amountFinal}
}

delegateAction() {
  balance=$(getBalance)
  rewards=$(getRewardsBalance)
  amountFinal=$(getFinalBalance ${balance} ${rewards})
  echo "------ DELEGATE ------"
  echo "Balance: ${balance}"
  echo "Rewards: ${rewards}"
  echo "Amount to delegate: ${amountFinal}"
  if [[ ${amountFinal} > 0 ]]; then
    rm -rf tx.json
    ${BINARY} tx staking delegate ${VALIDATOR} ${amountFinal}${DENOM} --from ${DELEGATOR} ${DETAILS} -y --generate-only >tx.json
    ${BINARY} tx authz exec tx.json --from ${RESTAKE} ${GAS_PRICES} ${DETAILS} -y
    rm -rf tx.json
  fi
}

delegateAction
