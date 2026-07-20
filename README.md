# 🐳 Docker Multi-Networking Lab

A hands-on Docker networking project demonstrating how containers communicate across custom bridge networks, how static IP addresses can be assigned, and how a single container can connect to multiple Docker networks.

This lab focuses on practical Docker networking concepts including:

- Custom bridge networks
- Network isolation
- Static container IP addresses
- Multi-network containers
- Container-to-container communication
- ICMP connectivity testing
- Docker network inspection
- Basic routing concepts

---

## 📌 Project Overview

The project creates **four Ubuntu containers** distributed across **two custom Docker bridge networks**.

The main goal is to demonstrate how Docker isolates containers based on network membership and how a container can participate in multiple networks simultaneously.

Two networks are created:

| Network | Subnet |
|---|---|
| `network1` | `172.18.0.0/16` |
| `network2` | `10.0.0.0/16` |

Four containers are deployed:

| Container | Network | IP Address |
|---|---|---|
| `cont1` | `network1` | `172.18.0.2` |
| `cont2` | `network1` | `172.18.0.3` |
| `cont3` | `network1` | `172.18.0.4` |
| `cont3` | `network2` | `10.0.0.2` |
| `cont4` | `network2` | `10.0.0.3` |

`cont3` is connected to both networks, making it a **multi-homed container** with two network interfaces.

> Important: Connecting `cont3` to both networks does not automatically make it a router. Containers on different networks still cannot communicate through `cont3` unless IP forwarding and routing are explicitly configured.

---

## 🏗️ Network Architecture

```text
                    Docker Host
┌───────────────────────────────────────────────────────┐
│                                                       │
│          network1 — 172.18.0.0/16                     │
│                                                       │
│     ┌─────────────┐       ┌─────────────┐             │
│     │    cont1    │       │    cont2    │             │
│     │ 172.18.0.2  │       │ 172.18.0.3
