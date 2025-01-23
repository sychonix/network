# Chromium in Docker

This guide provides steps to set up and run Chromium in a Docker container using `docker-compose`.

## Prerequisites
Ensure you have the following installed on your server:
- **Docker**
- **Docker Compose**

If not installed, follow the steps below:

### Installing Docker and Docker Compose
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
```

Verify installation:
```bash
docker --version
docker compose version
```

---

## Setting Up Chromium in Docker
1. Create a folder for the project:
   ```bash
   mkdir chromium
   cd chromium
   ```

2. Create a `docker-compose.yaml` file:
   ```bash
   nano docker-compose.yaml
   ```

3. Add the following content to `docker-compose.yaml`:
   ```yaml
   services:
     chromium:
       image: lscr.io/linuxserver/chromium:latest
       container_name: chromium
       security_opt:
         - seccomp:unconfined # Optional
       environment:
         - CUSTOM_USER=your_username       # Set your username
         - PASSWORD=your_password          # Set your password
         - PUID=1000                       # User ID (default: 1000)
         - PGID=1000                       # Group ID (default: 1000)
         - TZ=Asia/Jakarta                 # Set your timezone
         - CHROME_CLI=https://x.com/nodem0rt
       volumes:
         - /root/chromium/config:/config
       ports:
         - 3010:3000                       # Port for accessing Chromium
         - 3011:3001                       # Additional port (optional)
       shm_size: "1gb"                     # Shared memory size
       restart: unless-stopped             # Auto-restart policy
   ```

4. Save and exit:
   - Press `Ctrl+O` to save.
   - Press `Ctrl+X` to exit.

---

## Running the Chromium Container
Run the following command to start the container:
```bash
docker compose up -d
```

Verify that the container is running:
```bash
docker ps
```

---

## Accessing Chromium
1. Open your browser and type the following URL:
   ```
   http://<your-server-ip>:3010
   ```
   Replace `<your-server-ip>` with the IP address of your VPS/server. For example:
   ```
   http://123.45.67.89:3010
   ```

2. Log in using the username and password you set in the `docker-compose.yaml` file.

---

## Additional Commands
- **Check container logs:**
  ```bash
  docker logs chromium
  ```

- **Stop the container:**
  ```bash
  docker stop chromium
  ```

- **Start the container:**
  ```bash
  docker start chromium
  ```

- **Remove the container:**
  ```bash
  docker rm chromium
  ```

---

## Troubleshooting
### 1. Cannot Access Chromium
- Ensure the container is running:
  ```bash
  docker ps
  ```
- Check if the ports are open:
  ```bash
  sudo netstat -tuln | grep 3010
  ```
- If using a firewall, open the ports:
  ```bash
  sudo ufw allow 3010/tcp
  sudo ufw allow 3011/tcp
  ```

### 2. Adjust Port Conflicts
If port `3010` or `3011` is already in use, edit the `docker-compose.yaml` file to use different ports. For example:
```yaml
ports:
  - 3020:3000
  - 3021:3001
```
Restart the container:
```bash
docker compose down && docker compose up -d
```

---

## License
This project uses the open-source [LinuxServer Chromium](https://hub.docker.com/r/linuxserver/chromium) image.
```
