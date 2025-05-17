# Pre-processed DoH IP Blocklists for Mikrotik

This repository contains pre-processed IP blocklists for DNS over HTTPS (DoH) servers, specially formatted for easy use with Mikrotik RouterOS.

## Files
- `mikrotik-doh-ipv4.txt`: Clean list of IPv4 addresses for DoH servers (one IP per line)
- `mikrotik-doh-ipv6.txt`: Clean list of IPv6 addresses for DoH servers (one IP per line)
- `mikrotik-doh-ipv4.rsc`: MikroTik-ready script for IPv4 DoH servers (can be imported directly)
- `mikrotik-doh-ipv6.rsc`: MikroTik-ready script for IPv6 DoH servers (can be imported directly)

## Original Source
These lists are processed versions of DoH-IP-blocklists maintained by dibdot:
https://github.com/dibdot/DoH-IP-blocklists

## Last Updated
Sat 17 May 2025 08:51:54 PM -03

## IPv4 List Stats
- Total IPs: 2534

## IPv6 List Stats
- Total IPs: 1853

## Usage with Mikrotik
You can use these lists in two ways:

1. **Direct Import Method:**
   - Download the appropriate .rsc file
   - In Winbox: Files ? Upload ? select the downloaded .rsc file
   - In Terminal: /import file-name=mikrotik-doh-ipv4.rsc

2. **Script Method:**
   See the included `mikrotik-doh-blocker.rsc` script for automatic implementation.
