## Description
Setup a OpenVPN client for access to your home network

## Minimum system requirements
* RouterOS 7.5 or newer
* arm, arm64 or x86 cpu
* 10 MB disk space (internal NAND storage)

## Usage

Setup container on RouterOS. See details [here](https://help.mikrotik.com/docs/display/ROS/Container).

Replace `config.ovpn` and `config.pass` with your own files.

Build image:
```shell
docker buildx build  --no-cache --platform linux/arm/v7 -t ovpn-container .
docker save ovpn-container > ovpn-container.tar
```

| arch         | router cpu |
|:-------------|:----------:|
| linux/arm/v7 |    ARM     |
| linux/arm64  |   ARM64    |
| linux/amd64  |    x86     |

Upload `ovpn-container.tar` to your router

Setup routing

```shell
/routing/table/add disabled=no fib name=homeNetwork
/ip/route/add disabled=no distance=1 dst-address=172.16.0.0/12 gateway=192.168.121.2 \
    pref-src=0.0.0.0 routing-table=homeNetwork scope=30 suppress-hw-offload=no \
    target-scope=1
/routing/rule/add action=lookup disabled=no dst-address=172.16.0.0/12 table=homeNetwork
```

Create container

```shell
 /container/add file=ovpn-container.tar interface=veth1 dns=192.168.121.1 logging=yes
 /container/start 0
```

Done, now you can access all your services in `172.16.0.0/12` network