# ToneHone PRD Addendum – Tone Configuration & Keyboard Injection (Feb 2025)

Purpose: clarify the core differentiation and flows for per-conversation tone configuration and keyboard-based injection.

## Core differentiation (restated)
- Every conversation has its own tone profile (playfulness, formality, forwardness, expressiveness) with presets and custom sliders.
- Users can paste recent text from the other person to set context instantly; suggestions are generated with that tone and context.
- Rapid refinement: keep/adjust specific spans of a suggested message, regenerate targeted sections, and apply tone guardrails.
- Keyboard extension is the delivery vehicle: copy-only responses from the extension into any app, with tone profile applied per conversation/person.

## Key flows (condensed)
1) **Tone Config per conversation**
   - Entry: from Hub card, Thread header, or extension quick-switch.
   - Controls: sliders, presets, live preview; tone mismatch warnings; version history/tone shift log.
2) **Paste-to-context → Suggest**
   - User pastes “their” latest text (app or extension).
   - System updates context and generates 3–5 options (safe/bold/playful/question/statement) with match scores and rationales.
3) **Refine**
   - Highlight spans → keep/adjust; targeted rewrites; version history; pre-send tone guardrail warning.
4) **Inject via keyboard**
   - Extension shows recent threads + tone preset; paste text → instant suggestions; copy-only into any app; sub-2s latency target.

## Sprint alignment (summary)
- Sprint 1: Tone Config surface per conversation; paste-to-context → suggestions; keyboard shell with copy-only.
- Sprint 2: Refinement editor (keep/adjust), OCR import with review; tone shift log/warnings; keyboard v1 with inline paste-to-suggest.
- Sprint 3: Billing/compliance and health basics.
- Sprint 4: Reminders/perf/polish; keyboard v2 tone check/quick tone switch.

This addendum complements the main PRD; no other changes to scope.***
