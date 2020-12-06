## DLNA service daemon for Raspberry Pi - Docker image

Based on https://sourceforge.net/projects/minidlna/
Binaries are built from source (master tree).


### Build it

```
git clone https://github.com/dbyio/dlnaMyPi
cd dlnaMyPi
chmod +x do.sh
sudo ./do.sh build
```

## Configure it

Copy `etc/minidlna.conf` in `/etc/minidlna`.
Defaults should be fine.


## Run it (Systemd and Docker Compose)

You'll first need to install Docker Compose and set it up with Systemd.

Copy `etc/docker-compose.yml` in `/etc/docker/compose/minidlna`. If needed, edit and set your local video media directory.

```
sudo mkdir /etc/docker/compose/minidlna && cp docker-compose.yml /etc/docker/compose/minidlna
sudo systemctl enable docker-compose@minidlna --now
```


## Update the image

The following command will build a new image using the latest minidlna source and upgrade the system base image.

```
sudo ./do.sh update
```

You'll then need to (re)start the service manually.
