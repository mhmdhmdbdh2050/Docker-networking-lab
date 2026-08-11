#!/usr/bin/env bash

set -e

echo "======================================"
echo " Docker Networking Lab - Setup"
echo "======================================"

echo
echo "[1/4] Creating Docker networks..."

docker network create \
  --driver bridge \
  --subnet 172.18.0.0/16 \
  network1 2>/dev/null || echo "network1 already exists."

docker network create \
  --driver bridge \
  --subnet 10.0.0.0/16 \
  network2 2>/dev/null || echo "network2 already exists."

echo
echo "[2/4] Creating containers..."

docker run -dit \
  --name cont1 \
  --network network1 \
  --ip 172.18.0.2 \
  ubuntu bash 2>/dev/null || echo "cont1 already exists."

docker run -dit \
  --name cont2 \
  --network network1 \
  --ip 172.18.0.3 \
  ubuntu bash 2>/dev/null || echo "cont2 already exists."

docker run -dit \
  --name cont3 \
  --network network1 \
  --ip 172.18.0.4 \
  ubuntu bash 2>/dev/null || echo "cont3 already exists."

docker run -dit \
  --name cont4 \
  --network network2 \
  --ip 10.0.0.3 \
  ubuntu bash 2>/dev/null || echo "cont4 already exists."

echo
echo "[3/4] Connecting cont3 to network2..."

docker network connect \
  --ip 10.0.0.2 \
  network2 \
  cont3 2>/dev/null || echo "cont3 is already connected to network2."

echo
echo "[4/4] Setup completed successfully."

echo
echo "======================================"
echo " Network Configuration"
echo "======================================"

docker network inspect network1 \
  --format 'network1: {{range .IPAM.Config}}{{.Subnet}}{{end}}'

docker network inspect network2 \
  --format 'network2: {{range .IPAM.Config}}{{.Subnet}}{{end}}'

echo
echo "Containers:"
docker ps \
  --filter "name=cont1" \
  --filter "name=cont2" \
  --filter "name=cont3" \
  --filter "name=cont4" \
  --format "table {{.Names}}\t{{.Status}}\t{{.Networks}}"

echo
echo "======================================"
echo " Lab is ready!"
echo "======================================"
