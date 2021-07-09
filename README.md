# cosmos-autostaking

### Install dependencies

```bash
sudo apt install expect
```

### Clone this repository
```bash
git clone https://github.com/zlounes/cosmos-autostaking.git && cd cosmos-autostaking
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
screen -S autoDelegate ./auto_delegate.sh
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
