# Mac Docker Networking
Provides IP network access to docker containers and manages container /etc/hosts entries on Mac OS X.

### Prerequisites
- [Colima](https://github.com/abiosoft/colima)
- [Tunnelblick](https://tunnelblick.net)

### Installation
- `$ ./docker-net.sh -b  # build`
- `$ ./docker-net.sh -s  # start`
- import openvpn profile to tunnelblick: `compose/docker-mac-net.ovpn`

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
