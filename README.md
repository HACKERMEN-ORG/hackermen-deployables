# hackermen-deployables
Deployable items for hackerman (pull your shit here)

## How to use ansible

### ansible playbook
Change yaml

`hosts: <your host> # eg. localhost`

Add ssh keys to the host

`ssh-copy-id -i YOUR PRIVATE KEY`

DEPLOY!!!

`$ ansible-playbook <the configuration you want to run>.yml # etc.`


GOAL: Automate the deployment of 

Essential Services:

    Infrastructure
        Docker - containerization
        Traefik - dynamic reverse proxy
        OpenVPN - VPN servers, maybe WireGuard?
        Proxmox VE - connect to nodes and provide VMs
        Portainer - allow deployment of docker containers
        TBD - Cloud storage service, NextCloud?
        TBD - nightly backups (Tarsnap? Rsnapshot?)
        Security - determine services for logging and 
    
    Development
        Gitea - git server
        Code-Server - vscode web client
        Wiki - determine wiki for more elaborate projects
        Clearflask - user feedback and dev road map?

    Communication
        Mailu - mail server with roundcube webmail client
        Synapse - matrix server with web client (TBD)
        myBB - Community forum
        FreshRSS - rss reader for relevant news

    Groupware
        FocalBoard - open to better alternatives
        BitWarden - password manager for shared services
        Cryptpad - E2EE office suite
        Draw.io - diagram editor
        BitPoll / Framadate - group event scheduler

    Finances
        BigCapital - Accounting suite
        BTCPay - Bitcoin payment processor
    
    Requested Services:
        TBD - shortlink maker
        PenPot - ui design tool
        OctaveOnline - MATLAB alternative
        Bracket - tournament bracket generator
        Searx - search engine

    Noteable Services:
        MyPaaS - docker and traefik automated deployment (captnbp/mypaas)
        PikaPod - deploy self hosted services
        VirtKick - VPS admin panel with billing
        Virtualmin - VPS admin panel
        Cloudron
        Coolify - Vercel clone
        Paperless - document scanner 
        Privatebin - encrypted pastebin
        Flashpaper - one time encrypted secret share
