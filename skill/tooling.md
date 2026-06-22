# Security Tool Reference

Complete tool setup and usage guide for Solana security auditing.

## Rust/Anchor Analysis

| Tool | Purpose | Install |
|------|---------|---------|
| cargo-audit | CVE scanner | `cargo install cargo-audit` |
| cargo-deny | License + security policy | `cargo install cargo-deny` |
| cargo-geiger | Unsafe Rust detection | `cargo install cargo-geiger` |
| clippy | Rust linter | `rustup component add clippy` |
| Soteria | Solana-specific static analysis | See [soteria.dev](https://soteria.dev) |

## Fuzzing

| Tool | Purpose | Install |
|------|---------|---------|
| Trident 3.0 | Anchor-compatible fuzzer | `cargo install trident-cli` |
| Honggfuzz | Coverage-guided fuzzing | `cargo install honggfuzz` |
| LiteSVM | Fast SVM testing | Add to `Cargo.toml` dev deps |

## Formal Verification

| Tool | Purpose | Install |
|------|---------|---------|
| Kani | Rust model checker | `cargo install --locked kani-verifier` |
| Proptest | Property-based testing | Add to `Cargo.toml` dev deps |

## On-Chain Tools

| Tool | Purpose | Install |
|------|---------|---------|
| solana-cli | Account/program inspection | `sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"` |
| anchor | IDL + program management | `cargo install anchor-cli` |

## Quick Setup

```bash
# Install all tools
cargo install cargo-audit cargo-deny cargo-geiger trident-cli honggfuzz
cargo install --locked kani-verifier
rustup component add clippy
```

## Automated Scan Script

```bash
#!/bin/bash
# Run all static analyzers
PROGRAM_DIR=$1
cd $PROGRAM_DIR
echo "=== cargo-audit ===" && cargo audit
echo "=== cargo-deny ===" && cargo deny check
echo "=== cargo-geiger ===" && cargo geiger
echo "=== clippy ===" && cargo clippy -- -D warnings
```
