```
#!/bin/bash

# Remove all inactive containers
echo "Removing all inactive containers..."
docker container prune -f

# Remove all unused images
echo "Removing all unused images..."
docker image prune -a -f

# Remove all inactive volumes
echo "Removing all inactive volumes..."
docker volume prune -f

# Remove all remaining builds
echo "Removing all remaining builds..."
docker builder prune -f

# Remove all inactive components (containers, images, volumes, and networks)
echo "Removing all inactive components..."
docker system prune -f

echo "Docker cleanup complete!"
```

# Make the Script Executable
```
chmod +x docker_cleanup.sh
./docker_cleanup.sh
```


# install docker
```
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
```

# Remove all Inactive Containers
```
docker container prune
```
# Remove all Unused Images
```
docker image prune -a
```

# Remove all Inactive Volumes
```
docker volume prune
```

# Remove all Remaining Builds
```
docker builder prune
```

# Remove all Inactive Components
```
docker system prune
```

# gabisa masuk screen
```
screen -d subs
```
