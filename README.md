# nubtek

Just my self-hosted setup for one of my raspberry pis. 

## Services

Has been in the works under many names with many other services
involved for 3 years, but with a focus on data storage, I have narrowed it
down to:

* A clone of my website on `jangarong.com`
* Filebrowser - Basic file storage.
* WireGuard - Open source VPN service.
* PiHole - Open Source DNS service with adblocker for the VPN.
* ArchiveBox - Web archive for this internal network.
* Gitea - GitHub alternative limited to this network only. Most of my solo work is on here!

## Why `nubtek`?

Why the name `nubtek`? I made this with the mind of reducing dependence on 
big tech companies (nu = no, b = big, tek = tech), but it could also be read
as "noob tech", which is probably more accurate based on my poor scripting
skills.

* Hosting is taken care by me, not AWS/GCP/Azure.
* All the services used are open source.
* My website is already enough of a "social media page" I can share around anyways.

## Tech Debt/Future Ideas
* Properly decide on whether to use raw IPs or domain names, has the tradeoff
  of doing self-signed certs or having to do a yearly thing on Linode where 
  I generate a new set of certs.
* Break down the docker-compose file if possible to smaller ones?
