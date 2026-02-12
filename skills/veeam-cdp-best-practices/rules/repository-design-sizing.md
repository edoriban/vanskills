---
title: Design and Size Backup Repositories Correctly
impact: CRITICAL
impactDescription: Prevents backup failures, storage bottlenecks, and missed backup windows
tags: repository, sizing, refs, xfs, sobr, object-storage, capacity-planning
---

## Design and Size Backup Repositories Correctly

Under-sized or misconfigured repositories are the primary cause of failed backup windows. Proper sizing of CPU, RAM, storage, and filesystem selection ensures reliable backup and restore operations.

### Repository Sizing Formulas

| Resource | Formula | Example (12 proxy cores) |
|----------|---------|--------------------------|
| CPU cores | 1 repo core per 3 proxy cores | 4 cores |
| RAM | Repo cores x 4 GB | 16 GB |
| Disk IOPS | Estimate 10 IOPS per concurrent VM task | 120 IOPS for 12 tasks |
| Network | 10 GbE minimum between proxy and repo | 10 GbE NIC |

> **Rule of thumb:** Provision repository storage at 1.5x the source data size to account for change rates and retention. Use Veeam ONE Reporter or the Veeam Capacity Planning tool for precise estimates.

### Filesystem Comparison: ReFS vs XFS

| Feature | Windows ReFS | Linux XFS |
|---------|-------------|-----------|
| Block size | 64 KB (required) | 64 KB (recommended) |
| Block cloning (fast synthetic full) | Yes | Yes (via Fast Clone / reflink on XFS 5.1+) |
| Immutability support | No native immutability | Yes (Hardened Linux Repo) |
| Max tested volume size | 64 TB (recommended) | 64 TB (recommended) |
| Best for | Environments with existing Windows infrastructure | Immutable repositories, Hardened Linux Repo |

> Always format volumes with **64 KB block size** regardless of filesystem to align with Veeam's data block size.

### Physical vs Virtual Repositories

| Aspect | Physical | Virtual |
|--------|----------|---------|
| Performance | Direct disk access, lower latency | Hypervisor overhead |
| Recommended for | Production backup repositories | Lab, test, or small environments |
| Immutability | Full support (Hardened Linux) | Supported but less isolation |

> **Best practice:** Use physical servers for production repositories. Virtual repositories introduce a hypervisor dependency that complicates disaster recovery.

### Per-VM Backup Chains

Enable **per-VM backup chains** for:
- Faster restores (each VM has its own chain)
- Better parallelism during synthetic full operations
- Easier management when removing individual VMs from jobs

**Incorrect (single backup chain for the entire job):**

```
Job "All Servers" → single .vbk + .vib chain
# Restoring 1 VM requires reading the entire chain
# Synthetic full processes all VMs sequentially
```

**Correct (per-VM backup chains):**

```
Job "All Servers" → per-VM chains enabled
# Each VM: individual .vbk + .vib files
# Restore targets only the relevant VM chain
# Synthetic full processes VMs in parallel
```

### Scale-Out Backup Repository (SOBR) Design

| Guideline | Recommendation |
|-----------|----------------|
| Number of extents | 3-4 maximum per SOBR |
| Extent sizing | All extents should be equal capacity |
| Placement policy | Data Locality (default) for performance |
| Network between extents | 10 GbE minimum |
| Capacity Tier | S3-compatible with Object Lock enabled |
| Archive Tier | S3 Glacier / Azure Archive for long-term |

```
SOBR "Primary"
├── Performance Tier
│   ├── Extent 1: Hardened Linux Repo (XFS, 64 KB, immutable)
│   ├── Extent 2: Hardened Linux Repo (XFS, 64 KB, immutable)
│   └── Extent 3: Hardened Linux Repo (XFS, 64 KB, immutable)
├── Capacity Tier
│   └── S3 Object Lock bucket (Compliance mode, copy + move policy)
└── Archive Tier
    └── S3 Glacier Deep Archive (GFS long-term retention)
```

### Object Storage Integration

- Enable **S3 Object Lock in Compliance mode** on the capacity tier bucket — Governance mode can be overridden by privileged users.
- Enable **versioning** on the bucket (required by Object Lock).
- Set lifecycle policies to transition to cheaper tiers (Glacier) after the active retention period.
- Use **copy policy** to offload backups immediately; add **move policy** only after the operational restore window expires.

### Verification Checklist

- [ ] Repository CPU and RAM sized according to proxy core count
- [ ] Volumes formatted with 64 KB block size (ReFS or XFS)
- [ ] Physical servers used for production repositories
- [ ] Per-VM backup chains enabled on all jobs
- [ ] SOBR has no more than 4 equal-capacity extents
- [ ] Capacity tier uses S3 Object Lock in Compliance mode
- [ ] Network between proxy and repository is 10 GbE or higher

Reference: [Veeam Repository Best Practices](https://bp.veeam.com/vbr/3_Build_structures/B_Veeam_Components/B_backup_repositories/)
