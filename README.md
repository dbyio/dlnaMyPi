## DLNA service daemon for Raspberry pi - Docker image

Based on https://sourceforge.net/projects/minidlna/
Build process pulls and build binaries from source (master).


### Build it

```
git clone https://github.com/dbyio/dlnaMyPi
cd dlnaMyPi
chmod +x do.sh
sudo ./do.sh build
```

## Configure it

Copy `conf/minidlna.conf` in `/opt/minidlna`.
Defaults should be fine.


## Run it

*Run with *systemd* (recommended).

Edit MEDIADIR in `conf/spotifyd.service` to define your local video media directory.

```
sudo cp conf/minidlna.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable minidlna
sudo systemctl start minidlna
```


## Update the image

The following command will build a new image using the latest minidlna source and upgrade the system base image.

```
sudo ./do.sh update
```

You'll then need to (re)start the image manually.
