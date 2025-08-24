# kanata

Just my self-hosted setup for one of my raspberry pis. 

## Services

Has been in the works under many names with many other services
involved for 3 years, but with a focus on data storage, I have narrowed it
down to:

* Filebrowser - Basic file storage.
* WireGuard - Open source VPN service.
* PiHole - Open Source DNS service with adblocker for the VPN.
* ArchiveBox - Web archive for this internal network.
* Gitea - GitHub alternative limited to this network only. Most of my solo work is on here!

## Tech Debt/Future Ideas
* Properly decide on whether to use raw IPs or domain names, has the tradeoff
  of doing self-signed certs or having to do a yearly thing on Linode where 
  I generate a new set of certs.
* Break down the docker-compose file if possible to smaller ones?
