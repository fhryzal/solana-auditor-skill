# Audit Report Generation

Professional security audit report format for Solana programs.

## Report Structure

### Executive Summary
- 1 page for non-technical stakeholders
- Overall risk rating (Critical/High/Medium/Low)
- Key findings count by severity
- Go/No-go recommendation

### Scope
- What was audited (program, version, commit hash)
- Methodology (Recon → Static → Dynamic → Verify)
- Timeline
- Limitations (e.g., "no mainnet deployment", "no upgrade authority check")

### Findings (ordered by severity)

Each finding:
```
### [F-001] Missing Signer Check in withdraw() — CRITICAL

**Location**: `programs/vault/src/lib.rs:42`
**Severity**: Critical (CVSS 9.8)

**Description**:
The `withdraw` instruction does not verify that the `authority` account signed the transaction, allowing anyone to drain funds.

**Impact**:
All funds in any vault can be stolen by any caller.

**Reproduction**:
1. Call `withdraw` with `authority` as any pubkey (no signer needed)
2. Amount transferred from vault to attacker

**Proof of Concept**:
[Link to PoC script]

**Remediation**:
Add `#[account(signer)]` to the authority account:
`pub authority: Signer<'info>,`
```

### Security Assessment
- Overall architecture review
- Centralization risks
- Upgrade path security
- Key management assessment

### Recommendations
- Critical fixes needed before mainnet
- Monitoring recommendations
- Future audit scope
- Process improvements

## Report Template

See [report-template.md](report-template.md) for a fillable template.
