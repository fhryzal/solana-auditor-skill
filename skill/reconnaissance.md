# On-Chain Reconnaissance

Program investigation and dependency analysis for Solana security audits.

## Program Inspection

```bash
# Get program account info
solana program show <PROGRAM_ID>

# Check upgrade authority (critical!)
solana program show <PROGRAM_ID> | grep -i authority

# Get program buffer (if upgradeable)
solana program buffer <BUFFER_ADDRESS>
```

## Account Analysis

```bash
# List all accounts owned by program
curl https://api.mainnet-beta.solana.com -X POST -H "Content-Type: application/json" -d '{
  "jsonrpc":"2.0","id":1,
  "method":"getProgramAccounts",
  "params":["<PROGRAM_ID>",{"encoding":"base64","filters":[{"dataSize":<SIZE>}]}]
}'

# Decode account data using IDL
anchor idl fetch <PROGRAM_ID> --provider.cluster mainnet
```

## Dependency Scanning

```bash
# Check Rust dependencies for known CVEs
cargo audit

# License + security policy check
cargo deny check

# Unsafe Rust detection
cargo geiger
```

## Admin Key Review

Critical questions:
1. Who holds the upgrade authority?
2. Is it a multisig? How many signers?
3. Is there a timelock on upgrades?
4. Are there emergency pause functions? Who controls them?

## Transaction Pattern Analysis

```bash
# Get recent transactions for a program
curl <RPC_URL> -X POST -H "Content-Type: application/json" -d '{
  "jsonrpc":"2.0","id":1,
  "method":"getSignaturesForAddress",
  "params":["<PROGRAM_ID>",{"limit":100}]
}'

# Analyze for unusual patterns:
# - Large transfers
# - Repeated failures
# - Admin-only instruction calls
# - Unusual time patterns
```
