# Pipe POP Node Setup Guide
This guide provides step-by-step instructions for setting up and running the Pipe POP Node on your server.

## System Requirements
- Minimum 4GB RAM (configurable), more the better for higher rewards
- At least 100GB free disk space (configurable). 200-500GB is a sweet spot
- Internet connectivity available 24/7

### Before installing stop your previous pipe node if it is still running on your server
```bash
sudo systemctl stop dcdnd
```

## Installation Steps
### 1. Create Necessary Directories
```bash
cd $HOME
mkdir -p $HOME/pipenetwork
mkdir -p $HOME/pipenetwork/download_cache
```

### 2. Navigate to the Directory
```bash
cd $HOME/pipenetwork
```

### 3. Download the POP Node Binary
Replace `"download_link_from_email"` with the actual link received in your email:
```bash
wget "download_link_from_email"
```

### 4. Set Execution Permissions
```bash
sudo chmod +x pop
```

### 5. Create a Systemd Service File

**Note:** The `--ram` and `--max-disk` parameters should be adjusted based on your VPS specifications:
- `--ram`: Specifies the amount of RAM (in GB) allocated to the node. Ensure it does not exceed your available RAM.
- `--max-disk`: Defines the maximum disk space (in GB) the node can use. Set it according to your available storage capacity.


```bash
sudo tee /etc/systemd/system/pipe.service > /dev/null <<EOF
[Unit]
Description=Pipe POP Node Service
After=network.target
Wants=network-online.target

[Service]
User=$USER
WorkingDirectory=$HOME/pipenetwork
ExecStart=$HOME/pipenetwork/pop
    --ram 26
    --max-disk 200
    --cache-dir $HOME/pipenetwork/download_cache
    --pubKey your_solana_address
Restart=always
RestartSec=5
LimitNOFILE=65536
LimitNPROC=4096
StandardOutput=journal
StandardError=journal
SyslogIdentifier=dcdn-node

[Install]
WantedBy=multi-user.target
EOF
```

### 6. Reload and Start the Service
```bash
sudo systemctl enable pipe
sudo systemctl daemon-reload
sudo systemctl start pipe
```

### 7. View Service Logs
```bash
sudo journalctl -u pipe -f
```

## Monitoring
### Check Node Metrics
```bash
./pop --status
```

### Check Earned Points
```bash
./pop --points-route
```

## Notes
- Ensure your server meets the minimum RAM and disk space requirements.
- Replace the `--pubKey` value with the your solana address.
- Keep your system updated and monitor logs regularly for any issues.
- Recommened to backup node_info.json in `cat $HOME/pipenetwork/node_info.json`. It is linked to the IP address that registered the PoP node. It is no recoverable if lost. 

If you encounter issues, please refer to the official documentation https://docs.pipe.network/devnet-2 or reach out to the support team.

