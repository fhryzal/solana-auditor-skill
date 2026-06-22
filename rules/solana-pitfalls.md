# Solana Common Pitfalls

Auto-loaded rules covering the most common Solana vulnerability patterns.

## Signer Authorization

**Pitfall**: Instruction accepts an account as authority but doesn't check it signed.
**Check**: Every account used for authorization MUST have `Signer` check or `#[account(signer)]`.
**Impact**: Anyone can call the instruction, bypassing authorization.

## Account Data Matching

**Pitfall**: Using wrong account in CPI or transfer without verifying it belongs to expected user.
**Check**: Validate account owner, mint, and any other relevant fields before use.
**Impact**: Cross-account contamination, wrong user affected.

## Type Confusion

**Pitfall**: Program accepts account but doesn't verify its discriminant/type.
**Check**: Anchor discriminator auto-checked by `#[account]`. For manual checks, validate first 8 bytes.
**Impact**: Attacker passes wrong account type, causing unexpected behavior.

## Closing Accounts

**Pitfall**: Account closed but lamports sent to attacker-controlled destination.
**Check**: Use `close = payer` constraint or validate the destination address.
**Impact**: Closed account lamports stolen.

## Sysvar Validation

**Pitfall**: Using `Clock::get()?` or `Rent::get()?` without verifying the sysvar account.
**Check**: Anchor auto-validates sysvars when used as account type.
**Impact**: Attacker passes fake clock with manipulated timestamp.

## Bump Seed Validation

**Pitfall**: Not validating bump seed, allowing attacker to provide non-canonical PDA.
**Check**: Use `ctx.bumps.get("pda_name")` or `Pubkey::find_program_address` to verify.
**Impact**: Multiple valid PDAs for same seeds, enabling double-spend or bypass.

## Unchecked Arithmetic

**Pitfall**: Using regular `+`, `-`, `*` operators on financial amounts.
**Check**: Always use `.checked_add()`, `.checked_sub()`, etc. for lamport calculations.
**Impact**: Overflow corrupts balances, underflow wraps to huge values.
