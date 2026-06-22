# Token & DeFi Security

Covers SPL Token, Token-2022 extensions, and DeFi protocol attack patterns.

## 1. SPL Token Security

### 1.1 Mint Authority Abuse
If mint authority is not revoked after token creation, tokens can be minted at will.
```rust
// Always check: who holds mint_authority?
let mint = spl_token::state::Mint::unpack(&account.data.borrow())?;
if mint.mint_authority.is_some() {
    // ⚠️ Tokens can be minted by this authority
}
```

### 1.2 Freeze Authority
Token-2022 supports freeze authority. If set and not revoked, holders can be frozen.
**Risk**: Governance or admin can freeze user funds. Check if freeze_authority is None for trustless tokens.

### 1.3 Transfer Hook Bypass
Token-2022 transfer hooks execute additional logic on transfer. If the hook program is upgradeable, it can be replaced.
**Check**: Is the transfer hook program immutable (no upgrade authority)?

### 1.4 Close Authority
Token accounts with close authority set can be closed by that authority.
**Risk**: User token accounts can be forcibly closed if close authority is set maliciously.

### 1.5 Permanent Delegate
Token-2022 allows a permanent delegate that can transfer/burn any holder's tokens.
**Detection**: Check `permanent_delegate` field on mint. This is a critical centralization risk.

---

## 2. DeFi Attack Patterns

### 2.1 Oracle Manipulation

**Pattern**: Attacker manipulates price feed to extract value.

```solidity
// Common attack flow:
// 1. Flash loan large amount
// 2. Swap to manipulate AMM pool price
// 3. Borrow against inflated collateral
// 4. Repay flash loan, keep borrowed funds
```

**Solana-specific checks**:
- Using Pyth/Switchboard → verify confidence interval is not exceeded
- Using AMM spot price → trivially manipulable, NEVER use as sole oracle
- TWAP → harder to manipulate but possible with sustained capital

### 2.2 Flash Loan Attacks

**Pattern**: Uncollateralized borrow → manipulate → extract → repay all in one tx.

**Defense**: Never make security decisions based on balances that can change within a single transaction. Use post-transaction checks or separate transactions for critical operations.

### 2.3 MEV / Sandwich Attacks

**Pattern**: Attacker sees pending AMM swap, inserts buy before and sell after.

**Solana context**: No public mempool, but leaders can MEV. Jito bundles offer some protection.

### 2.4 AMM Pool Exploits

| Vulnerability | How It Works |
|--------------|-------------|
| **Rounding errors** | Repeated small swaps exploit rounding direction |
| **Impermanent loss manipulation** | Attack LP providers by manipulating pool ratio |
| **Fee extraction** | Flash-loan large amounts to collect disproportionate fees |
| **K-value invariant break** | Buggy implementations that don't preserve x*y=k |

### 2.5 Lending Protocol Attacks

- **Oracle staleness**: Using stale price to borrow against inflated collateral
- **Liquidation gaming**: Manipulating price to trigger unfair liquidations
- **Interest rate manipulation**: Flash loan → deposit → borrow → withdraw in one tx
- **Bad debt accumulation**: Under-collateralized positions not liquidated fast enough

### 2.6 Governance Attacks

- **Vote buying**: Flash loan governance tokens → vote → sell
- **Timelock bypass**: Exploiting missing or short timelock on proposal execution
- **Quorum manipulation**: Using flash-loaned tokens to meet quorum
- **Delegation abuse**: Self-delegation of flash-loaned tokens

---

## 3. Cross-Protocol Dependencies

### Risk: Upgradeable Dependencies
If your protocol depends on another upgradeable program, that dependency can change behavior.
**Mitigation**: Pin to specific program versions, monitor upgrade authorities.

### Risk: Token Program Confusion
Token vs Token-2022 — different programs, different features.
**Mitigation**: Always validate which token program you're interacting with.

---

## 4. Quick Assessment Checklist

```
□ Mint authority revoked or controlled by governance
□ Freeze authority is None (or justified)
□ Transfer hook program is immutable
□ No permanent delegate on token (or justified)
□ Oracle uses confidence interval + staleness checks (not spot price)
□ Flash loan resistance: critical state changes can't be done in single tx
□ Governance has timelock ≥ 24h
□ All external CPI calls validate program IDs
□ Supply-chain: all dependency programs are verified/known
```
