# rails.md — choosing & wiring a stablecoin

**Goal:** pick a rail and set up the on-chain plumbing correctly. The #1 source of silent payment
bugs lives here: wrong token program, wrong decimals, wrong ATA derivation. Verified mints are in
`resources.md` — never hardcode from memory.

## Pick a rail

| Rail | When | Token program | Notes |
|------|------|---------------|-------|
| **USDC** | Default. Deepest liquidity, every wallet/ramp supports it | SPL Token | Safe baseline |
| **USDG** | Bank Global Dollar Network rewards/partners | SPL Token | Growing integrations |
| **PYUSD** | PayPal reach, consumer fiat bridge | **Token-2022** | Has token extensions — code for it |

You can accept several. If you do, **abstract over the token program** — do not assume SPL Token.

## The trap: SPL Token vs Token-2022

USDC and USDG are classic SPL Token. PYUSD is Token-2022. They have **different program ids** and
their **ATAs derive under the owning program**. Resolve the program from the mint; never assume:

```ts
import { createSolanaRpc, address } from "@solana/kit";

const rpc = createSolanaRpc(process.env.RPC_URL!);

// The mint's account owner IS the token program to use for transfers + ATA derivation.
const { value } = await rpc.getAccountInfo(address(MINT), { encoding: "base64" }).send();
const tokenProgram = value!.owner; // TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA = SPL, Tokenz… = T22
```

## Read decimals from the mint (Safety Law #3)

Never hardcode `6`. Read it, and transfer with `transferChecked` so the chain asserts amount *and*
decimals. To send "$10.00", the base-unit amount is `10 * 10**decimals`.

```ts
// decimals come from the parsed mint account; compute base units server-side only
const baseUnits = BigInt(Math.round(dollars * 10 ** decimals)); // dollars derived from the invoice
```

## Associated Token Accounts

- Payer and merchant each need an ATA for the mint, derived **under the mint's token program**.
- The receiving merchant ATA should exist before you publish a payment request; create it once.
- For Token-2022 mints, account size differs (extensions) — let the SDK size it; don't assume SPL
  account length.

## Output of this step

A resolved `{ mint, decimals, tokenProgram, merchantAta }` tuple that every later step
(`solana-pay.md`, `checkout.md`, `confirmation.md`) consumes. Wrong values here corrupt everything
downstream — verify against `resources.md` and on-chain before proceeding.

→ Next: encode the request in `solana-pay.md`.
