# Section Definitions

This file defines the rule categories for Veeam CDP best practices. Each section maps to a rule file in this directory.

---

## 1. Architecture & 3-2-1-1-0 (architecture)
**Impact:** CRITICAL
**Description:** The foundational backup rule ensuring data survivability: 3 copies, 2 media types, 1 offsite, 1 immutable/air-gapped, 0 verification errors. Includes immutability strategies and air-gap design.

## 2. Repository Design & Sizing (repository)
**Impact:** CRITICAL
**Description:** Sizing formulas for CPU, RAM, and storage; filesystem selection (ReFS vs XFS); Scale-Out Backup Repository (SOBR) design; and object storage integration with S3 Object Lock.

## 3. Proxy & Transport Optimization (proxy)
**Impact:** HIGH
**Description:** Transport mode selection (Direct SAN, Hot-Add, Network), proxy sizing and placement, throughput benchmarks, and network requirements for optimal backup performance.

## 4. Job Configuration & Retention (job)
**Impact:** HIGH
**Description:** Backup job design including synthetic vs active full backups, retention policies (days-based and GFS), scheduling strategies, compression algorithms, and deduplication block sizes.

## 5. CDP Architecture & Policies (cdp)
**Impact:** CRITICAL
**Description:** Continuous Data Protection architecture using VAIO I/O filters, source/target proxy design, RPO target selection, and criteria for identifying Tier 1 workloads suitable for CDP.

## 6. Failover & Orchestration (failover)
**Impact:** HIGH
**Description:** Failover/failback workflows, network remapping and Re-IP rules, Veeam Recovery Orchestrator (VRO) plan types, application-centric runbooks, and automated DR testing.

## 7. Security Hardening & Compliance (security)
**Impact:** CRITICAL
**Description:** MFA enforcement, RBAC, encryption at three layers, Hardened Linux Repository configuration, attack surface reduction, compliance mapping (GDPR, HIPAA, PCI DSS, SOC2, SOX), and Veeam ONE monitoring.
