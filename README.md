# Mac Docker Networking
Container network and IP access on MacOS

## Features
- Proxy and openvpn server
- Openvpn client config generation
- Container access by name or IP address
- Apple silicon support

## Prerequisites
- [Colima](https://github.com/abiosoft/colima)
- [Tunnelblick](https://tunnelblick.net)

## Installation
1. Build proxy and openvpn servers
```sh
./docker-net.sh -b
```
2. Start the proxy and openvpn servers 
```sh
./docker-net.sh -s
```
3. Add the generated openvpn profile to tunnelblick: `compose/docker-mac-net.ovpn`
4. Use tunnelblick to connect to `mac-docker-net`
5. Update `/etc/hosts`

```sh
./docker-net.sh -H

```
### Usage
```
Usage: docker-net.sh [OPTIONS]

Options: 
    -h    This help message
    -b    Build openvpn and proxy
    -s    Start [default]
    -x    Stop
    -H    Update container entries in /etc/hosts
    -l    Update /etc/hosts entries and lo0 alias (not recommended)
```
