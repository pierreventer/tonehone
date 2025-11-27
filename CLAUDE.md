# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project: ToneHone

This is a new project. Details will be added as the project develops.

## Commands

Text-to-Speech (TTS)
⚠️ TTS Default Status: ALWAYS ON
Default: ON (MANDATORY at session start unless user explicitly disables)
Voice: shimmer | Speed: 1.25
Usage: mcp__tts__openai_tts(text, voice="shimmer", speed=1.25)
FIRST response in every session MUST use TTS
Play completion ping: afplay /System/Library/Sounds/Ping.aiff (ONCE at end of response)
Commands:
"turn off TTS" - disable audio
"turn on TTS" - re-enable audio
TTS Troubleshooting (if not working):
FIRST: Restart Claude Code - Fixes 90% of issues (kills duplicate mcp-tts processes)
Check for duplicates: ps aux | grep mcp-tts | grep -v grep → Kill if found
Test tool: mcp__tts__openai_tts(text="test")
Only if restart fails: Check ~/.claude.json and .claude/settings.local.json configs
DO NOT modify ~/.claude.json automatically. Restart Claude Code first.
MCP Configuration
mcp-tts Setup (already configured):
Config: ~/.claude.json under vibesprint project
Enable: .claude/settings.local.json → enabledMcpjsonServers: ["tts"]
Restart Claude Code after any config changes


## Code Style

(No specific style guidelines yet)

## Architecture

(Architecture details to be added)

---

## Agent Selection Protocol

### Available Agents

| Agent | Responsibility |
|-------|----------------|
| **backend-architect** | API routes, database schema, services, performance, rate limiting |
| **frontend-developer** | React components, UI, forms, state management, responsive design |
| **test-engineer** | Test strategy, writing tests, coverage (80%+), CI/CD (MANDATORY for every feature) |
| **database-architect** | Database design, indexes, queries, migrations, data modeling |
| **typescript-pro** | Complex types, generics, type inference, TypeScript config |
| **react-performance-optimizer** | Bundle size, rendering, code splitting, memoization, Core Web Vitals |
| **ios-developer** | Native iOS, Swift, SwiftUI, Core Data, app lifecycle |
| **mobile-developer** | React Native, Flutter, cross-platform, offline sync, push notifications |
| **ai-engineer** | LLM integrations, RAG systems, prompt pipelines, vector search |
| **vercel-deployment-specialist** | Vercel deployments, edge functions, middleware, performance |

### Workflow

1. **STOP** - Don't code yet
2. **ASSESS** - What type of task? (backend, frontend, testing, iOS, etc.)
3. **IDENTIFY** - Which agent(s) should handle this?
4. **LAUNCH** - Use Task tool to engage specialist(s) IN PARALLEL for complex tasks
5. **IMPLEMENT** - Follow agent recommendations

### Agent Selection Matrix

| Task Type | Agents to Launch |
|-----------|------------------|
| React hooks | frontend-developer + typescript-pro |
| UI components | frontend-developer + test-engineer |
| API routes | backend-architect + test-engineer |
| Database queries | database-architect + backend-architect |
| Complex types | typescript-pro + backend-architect |
| Performance issues | react-performance-optimizer + frontend-developer |
| iOS features | ios-developer + test-engineer |
| Mobile (cross-platform) | mobile-developer + test-engineer |
| AI/LLM features | ai-engineer + backend-architect |
| Deployment | vercel-deployment-specialist + test-engineer |

---

## Quality Gates (Per Task)

- Agent implemented solution
- Tests written and passing (80%+ coverage)
- No TypeScript errors
- Code follows existing patterns
- TodoWrite and ROADMAP.md updated

---

## Multi-Agent Coordination Patterns

### Pattern A: Parallel Planning (Sprint Start)
- Launch 2-4 agents simultaneously at sprint start
- Each provides domain expertise (frontend, backend, testing, database)
- Synthesize all recommendations into unified execution plan

### Pattern B: Sequential Task Execution
- Complete one task fully before starting next
- Each task gets specialist agent(s) → implementation → tests → verification
- Mark complete in TodoWrite, update ROADMAP.md, then proceed

### Pattern C: Complex Decision Discussion
- For challenging architectural decisions, launch 2-3 agents with same question
- Each agent provides different perspective on the problem
- Compare approaches and select optimal solution

---

## Mandatory Checkpoints

- Every new API route → Backend Architect
- Every new component → Frontend Developer
- Every feature completion → Test Engineer
- Every database change → Database Architect
- Complex TypeScript → TypeScript Pro
- iOS features → iOS Developer
- Cross-platform mobile → Mobile Developer
- AI/LLM features → AI Engineer
- Deployment changes → Vercel Deployment Specialist
