# Cosmos Auto Staking

> **_⚠ WARNING:_**  Using this script in a mainnet environment is not recommended.

> **_⚠ WARNING:_**  You are strongly advised to configure the service with the root user, so other users will not have access to the profile details and therefore the password (if you have decided to use the script with password set in profile).

### Install dependencies

```bash
sudo apt install screen expect bc -y
```

### Clone this repository
```bash
git clone https://github.com/zlounes/cosmos-autostaking.git $HOME/cosmos-autostaking && cd $HOME/cosmos-autostaking
```

### Configuration

#### Make files executable
```bash
chmod +x $HOME/cosmos-autostaking/*delegate*
```

#### Edit desired profile files, set the appropriate values
```bash
nano $HOME/cosmos-autostaking/profiles/.bitcanna_profile
nano $HOME/cosmos-autostaking/profiles/.bitsong_profile
nano $HOME/cosmos-autostaking/profiles/.desmos_profile
nano $HOME/cosmos-autostaking/profiles/.emoney_profile
nano $HOME/cosmos-autostaking/profiles/.evmos_profile
nano $HOME/cosmos-autostaking/profiles/.irisnet_profile
nano $HOME/cosmos-autostaking/profiles/.juno_profile
nano $HOME/cosmos-autostaking/profiles/.kichain_profile
nano $HOME/cosmos-autostaking/profiles/.omniflix_profile
nano $HOME/cosmos-autostaking/profiles/.osmosis_profile
nano $HOME/cosmos-autostaking/profiles/.regen_profile
nano $HOME/cosmos-autostaking/profiles/.stargaze_profile
nano $HOME/cosmos-autostaking/profiles/.terra_profile
```

### Manage start&stop

#### Start
More profiles availables in the /profiles folder
```bash
screen -S autoDelegate $HOME/cosmos-autostaking/auto_delegate.sh -p $HOME/cosmos-autostaking/profiles/.desmos_profile
```

#### Stop
```bash
screen -R autoDelegate
exit
```

### Watch logs
```bash
tail -f $HOME/cosmos-autostaking/auto_delegate.log
```

### Using Systemd Service

```
sudo tee /etc/systemd/system/cosmos-autostaking.service <<EOF
[Unit]
Description=Cosmos Auto Staking
After=network-online.target

[Service]
User=$USER
WorkingDirectory=$HOME/cosmos-autostaking
ExecStart=$HOME/cosmos-autostaking/auto_delegate.sh -p $HOME/cosmos-autostaking/profiles/.desmos_profile

[Install]
WantedBy=multi-user.target
EOF
```

#### Start 
```bash
sudo systemctl enable --now cosmos-autostaking
```

#### Stop 
```bash
sudo systemctl stop cosmos-autostaking
```

#### Manual Delegation
```bash
$HOME/cosmos-autostaking/delegate_manually.sh -p $HOME/cosmos-autostaking/profiles/.desmos_profile
```

#### Auto Delegate using Authz
```bash
# Grant authorization to your Authz operator
$HOME/cosmos-autostaking/authz_grant.sh -p $HOME/cosmos-autostaking/profiles/.desmos_profile

# Auto Delegate Automatically
$HOME/cosmos-autostaking/authz_auto_delegate.sh -p $HOME/cosmos-autostaking/profiles/.desmos_profile
```
