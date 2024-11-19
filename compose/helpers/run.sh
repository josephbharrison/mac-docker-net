#!/bin/sh

dest=${dest:-docker.ovpn}

if [ ! -f "/local/$dest" ]; then
    echo "*** REGENERATING ALL CONFIGS ***"
    set -ex
    rm -rf /etc/openvpn/*
    ovpn_genconfig -u tcp://localhost
    sed -i 's|^push|#push|' /etc/openvpn/openvpn.conf
    echo host | ovpn_initpki nopass
    easyrsa --batch build-client-full host nopass
    ovpn_getclient host | sed '
    	s|localhost 1194|localhost 13194|;
	s|redirect-gateway.*|route 172.16.32.0 255.255.240.0|;
    ' > "/local/$dest"
fi

# Workaround for https://github.com/wojas/docker-mac-network/issues/6
/sbin/iptables -I FORWARD 1 -i tun+ -j ACCEPT

#### /sbin/iptables -I FORWARD 1 -i tun+ -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT
#### /sbin/iptables -A INPUT -i tun+ -j ACCEPT
#### /sbin/iptables -A FORWARD -i tun+ -j ACCEPT
#### /sbin/iptables -A FORWARD -i tun+ -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
#### /sbin/iptables -A FORWARD -i eth0 -o tun+ -m state --state RELATED,ESTABLISHED -j ACCEPT

exec ovpn_run
