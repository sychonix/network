# api true
```
nano $HOME/.#/config/app.toml
```
# rpc 
```
nano $HOME/.#/config/config.toml
```

# config 
```
nano /etc/nginx/sites-enabled/api-og-testnet.sychonix.xyz.conf
```

# nano file api
```
server {
    server_name api-og-testnet.sychonix.xyz;
    listen 80;
    location / {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Max-Age 3600;
        add_header Access-Control-Expose-Headers Content-Length;

	proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
        proxy_set_header   Host             $host;

        proxy_pass http://0.0.0.0:2017;

    }
}
```

# config 
```
nano /etc/nginx/sites-enabled/rpc-og-testnet.sychonix.xyz.conf
```

# nano file api
```
server {
    server_name rpc-og-testnet.sychonix.xyz;
    listen 80;
    location / {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Max-Age 3600;
        add_header Access-Control-Expose-Headers Content-Length;

	proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
        proxy_set_header   Host             $host;

        proxy_pass http://127.0.0.1:24656;

    }
}
```


































