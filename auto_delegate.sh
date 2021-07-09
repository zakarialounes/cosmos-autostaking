#!/bin/bash

source .profile

echo "Last running: $(date)" > auto_delegate.log
echo "Log: $(pwd)/auto_delegate.log"

while :
do
    if [[ "$KEYRING_BACKEND" = "test" || "$KEYRING_BACKEND" = "memory" ]]; then
        ./delegate.sh >> output.log
    else
        ./delegate.exp $(cat .passwd) >> auto_delegate.log
    fi

    echo "------ SLEEP 30s ------" >> auto_delegate.log
    sleep 30
done
