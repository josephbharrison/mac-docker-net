# Mac Docker Networking
IP access to containers on MacOS. Works with Apple silicon.

### Prerequisites
- [Colima](https://github.com/abiosoft/colima)
- [Tunnelblick](https://tunnelblick.net)

### Installation
1. Build openvpn and proxy and start
```sh
./docker-net.sh -b  # build
./docker-net.sh -s  # start
```
2. import openvpn profile to tunnelblick: `compose/docker-mac-net.ovpn`

### Usage
```
Usage: docker-net.sh [OPTIONS]

Options: 
    -b    Build openvpn and proxy
    -s    Start [default]
    -x    Stop
    -l    Update /etc/hosts entries and lo0 alias
    -H    Update /etc/hosts entries only
    -h    Help message
```
