install docker
```
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
```


Remove all Inactive Containers
```
docker container prune
```
Remove all Unused Images
```
docker image prune -a
```
Remove all Inactive Volumes
```
docker volume prune
```

Remove all Remaining Builds
```
docker builder prune
```

Remove all Inactive Components
```
docker system prune
```
