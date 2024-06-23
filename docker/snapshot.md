#Create Directory for Snapshot
```
mkdir -p /var/www/html/snapshot/warden/
```

#Install Required Packages and Create the First Snapshot
```
sudo apt install lz4
```
```
cd $HOME/.wardend
```
```
sudo systemctl stop wardend
```
```
tar -cf - data | lz4 > /var/www/html/snapshot/warden/warden-snapshot-$(date +%Y%m%d).tar.lz4
```
```
sudo systemctl start wardend
```

#Update Nginx Configuration = /etc/nginx/sites-enabled/default
```
location /snapshot/warden {
    # First attempt to serve request as file, then
    # as directory, then fall back to displaying a 404.
    autoindex on;
    autoindex_exact_size off;
    autoindex_format html;
    autoindex_localtime on;
}
```
#Restart Nginx
```
sudo service nginx restart
```

#Verify Snapshot Access
http://winnode.xyz/snapshot/warden/

#Install and Start Cron Service
sudo apt-get install cron
sudo systemctl enable cron
sudo systemctl start cron

#Create Snapshot Script
rm $HOME/cron.sh
sudo tee $HOME/cron.sh > /dev/null << 'EOF'
sudo systemctl stop wardend
cd $HOME/.wardend/
rm /var/www/html/snapshot/warden/*
tar -cf - data | lz4 > /var/www/html/snapshot/warden/warden-snapshot-$(date +%Y%m%d).tar.lz4
sudo systemctl start wardend
EOF

chmod +x $HOME/cron.sh


#Create Daily Cron Job
crontab -l > cronjob
echo "0 0 * * * /root/cron.sh" >> cronjob
crontab cronjob
rm cronjob

crontab -l
