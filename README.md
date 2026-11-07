# Homelab

This project will contain all code to setup my homelab in a Proxmox cluster with multiple machines.

## About this project

The plan is to have most/all configurations and setup defined by code,
this will be done by using:

- [SOPS](https://github.com/getsops/sops) for initial setup for proxmox iso's and openbao
- [OpenTofu](https://github.com/opentofu/opentofu) to setup the required VMs
- [Ansible](https://github.com/ansible/ansible) to configure these VMs
- **K3S** cluster to contain all my required apps
- [VyOS](https://docs.vyos.io/en/rolling/introducing/about.html) to act as server between my LAN/VPN and the cluster
- [OpenBAO](https://github.com/openbao/openbao) for secret management

### Applications

The plan is to migrate my old applications and add new applications,
these range from **Immich**, **Vaultwarden** to a full media server using the [**\*arr**](https://github.com/Ravencentric/awesome-arr)

### Why?

My first homelab was managed on a single Proxmox host with multiple **LXC** containers and multiple **Virtual Machines**.
Most traffic was routed trough an OPNSense VM where also my VPN was connected to.

A lot of stuff was done manually such as setting DNS, Reverse proxies, updating containers.
There were also 20-30 different passwords as no centalized authentication.

My plan with the revamp will be:

- Better security by design, including firewall inside cluster and from the outside, and rolling updates
- Replicability when something went wrong
- Redundancy of both running services and the data it contains

### Inventory

Currently **pve** is used and runs all services, when ready everything will be migrated and it will join the cluster

| Occupied? | Name                    | CPU                 | RAM       | GPU            | Main storage | Extra storage | Job     |
| --------- | ----------------------- | ------------------- | --------- | -------------- | ------------ | ------------- | ------- |
| **Yes**   | **pve** -> Shiro Mukuba | i7-6700T (8c)       | 16GB DDR4 |                | 500GB SSD    | 1TB HDD       | Compute |
| **No**    | Mini Merry              | Ryzen 5 3600X (12c) | 16GB DDR4 | RTX 2060 Super | 500GB SSD    | 2TB HDD       | Compute |
| **No**    | Shark Submerge          | i5-3330S (4c)       | 8GB       |                | 1TB HDD      |               | Storage |

### Plan

Ideally in this planning, I would need to be able to fully remove everything and start from a fresh install and it would work

#### Stage 1: **Core**

- [] Continueing automating setup of Proxmox cluster

#### Stage 2: Secret management + Cluster setup

- [] **Ansible**: Setup storage of the proxmox cluster
- [] **OpenTofu/Ansible**: Base for creating **LXC**/**VM**s automatically
- [] **OpenTofu/Ansible**: Setup **OpenBAO**
- [] **OpenTofu/Ansible**: Setup **VyOS**

#### Stage 3: Base K3S setup

- [] **OpenTofu/Ansible**: Creation of K3S cluster
- [] **Kubernetes**: Setup Postgresql + [CloudNativePG](https://github.com/cloudnative-pg/cloudnative-pg)
- [] **Kubernetes**: Setup certificates manager
- [] **Kubernetes**: Setup ingress + traefik
- [] **Kubernetes**: Setup k8s_gateway
- [] **Kubernetes**: Setup [Cilium](https://docs.cilium.io/en/stable/installation/k3s/) to control traffic inside of the cluster

#### Stage 4: Setup git + CI/CD

- [] **Kubernetes**: Setup Forgejo + mirror to github/codeberg
- [] **Kubernetes**: CI/CD with FluxCD/ArgoCD
- [] **Ansible**: Auto deploying current cluster to a fresh K3S node/cluster without issues

#### Stage 5: Access Control + Start installing applications

- [] **Kubernetes**: Setup Authelia/Keycloak for central auth managment of applications
- [] **Kubernetes**: Setup arr stack
- [] **Migration**: Migrate the data of scrob

#### Stage 6: Setup applications with critical data

- [] **Kubernetes**: Setup **Immich**
- [] **Kubernetes**: Setup **Nextcloud**
- [] **Kubernetes**: Setup **Vaultwarden**
- [] **Migration**: Copy data to the new applications [**Critical data** -> Backup to personal drive]

#### Stage 7: Varia

- [] Monitors of all data and statistics
- [] [Renovate](https://github.com/renovatebot/renovate) for up-to-date applications
- [] ...
