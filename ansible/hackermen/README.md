### DEPLOYING TRAEFIK WITH ANSIBLE AS A DOCKER-COMPOSE

Current features: Deploys Traefik as Docker container an uses staging SSL certs by default.
Bugs: the Traefik dashboard doesn't load and FocalBoard isn't working with HTTPS

Run the playbook: `ansible-playbook traefik-playbook.yml`

This playbook downloads docker and docker-compose and deploys the compose file for Traefik (./docker/docker-compose.yml)

All services will need to be configured with docker-compose for ease of deployment. It allows changes to be made to the labels of the individual docker services without modifying the ansible script and as an example allows the service to run as a cronjob pulling the latest docker configurations from the repo.

The traefik configuration (./config/traefik.yml) is downloaded from get_url which is hardcoded, will break on directory changes, needs fixed.

the playbook creates the directory /opt/traefik-config and saves the config

the docker-compose creates a volume in that directory 
      - `/opt/traefik-config/traefik.yml:/etc/traefik/traefik.yml`

the following labels are needed for SSL/TLS:
    - `traefik.enable=true`
      - ``traefik.http.routers.dashboard.rule=Host(`dashboard-subdomain.overflow.no`)``
      - `traefik.http.routers.dashboard.service=api@internal`
      - `traefik.http.routers.dashboard.tls=true`
      - `traefik.http.routers.dashboard.tls.certresolver=staging`

HTTPS Redirection:
      - `traefik.http.routers.httpCatchall.rule=HostRegexp(\`{any:.+}\`)`
      - `traefik.http.routers.httpCatchall.entrypoints=http`
      - `traefik.http.routers.httpCatchall.middlewares=httpsRedirect`
      - `traefik.http.middlewares.httpsRedirect.redirectscheme.scheme=https`
      - `traefik.http.middlewares.httpsRedirect.redirectscheme.permanent=true`
    
Dashboard Authentication Middleware labels:
      - `traefik.http.routers.dashboard.middlewares=dashboardAuth`
      - `traefik.http.middlewares.dashboardAuth.basicauth users=user:$$xx$$xx$$xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`



The SSL cert resolver is defined at the bottom of the traefik.yml config
```
certificatesResolvers:
  staging:
    acme:
      email: your-email@example.com
      storage: /etc/traefik/certs/acme.json
      caServer: "https://acme-staging-v02.api.letsencrypt.org/directory"
```
when in development make sure to use staging in case of rate limiting
after testing move to production cert resolver defined in the labels above
