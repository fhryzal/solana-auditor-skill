# Audit Methodology

5-phase security audit workflow for Solana programs.

## Phase 1: Reconnaissance
**Goal**: Understand the program's attack surface.

1. Parse IDL → identify all instructions and account structures
2. Check on-chain deployment → program address, upgrade authority
3. Analyze dependencies → `cargo-deny`, `cargo-audit`
4. Review admin keys → who can upgrade? who can pause?
5. Map state transitions → what states can accounts be in?

**Deliverable**: Attack surface map document.

## Phase 2: Static Analysis
**Goal**: Find vulnerabilities through code review.

1. Manual review of every instruction handler
2. Run automated scanners: cargo-geiger, cargo-audit, clippy with security lints
3. Pattern match against 10 common Solana vulnerability classes
4. Document findings with code locations

**Deliverable**: Static findings catalog.

## Phase 3: Dynamic Testing
**Goal**: Find bugs through automated input generation.

1. Build Trident fuzzing harnesses for high-value instructions
2. Run Honggfuzz coverage-guided campaigns
3. Property-based tests for critical invariants
4. LiteSVM rapid state exploration
5. Triage crashes → reproduce → classify

**Deliverable**: Fuzzing report with crash analysis.

## Phase 4: Formal Verification
**Goal**: Prove critical properties mathematically.

1. Identify critical safety invariants
2. Encode as Kani verification targets
3. Run prover → fix violations or confirm safety
4. Document verified properties

**Deliverable**: Formal verification report.

## Phase 5: Reporting
**Goal**: Professional deliverables for stakeholders.

1. Executive summary (1 page)
2. Finding catalog with severity + PoC + fix
3. Overall risk assessment
4. Remediation roadmap

**Deliverable**: Final audit report.

## Severity Classification (CVSS-aligned)

| Severity | Criteria | Example |
|----------|----------|---------|
| **Critical** | Direct fund loss, no preconditions | Missing signer on withdraw |
| **High** | Protocol invariants broken | Oracle manipulation possible |
| **Medium** | Degraded security, limited impact | Information disclosure |
| **Low** | Best practice violation | Missing input validation |
| **Info** | Observation, not a vulnerability | Code style suggestion |

## Prioritization Matrix

Prioritize by: (User Funds at Risk) × (Exploit Complexity) × (Detection Difficulty)

1. Funds at risk + easy to exploit + hard to detect = CRITICAL priority
2. Funds at risk + hard to exploit = HIGH priority  
3. No funds at risk + best practice = LOW priority
