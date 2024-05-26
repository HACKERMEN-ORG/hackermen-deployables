# HACKERMEN.ORG

### OBJECTIVE
Automated deployment and maintenance of the services required to allow an organization to collaborate efficently.


### Process

Use Ansible to automate the deployment and long term support of required infrastructure. The Ansible playbook will use Docker for containerization and Traefik as the dynamic reverse proxy.

All services to be deployed will be a docker-compose config file. To intergrate the docker service into the Traefik reverse proxy add the appropriate labels


#### Docker-compose services
```
version: "3.8"
services:
  nginx:
    image: example/example:latest
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.example.rule=Host(`subdomain.example.com`)"
      - "traefik.http.routers.example.entrypoints=https"
      - "traefik.http.routers.example.tls=true"
      - "traefik.http.services.example.loadbalancer.server.port=8000"
    networks:
      - proxy

networks:
  proxy:
    external: true
```

Ensure you have created a docker network and defined it accordingly. The network called "proxy" is used throughout this project.

'docker network create proxy'

#### Cloudflare DNS Challenge
Cloudflare is currently used as the DNS Challenge for SSL certs, which requires an API token.

To create your API token, create a cloudflare account and add your domain. Go to your profile and locate API Tokens. Generate a new token for your domain with the following permissions:

Zone.Zone, Zone.DNS

Set the generated Token in the .env as CF_DNS_API_TOKEN

NOTE: THIS IS OPEN TO BE CHANGED TO A DNS CHALLENGE METHOD THAT DOES NOT REQUIRE AN ACCOUNT

#### Ansible playbook deployment

Adding docker compose services to the ansible playbook is as simple as the following:

```
- name: Deploy example
      docker_compose:
        project_src: ./docker/example/
        state: present
```

Ensure that the docker-compose has the appropriate Traefik labels as mentioned earlier.

Deploy the playbook with the following:
`ansible-playbook playbook.yml`


