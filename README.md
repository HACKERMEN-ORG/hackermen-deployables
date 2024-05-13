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
