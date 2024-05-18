# HACKERMEN
### internet gigachads

### [START HACKING](https://github.com/HACKERMEN-ORG/hackermen-deployables/tree/main/ansible/hackermen) (go to docs folder)

#### Mission
create a community of like minded technical individuals with the infrastructure in place to collaborate efficiently

#### Process
Use Ansible to automate the deployment and long term support of required infrastructure.
The Ansible playbook will use Docker for containerization and Traefik as the dynamic reverse proxy
All essential services will be deployed with docker-compose within the playbook.
Essential services are the bare minimum resources required for an organization to operation.
These include communications such as email, instant messaging, forum based threads, and infrastructure services such as VM and container orchestration, shared drives, and various groupware etc.
After deployment, ease of migration and data redundancy is essential to ensure smooth transition between hosts and ensure permanence of the project and long term support using automated playbooks.

#### Current Objective

#### Automate the deployment of the following using Ansible
 Essential Services

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

    Basic services
        pass (unix program) password manager
        RSS feed client server
        web page deployment

#### How to use ansible
Ensure public ssh keys are located on clients
`ssh-copy-id -i YOUR PRIVATE KEY`

To run as local host configure yaml config:
`hosts: <your host> # eg. localhost`

To run the playbook in your current directory
`$ ansible-playbook <the configuration you want to run>.yml # etc.`

DEPLOY!!!

[TO BE CONTINUED] 


