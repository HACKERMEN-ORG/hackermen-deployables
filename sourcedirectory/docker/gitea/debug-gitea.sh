#!/bin/bash

echo "=== Gitea Debugging Guide ==="
echo ""

echo "1. Check if Gitea container is running:"
docker ps | grep gitea

echo ""
echo "2. Check Gitea container logs:"
docker logs gitea --tail 50

echo ""
echo "3. Check if proxy network exists:"
docker network ls | grep proxy

echo ""
echo "4. Check if Gitea is in proxy network:"
docker inspect gitea | grep -A 10 Networks

echo ""
echo "5. Test internal connectivity (from traefik to gitea):"
docker exec traefik wget -q --spider http://gitea:3000 && echo "Connection OK" || echo "Connection FAILED"

echo ""
echo "6. Check Traefik routes:"
docker exec traefik cat /etc/traefik/traefik.yml

echo ""
echo "7. Check if port 3000 is responding inside container:"
docker exec gitea netstat -tlnp | grep 3000

echo ""
echo "=== Quick Fixes ==="
echo "If Gitea isn't running: docker-compose up -d"
echo "If network issues: docker-compose down && docker-compose up -d"
echo "If still failing: docker-compose logs -f"