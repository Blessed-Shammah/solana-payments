#!/usr/bin/env bash
# solana-payments-skill — minimal installer.
# Copies the skill into ~/.claude/skills/solana-payments and the safety rules into ~/.claude/rules.
# No network calls, no binaries downloaded. Review before running (it only copies files).
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST_ROOT="${CLAUDE_HOME:-$HOME/.claude}"
SKILL_DEST="$DEST_ROOT/skills/solana-payments"
RULES_DEST="$DEST_ROOT/rules"

echo "Installing solana-payments-skill → $SKILL_DEST"

mkdir -p "$SKILL_DEST" "$RULES_DEST"

# Skill references (the SKILL.md hub + focused .md files)
cp -R "$SRC_DIR/skill/." "$SKILL_DEST/"

# Optional agents / commands, if present
[ -d "$SRC_DIR/agents" ] && { mkdir -p "$DEST_ROOT/agents"; cp -R "$SRC_DIR/agents/." "$DEST_ROOT/agents/"; }
[ -d "$SRC_DIR/commands" ] && { mkdir -p "$DEST_ROOT/commands"; cp -R "$SRC_DIR/commands/." "$DEST_ROOT/commands/"; }

# Safety laws (auto-loaded on payment code)
cp "$SRC_DIR/rules/payments.md" "$RULES_DEST/payments.md"

echo "Done."
echo "  Skill : $SKILL_DEST/SKILL.md"
echo "  Rules : $RULES_DEST/payments.md"
echo "Open your agent and ask it to load the 'solana-payments' skill."
