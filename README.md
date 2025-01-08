## kali contianer

PID1 is systemd

### desktop

kali-desktop-i3 on lightdm with tigervnc

system language is Chinese

IM configured

#### configs

> todo

### username and password

`bonjour:bonjour`

### run

``` bash
podman run \
	-td \
	-v ./init:/usr/local/etc/init \
	-v ./data:/home/bonjour/data \
	-v ./firefox:/home/bonjour/.config/firefox \
	-p 30100:5900 \
	--device /dev/fuse \
	--security-opt label=disable \
	--cap-add=NET_RAW \
	--name container \
	ghcr.io/bonjour-py/kali
```

### softwares

#### tools

|Name|something needed|add-ons|
|-|-|-|
|podman|--device /dev/fuse||
|wireshark|--cap-add=NET_RAW||
|libreoffice|-|libreoffice-l10n-zh-cn|
|企业微信|-||

#### programming language

|Name|add-ons|
|-|-|
|rust|cargo|
|golang||
|python-is-python3|requests<br>flask|

### ports

#### 5900

vnc port

### volumes

#### `/usr/local/etc/init`

pre-start shell script directory, all files end with `.sh` will runs with bash.

#### `/home/<username>/.config/firefox`

firefox profile directory like `.mozilla/firefox/5q4w06k8.default`