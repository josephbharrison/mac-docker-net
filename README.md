# Mac Docker Networking
Container network and IP access on MacOS

## Features
- Container access by name or IP address
- Proxy and openvpn servers included
- Openvpn profile generation
- Apple silicon support
- Does not require `Docker Desktop for Mac`

## Prerequisites
- [Colima](https://github.com/abiosoft/colima) (Recommended)
- [Tunnelblick](https://tunnelblick.net) or any OpenVPN client

## Installation (one-time setup)
1. Install Prerequisites
```sh
brew install colima tunnelblick
```
2. Update Colima configuration
```yaml
# ~/.colima/default/colima.yaml
docker:
  default-address-pools:
    - base: 172.16.32.0/20
      size: 24
  experimental: false
```
3. Start Colima
```sh
colima start
```
4. Build proxy and openvpn servers
```sh
./docker-net.sh -b
```
5. Start the proxy and openvpn servers 
```sh
./docker-net.sh -s
```
6. Add the generated openvpn profile to tunnelblick: `compose/docker-for-mac.ovpn`

## Usage
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
## Credits       
- [ix-ai/openvpn](https://github.com/ix-ai/openvpn)
- [wojas/docker-mac-network](https://github.com/wojas/docker-mac-network)
- [kylemanna/docker-openvpn](https://github.com/kylemanna/docker-openvpn)
