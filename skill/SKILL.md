---
name: solana-auditor
description: Solana program security auditing — static analysis, fuzzing, formal verification, DeFi exploit patterns, on-chain recon, and professional report generation. Extends solana-dev-skill with attacker-perspective analysis. Covers Anchor, SPL Token, DeFi protocols, governance, and cross-program invocations.
user-invocable: true
---

# Solana Security Auditor Skill

> **Extends**: [solana-dev-skill](../solana-dev/SKILL.md) - Core Solana development (Anchor, Pinocchio, testing, deployment)

## What This Skill Is For

Use this skill when the user asks for:

### Program Auditing
- Full security audit of Anchor/Solana programs
- Vulnerability discovery and classification
- Attack surface analysis and threat modeling
- Code review for security-critical paths

### Token & DeFi Security
- SPL Token / Token-2022 program security
- DeFi protocol vulnerability assessment
- Oracle manipulation, flash loan, MEV analysis
- Governance attack detection

### Automated Analysis
- Fuzzing harness generation and execution
- Property-based testing for invariants
- Static analysis with automated scanners
- Formal verification of critical functions

### Reconnaissance
- On-chain program usage analysis
- Dependency vulnerability scanning
- Admin key and upgrade authority review
- Transaction pattern analysis

### Reporting
- Professional security audit reports
- PoC development for found vulnerabilities
- Severity classification (CVSS-aligned)
- Remediation guidance and patches

### For Program Development (Delegate to Core)
- Building programs → [programs-anchor.md](../solana-dev/programs-anchor.md)
- Testing programs → [testing.md](../solana-dev/testing.md)
- Deploying programs → [deployment.md](../solana-dev/deployment.md)

## Default Stack Decisions

### 1) Anchor Programs: 0.30+
- Discriminant-based account validation
- CPI with proper program ID checks
- PDA derivation with unique seeds

### 2) Static Analysis: Multi-Tool
- cargo-geiger for unsafe Rust detection
- cargo-audit for dependency CVEs
- cargo-deny for supply chain
- Manual review for logic bugs

### 3) Fuzzing: Trident 3.0+
- Anchor-compatible fuzzing harnesses
- Honggfuzz for coverage-guided fuzzing
- LiteSVM for fast property testing

### 4) Formal Verification: Kani + Proptest
- Kani for Rust function verification
- Proptest for invariant testing
- Creusot for deductive verification (complex paths)

### 5) Reporting: Evidence-First
- Every finding includes: reproduction → proof → impact → fix
- Severity: Critical (funds at risk), High (protocol break), Medium (degraded security), Low (best practice), Info (observation)
- PoC scripts in Python or TypeScript

## Operating Procedure

### 1. Classify the Audit Task

| Phase | Activity | Skill File(s) |
|-------|----------|---------------|
| Recon | Program inspection, deps, on-chain | [reconnaissance.md](reconnaissance.md) |
| Static | Code review, scanners | [anchor-security.md](anchor-security.md), [token-security.md](token-security.md) |
| Dynamic | Fuzzing, property tests | [fuzzing.md](fuzzing.md) |
| DeFi | Economic attacks, oracles | [defi-security.md](defi-security.md) |
| Verify | Formal methods | [anchor-security.md](anchor-security.md) |
| Report | Write-up, PoC, remediation | [reporting.md](reporting.md) |

### 2. Pick the Right Agent

| Task Type | Agent | Model |
|-----------|-------|-------|
| Audit scoping, planning | lead-auditor | opus |
| Code review, static analysis | static-analyzer | sonnet |
| Fuzzing harnesses | fuzz-engineer | sonnet |
| PoC development | exploit-developer | sonnet |

### 3. Apply Attack Vectors (Always Check These 10)

1. Missing signer checks on instruction accounts
2. Missing ownership validation (Account Owner)
3. Account type confusion via discriminant spoofing
4. Arithmetic: overflow, division precision, rounding
5. Reinitialization attacks on already-initialized PDAs
6. Arbitrary CPI with unvalidated program IDs
7. Predictable PDA seeds enabling collision attacks
8. CPI depth limits exhausting compute budget
9. Clock/timestamp manipulation in time-sensitive logic
10. Governance bypass via missing authority checks

### 4. Add Tests & PoC

- **Static findings**: Show code location + exploit path
- **Dynamic findings**: Provide working fuzzing harness or test case
- **Economic findings**: Simulate with Python model
- **Two-strike rule**: If tool fails twice, present findings and ask

### 5. Deliverables

- Finding title + severity classification
- Affected code locations (file:line)
- Reproduction steps with evidence (logs, tx sigs, screenshots)
- Impact analysis (direct + cascading)
- Remediation with code patch (diff format)
- PoC script where applicable

---

## Progressive Disclosure (Read When Needed)

### Security Analysis Skills (This Addon)

#### Methodology & Workflow
- [audit-methodology.md](audit-methodology.md) - 5-phase audit workflow, scoping, and prioritization

#### Program Security
- [anchor-security.md](anchor-security.md) - Anchor program vulnerabilities, account validation, CPI safety, PDA security
- [token-security.md](token-security.md) - SPL Token, Token-2022, mint authority, freeze authority, transfer hooks
- [defi-security.md](defi-security.md) - Oracle manipulation, flash loans, MEV, AMM exploits, lending protocol attacks

#### Automated Testing
- [fuzzing.md](fuzzing.md) - Trident, Honggfuzz, LiteSVM harnesses, coverage-guided fuzzing, invariant testing

#### Reconnaissance
- [reconnaissance.md](reconnaissance.md) - On-chain program analysis, dependency scanning, admin key review, tx pattern analysis

#### Reporting
- [reporting.md](reporting.md) - Professional report format, severity classification, PoC templates, remediation guidance

#### Reference
- [tooling.md](tooling.md) - Complete tool reference, installation, and configuration

### Core Solana Dev Skills (from solana-dev-skill)

> These are provided by [solana-dev-skill](../solana-dev/SKILL.md)

#### Program Development
- [programs-anchor.md](../solana-dev/programs-anchor.md) - Anchor patterns
- [programs-pinocchio.md](../solana-dev/programs-pinocchio.md) - Pinocchio patterns
- [idl-codegen.md](../solana-dev/idl-codegen.md) - IDL generation

#### Testing & Security
- [testing.md](../solana-dev/testing.md) - LiteSVM, Mollusk, Surfpool
- [security.md](../solana-dev/security.md) - Core security checklist
- [payments.md](../solana-dev/payments.md) - Payment patterns
- [frontend-security.md](../solana-dev/frontend-security.md) - Client security

---

## Task Routing Guide

| User asks about... | Primary skill file(s) |
|--------------------|----------------------|
| Full audit workflow | audit-methodology.md |
| Anchor vulnerability | anchor-security.md |
| Token mint security | token-security.md |
| DeFi protocol audit | defi-security.md |
| Fuzzing setup | fuzzing.md |
| Program inspection on-chain | reconnaissance.md |
| Audit report format | reporting.md |
| Security tool setup | tooling.md |
| Account validation bug | anchor-security.md |
| CPI safety check | anchor-security.md |
| PDA collision | anchor-security.md |
| Oracle price attack | defi-security.md |
| Flash loan vector | defi-security.md |
| Governance attack | defi-security.md |
| SPL Token freeze abuse | token-security.md |
| Transfer hook bypass | token-security.md |
| Supply chain audit | reconnaissance.md + tooling.md |
| Upgrade authority risk | reconnaissance.md |
| Formal verification | anchor-security.md + tooling.md |
| **Anchor program build** | solana-dev → programs-anchor.md |
| **Program deployment** | solana-dev → deployment.md |
| **Core testing** | solana-dev → testing.md |

---

## Commands

| Command | Description |
|---------|-------------|
| /quick-audit | Fast scan of a single program (recon + static + report) |
| /deep-audit | Full 5-phase audit (recon → static → dynamic → verify → report) |
| /fuzz-target | Generate fuzzing harness for a specific instruction |
| /generate-report | Compile findings into professional audit report |

## Agents

| Agent | Purpose |
|-------|---------|
| **lead-auditor** | Audit planning, scope definition, threat modeling, report compilation |
| **static-analyzer** | Deep code review, pattern matching, vulnerability classification |
| **fuzz-engineer** | Build fuzzing harnesses, run coverage-guided campaigns |
| **exploit-developer** | Build working PoCs, simulate economic attacks, verify findings |
