# DeFi Security

Oracle manipulation, flash loans, MEV, AMM exploits, lending protocol attacks, and governance vulnerabilities.

## 1. Oracle Price Manipulation

**Attack**: Manipulate the data source your protocol uses for asset pricing.

### Spot Price (Most Vulnerable)
Using AMM pool spot price directly:
```rust
// ❌ DON'T — trivially manipulable
let price = pool_a_balance / pool_b_balance;
```

### TWAP (Better but Not Immune)
Time-weighted average price reduces manipulation window but requires sustained capital.

### Oracle Networks (Pyth, Switchboard) — Best Practice
```rust
// ✅ Use oracle with confidence interval check
let price = pyth.get_price()?;
require!(price.confidence <= price.price * MAX_CONFIDENCE_BPS / 10000);
require!(Clock::get()?.unix_timestamp - price.publish_time <= MAX_STALENESS);
```

## 2. Flash Loan Vectors

Single-transaction borrowing without collateral. Enables:
- Oracle manipulation (borrow → swap → manipulate → exploit)
- Governance attacks (borrow → vote → sell)
- Liquidation manipulation (borrow → liquidate → profit)

**Mitigation**: Critical oracle or state changes should NOT be possible within a single transaction block.

## 3. MEV on Solana

No public mempool, but:
- **Leader MEV**: Current leader can reorder/insert transactions
- **Jito bundles**: Offer some protection
- **Tip-based priority**: Higher tips = earlier execution

## 4. AMM Pool Vulnerabilities

### Rounding Exploitation
Repeated small swaps to exploit rounding direction:
```
Attack: swap(1) → swap(1) → ... (N times)
         ≠ swap(N)
         Due to rounding, the sum of small swaps can extract more value
```

### K-Value Invariant Violations
Buggy pool implementations that don't enforce `x * y = k` invariant after each swap.

## 5. Lending Protocol Attacks

| Attack | Mechanism |
|--------|-----------|
| **Oracle Staleness** | Use old price to borrow against overvalued collateral |
| **Liquidation Gaming** | Manipulate price to trigger liquidation, profit from bonus |
| **Interest Rate Manipulation** | Flash loan → deposit huge → borrow → withdraw in one tx |
| **Bad Debt** | Collateral drops faster than liquidation can process |

## 6. Governance Attack Surface

- **Flash loan voting**: Borrow governance tokens → vote → return
- **Timelock bypass**: Proposals executable immediately
- **Quorum manipulation**: Flash loan meets quorum requirement
- **Delegation chain**: Vote power concentrated through delegation

## 7. Yield/Reward Manipulation

- **Reward harvesting**: Split deposits across epochs to game reward calculation
- **Staking sandwich**: Stake before reward snapshot, unstake after
- **Inflation attacks**: First depositor inflates share price → later depositors lose value

## Quick Defensive Checklist

```
□ Oracle: Pyth/Switchboard with confidence interval + staleness check
□ Flash loan: Critical state changes split across transactions
□ AMM: K-value invariant enforced, rounding direction validated
□ Lending: Liquidation threshold > oracle deviation buffer
□ Governance: Timelock ≥ 24h, quorum excludes flash-loaned tokens
□ Yield: First depositor protection, reward smoothing
```
