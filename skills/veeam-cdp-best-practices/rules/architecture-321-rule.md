---
title: Follow the 3-2-1-1-0 Backup Rule with Immutability
impact: CRITICAL
impactDescription: Prevents total data loss from ransomware, site disasters, and insider threats
tags: 3-2-1-1-0, immutability, air-gap, backup-architecture, ransomware-protection
---

## Follow the 3-2-1-1-0 Backup Rule with Immutability

The 3-2-1-1-0 rule is the foundation of any resilient Veeam architecture. Every digit represents a layer of protection that must be satisfied before a backup strategy can be considered production-ready.

### The 3-2-1-1-0 Breakdown

| Digit | Meaning | Example |
|-------|---------|---------|
| **3** | At least 3 copies of data | Production + local backup + offsite copy |
| **2** | On at least 2 different media types | Disk + object storage (or tape) |
| **1** | At least 1 copy offsite | Cloud repository, remote site, or tape vault |
| **1** | At least 1 copy immutable or air-gapped | Hardened Linux Repo, S3 Object Lock, WORM tape |
| **0** | 0 errors in SureBackup recovery verification | Automated SureBackup jobs pass every cycle |

### Immutability Options

| Option | Immutability Type | Air-Gap | Cost | Best For |
|--------|-------------------|---------|------|----------|
| Hardened Linux Repository | Software-based (XFS) | No (logical) | Low | On-prem primary immutable target |
| S3 Object Lock (Compliance) | Object-level lock | No (logical) | Medium | Cloud capacity tier / archive |
| Tape / WORM | Physical media | Yes (physical) | Low-Medium | Long-term retention, compliance |
| Veeam Data Cloud Vault | Managed immutable cloud | Yes (logical) | Higher | Fully managed offsite immutable copy |

### Air-Gap and Offline Strategies

- **Physical air-gap**: Rotate tapes offsite; eject media after backup window completes.
- **Logical air-gap**: Use S3 Object Lock in Compliance mode (cannot be deleted even by root). Hardened Linux Repo prevents deletion for the configured immutability period.
- **Network isolation**: Place the immutable repository on a management VLAN with no inbound access from production networks; use Veeam's built-in encrypted channel.

### Decision Tree: Selecting Immutability

```
Is the target on-premises?
├── Yes → Does the org manage Linux infrastructure?
│   ├── Yes → Hardened Linux Repository (XFS + immutability flag)
│   └── No  → WORM tape with offsite rotation
└── No  → Is a fully managed solution preferred?
    ├── Yes → Veeam Data Cloud Vault
    └── No  → S3-compatible Object Lock (Compliance mode)
```

### Examples

**Incorrect (no immutable copy):**

```
Backup job → Windows ReFS repository (local)
Copy job   → Windows share at DR site (SMB)

# Both targets are mutable — ransomware can encrypt or delete all copies.
# No SureBackup job exists — recovery is untested.
```

**Correct (3-2-1-1-0 satisfied):**

```
Backup job → Hardened Linux Repository (immutable, 14-day lock)
Copy job   → S3 Object Lock bucket (Compliance mode, 30-day retention)
Tape job   → LTO-9 WORM, weekly offsite rotation
SureBackup → Automated daily verification, 0 errors

# 3 copies: local + S3 + tape
# 2 media: disk + object storage + tape
# 1 offsite: S3 bucket in different region
# 1 immutable: Hardened Linux Repo + S3 Object Lock
# 0 errors: SureBackup runs daily
```

### Verification Checklist

- [ ] At least 3 independent copies of all protected data exist
- [ ] Copies span at least 2 different media types
- [ ] At least 1 copy is stored offsite (different location or cloud region)
- [ ] At least 1 copy is immutable or air-gapped
- [ ] SureBackup / SureReplica jobs run regularly with 0 errors
- [ ] Immutability retention period exceeds the longest realistic detection window for ransomware (minimum 14 days)

Reference: [Veeam 3-2-1-1-0 Rule](https://www.veeam.com/blog/321-backup-rule.html)
