# Fuzzing Solana Programs

Automated vulnerability discovery through coverage-guided fuzzing and property-based testing.

## Tools

### Trident (Recommended for Anchor)
Anchor-compatible fuzzer v3.0+. Generates fuzz harnesses from IDL.

```bash
cargo install trident-cli
trident fuzz init
trident fuzz run fuzz_0
```

### Honggfuzz
Coverage-guided fuzzer for raw byte inputs.

```bash
cargo install honggfuzz
cargo hfuzz run fuzz_target
```

### LiteSVM
Fast SVM for property testing without full validator.

```rust
use litesvm::LiteSVM;
let mut svm = LiteSVM::new();
svm.airdrop(&user, 1_000_000_000)?;
```

## Harness Template

```rust
use trident_fuzz::fuzzing::*;

#[derive(Accounts)]
pub struct FuzzAccounts {
    pub user: AccountInfo,
    pub vault: AccountInfo,
    pub token_program: AccountInfo,
}

#[trident_test]
async fn fuzz_withdraw() {
    let mut fuzzer = Fuzzer::new();
    fuzzer
        .accounts(FuzzAccounts::default())
        .data(vec![0u8; 32])  // fuzzed instruction data
        .fuzz(|ctx| {
            // Invariant: vault balance never goes negative
            let vault_before = get_balance(ctx.vault);
            let result = my_program_withdraw(ctx);
            let vault_after = get_balance(ctx.vault);
            
            if result.is_ok() {
                assert!(vault_after <= vault_before, "Vault balance increased");
            }
        });
}
```

## Key Invariants to Test

1. **Token Conservation**: sum(balances) = constant (minus fees)
2. **Auth Only**: Only authorized users can withdraw
3. **No Underflow**: Amounts never go negative
4. **State Consistency**: Account state matches expected
5. **PDA Uniqueness**: Same seeds → same PDA

## Crash Priority

| Crash Type | Priority | 
|-----------|----------|
| Panic/overflow → probable exploitable | HIGH |
| Invariant violation → logic bug | HIGH |
| Unexpected error → edge case | MEDIUM |
| Timeout → perf issue | LOW |
