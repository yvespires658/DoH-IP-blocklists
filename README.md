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
Fri 06 Jun 2025 05:42:29 PM -03

## IPv4 List Stats
- Total IPs: 2536

## IPv6 List Stats
- Total IPs: 1856

## Usage with Mikrotik
   See the included `mikrotik-doh-blocker.rsc` script for automatic implementation.
