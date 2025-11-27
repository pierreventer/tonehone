# ToneHone

Conversation intelligence for dating: manage multiple threads, keep tones consistent per person, and generate/refine replies with a tone-aware iOS keyboard.

## Platform and scope
- iOS app + system keyboard extension (Swift/SwiftUI, iOS 17+), copy-only from extension.
- Backend API (Node/TypeScript, Express) with Stripe billing, PostgreSQL, Redis, S3-compatible storage (UK region).
- Web companion/marketing in Next.js (Vercel) for dashboard/insights and landing.
- Online-only; no on-device/offline LLM.

## Core MVP features (from PRD)
- Conversation Hub: 50+ conversations, filters/search/sort, “needs response,” badges (tone/platform/health), unread counts, quick actions, summary stats.
- Thread View: virtualized chat, jump-to-bottom, edit/delete/reorder messages, key-moment flags, export/share/archive/delete.
- Ingestion: manual add, screenshot upload with crop → OCR → review/correction, platform detection, manual paste, individual message add.
- Tone Profile System: 4 sliders (playfulness, formality, forwardness, expressiveness), presets/custom, AI-suggested tone, mismatch warnings, versioning/tone shift log.
- AI Suggestions: 3–5 options with match scores, “why it works,” variation types (safe/bold/playful/question/statement), quick-adjust (shorter/less forward/funnier/etc.).
- Iterative Refinement: keep/adjust sections, targeted rewrite, regenerate, version history, pre-send tone guardrails.
- Keyboard Extension v1: recent threads + tone presets, generate/copy replies from any app, latency <2s, App Group/Keychain sharing.
- Monetization: credits + Pro subscription ($39/mo) with usage limits per tier; Stripe + usage tracking.
- Reliability/compliance: logging/metrics, Sentry, rate limiting, PII encryption, GDPR export/delete; data stored in UK region.

## Tech stack (current plan)
- **iOS:** Swift/SwiftUI, Combine/async-await, App Group + Keychain sharing, SFSymbols/HIG patterns, XCTest/XCUITest.
- **Backend:** Node.js 20+, TypeScript, Express, Zod/Joi validation, Prisma + PostgreSQL (UK), Redis, Bull/queues, S3-compatible storage (UK), Stripe, Sentry, structured logging.
- **AI/OCR:** GPT-4.1 (tunable) primary, Claude fallback; prompt pipeline with tone vectors; Google Vision OCR with manual review.
- **Web:** Next.js 14+, React Query, Tailwind/Radix, Vercel for marketing/app shell; protected routes proxied to backend.
- **Security/Compliance:** GDPR-first, data residency in UK, audit logging, export/delete endpoints, PII encryption at rest.

## Roadmap
See `roadmap.MD` for phased priorities (P0–P2), agent inputs, and immediate next steps.

## Working notes
- Build and testing will happen locally in Cursor/Claude Code, with Xcode simulator for iOS targets.
- No offline LLM; ensure clear UX when offline.
- Extension is copy-only (no direct send).***
