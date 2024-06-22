# api true
```
sudo nano $HOME/.warden/config/app.toml
```
# rpc 
```
sudo nano $HOME/.warden/config/config.toml
```

# config 
```
sudo nano /etc/nginx/sites-enabled/api-warden-t.sychonix.com.conf
```

# nano file api
```
server {
    server_name api-warden-t.sychonix.com;
    listen 80;
    location / {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Max-Age 3600;
        add_header Access-Control-Expose-Headers Content-Length;

	proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
        proxy_set_header   Host             $host;

        proxy_pass http://0.0.0.0:1717;

    }
}
```

# config 
```
sudo nano /etc/nginx/sites-enabled/rpc-warden-t.sychonix.com.conf
```

# nano file api
```
server {
    server_name rpc-warden-t.sychonix.com;
    listen 80;
    location / {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Max-Age 3600;
        add_header Access-Control-Expose-Headers Content-Length;

	proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
        proxy_set_header   Host             $host;

        proxy_pass http://127.0.0.1:51657;

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































