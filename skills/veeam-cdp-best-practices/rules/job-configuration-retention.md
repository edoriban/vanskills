---
title: Configure Backup Jobs with Proper Retention and Optimization
impact: HIGH
impactDescription: Reduces storage consumption 30-60% and ensures compliant data retention
tags: backup-job, retention, synthetic-full, gfs, compression, deduplication, scheduling
---

## Configure Backup Jobs with Proper Retention and Optimization

Backup job configuration directly impacts storage consumption, backup window duration, and recovery point compliance. Proper settings for full backup method, retention, compression, and deduplication are essential.

### Synthetic Full vs Active Full

| Method | How It Works | Best For | Storage Impact |
|--------|-------------|----------|----------------|
| **Synthetic Full** | Assembles full from existing chain (no production I/O) | ReFS / XFS repos with block cloning | Low (instant via reflink) |
| **Active Full** | Reads all data from source again | NAS / dedup appliances / no block cloning | High (full read + write) |
| **Forever Forward Incremental** | No periodic full; relies on merge | Small environments, limited storage | Lowest, but merge is I/O intensive |

> **Default recommendation:** Use **Synthetic Full** on ReFS/XFS repositories with block cloning. Schedule a weekly synthetic full (e.g., Saturday). Reserve Active Full for NAS targets or dedup appliances that benefit from re-hydration.

### Retention Policies

#### Days-Based Retention

| Tier | Retention | Use Case |
|------|-----------|----------|
| Operational | 14-30 days | Fast restores from local repository |
| Short-term offsite | 30-90 days | DR site or cloud copy |
| Long-term archive | 1-7 years | Compliance (GDPR, HIPAA, SOX) |

#### GFS (Grandfather-Father-Son) Retention

| GFS Level | Frequency | Retention Example |
|-----------|-----------|-------------------|
| Weekly (Son) | Every Saturday | 4 weeks |
| Monthly (Father) | First Saturday of month | 12 months |
| Yearly (Grandfather) | First Saturday of January | 7 years |

```
Backup Job → Retention: 14 daily restore points
           → GFS: Weekly=4, Monthly=12, Yearly=7
           → Archive to Capacity Tier after 14 days
```

### Scheduling and Staggering

- **Stagger job start times** by 10-15 minutes to avoid proxy/repository contention.
- **Limit concurrent tasks** per repository to avoid I/O saturation (rule of thumb: 1 task per physical disk spindle or NVMe queue).
- **Schedule copy/tape jobs** to start after primary backup job completes (use "After this job" chaining).
- **Avoid overlapping backup windows** between production and copy jobs.

**Incorrect (all jobs start simultaneously):**

```
Job "DB Servers"    → Start: 20:00
Job "App Servers"   → Start: 20:00
Job "File Servers"  → Start: 20:00
# All 3 jobs compete for the same proxies and repository I/O
```

**Correct (staggered with chaining):**

```
Job "DB Servers"    → Start: 20:00  (highest priority)
Job "App Servers"   → Start: 20:15
Job "File Servers"  → Start: 20:30
Copy Job            → After: "DB Servers" completes
```

### Compression Settings

| Level | Algorithm | CPU Impact | Ratio | Best For |
|-------|-----------|------------|-------|----------|
| **None** | — | Lowest | 1:1 | Dedup appliances (they compress internally) |
| **Dedupe-friendly** | LZ4 (fixed 256 KB) | Low | ~1.5:1 | Dedup storage targets |
| **Optimal** (default) | LZ4 | Low-Medium | ~2:1 | General use (recommended default) |
| **High** | zlib | High | ~2.5:1 | WAN copy jobs, slow links |
| **Extreme** | zstd | Very High | ~3:1 | Archive/tape with available CPU |

> Keep **Optimal (LZ4)** as the default. Only increase compression for WAN-based copy jobs where bandwidth is the bottleneck, not CPU.

### Deduplication Block Size

| Block Size | Use Case |
|------------|----------|
| **Local target (1 MB)** | Default for local or SAN-attached repositories |
| **LAN target (512 KB)** | Repositories accessed over LAN |
| **WAN target (256 KB)** | Cloud or remote repositories over WAN links |

> Smaller block sizes improve deduplication ratio at the cost of higher CPU and metadata overhead. Use the default unless the target is remote.

### Application-Aware Processing

- **Enable application-aware processing** for all VMs running databases (SQL Server, Oracle, PostgreSQL) or applications with VSS writers (Exchange, AD, SharePoint).
- **Configure guest OS credentials** with appropriate privileges for VSS quiescing.
- **Use pre/post scripts** for applications without VSS support (e.g., MySQL dump before snapshot).

### Verification Checklist

- [ ] Synthetic Full configured for ReFS/XFS repositories; Active Full for NAS/dedup targets
- [ ] Retention policy matches business and compliance requirements
- [ ] GFS retention configured for long-term compliance needs
- [ ] Jobs staggered by 10-15 minutes to avoid contention
- [ ] Compression set to Optimal (LZ4) by default
- [ ] Deduplication block size matches target location (Local/LAN/WAN)
- [ ] Application-aware processing enabled for database and application VMs
- [ ] Copy/tape jobs chained to run after primary backup completes

Reference: [Veeam Job Configuration Best Practices](https://bp.veeam.com/vbr/4_Design_Guide/D_Veeam_usage/D_backup/)
