```
echo '
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
' | bash
```


```
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
```
