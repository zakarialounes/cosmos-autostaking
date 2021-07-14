# Cosmos Auto Staking

### Install dependencies

```bash
sudo apt install expect
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
nano $HOME/cosmos-autostaking/profiles/.osmosis_profile
nano $HOME/cosmos-autostaking/profiles/.desmos_profile
nano $HOME/cosmos-autostaking/profiles/.juno_profile
```

### Manage start&stop

#### Start
```bash
# More profiles availables in the /profiles folder
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
Description=Cosmos Auto Staking
After=network-online.target

[Service]
User=$USER
WorkingDirectory=/home/$USER/cosmos-autostaking
ExecStart=/home/$USER/cosmos-autostaking/auto_delegate.sh -p /home/$USER/cosmos-autostaking/profiles/.desmos_profile
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

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