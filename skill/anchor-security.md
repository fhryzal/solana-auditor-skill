# Anchor Program Security

Comprehensive vulnerability catalog for Anchor-based Solana programs. Covers account validation, CPI safety, PDA security, and state management.

## 1. Account Validation Vulnerabilities

### 1.1 Missing Signer Check

**Pattern**: Account used for authorization but no `Signer` constraint.

```rust
// ❌ VULNERABLE
pub fn withdraw(ctx: Context<Withdraw>, amount: u64) -> Result<()> {
    // authority not validated as signer!
    ctx.accounts.vault.sub_lamports(amount)?;
    ctx.accounts.authority.add_lamports(amount)?;
}

// ✅ FIXED
#[derive(Accounts)]
pub struct Withdraw<'info> {
    #[account(mut, signer)]  // ← ADDED
    pub authority: Signer<'info>,
    #[account(mut)]
    pub vault: Account<'info, Vault>,
}
```

**Detection**: Search for functions without `Signer<'info>` or `#[account(signer)]` on auth accounts.

### 1.2 Missing Ownership Validation

**Pattern**: Account data read/written without verifying it's owned by the program.

```rust
// ❌ VULNERABLE — anyone can pass an account they own
pub fn update_config(ctx: Context<Update>, new_config: Config) -> Result<()> {
    ctx.accounts.config_account.set_inner(new_config);
}

// ✅ FIXED
#[derive(Accounts)]
pub struct Update<'info> {
    #[account(mut, has_one = authority)]
    pub config_account: Account<'info, ConfigAccount>,  // Anchor checks discriminator
    pub authority: Signer<'info>,
}
```

**Detection**: Look for manual `AccountLoader` or direct `Account` without proper constraints.

### 1.3 Account Type Confusion

**Pattern**: No discriminant check allows attackers to pass different account types.

```rust
// ❌ VULNERABLE — no type check
#[account]
pub struct Vault { amount: u64 }

#[account]
pub struct FakeVault { amount: u64 }  // Same discriminator?

// ✅ FIXED — Anchor's #[account] adds 8-byte discriminator automatically
// Always use #[account] macro for account structs
```

**Detection**: Search for `Account<'info, T>` where T doesn't have `#[account]`.

---

## 2. PDA Security

### 2.1 Predictable Seeds

**Pattern**: PDA seeds that can be predicted/controlled by attackers.

```rust
// ❌ VULNERABLE — seed includes only static string
let (pda, bump) = Pubkey::find_program_address(
    &[b"vault"],
    &program_id
);

// ✅ FIXED — include unique user identifier
let (pda, bump) = Pubkey::find_program_address(
    &[b"vault", user.key().as_ref()],
    &program_id
);
```

**Detection**: PDAs without user/wallet/mint pubkey in seeds.

### 2.2 Missing Bump Validation

**Pattern**: Not using canonical bump, allowing multiple valid PDAs.

```rust
// ❌ VULNERABLE
pub fn process(ctx: Context<Process>, bump: u8) -> Result<()> {
    // Attacker provides non-canonical bump
    let seeds = &[b"config", &[bump]];
    // ... creates different PDA with same seeds
}

// ✅ FIXED
pub fn process(ctx: Context<Process>) -> Result<()> {
    let bump = ctx.bumps.config_account;  // Anchor auto-validates
    let seeds = &[b"config", &[bump]];
}
```

**Detection**: Functions accepting `bump: u8` as parameter instead of using `ctx.bumps`.

### 2.3 Seed Collision

**Pattern**: Different account types using same seed prefix.

```rust
// ❌ VULNERABLE
let vault_pda = Pubkey::find_program_address(&[b"account"], &program_id);
let config_pda = Pubkey::find_program_address(&[b"account"], &program_id); // SAME!
```

**Detection**: Check for duplicate seed strings across different PDA derivations.

### 2.4 Reinitialization Attack

**Pattern**: Calling `init` on already-initialized PDA can reset state.

```rust
// ❌ VULNERABLE (before Anchor 0.30)
#[account(init, payer = user, space = 8 + 32)]
pub vault: Account<'info, Vault>,

// ✅ FIXED — Anchor 0.30+ auto-checks, but verify for older code
// If using older Anchor, add explicit check:
#[account(
    init_if_needed,  // Only if truly needed
    payer = user,
    space = 8 + 32
)]
pub vault: Account<'info, Vault>,
```

---

## 3. Cross-Program Invocation (CPI) Safety

### 3.1 Unvalidated Program ID

**Pattern**: Calling CPI with hardcoded or unvalidated program ID.

```rust
// ❌ VULNERABLE — could be any program
let token_program = ctx.accounts.token_program.key();
invoke(
    &transfer_instruction,
    &[ctx.accounts.user_token.to_account_info()],
)?;

// ✅ FIXED — verify against expected program
require!(
    ctx.accounts.token_program.key() == spl_token::ID,
    ErrorCode::InvalidTokenProgram
);
// OR use Anchor's Program<'info, Token> which auto-validates the program ID
```

**Detection**: `invoke()` or `invoke_signed()` calls where the program ID isn't validated.

### 3.2 CPI with Remaining Accounts

**Pattern**: Passing `ctx.remaining_accounts` to CPI without validation.

```rust
// ❌ VULNERABLE
invoke_signed(
    &instruction,
    ctx.remaining_accounts,  // unvalidated!
    &[&seeds],
)?;

// ✅ FIXED — validate each remaining account
for acc in ctx.remaining_accounts.iter() {
    require!(acc.key() == expected_key, ErrorCode::InvalidAccount);
}
```

### 3.3 CPI Depth Limit

**Pattern**: Recursive or deeply nested CPIs that exhaust compute budget.

```rust
// Risk: if Program A → CPI → Program B → CPI → Program A (cycle)
// Each CPI call uses ~1k-2k CU. Max depth ~4 before hitting limits
```

**Detection**: Check for circular dependency patterns in CPI chains.

---

## 4. State Management Issues

### 4.1 Missing Close Constraint

**Pattern**: Accounts not properly closed, leaving lamports claimable.

```rust
// ❌ VULNERABLE — account data zeroed but lamports remain
pub fn close_account(ctx: Context<Close>) -> Result<()> {
    // Just clears data, lamports stay
}

// ✅ FIXED
#[derive(Accounts)]
pub struct Close<'info> {
    #[account(mut, close = user)]  // lamports go to user
    pub account: Account<'info, MyAccount>,
    #[account(mut)]
    pub user: Signer<'info>,
}
```

### 4.2 State Machine Violations

**Pattern**: Instruction called in wrong state without proper transition guard.

```rust
// ❌ VULNERABLE
pub fn claim(ctx: Context<Claim>) -> Result<()> {
    // No check if vesting period has elapsed
    ctx.accounts.vault.transfer_tokens(amount)?;
}

// ✅ FIXED
pub fn claim(ctx: Context<Claim>) -> Result<()> {
    let clock = Clock::get()?;
    require!(
        clock.unix_timestamp >= ctx.accounts.vesting.end_time,
        ErrorCode::VestingNotComplete
    );
    ctx.accounts.vault.transfer_tokens(amount)?;
}
```

### 4.3 Authority Validation on Privileged Operations

**Pattern**: Admin/owner operations without proper authority checks.

```rust
// ❌ VULNERABLE
pub fn set_fee(ctx: Context<SetFee>, new_fee: u64) -> Result<()> {
    ctx.accounts.config.fee = new_fee; // anyone can call?
}

// ✅ FIXED
#[derive(Accounts)]
pub struct SetFee<'info> {
    #[account(mut, has_one = admin)]
    pub config: Account<'info, Config>,
    pub admin: Signer<'info>,  // must match config.admin
}
```

---

## 5. Clock & Sysvar Dependencies

### 5.1 Clock Manipulation

**Pattern**: Security decisions based on `Clock::get()?` that can be manipulated within a slot.

```rust
// Risk: Clock returns slot-level timestamp (~400ms granularity)
// Multiple transactions in same slot see identical timestamps
// Front-running: attacker sees your tx, submits theirs in same slot
```

### 5.2 Slot Dependency

**Pattern**: Using slot number for randomness or timing-critical decisions.

```rust
// ❌ RISKY — predictable, same for all txs in slot
let pseudo_random = Clock::get()?.slot % 10;
```

**Fix**: Use commit-reveal schemes or VRF (e.g., Switchboard/ORAO) for randomness.

---

## Quick Reference: Vulnerability → Detection

| Vulnerability | grep/scan pattern |
|--------------|-------------------|
| Missing signer | `pub fn.*\(ctx.*\)` without `Signer` in Accounts |
| Missing owner check | `Account<'info, T>` where T has no `#[account]` |
| Type confusion | Manual `try_from_slice` without discriminator check |
| PDA seed collision | Duplicate static seed strings |
| Reinitialization | `init` without bump check or state guard |
| Unvalidated CPI | `invoke(` or `invoke_signed(` with hardcoded prog ID |
| Missing close | Account mutation without `close` constraint |
| State machine | State field modified without guard checks |

## Remediation Priority

1. **Critical**: Missing signer → funds directly at risk
2. **Critical**: Unvalidated CPI → arbitrary program execution
3. **High**: PDA collision → can break accounting
4. **High**: Reinitialization → state can be reset
5. **Medium**: Missing owner check → only exploitable if combined with other bugs
6. **Medium**: Clock dependency → temporal attacks within a slot
