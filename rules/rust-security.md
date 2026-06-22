# Rust/Anchor Security Rules

Auto-loaded for all Solana program files. These rules enforce security best practices.

## Account Validation

- Every instruction must validate ALL accounts it receives
- Use Anchor's `#[account(...)]` constraints where possible, custom validation where needed
- `#[account(signer)]` for any account that must sign
- `#[account(owner = program_id)]` for program-owned accounts
- `#[account(mut)]` only when actually modifying the account

## PDA Security

- PDA seeds MUST include unique identifiers (user pubkey, mint, etc.)
- Never use static/constant seeds that could be predicted by attackers
- Validate bump seed is canonical (`ctx.bumps.get("account_name")`)
- Don't reuse PDAs across different instruction contexts

## CPI Safety

- NEVER hardcode program IDs in CPI calls
- Always validate the program ID being called
- Use `ctx.remaining_accounts` carefully — validate each one
- Limit CPI depth to prevent compute budget exhaustion

## Arithmetic

- Use checked math: `checked_add`, `checked_sub`, `checked_mul`, `checked_div`
- Or enable `overflow-checks = true` in Cargo.toml
- For financial calculations, use u64 for lamports, never f64
- Validate amounts > 0 before transfers

## State Management

- Always use discriminants on account structs (#[account])
- Reinitialization check: use `#[account(init)]` or explicit check
- Close accounts properly with `close = <target>` constraint
- Don't leave lamports in closed accounts claimable by attackers

## Token Operations

- Validate mint addresses on token accounts
- Check token program ID (Token vs Token-2022)
- Verify decimal consistency across operations
- Don't trust client-provided token accounts without validation
