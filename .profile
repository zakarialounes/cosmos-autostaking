# Desmos Keyring Backend ("test", "file", "os" or "memory")
# Example: KEYRING_BACKEND="test"
# You can reimport your wallet with desired backend-type
# (`desmos keys add DesmosWalletName --recover --keyring-backend test`)
KEYRING_BACKEND="test"

# Desmos Wallet Name (`desmos keys list`)
# Example: DELEGATOR_NAME="EZStaking"
DELEGATOR_NAME=""

# Desmos Wallet Address (`desmos keys show DesmosWalletName -a`)
# Example: DELEGATOR="desmos164kcy3s0pqfall3r837n82l24alc6l36ky56ld"
DELEGATOR=""

# Desmos Validator Address
# Example: VALIDATOR="desmosvaloper164kcy3s0pqfall3r837n82l24alc6l36gfuw4l"
VALIDATOR=""

# Current Desmos Chain ID
CHAIN_ID="morpheus-apollo-1"

#########################################################
# In case you customized the Desmos Node configuration, #
# you will want to edit this below parameters.          #
#########################################################

# The IP of your Desmos Node
NODE_IP="127.0.0.1"

# The port of your Desmos Node
NODE_PORT="26657"

# The home of your Desmos Node
NODE_HOME="/home/desmos/.desmos"

# The path to your Desmos binary
# To get the full path to your emcli binary you can use `whereis emcli` and replace the below value by.
BINARY="/home/desmos/go/bin/desmos"

####################
# MODIFY FOR TESTS #
####################

BALANCE_POSITION="2"
DENOM="udaric"
GAS_PRICES="--fees 200000${DENOM}"

##################
# DO NOT MODIFY! #
##################

SDETAILS="--chain-id ${CHAIN_ID} --node tcp://${NODE_IP}:${NODE_PORT}"
DETAILS="${SDETAILS} --keyring-backend ${KEYRING_BACKEND}"