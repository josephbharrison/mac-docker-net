# Mac Docker Networking
Container network access on MacOS

## Features
- Includes proxy and openvpn server
- Generates openvpn client configuration
- Access containers by IP address
- Adds container entries to /etc/hosts
- Works with Apple silicon

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
    -b    Build openvpn and proxy
    -s    Start [default]
    -x    Stop
    -H    Add/update container entries to /etc/hosts
    -h    Help message
    -l    Update /etc/hosts entries and lo0 alias (not recommended)
```
