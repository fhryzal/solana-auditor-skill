# Solana Auditor Skill

> Turn any AI coding agent into a production-grade Solana security auditor.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Solana AI Kit Compatible](https://img.shields.io/badge/Solana_AI_Kit-Compatible-green)](https://github.com/solanabr/solana-ai-kit)

## The Problem

Solana programs hold **billions in TVL**, but security auditing is:

- **Expensive**: $50K–$250K per audit from top firms
- **Slow**: 4–8 week turnaround for manual audits
- **Inconsistent**: Quality varies wildly between auditors
- **Reactive**: Most audits happen right before mainnet, not during development

## The Solution

**solana-auditor-skill** gives any AI coding agent the knowledge, workflow, and tools to perform:

- **Continuous security review** during development (not just pre-mainnet)
- **10-category attack vector coverage** covering all common Solana vulnerability classes
- **Automated fuzzing** with Trident + Honggfuzz harnesses
- **Formal verification guidance** using Kani and proptest
- **Professional audit reports** with PoCs and remediation

## What's Included

| Component | Description |
|-----------|-------------|
| `skill/SKILL.md` | Entry point with progressive routing to 8 specialized skill files |
| `skill/audit-methodology.md` | 5-phase audit workflow (Recon → Static → Dynamic → Verify → Report) |
| `skill/anchor-security.md` | Anchor program vulnerabilities: account validation, CPI, PDA, signer checks |
| `skill/token-security.md` | SPL Token & Token-2022: mint authority, freeze, transfer hooks, close authority |
| `skill/defi-security.md` | DeFi attack patterns: oracles, flash loans, MEV, AMMs, lending, governance |
| `skill/fuzzing.md` | Fuzzing with Trident 3.0, Honggfuzz, and LiteSVM property testing |
| `skill/reconnaissance.md` | On-chain recon: program inspection, dependency scanning, admin key review |
| `skill/reporting.md` | Professional report format, severity classification, PoC templates |
| `skill/tooling.md` | Complete security tool reference and setup guide |
| `agents/` | 4 specialized sub-agents: lead-auditor, static-analyzer, fuzz-engineer, exploit-developer |
| `commands/` | 4 workflow commands: quick-audit, deep-audit, fuzz-target, generate-report |
| `rules/` | Auto-loading security rules for Rust/Anchor and common Solana pitfalls |

## Install

### For Solana AI Kit (Recommended)

```bash
# Clone into your solana-ai-kit skills directory
git clone https://github.com/YOUR_USER/solana-auditor-skill.git
cd solana-ai-kit
# Add as a git submodule
git submodule add https://github.com/YOUR_USER/solana-auditor-skill.git skills/solana-auditor

# Run the installer
cd skills/solana-auditor
./install.sh
```

### Standalone

```bash
git clone https://github.com/YOUR_USER/solana-auditor-skill.git
cd solana-auditor-skill
./install.sh
```

The installer sets up required Rust/Solana tooling if not already present.

## Example Use Cases

### Quick Pre-Deploy Audit
```
User: "Audit my Anchor program at /src/programs/token_vesting/"
Agent: [Loads anchor-security.md + token-security.md]
       → Identifies missing signer check in withdraw()
       → Reports missing ownership validation on vault PDA
       → Generates PoC showing fund drainage path
       → Severity: CRITICAL
```

### DeFi Protocol Deep Dive
```
User: "Check our lending protocol for oracle manipulation"
Agent: [Loads defi-security.md + fuzzing.md]
       → Analyzes price feed dependencies
       → Finds stale price attack window via Clock dependency
       → Generates fuzzing harness confirming exploit
       → Severity: HIGH
```

### Continuous Development Review
```
Agent auto-loads on every code change:
→ Checks new instructions for account validation
→ Validates PDA derivation with unique seeds
→ Ensures CPI calls check program IDs
→ Reports issues inline, no separate audit cycle
```

## Skill Structure

```
solana-auditor-skill/
├── CLAUDE.md                    # Main agent configuration
├── README.md                    # This file
├── LICENSE                      # MIT
├── install.sh                   # Dependency installer
│
├── skill/                       # Progressive disclosure skills
│   ├── SKILL.md                # Entry point → routes to specific files
│   ├── audit-methodology.md    # 5-phase workflow
│   ├── anchor-security.md      # Anchor program vulnerabilities
│   ├── token-security.md       # SPL Token security
│   ├── defi-security.md        # DeFi attack patterns
│   ├── fuzzing.md              # Automated fuzzing
│   ├── reconnaissance.md       # On-chain investigation
│   ├── reporting.md            # Report generation
│   └── tooling.md              # Tool reference
│
├── agents/                      # Specialized sub-agents
│   ├── lead-auditor.md         # Planning & coordination
│   ├── static-analyzer.md      # Deep code review
│   ├── fuzz-engineer.md        # Fuzzing harnesses
│   └── exploit-developer.md    # PoC & exploit simulation
│
├── commands/                    # Workflow commands
│   ├── quick-audit.md
│   ├── deep-audit.md
│   ├── fuzz-target.md
│   └── generate-report.md
│
└── rules/                       # Auto-loading rules
    ├── rust-security.md
    └── solana-pitfalls.md
```

## 10 Attack Vectors Covered

1. Missing signer checks
2. Missing ownership validation
3. Account type confusion
4. Arithmetic errors (overflow, precision)
5. Reinitialization attacks
6. Arbitrary CPI (unvalidated program IDs)
7. PDA seed collision
8. CPI depth limits
9. Clock/timestamp manipulation
10. Governance bypass

## Contributing

This skill is part of the Solana AI Kit ecosystem. PRs welcome for:

- New vulnerability patterns discovered in the wild
- Additional fuzzing harnesses
- Formal verification proof templates
- Tool updates as the ecosystem evolves

## License

MIT — See [LICENSE](LICENSE)

---

**Built for the Solana AI Kit ecosystem.** Turn every code review into a security audit.
