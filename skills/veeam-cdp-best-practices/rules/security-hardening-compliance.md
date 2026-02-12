---
title: Harden Veeam Infrastructure and Maintain Compliance
impact: CRITICAL
impactDescription: Prevents backup infrastructure compromise — the last line of defense against ransomware
tags: security, hardening, mfa, rbac, encryption, immutability, compliance, veeam-one, monitoring
---

## Harden Veeam Infrastructure and Maintain Compliance

Backup infrastructure is a primary target for ransomware operators. If attackers compromise the Veeam server or repositories, all recovery options are lost. Hardening, encryption, and compliance controls are non-negotiable.

### Authentication and Access Control

| Control | Requirement |
|---------|-------------|
| **MFA** | Enable MFA on the Veeam console and all management interfaces |
| **RBAC** | Use built-in roles (Backup Admin, Restore Operator, Tape Operator); never share the Backup Admin account |
| **Service accounts** | Dedicated service accounts with minimum required permissions; no domain admin |
| **Console access** | Restrict Veeam console access to jump servers / PAWs (Privileged Access Workstations) |
| **API access** | Use token-based authentication; rotate tokens regularly |

> **Never use Domain Admin credentials** for Veeam service accounts. Create dedicated accounts with only the permissions required for backup operations (VMware role, repository access, application-aware processing).

### Encryption (Three Layers)

| Layer | What It Protects | How to Enable |
|-------|-----------------|---------------|
| **Configuration backup encryption** | Veeam server config DB and credentials | Settings → Configuration Backup → Enable encryption |
| **At-rest encryption** | Backup files on repository | Job settings → Storage → Enable encryption (AES-256) |
| **In-transit encryption** | Data between components | Enabled by default for WAN; enforce for LAN in traffic rules |

```
Encryption configuration:
  Config backup:  AES-256, password stored in enterprise password manager
  Backup jobs:    AES-256 encryption enabled, key managed per job
  Network:        TLS 1.2+ between all Veeam components

# Store encryption passwords in a secure vault (not on the Veeam server)
# Loss of encryption password = loss of backup data
```

> **Always encrypt configuration backups.** The config backup contains stored credentials for all managed infrastructure. An unencrypted config backup is a credential dump.

### Attack Surface Reduction

| Measure | Action |
|---------|--------|
| **Minimal OS install** | Server Core or minimal Linux; no GUI, no unnecessary services |
| **Firewall rules** | Allow only required Veeam ports; deny all others |
| **No internet access** | Veeam server and repositories should not have direct internet access |
| **Disable RDP/SSH** | Use out-of-band management (iLO/iDRAC) or jump server |
| **Patch management** | Monthly OS patches; Veeam patches within 30 days of release |
| **Remove default accounts** | Disable or rename default local admin accounts |

### Hardened Linux Repository

The Hardened Linux Repository is Veeam's recommended immutable on-premises target. It uses XFS immutability flags to prevent backup file modification or deletion.

| Setting | Requirement |
|---------|-------------|
| **OS** | Ubuntu 20.04 LTS or RHEL 8+ (minimal install) |
| **Filesystem** | XFS, 64 KB block size |
| **Immutability period** | Minimum 7 days (14+ recommended) |
| **SSH** | Disabled after initial Veeam configuration (single-use credentials) |
| **User** | Non-root user with limited sudo (only Veeam transport) |
| **Physical access** | BIOS password, disable USB boot, locked rack |
| **Hardening standard** | Apply DISA STIG or CIS Benchmark for the OS |

```
Hardened Linux Repository setup:
  1. Install minimal Ubuntu 20.04 LTS (no GUI, no snap)
  2. Create dedicated veeam user (non-root)
  3. Format backup volume: mkfs.xfs -b size=4096 -m reflink=1 /dev/sdb1
  4. Mount with noatime: /dev/sdb1 /backups xfs noatime 0 0
  5. Add as Veeam repository with "Make recent backups immutable" enabled
  6. Set immutability period: 14 days minimum
  7. Disable SSH after Veeam configuration completes
  8. Apply DISA STIG hardening baseline
  9. Enable host-based firewall (allow only Veeam ports)
```

> After initial setup, **disable SSH entirely.** Veeam uses its own persistent transport service. SSH access is only needed during initial deployment or Veeam upgrades.

### Compliance Mapping

| Framework | Relevant Controls | Veeam Capability |
|-----------|-------------------|-------------------|
| **GDPR** | Right to erasure, data protection | Encryption, retention policies, secure deletion |
| **HIPAA** | ePHI backup and recovery | Encryption at rest/transit, access logging, tested DR |
| **PCI DSS** | Requirement 3 (protect stored data), Req 10 (logging) | AES-256 encryption, RBAC, audit trails |
| **SOC 2** | Availability, confidentiality | SureBackup verification, immutability, monitoring |
| **SOX** | Data integrity, financial record retention | GFS retention, immutable copies, audit reports |

> Use VRO compliance reports to provide auditors with evidence of backup verification, DR testing, and retention policy adherence.

### Veeam ONE Monitoring

Veeam ONE provides real-time monitoring and reporting across the entire backup infrastructure.

| Capability | Details |
|------------|---------|
| **Alarms** | 340+ predefined alarms; configure notifications for critical events |
| **Business View** | Group infrastructure by business unit, application, or SLA tier |
| **Reporter** | Scheduled reports for capacity, compliance, and SLA compliance |
| **Key alarms to enable** | Repository space low, job failed, RPO SLA violation, license expiration |

Critical alarms to configure:

```
Veeam ONE Alarm Policy:
  - "Backup job failed"           → Email + SMS to backup-team
  - "Repository free space < 15%" → Email to storage-team
  - "RPO SLA violation"           → Email to dr-manager
  - "VM not protected"            → Weekly report to backup-admin
  - "Immutability gap detected"   → Email + ticket to security-team
  - "Configuration backup failed" → Email to backup-team (CRITICAL)
```

### Verification Checklist

- [ ] MFA enabled on all Veeam management interfaces
- [ ] RBAC configured with dedicated roles; no shared Backup Admin accounts
- [ ] Service accounts use minimum required permissions (no Domain Admin)
- [ ] Configuration backup encrypted with AES-256
- [ ] All backup jobs have encryption enabled
- [ ] TLS 1.2+ enforced between all Veeam components
- [ ] Veeam server and repositories have no direct internet access
- [ ] Hardened Linux Repository deployed with immutability >= 14 days
- [ ] SSH disabled on Hardened Linux Repository after setup
- [ ] DISA STIG or CIS Benchmark applied to repository OS
- [ ] Veeam ONE alarms configured for critical events
- [ ] Compliance reports generated for applicable frameworks
- [ ] Encryption passwords stored in an external vault (not on Veeam server)

Reference: [Veeam Security Best Practices](https://bp.veeam.com/vbr/2_Design_Structures/D_Veeam_Security/)
