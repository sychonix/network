
## Updating Pipe POP Node

To update your Pipe POP Node to version 0.2.2, follow these steps:

### 1. Navigate to the Pipe Network Directory
```bash
cd $HOME/pipenetwork
```

### 2. Stop the Running Service
```bash
sudo systemctl stop pipe
```

### 3. Remove the Old Binary
```bash
sudo rm -rf pop
```

### 4. Download the Latest Version (0.2.3)
```bash
wget https://dl.pipecdn.app/v0.2.3/pop -O pop
```

### 5. Set Execution Permissions
```bash
chmod +x pop
```

### 6. Restart the Service
```bash
sudo systemctl restart pipe
```

### 7. Verify the Update
Check the logs to ensure the service is running correctly:
```bash
sudo journalctl -u pipe -f
```

Check the installed version:
```bash
./pop --version
```

Check node status:
```bash
./pop --status
```
