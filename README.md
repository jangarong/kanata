# penguin-secret-agency

Just my self-hosted setup for one of my raspberry pis. 

## Services

Has been in the works under many names with many other services
involved for 3 years, but with a focus on data storage, I have narrowed it
down to:

* Filebrowser (`/files`) - Basic file storage.
* Syncthing (`/sync`) - File sync for backups/redundancy.
* WireGuard - Open source VPN service.
* PiHole - Open Source DNS service with adblocker for the VPN.
* ArchiveBox (`/`) - Web archive for this internal network.
* Gitea (`/git`) - GitHub alternative limited to this network only. Most of my solo work is on here!
  * note: to use SSH, please use the direct host `10.8.1.60:22`

## Note on gitea
Please ensure the gitea's config file `./volumes/container/gitea/gitea/conf/app.ini` looks like this:
```
[server]
...
DOMAIN = corp.jangarong.com
SSH_DOMAIN =  10.8.1.60
HTTP_PORT = 3000
ROOT_URL = https://corp.jangarong.com/git/
DISABLE_SSH = false
SSH_PORT = 22
SSH_LISTEN_PORT = 22
LFS_START_SERVER = true
...
OFFLINE_MODE = true
```
