---
title: Design CDP Architecture for Tier 1 Workloads
impact: CRITICAL
impactDescription: Enables near-zero RPO (2-15 seconds) for mission-critical VMs
tags: cdp, continuous-data-protection, vaio, io-filter, rpo, tier-1, replication
---

## Design CDP Architecture for Tier 1 Workloads

Continuous Data Protection (CDP) provides near-zero RPO by capturing every I/O write in real-time. Unlike traditional backup (which is snapshot-based), CDP uses VMware VAIO I/O filters to intercept writes at the hypervisor level. Reserve CDP for Tier 1 mission-critical workloads due to its higher resource requirements.

### CDP vs Traditional Backup

| Feature | Traditional Backup | CDP |
|---------|-------------------|-----|
| Mechanism | VMware snapshots | VAIO I/O filter (snapshotless) |
| Minimum RPO | 1 hour (practical) | 2 seconds (theoretical) |
| Production I/O impact | Snapshot stun during commit | Minimal (async I/O intercept) |
| Target | Backup repository (deduplicated) | Target proxy datastore (transaction logs) |
| Restore type | Full VM, file-level, app-item | Failover to any point-in-time |
| Best for | All workloads | Tier 1 only (databases, ERP, financial) |

### CDP Architecture Diagram

```
┌─────────────┐    VAIO I/O     ┌──────────────┐    TCP/10GbE    ┌──────────────┐
│  Production  │───  Filter  ───│   Source      │───────────────→│   Target     │
│     VM       │                │   CDP Proxy   │                │   CDP Proxy  │
└─────────────┘                └──────────────┘                └──────┬───────┘
                                                                       │
                                                                       ▼
                                                               ┌──────────────┐
                                                               │  Target Host │
                                                               │  Datastore   │
                                                               │  (Txn Logs)  │
                                                               └──────────────┘
```

**Component roles:**
1. **VAIO I/O Filter**: Installed on ESXi hosts; intercepts all VM disk writes without snapshots.
2. **Source CDP Proxy**: Receives intercepted I/O from the filter; compresses and sends to target proxy.
3. **Target CDP Proxy**: Receives I/O stream; writes transaction logs to the target datastore.
4. **Transaction Logs**: Stored on target datastore; contain every write operation for point-in-time replay.

### RPO Target Selection

| RPO Setting | CPU Overhead | Network Load | Use Case |
|-------------|-------------|--------------|----------|
| **2-5 seconds** | Very High | Very High | Financial trading, real-time analytics |
| **15 seconds** | High | High | Tier 1 databases, ERP systems (recommended) |
| **30-60 seconds** | Medium | Medium | Business-critical apps with moderate tolerance |
| **5-60 minutes** | Low | Low | Consider traditional replication instead |

> **Recommended default RPO: 15 seconds.** This balances data protection with resource consumption. RPOs below 5 seconds require dedicated 25 GbE network and high-performance storage.

### Network Requirements

| Path | Minimum | Recommended |
|------|---------|-------------|
| ESXi ↔ Source CDP Proxy | 10 GbE | 10 GbE dedicated |
| Source CDP Proxy ↔ Target CDP Proxy | 10 GbE | 25 GbE |
| MTU | 1500 | 9000 (Jumbo Frames) |
| Latency | < 5 ms | < 2 ms |

> CDP is bandwidth-sensitive. Calculate required bandwidth as: `Change Rate (MB/s) x 1.1 (overhead)`. For a VM with 50 MB/s sustained write rate, provision at least 55 MB/s (440 Mbps) of dedicated network capacity.

### Tier 1 Workload Selection Criteria

Not every VM should use CDP. Use these criteria to identify candidates:

| Criterion | Qualifies for CDP | Use Traditional Backup |
|-----------|-------------------|----------------------|
| RPO requirement | < 15 minutes | > 15 minutes |
| Revenue impact of downtime | > $10K/hour | < $10K/hour |
| Data change rate | Moderate to high | Low |
| Application type | Database, ERP, financial | File server, web, dev/test |
| Compliance requirement | Real-time data protection mandated | Standard backup sufficient |

> **Rule of thumb:** If the organization cannot afford to lose more than 15 minutes of data for a workload, it belongs on CDP. Everything else uses standard backup with replication.

### CDP Policy Configuration

**Incorrect (CDP applied to all VMs):**

```
CDP Policy: "All Production VMs"
RPO: 5 seconds
VMs: 200 (all production)
# Excessive resource consumption; source/target proxies overwhelmed
# Network saturated; production I/O impacted
```

**Correct (CDP scoped to Tier 1 only):**

```
CDP Policy: "Tier 1 Critical"
RPO: 15 seconds
VMs: 12 (SQL cluster, ERP, financial DB)
Short-term retention: 4 hours (transaction logs)
Long-term retention: 7 days (target datastore restore points)

Standard Backup Job: "All Production"
RPO: 1 hour (scheduled backups)
VMs: 200 (all production including Tier 1)
# Tier 1 VMs get CDP + standard backup (defense in depth)
```

### Verification Checklist

- [ ] VAIO I/O filter installed on all ESXi hosts protecting CDP-enabled VMs
- [ ] Source and target CDP proxies deployed and sized for workload I/O rate
- [ ] RPO set to 15 seconds or higher (only lower if justified and resourced)
- [ ] 10 GbE minimum, 25 GbE recommended between source and target proxies
- [ ] Jumbo Frames enabled end-to-end for CDP traffic
- [ ] CDP applied only to Tier 1 workloads (< 20% of total VMs)
- [ ] Tier 1 VMs also protected by standard backup jobs (defense in depth)
- [ ] Transaction log retention sized for target datastore capacity

Reference: [Veeam CDP Best Practices](https://bp.veeam.com/vbr/4_Design_Guide/D_Veeam_usage/D_cdp/)
