# 🐳 Docker Networking Lab

A hands-on Docker networking project demonstrating custom bridge networks, static IP addressing, container isolation, and multi-network container communication.

## 📌 Project Overview

This project demonstrates how Docker containers communicate across custom bridge networks.

The lab consists of:

- 4 Ubuntu containers
- 2 custom Docker bridge networks
- Static IPv4 addresses
- One multi-homed container connected to both networks
- Connectivity and network isolation testing using `ping`

## 🏗️ Network Architecture

```text
Network1: 172.18.0.0/16

cont1: 172.18.0.2
cont2: 172.18.0.3
cont3: 172.18.0.4
          |
          | Connected to both networks
          |
cont3: 10.0.0.2
cont4: 10.0.0.3

Network2: 10.0.0.0/16
```

`cont3` is connected to both Docker networks and therefore has two network interfaces.

> Note: Being connected to both networks does not automatically make `cont3` a router between them. Containers on different networks remain isolated unless IP forwarding/routing is explicitly configured.

## 🌐 Network Configuration

| Container | Network | IP Address |
|---|---|---|
| cont1 | network1 | 172.18.0.2 |
| cont2 | network1 | 172.18.0.3 |
| cont3 | network1 | 172.18.0.4 |
| cont3 | network2 | 10.0.0.2 |
| cont4 | network2 | 10.0.0.3 |

## 🚀 Implementation

### Create Docker Networks

```bash
docker network create --subnet=172.18.0.0/16 network1
docker network create --subnet=10.0.0.0/16 network2
```

### Create Containers

```bash
docker run -dit --name cont1 --network network1 --ip 172.18.0.2 ubuntu bash

docker run -dit --name cont2 --network network1 --ip 172.18.0.3 ubuntu bash

docker run -dit --name cont3 --network network1 --ip 172.18.0.4 ubuntu bash

docker run -dit --name cont4 --network network2 --ip 10.0.0.3 ubuntu bash
```

### Connect cont3 to Network2

```bash
docker network connect --ip 10.0.0.2 network2 cont3
```

## 🔍 Verify the Configuration

```bash
docker ps

docker network inspect network1

docker network inspect network2

docker inspect cont3
```

## 🧪 Connectivity Testing

Install the `ping` utility inside the Ubuntu containers when needed:

```bash
apt update
apt install -y iputils-ping
```

Containers connected to the same Docker bridge network can communicate directly.

For example:

```bash
# cont1 → cont2
ping 172.18.0.3

# cont1 → cont3
ping 172.18.0.4

# cont4 → cont3
ping 10.0.0.2
```

Containers located only on different bridge networks cannot communicate directly by default.

For example:

```bash
# cont4 → cont2
ping 172.18.0.3
```

## 📸 Test Results

### Docker Networking Connectivity Tests

![Docker Networking Test 1](screenshots/first-image.jpg)

![Docker Networking Test 2](screenshots/second-image.jpg)

![Docker Networking Test 3](screenshots/third-image.jpg)

![Docker Networking Test 4](screenshots/forth-image.jpg)

## 💡 Key Concepts Demonstrated

- Docker custom bridge networks
- Container-to-container communication
- Static IPv4 addressing
- Network isolation
- Multi-network containers
- Docker network inspection
- ICMP connectivity testing
- Basic container networking troubleshooting

## 🛠️ Technologies Used

- Docker
- Docker Desktop
- Ubuntu Linux Containers
- Docker CLI
- Git & GitHub

## 🎯 Learning Outcomes

This project provides practical experience with Docker networking fundamentals and demonstrates how container connectivity is controlled by network membership.

It also highlights an important networking concept: a container connected to multiple networks can communicate directly with containers on each attached network, but it does not automatically route traffic between those networks.

## 📂 Project Structure

```text
docker-networking-lab/
├── README.md
└── screenshots/
    ├── first-image.jpg
    ├── second-image.jpg
    ├── third-image.jpg
    └── forth-image.jpg
```

## 👤 Author

**Mohamed Ahmed Abdo**

Junior DevOps & Cloud Engineer