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

#### Stage 1: Foundation

- [ ] Repo, mise, SOPS/age, pre-commit, Renovate
- [ ] Automated Proxmox installs (test VM → pve2 → pve3)
- [ ] Ansible: base Proxmox config + cluster (pve2 + pve3)
- [ ] Ansible: storage (ZFS bulk pools, NFS exports)
- [ ] Ansible: PBS on pve3 + back up old pve1 (safety net)

#### Stage 2: Platform outside k3s

- [ ] OpenTofu: VM/LXC modules + cloud-image templates
- [ ] OpenTofu/Ansible: OpenBao (1 node) + init/unseal runbook
- [ ] OpenTofu: OpenBao config (policies, AppRole for Ansible)
- [ ] OpenTofu/Ansible: Garage S3 on pve3 (backup target + Tofu state)
- [ ] OpenTofu/Ansible: VyOS on a test VLAN (no cutover yet)

#### Stage 3: k3s + GitOps

- [ ] OpenTofu/Ansible: k3s VMs + k3s install
- [ ] Ansible: Cilium (CNI, LB-IPAM)
- [ ] Flux bootstrap (GitHub/Codeberg as source)
- [ ] Flux: External Secrets → OpenBao
- [ ] Flux: Longhorn + NFS CSI + StorageClasses
- [ ] Flux: cert-manager + Traefik + k8s_gateway
- [ ] Flux: CloudNativePG + backups to Garage
- [ ] OPNsense Unbound forwards the home zone to k8s_gateway
- [ ] CI: lint + tofu plan on pull requests
- [ ] Rebuild test: wipe k3s, restore from Git + backups

#### Stage 4: Observability + backups verified

- [ ] Basic monitoring + alerts (VictoriaMetrics/Grafana, disk/node alerts)
- [ ] Off-site backup sync
- [ ] Restore tests: PBS VM, Longhorn volume, CNPG point-in-time

#### Stage 5: Auth + first apps

- [ ] Authelia (SSO)
- [ ] arr stack (configs on Longhorn, media on NFS)
- [ ] Migrate scrob data

#### Stage 6: Critical data apps

- [ ] Vaultwarden (independent of SSO, high priority)
- [ ] Immich (photos on NFS, CNPG with VectorChord)
- [ ] Nextcloud
- [ ] Migrate data (copy to a personal drive first)

#### Stage 7: Cutover + full HA

- [ ] Router cutover OPNsense → VyOS
- [ ] Empty pve1, rebuild it, join the cluster
- [ ] Scale up: 3 etcd, 3 OpenBao, Longhorn x2, CNPG x2, VyOS HA
- [ ] Pull-the-plug tests per host

#### Stage 8: Extras

- [ ] Forgejo mirror (optional)
- [ ] More dashboards and statistics
- [ ] ...
