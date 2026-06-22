#!/usr/bin/env bash
set -euo pipefail

echo "=== Solana Auditor Skill Installer ==="
echo ""

# Check for Solana CLI
if ! command -v solana &> /dev/null; then
    echo "⚠ Solana CLI not found. Install from https://docs.solana.com/cli/install"
    echo "  sh -c \"\$(curl -sSfL https://release.anza.xyz/stable/install)\""
fi

# Check for Rust
if ! command -v rustc &> /dev/null; then
    echo "⚠ Rust not found. Install from https://rustup.rs"
    echo "  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
fi

# Check for Anchor
if ! command -v anchor &> /dev/null; then
    echo "⚠ Anchor CLI not found. Install with:"
    echo "  cargo install --git https://github.com/coral-xyz/anchor anchor-cli"
fi

# Install Rust auditing tools
echo "→ Installing cargo-audit..."
cargo install cargo-audit 2>/dev/null || echo "  (already installed or skipped)"

echo "→ Installing cargo-deny..."
cargo install cargo-deny 2>/dev/null || echo "  (already installed or skipped)"

echo "→ Installing cargo-geiger..."
cargo install cargo-geiger 2>/dev/null || echo "  (already installed or skipped)"

# Install Trident fuzzer
echo "→ Installing Trident..."
cargo install trident-cli 2>/dev/null || echo "  (already installed or skipped)"

# Install Kani verifier
echo "→ Installing Kani..."
cargo install --locked kani-verifier 2>/dev/null || echo "  (install manually: https://model-checking.github.io/kani/)"

echo ""
echo "=== Installation Complete ==="
echo "Skill is ready to use with any Solana AI Kit-compatible agent."
echo "Start with: /quick-audit or /deep-audit"
