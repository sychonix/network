# Docker Command


### Cek `container` yang aktif
```
sudo docker ps
```

### Cek seluruh `conatiner` aktif+ngga
```
sudo docker ps -a
```

### Memberhentikan `container` aktif
```
sudo docker stop NAMES
```

>- `NAMES` diganti dengan nama container yang ingin dihapus

### Menghapus `container`
```
sudo docker rm NAMES
```

>- `NAMES` diganti dengan nama container yang ingin dihapus
>- Container aktif tidak bisa dihapus, harus di stop dulu

### Menghapus **SEMUA** `container` yang tidak terpakai
```
sudo docker container prune
```
>- Container aktif tidak bisa dihapus, harus di stop dulu

- `container` apaan ?
- Docker Container adalah wadah untuk menjalankan sesuatu

### Cek `images` aktif
```
sudo docker images
```

### Cek semua `images` aktif+ngga
```
sudo docker images -a
```

### Menghapus `images`
```
sudo docker rmi imagesID
```
>- `imagesID` diganti menggunakan **IMAGES ID* yang ingin dihapus
>- `images` aktif tidak bisa dihapus

### Mengahapus **SEMUA** `images` tidak aktif
```
sudo docker image prune -a
```

- `images` apaan ?
- Docker Images adalah kumpulan file yang di pull(pull=download) untuk menjalankan sesuatu dan di tampung di `Docker Container`

### Cek logs docker
```
docker logs -f NAMES
```
>- `NAMES` diganti dengan nama yang ingin di cek logs nya

### Membersihkan **SEMUA** hal yang tidak berguna
```
sudo  docker system prune
```

## Belajar lebih lanjut tentang command Docker
[KLIK DISINI](https://docs.docker.com/engine/reference/commandline/cli/)
