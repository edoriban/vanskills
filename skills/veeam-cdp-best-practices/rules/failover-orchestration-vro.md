---
title: Design Failover Workflows and Orchestration with VRO
impact: HIGH
impactDescription: Reduces RTO from hours to minutes with automated, tested failover plans
tags: failover, failback, vro, orchestration, re-ip, dr-testing, runbook
---

## Design Failover Workflows and Orchestration with VRO

A backup without a tested recovery plan is incomplete. Veeam Recovery Orchestrator (VRO) automates failover, failback, and DR testing so that recovery is predictable, documented, and auditable.

### Failover / Failback Workflow (9 Steps)

| Step | Action | Owner |
|------|--------|-------|
| 1 | **Declare disaster** | DR Manager |
| 2 | **Initiate failover** in VRO or VBR console | Veeam Admin |
| 3 | **VMs powered on at DR site** from latest replica/CDP restore point | Automated |
| 4 | **Network remapping applied** (Re-IP, DNS update) | Automated |
| 5 | **Application verification** (custom scripts, ping, service check) | Automated + Manual |
| 6 | **Production runs on DR site** | Operations |
| 7 | **Plan failback** when primary site recovered | DR Manager |
| 8 | **Execute failback** — reverse replication to primary site | Automated |
| 9 | **Commit failback** — finalize and resume normal replication | Veeam Admin |

> **Never skip step 5.** Automated verification scripts should validate that services are reachable (HTTP 200, SQL connection, LDAP bind) before declaring failover complete.

### Network Remapping and Re-IP Rules

When VMs fail over to a DR site, IP addresses and network segments typically differ. Configure Re-IP rules and network mapping before a disaster occurs.

**Re-IP rule example:**

| Source Network | Target Network | Rule |
|----------------|----------------|------|
| 10.1.0.0/24 (Production) | 192.168.100.0/24 (DR) | Replace 10.1.0.x → 192.168.100.x |
| 10.2.0.0/24 (Database) | 192.168.200.0/24 (DR-DB) | Replace 10.2.0.x → 192.168.200.x |

```
Re-IP Configuration:
  Source: 10.1.0.* → Target: 192.168.100.*
  Source: 10.2.0.* → Target: 192.168.200.*

Network Mapping:
  Source portgroup: "VLAN-100-Prod"  → Target portgroup: "DR-VLAN-100"
  Source portgroup: "VLAN-200-DB"    → Target portgroup: "DR-VLAN-200"

DNS Update Script (post-failover):
  Update-DnsRecord -Zone "corp.local" -Name "app01" -IP "192.168.100.10"
```

> **Pre-configure all Re-IP rules and network mappings.** Do not rely on manual network changes during a disaster — pressure and time constraints lead to errors.

### VRO Plan Types

| Plan Type | Source | Use Case |
|-----------|--------|----------|
| **Replica** | VM replicas (VBR) | Site failover using pre-staged replicas |
| **CDP Replica** | CDP replicas (VBR) | Near-zero RPO failover for Tier 1 |
| **Restore** | Backup files | Full VM restore to DR site from backups |
| **Storage** | Storage snapshots | Failover using storage-level replication |
| **Cloud** | Cloud Connect replicas | Failover to service provider cloud |

### Application-Centric Runbooks

Design orchestration plans around applications, not individual VMs. Define startup order with dependency chains.

**Example: 3-Tier Application Runbook**

```
Orchestration Plan: "ERP Application"
├── Step 1: Domain Controller (dc01)
│   ├── Boot order: 1
│   ├── Verify: LDAP bind on port 389
│   └── Wait: 120 seconds
├── Step 2: Database Server (sql01)
│   ├── Boot order: 2
│   ├── Depends on: dc01
│   ├── Verify: SQL connection on port 1433
│   └── Wait: 180 seconds
├── Step 3: Application Server (app01, app02)
│   ├── Boot order: 3
│   ├── Depends on: sql01
│   ├── Verify: HTTPS 200 on /health endpoint
│   └── Wait: 60 seconds
└── Step 4: Notification
    └── Send email: dr-team@corp.local with status report
```

> Group VMs by application, not by backup job. A single orchestration plan should bring up an entire application stack in the correct order with verification at each step.

### Automated DR Testing

| Requirement | Recommendation |
|-------------|---------------|
| Frequency | Minimum 2 times per year (quarterly preferred) |
| Environment | Isolated network (virtual lab / sandbox) |
| Validation | Automated scripts: ping, port check, app-level health |
| Reporting | VRO generates compliance-ready PDF reports |
| Duration | Full test should complete in < 4 hours |

DR testing workflow:

```
1. VRO starts orchestration plan in "Test" mode
2. Replicas/restores boot in isolated virtual lab (no production impact)
3. Re-IP rules applied within sandbox network
4. Verification scripts execute against each VM
5. Results logged and compliance report generated
6. Lab powered off and resources released
7. Report sent to DR Manager and Compliance team
```

> **Schedule DR tests as recurring VRO jobs.** Manual testing is forgotten or postponed. Automated tests with reporting provide audit-ready evidence of recoverability.

### Verification Checklist

- [ ] Failover/failback workflow documented and rehearsed
- [ ] Re-IP rules configured for all protected network segments
- [ ] Network mapping matches source and DR portgroups
- [ ] VRO orchestration plans defined per application (not per VM)
- [ ] Startup dependencies and boot order verified
- [ ] Post-failover verification scripts validate service availability
- [ ] DR testing executed at least 2 times per year
- [ ] Compliance reports generated and archived after each test
- [ ] Failback procedure tested and documented

Reference: [Veeam Recovery Orchestrator](https://www.veeam.com/recovery-orchestrator.html)
