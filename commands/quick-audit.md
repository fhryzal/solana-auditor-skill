# /quick-audit

Fast security scan of a single Solana program. Runs reconnaissance + static analysis + generates report.

## Usage

```
/quick-audit <path-to-program>
```

## Workflow

1. **Recon** (2 min): Load IDL, check program address, inspect accounts
2. **Static** (10 min): Run cargo-audit, cargo-geiger, manual review for top 10 attack vectors
3. **Report** (3 min): Compile findings with severity + code locations + fixes

## Output

- Finding list with severity classification
- Code locations (file:line)
- Quick fixes where obvious
- Recommendation: whether /deep-audit is warranted

## When to Use

- Pre-commit security check
- New program onboarding
- Lightweight review for low-value programs
- First pass before deep audit

## When NOT to Use

- Programs holding >$100K TVL → use /deep-audit
- Complex DeFi protocols → use /deep-audit
- Programs with upgrade authority → use /deep-audit
