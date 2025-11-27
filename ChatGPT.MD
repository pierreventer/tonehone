# ChatGPT working notes for ToneHone

Purpose: persistent instructions for future sessions. Keep it short, actionable, and aligned to the agreed MVP.

## Decisions (current)
- Platform: iOS app (iPhone focus) + system keyboard extension; Swift/SwiftUI; iOS 17+.
- Extension: copy-only (no direct send); aim for sub-2s latency; App Group + Keychain sharing.
- Stack: GPT-4.1 primary, Claude fallback; Node/TS backend with PostgreSQL/Redis/S3 (UK region); Google Vision OCR with manual review; Next.js web companion/marketing on Vercel.
- Compliance: GDPR-first; data stored in UK region; online-only (no offline/on-device LLM).
- Scope: MVP, ship fast (hours, not days); usable personally for a couple weeks; functionality over polish; iPhone-only for now (adaptive layouts so iPad later is possible).
- UI/UX: SwiftUI shells for Hub, Thread, Tone profiles, Suggestions/Refiner; HIG-aligned, minimal.
- Monetization: credits + Pro ($39/mo) with Stripe/webhooks; usage tracking per tier.

## Working principles
- Bias to shipping core flows: ingest conversation (manual + screenshot OCR), tone profiles, suggestions + refinement, keyboard copy flow.
- Keep project structure simple: main app target + keyboard target, shared models/services; entitlements for App Group/Keychain.
- Avoid Expo/RN; native-first.
- No offline mode—show clear messaging if offline.

## Open/assumed
- Bundle IDs/app group IDs to be set when provisioning.
- iPad/Catalyst deferred; add only if needed later.
