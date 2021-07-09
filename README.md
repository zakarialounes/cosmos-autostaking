# cosmos-autostaking

### Install dependencies

```bash
sudo apt install expect
```

### Clone this repository
```bash
git clone https://github.com/zlounes/cosmos-autostaking.git $HOME/cosmos-autostaking && cd cosmos-autostaking
```

### Configuration

Make files executable
```bash
sudo chmod +x *delegate*
```

Edit the .profile file and set the appropriate values
```bash
nano .profile
```

Set password if needed
```bash
nano .passwd
```

### Manage start&stop

Start
```bash
# More profiles availables in the /profiles folder
screen -S autoDelegate ./$HOME/cosmos-autostaking/auto_delegate.sh -p .profile
```

Stop
```bash
screen -R autoDelegate
exit
```

### Watch logs
```bash
tail -f auto_delegate.log
```

Create the file service
```
sudo tee /etc/systemd/system/cosmos-autostaking.service <<EOF
Description=Cosmos Auto Staking
After=network-online.target

[Service]
User=$USER
WorkingDirectory=/home/$USER/cosmos-autostaking
ExecStart=/home/$USER/cosmos-autostaking/auto_delegate.sh -p /home/$USER/cosmos-autostaking/.profile
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF
```