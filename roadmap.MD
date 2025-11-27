# ToneHone Roadmap (multi-agent synthesis)
Date: 2025-02-17

## Context from source docs
- CLAUDE.md: TTS defaults to ON, agent-selection matrix with mandatory checkpoints (backend for APIs, frontend for components, iOS for iOS features, test engineer for every feature, etc.), and quality gates (tests, TodoWrite/ROADMAP updates). No architecture specifics yet.
- tonehone-PRD.md: Vision is a conversation intelligence platform for dating; primary platform is iOS (PRD assumed React Native/Expo) with web companion; monetization via credits + $39/mo Pro. MVP P0 features: Conversation Hub, Thread View with OCR/manual import, Tone Profile System (sliders, presets, warnings), AI Response Generation (3–5 options, tone-matched), Iterative Refinement Editor (keep/adjust sections), and early Insights/Health. Design: sophisticated, fast (<1.5s dashboard, 60fps), WCAG AA, clean Linear/Notion/Superhuman-inspired. Success metrics center on weekly active conversations and response velocity.

## Target tech stack (current plan)
- **iOS app + keyboard extension:** Swift/SwiftUI, Combine/async-await, App Group + Keychain sharing, iOS 17+; HIG-compliant gestures/haptics.
- **Backend:** Node.js 20+ with TypeScript, Express, Zod/Joi validation, Stripe billing, S3-compatible storage (UK region), Redis cache, PostgreSQL (UK region) with Prisma; Bull/queue for OCR/LLM jobs; Sentry/structured logging.
- **AI/OCR:** GPT-4.1 (tunable) primary, Claude as fallback; prompt pipeline with tone vectors; Google Vision OCR (or equivalent) with manual review step.
- **Web companion/marketing:** Next.js 14+, Vercel hosting for marketing and dashboard; React Query, Tailwind/Radix; protected app routes proxied to backend.
- **Compliance/security:** GDPR-first, data stored in UK region, PII encryption at rest, audit logging, export/delete endpoints.

## Agent feedback (specialist lenses)
- AI Engineer: Prioritize robust prompt pipeline with tone vectors, platform/person context, “why it works” rationales; GPT-4.1 (tunable) primary with Claude fallback; cache per-thread embeddings to cut token cost; log generations/selected options for post-hoc tuning; keep extension latency under 2s without on-device LLM.
- Backend Architect: Define services for auth/billing, conversations/messages, tone profiles, AI generation, OCR ingestion, and analytics. Enforce rate limits per user/tier; async jobs for OCR and heavy LLM calls; idempotent webhooks for Stripe; signed URLs for uploads; observability (structured logs, traces).
- Database Architect: Normalize users→conversations→messages with tone_profile versions and ai_generations tables (already outlined in PRD); add search index on messages.content + person_name; materialized view or summary table for conversation health; partition/TTL for generations to manage cost; encryption at rest; per-tenant row-level ownership.
- Frontend Developer (Web): Componentize ConversationCard, ThreadView, Tone sliders, SuggestionList, RefinementEditor; use React Query + optimistic updates; virtualize long threads; skeletons for OCR/LLM loading; strict accessibility (focus order, ARIA on web).
- iOS Developer: Build iOS app + system keyboard extension (Swift/SwiftUI, iOS 17+), App Group + Keychain sharing; respect extension memory/time limits; native clipboard with “tone check” warning; haptics/animations tuned to HIG.
- Mobile Developer: RN path deprioritized; focus native SwiftUI patterns, native image picker/camera, on-device compression; push/deep links for “needs response.”
- React Performance Optimizer: Virtualize lists, memoize tone visualizations, keep context providers thin, prefetch likely-next thread; code-split web marketing site; measure LCP/TTI.
- Test Engineer: Test pyramid with Swift unit/UI tests (XCTest/XCUITest) and web E2E (Playwright); contract tests for API; synthetic load on LLM/OCR endpoints; guardrails for tone mismatch detection; CI gates at 80% coverage.
- TypeScript Pro: Shared types for backend/web (Person, Conversation, Message, ToneProfile, Suggestion); strict tsconfig; Zod/Joi for request validation; discriminated unions for message sources; branded types for IDs.
- Vercel Deployment Specialist: Host marketing/landing + web app on Vercel with preview deployments; edge caching for public pages; protect app routes with auth middleware; use Speed Insights/Web Analytics; API off-Vercel (Node/Express) but proxied via rewrites.

## Priority roadmap (phased)
**P0 – Foundation & iOS MVP (0–3 months, iOS 17+)**
- Auth, billing (Stripe credits + Pro), usage tracking; basic roles/limits per tier.
- Conversation ingestion: manual add + screenshot OCR with crop/review/correction; storage to S3-equivalent with signed URLs; edit/delete/reorder messages; mark “key moments”; platform detection.
- Conversation Hub + Thread View: 50+ conversations, filters/search/sort, “needs response,” unread counts, health badges, tone badges, platform badges; virtualized threads; jump-to-bottom; message edit/delete; export/share; archive.
- Tone Profile System: sliders/presets, AI-suggested starting tone, per-person storage, mismatch warnings, versioning; tone shift log.
- AI Suggestions: 3–5 options with tone match scores, reasoning snippets, variation types (safe/bold/playful/question/statement); quick-adjust buttons (funnier/shorter/less forward/etc.).
- Iterative Refinement Editor: keep/adjust sections, targeted rewrite, regenerate, version history; pre-send tone guardrails.
- Keyboard Extension v1 (iOS): quick access to recent threads + tone presets, generate/copy responses from any app; App Group storage; latency budget <2s; copy-only (no direct send); respects extension memory/time constraints.
- Reliability/compliance: logging/metrics, Sentry, rate limits, PII encryption; GDPR export/delete; data stored in UK region; online-only (graceful messaging when offline).
- Design: implement core design system tokens/components matching PRD palette/typography; 60fps interactions; HIG-aligned, minimal.

**P1 – Insightful & cross-app depth (3–6 months)**
- Conversation Insights: health score, response-time analytics, “what worked” highlights, tone-shift detection with audit trail; timeline of key moments.
- Tone Profile evolution: richer versioning, reuse across conversations, smarter auto-suggestions per platform/persona, preset cloning.
- Keyboard Extension v2: inline refinement shortcuts, per-contact default tone, quick “tone check” warnings in extension, predictive surfacing of likely reply snippets.
- Notifications/reminders: push + in-app alerts for “needs response,” tone-shift suggestions, credit low alerts; snooze/quiet hours.
- Cost/perf hardening: caching conversation context, resumable uploads, background jobs for OCR/LLM; hard limits per tier.
- Web companion: Next.js app for dashboard/thread view + insights (parity with mobile minus uploads), Vercel previews.
- Privacy/compliance: user-controlled data deletion/export, audit logging, secure data sharing to extension, DPIA-ready docs; data residency UK.
- Testing maturity: CI with XCTest/XCUITest, Playwright for web, contract tests for LLM/OCR adapters, synthetic load on AI endpoints.

**P2 – Growth, retention, and expansion (6–12 months)**
- Templates/snippets library with tone-aware variants; sharing with friends/coaches (permissioned).
- Coach/Team mode: multi-seat access, per-conversation permissions, export/PDF bundles.
- Advanced monetization: referrals, annual plan upsell, promo credits; dynamic limits based on risk/cost.
- Android + desktop uplift: revisit only after iOS excellence; richer web experience; parity for keyboard via suggestion overlay (where allowed).
- Deeper insights: relationship progression timelines, A/B tone experiments, calendar/date-tracking hooks.
- Operational excellence: autoscaling, disaster recovery, proactive alerting; cost dashboards for LLM/OCR.

## Immediate next steps (actionable)
- Confirm native SwiftUI app + system keyboard extension (no Expo). Create Xcode workspace with targets: App, Keyboard Extension; configure App Group + Keychain sharing; set secure storage plan; target iOS 17+.
- Finalize data model and API contracts for conversations, messages, tone profiles, and generations; scaffold CI with lint/tests.
- Prototype prompt pipeline with tone vectors + “why it works” rationales; instrument token cost logging; primary model GPT-4.1 (tunable) with Claude fallback if needed.
- Design/build core SwiftUI components (Hub, Thread, Tone sliders, Suggestion list, Refiner) with skeleton/loading states.
- Implement OCR flow with manual review and error handling; set S3 bucket + signed upload endpoints.
- Stand up Stripe (credits + Pro) with webhooks and per-tier rate limits; add usage meters for AI/OCR.
- Implement GDPR-first: data export/delete, consent tracking, minimal retention defaults; data stored in UK region; document DPIA basics.

## Open questions for the product owner
- Resolved: Full system keyboard; copy-only (no send) from extension.
- Resolved: Go native Swift/SwiftUI + Xcode targets (app + keyboard); RN/Expo deprioritized.
- Resolved: Model preference GPT-4.1 (tunable) primary, Claude as potential secondary; target UK/GDPR; data stored in UK region.
- Resolved: Minimum iOS version 17; no on-device/offline LLM capability required.
