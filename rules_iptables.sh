#!/bin/bash

# Cleanup
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -t raw -F
iptables -t raw -X

# Default Policy. Block all incoming connections
iptables -P FORWARD DROP
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT

# Allow previous Established connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow loopback
iptables -A INPUT -i lo -j ACCEPT

# ICMP (ping)
iptables -A INPUT -p icmp -j ACCEPT

# SSH (port 22/TCP,UDP)
iptables -A INPUT -p tcp --dport 479 -j ACCEPT
iptables -A INPUT -p udp --dport 479 -j ACCEPT

# HTTP (port 80/TCP)
iptables -A INPUT -p tcp --dport 80 -j ACCEPT


# Any IP that performs a PortScan will be blocked for 48 hours

iptables -A INPUT   -m recent --name portscan --rcheck --seconds 172800 -j DROP

iptables -A FORWARD -m recent --name portscan --rcheck --seconds 172800 -j DROP

