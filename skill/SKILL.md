---
name: solana-payments
description: Production-grade stablecoin payments for Solana — Solana Pay checkout & payment links,
  subscriptions, safe confirmation & idempotency, webhook-to-ledger reconciliation, refunds,
  on/off-ramp, treasury, and compliance basics. Routes to focused references. Progressive disclosure.
user-invocable: true
license: MIT
---

# Solana Payments — Skill Hub

The skill a coding agent loads the moment a builder says *"let users pay me in USDC/USDG/PYUSD."*
From checkout to **confirmed, reconciled, refundable, compliant** settlement.

**Precedence:** `rules/payments.md` (safety laws) > official protocol/provider docs (Solana Pay,
Circle, Paxos, PayPal, Helius) > this skill's guidance. When unsure about a current value (mint,
SDK version), confirm against `resources.md` — never from memory.

## Route — one primary reference per task

| If the builder is trying to… | Primary | Then |
|------------------------------|---------|------|
| Pick a stablecoin; set up mints, ATAs, token program | `rails.md` | `resources.md` |
| Build a QR / payment-link checkout (Solana Pay) | `solana-pay.md` | `checkout.md` |
| Wire a full web checkout (server creates request, client pays) | `checkout.md` | `confirmation.md` |
| Charge recurring / subscriptions | `subscriptions.md` | `confirmation.md` |
| Answer "did I *really* get paid?" | `confirmation.md` | `reconciliation.md` |
| Match on-chain payments to my database | `reconciliation.md` | `confirmation.md` |
| Refund, partial-refund, or handle a dispute | `refunds-disputes.md` | `treasury.md` |
| Move money to/from fiat | `onramp-offramp.md` | `compliance.md` |
| Screen/record payments for compliance | `compliance.md` | → `crypto-legal` skill for legal layer |
| Hold and settle funds safely | `treasury.md` | `refunds-disputes.md` |
| Test any flow on devnet / mainnet-fork | `testing.md` | — |

## Decision shortcuts

- **Which rail?** Default **USDC** (deepest liquidity, classic SPL). Offer **USDG** to bank the
  Global Dollar Network; **PYUSD** for PayPal reach — note PYUSD is **Token-2022**, code for both
  programs. → `rails.md`.
- **How do I know a payment landed?** Attach a unique `reference` pubkey to the Solana Pay request,
  then index it with `getSignaturesForAddress` and verify the tx. → `confirmation.md`.
- **Recurring on Solana?** There is **no native recurring charge**. Primary pattern: token
  **delegate/approval** + an off-chain scheduler that pulls within the approved allowance. →
  `subscriptions.md`.

## Hand-offs (don't reinvent)

- Custom on-chain programs / PDAs / CPIs → **`solana-dev`** core skill.
- NFT or token-mint mechanics, candy machine → **`metaplex`** / token skills.
- Legal entity, licensing, jurisdiction, KYC policy → **`crypto-legal`** skill.
- Trading, LP, IL, oracle pricing → **out of scope** (see `position-manager` skill).

## Agents & commands (optional, in this repo)

- `agents/payments-engineer.md` — implements checkout/confirmation/reconciliation.
- `agents/compliance-reviewer.md` — adversarial review: double-pay, replay, screening, key handling.
- `/scaffold-checkout` — generate a working devnet checkout. `/reconcile` — wire webhook→ledger.

**Golden rule:** payments code that is wrong loses money. Verify facts (`resources.md`), obey the
safety laws (`rules/payments.md`), and test before you trust (`testing.md`).
