---
title: Optimize Proxy Configuration and Transport Modes
impact: HIGH
impactDescription: 2-10x throughput improvement with correct transport mode and proxy sizing
tags: proxy, transport-mode, direct-san, hot-add, nbd, network, throughput
---

## Optimize Proxy Configuration and Transport Modes

Backup proxies are the data movers in a Veeam architecture. Choosing the correct transport mode and properly sizing proxies directly determines whether backup windows are met.

### Transport Mode Priority

Always prefer the highest-performing transport mode available in your environment:

| Priority | Mode | Throughput | Requirements |
|----------|------|------------|-------------|
| 1 | **Direct SAN** (Fibre Channel / iSCSI) | 400-600 MB/s | Physical proxy with SAN access to datastores |
| 2 | **Hot-Add** (Virtual Appliance) | 200-400 MB/s | Virtual proxy on the same ESXi host/cluster |
| 3 | **Network (NBD/NBDSSL)** | 100-200 MB/s | Network connectivity only (10 GbE minimum) |

> **Direct SAN** bypasses the hypervisor entirely and reads data blocks directly from storage. Use this for the highest throughput on physical proxies with Fibre Channel or iSCSI connectivity.

### Proxy Sizing Guidelines

| Resource | Recommendation |
|----------|---------------|
| vCPU / Cores | 1 core per concurrent task (2 tasks per core maximum) |
| RAM | 2 GB per core (minimum 8 GB) |
| Minimum per site | 2 proxies (high availability) |
| Maximum tasks per proxy | Match core count; do not oversubscribe |
| Disk | Minimal local disk; proxies are CPU/RAM-bound |

**Sizing example:**

```
Environment: 200 VMs, 8-hour backup window
Average VM size: 100 GB, 10% daily change rate
Data per night: 200 x 100 GB x 10% = 2 TB

Required throughput: 2 TB / 8 hours = 250 MB/s = ~70 MB/s per proxy (4 proxies)
Each proxy: 4 cores, 8 GB RAM, 4 concurrent tasks
```

### Network Requirements

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| Proxy ↔ Repository | 10 GbE | 25 GbE |
| Proxy ↔ ESXi (NBD) | 10 GbE | 10 GbE dedicated |
| MTU | 1500 (default) | 9000 (Jumbo Frames) |
| Latency | < 5 ms | < 1 ms |

> Enable **Jumbo Frames (MTU 9000)** end-to-end (NIC → switch → NIC) for NBD transport to reduce CPU overhead and improve throughput by 10-20%.

### Proxy Placement Decision

```
Is SAN storage (FC/iSCSI) available?
├── Yes → Deploy physical proxy with Direct SAN access
│         (highest throughput, no hypervisor overhead)
└── No  → Is the proxy on the same cluster as VMs?
    ├── Yes → Deploy virtual proxy with Hot-Add mode
    │         (good throughput, automatic disk mount)
    └── No  → Deploy proxy with Network (NBD) mode
              (ensure 10 GbE + Jumbo Frames)
```

### Best Practices

- **Deploy at least 2 proxies per site** for fault tolerance and load balancing.
- **Place Hot-Add proxies in the same cluster** as protected VMs to avoid cross-cluster vMotion of proxy disks.
- **Avoid mixing transport modes** on the same proxy when possible — let Veeam auto-select, but validate the selected mode in session logs.
- **Use dedicated NICs** for backup traffic; separate from production and management networks using VLANs or physical isolation.
- **Monitor proxy task utilization** in Veeam ONE — if proxies consistently run at 100% task capacity, add more proxies or cores.

**Incorrect (under-sized, single proxy):**

```
1 virtual proxy, 2 cores, 4 GB RAM
Transport: Network (NBD) over 1 GbE shared NIC
# Result: 50 MB/s max, 11-hour backup window, missed SLA
```

**Correct (right-sized, redundant proxies):**

```
4 physical proxies, 4 cores each, 8 GB RAM each
Transport: Direct SAN (Fibre Channel)
Network: 10 GbE dedicated backup VLAN, MTU 9000
# Result: 500+ MB/s aggregate, 4-hour backup window
```

### Verification Checklist

- [ ] Transport mode matches infrastructure (Direct SAN > Hot-Add > NBD)
- [ ] At least 2 proxies deployed per site
- [ ] Proxy cores and RAM match concurrent task requirements
- [ ] 10 GbE or higher between proxy and repository
- [ ] Jumbo Frames enabled end-to-end for NBD transport
- [ ] Backup traffic isolated on dedicated NICs or VLANs
- [ ] Proxy task utilization monitored in Veeam ONE

Reference: [Veeam Proxy Best Practices](https://bp.veeam.com/vbr/3_Build_structures/B_Veeam_Components/B_backup_proxies/)
