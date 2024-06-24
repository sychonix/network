#Create Directory for Snapshot
```
mkdir -p /var/www/html/snapshot/crossfi/
```

#Install Required Packages and Create the First Snapshot
```
sudo apt install lz4
```
```
cd $HOME/.mineplex-chain
```
```
sudo systemctl stop crossfid
```
```
tar -cf - data | lz4 > /var/www/html/snapshot/crossfi/crossfi-snapshot-$(date +%Y%m%d).tar.lz4
```
```
sudo systemctl start crossfid
```

#Update Nginx Configuration =
```
nano /etc/nginx/sites-enabled/snapshot.sychonix.conf
```
```
server {
    listen 80;
    server_name snapshot.sychonix.com;

    location / {
        autoindex on;
        autoindex_exact_size off;
        autoindex_format html;
        autoindex_localtime on;

        root /var/www/html/snapshot/;
        index index.html index.htm;
    }

    # Optional: Additional configuration
    error_page 404 /404.html;
    location = /404.html {
        internal;
    }
}
```

# Config Test
```
sudo pkill nginx
```
```
sudo nginx -t 
```

# ssl
```
sudo certbot --nginx --register-unsafely-without-email
```
```
sudo certbot --nginx --redirect
```

https://snapshot.sychonix.com/

#Install and Start Cron Service
```
sudo apt-get install cron
```
```
sudo systemctl enable cron
```
```
sudo systemctl start cron
```

#Create Snapshot Script
```
rm $HOME/cron.sh
```
```
sudo tee $HOME/cron.sh > /dev/null << 'EOF'
sudo systemctl stop crossfid
cd $HOME/.crossfid/
rm /var/www/html/snapshot/crossfi/*
tar -cf - data | lz4 > /var/www/html/snapshot/crossfi/crossfi-snapshot-$(date +%Y%m%d).tar.lz4
sudo systemctl start crossfid
EOF
```
```
chmod +x $HOME/cron.sh
```
Buat Cron Job Harian:
```
crontab -l > cronjob
```
```
echo "0 0 * * * /root/cron.sh" >> cronjob
```
```
crontab cronjob
```
```
rm cronjob
```
```
crontab -l
```

create new snapshot node
```
sudo tee $HOME/example.sh > /dev/null << 'EOF'
sudo systemctl stop binary
cd $HOME/.binary/
rm /var/www/html/snapshot/nodename/*
tar -cf - data | lz4 > /var/www/html/snapshot/nodename/nodename-snapshot-$(date +%Y%m%d).tar.lz4
sudo systemctl start binary
EOF
```
```
crontab -l > cronjob
```
```
echo "0 0 * * * /root/crossfi.sh" >> cronjob
```
```
crontab cronjob
```
```
rm cronjob
```
```
crontab -l
```
