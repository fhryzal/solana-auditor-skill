# /deep-audit

Full 5-phase security audit: Recon → Static → Dynamic → Verify → Report.

## Usage

```
/deep-audit <path-to-program-directory>
```

## Phases

### Phase 1: Reconnaissance (30 min)
- Load and parse IDL
- Check on-chain deployment
- Analyze dependency tree (cargo-deny, cargo-audit)
- Review admin keys and upgrade authority
- Map account structure and state transitions
- **Deliverable**: Attack surface map

### Phase 2: Static Analysis (2-4 hours)
- Manual code review of every instruction
- Run cargo-geiger for unsafe Rust
- Check all 10 attack vectors systematically
- Review CPI calls for program ID validation
- Verify PDA derivation uniqueness
- Audit token extensions (if Token-2022)
- **Deliverable**: Static findings list

### Phase 3: Dynamic Testing (2-4 hours)
- Generate Trident fuzzing harnesses
- Run Honggfuzz coverage-guided campaigns (24h recommended)
- Property-based tests for critical invariants
- LiteSVM state exploration
- Transaction simulation with edge cases
- **Deliverable**: Crash reports + invariant violations

### Phase 4: Formal Verification (2-4 hours)
- Prove critical safety invariants with Kani
- Verify arithmetic correctness on key functions
- Check state machine transitions
- **Deliverable**: Verified or violated properties

### Phase 5: Report (2 hours)
- Executive summary
- Finding catalog with CVSS-aligned severity
- PoCs for Critical/High findings
- Remediation code patches
- Security recommendations
- **Deliverable**: Professional audit report

## Total: ~2-3 days for a typical program
