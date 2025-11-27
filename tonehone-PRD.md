# ToneHone Product Requirements Document

**Version:** 1.0  
**Date:** November 2025  
**Status:** Draft for Development  
**Author:** Product Strategy Team

---

## Executive Summary

**ToneHone** is a conversation intelligence platform that enables users to manage multiple dating conversations simultaneously while maintaining authentic, contextually appropriate communication across different relationships. Unlike competitors that focus on generating single pickup lines, ToneHone orchestrates entire conversation portfolios with sophisticated tone calibration and iterative refinement capabilities.

**Market Opportunity:** The dating conversation AI space has reached 55+ competitors generating $50-100M annually, but all focus on one-shot response generation. The multi-conversation orchestration and tone calibration markets remain completely unaddressed, representing a $10-20M opportunity in Year 1.

**Target Launch:** Q2 2026  
**Platform:** iOS (React Native/Expo) + Web  
**Monetization:** Credit-based + Premium Subscription ($39/month)

---

## Table of Contents

1. [Product Vision & Strategy](#1-product-vision--strategy)
2. [Market Analysis & Positioning](#2-market-analysis--positioning)
3. [Target User](#3-target-user)
4. [Problem Statement](#4-problem-statement)
5. [Solution Overview](#5-solution-overview)
6. [Core Features (MVP)](#6-core-features-mvp)
7. [User Flows](#7-user-flows)
8. [Technical Architecture](#8-technical-architecture)
9. [Design Requirements](#9-design-requirements)
10. [Monetization Strategy](#10-monetization-strategy)
11. [Success Metrics](#11-success-metrics)
12. [Competitive Differentiation](#12-competitive-differentiation)
13. [Development Roadmap](#13-development-roadmap)
14. [Go-to-Market Strategy](#14-go-to-market-strategy)
15. [Risk Assessment](#15-risk-assessment)
16. [Appendix](#16-appendix)

---

## 1. Product Vision & Strategy

### 1.1 Vision Statement

"Enable authentic, meaningful connections by helping users maintain conversation continuity, calibrate tone appropriately, and manage multiple relationships with contextual intelligence."

### 1.2 Mission

ToneHone empowers people to become MORE themselves—not someone else—by providing sophisticated tools to express their authentic voice across all their important conversations.

### 1.3 Product Philosophy

**We believe:**
- Dating app fatigue is real—people juggle 5-10 conversations and lose track
- Generic AI responses feel inauthentic and damage real connections
- Different relationships deserve different tones—playful with one person, thoughtful with another
- Great communication is iterative, not one-shot
- The goal is building real relationships, not collecting matches

**We reject:**
- Pickup line generators that treat dating as a numbers game
- One-size-fits-all AI that makes everyone sound the same
- Tools that replace human judgment rather than enhance it
- Quick tricks over long-term relationship building

### 1.4 Why Now?

1. **Market Timing:** Dating apps hit peak fatigue—users want quality over quantity
2. **AI Sophistication:** LLMs can now understand conversational context and tone nuance
3. **Competitive Gap:** 55+ competitors, zero focus on multi-conversation orchestration
4. **Validation:** Social Wizard ($1M ARR) and Keys AI ($40/month pricing) prove premium positioning works
5. **User Behavior:** Average Tinder user has 7+ active conversations—demand is proven

---

## 2. Market Analysis & Positioning

### 2.1 Market Size

**Total Addressable Market (TAM):**
- 380M dating app users globally
- 50M in US/UK (primary markets)
- Estimated 15-20M "active conversationalists" (3+ concurrent chats)

**Serviceable Addressable Market (SAM):**
- Users willing to pay for conversation tools: 3-5M
- Average spending: $20-40/month on dating optimization
- Market size: $60-200M annually

**Serviceable Obtainable Market (SOM) - Year 1:**
- Target: 10,000 paid users
- ARPU: $28/month
- Revenue target: $3.36M ARR by end of Year 1

### 2.2 Competitive Landscape

**Category Leaders:**
- **Rizz:** 7.5M downloads, $190K-500K monthly, playful positioning
- **YourMove AI:** 300K users, speed-focused, "5 seconds or less"
- **Keys AI:** Premium coach positioning, $40/month, no slang
- **Social Wizard:** $1M ARR, social anxiety niche

**Key Gaps We Exploit:**
1. **Multi-conversation orchestration:** NOBODY does this
2. **Relationship continuity:** All focus on first impressions only
3. **Sophisticated tone calibration:** Social Wizard has "10 tonalities" but generic
4. **Iterative refinement:** All give single suggestions, no collaborative editing

### 2.3 Positioning

**Category:** Conversation Intelligence Platform  
**Tagline:** "Hone your tone for every connection"

**Positioning Statement:**
"For sophisticated daters managing multiple conversations who want authentic connection over quick tricks, ToneHone is the conversation intelligence platform that helps you hone the perfect tone for every relationship—from casual to committed, playful to profound. Unlike basic dating assistants that generate one-size-fits-all pickup lines, ToneHone maintains conversation continuity across your entire dating portfolio while keeping your authentic voice."

**Brand Personality:**
- Sophisticated, not playful
- Intentional, not impulsive
- Empowering, not manipulative
- Collaborative, not automated
- Authentic, not artificial

---

## 3. Target User

### 3.1 Primary User Persona: "The Thoughtful Dater"

**Demographics:**
- Age: 27-38
- Gender: All (slight male skew 60/40)
- Location: Urban/suburban US & UK
- Education: College+
- Income: $60K-120K
- Occupation: Professional, knowledge worker

**Psychographics:**
- Values authentic connection over quantity of matches
- Frustrated by dating app fatigue and context overload
- Manages 5-10 active conversations across 2-3 apps
- Wants to be thoughtful but struggles with time/energy
- Cares about how they come across—communication matters to them
- Willing to invest in quality tools
- Already uses ChatGPT occasionally but finds workflow clunky

**Behavioral Traits:**
- Opens dating apps 2-3x daily
- Spends 20-40 min/day on dating app messaging
- Gets anxious about saying the wrong thing
- Screenshots conversations to friends for advice
- Loses track of who said what across multiple matches
- Sends different tones to different people (intentionally or not)
- Overthinks messages, takes 10+ minutes to craft replies

**Pain Points:**
- "I can't remember if I already told Jake this story or if that was Sarah"
- "I want to be playful with some people, deeper with others, but I keep mixing up my tone"
- "ChatGPT gives me okay responses but they don't sound like me"
- "I'm talking to 8 people and it feels like a part-time job"
- "I lose matches because I take too long to respond—decision fatigue is real"

**Jobs to Be Done:**
- Maintain conversation continuity across multiple relationships
- Respond authentically but efficiently
- Calibrate tone appropriately per person/context
- Not lose promising connections due to slow response time
- Build toward real dates, not endless chatting

### 3.2 Secondary Personas

**"The Career-Focused Professional"**
- Uses dating apps but limited time
- Needs efficiency without seeming robotic
- Values quality over quantity even more than primary persona
- Higher income, willing to pay premium ($50+/month)

**"The Re-entering Dater"**
- Recently single after long relationship
- Nervous about modern dating communication norms
- Needs confidence boost and guidance
- Likely older (35-45)

---

## 4. Problem Statement

### 4.1 Core Problems

#### Problem 1: Context Overload & Memory Failures

**User Quote:** *"I'm talking to 7 people on 3 apps and can't remember who said what or what tone I used with each person."*

**Current State:**
- Users manually track conversations across Hinge, Bumble, Tinder
- Lose track of conversation history and context
- Accidentally send wrong tone to wrong person
- Forget what topics they've discussed with whom
- Miss opportunities because they forget to respond

**Impact:**
- Lost matches due to inappropriate responses
- Emotional exhaustion from context-switching
- Decreased conversation quality
- Slower response times = lower match retention

**Existing Workarounds:**
- Screenshot → save to photos → scroll through later (inefficient)
- Notes app to track who's who (manual, forgotten)
- Ask friends for advice (slow, inconsistent)
- Just wing it and hope for the best (risky)

---

#### Problem 2: Tone Mismatch Across Relationships

**User Quote:** *"I want to be playful with Sarah, thoughtful with Jake, but the same generic 'AI suggestion' doesn't work for both."*

**Current State:**
- Different relationships require different communication styles
- AI tools give one-size-fits-all responses
- Users manually adjust every suggestion
- No way to maintain consistent tone per person over time

**Impact:**
- Responses feel inauthentic or "off"
- Matches disengage because vibe is inconsistent
- User exhaustion from constant manual adjustment
- Lower confidence in AI tools

**Existing Workarounds:**
- Manually prompt ChatGPT: "Make this more playful for Sarah"
- Copy/paste conversation history every time (tedious)
- Accept generic responses and lose authenticity
- Overthink every message (decision fatigue)

---

#### Problem 3: Iteration Hell

**User Quote:** *"The AI gives me something okay, but I need to adjust parts of it. Going back and forth takes forever."*

**Current State:**
- AI generates complete response
- User wants to keep part, adjust another part
- Must manually edit or start completely over
- No collaborative refinement workflow

**Impact:**
- Slower response creation (5-10 minutes per message)
- Frustration with AI tools
- Users abandon AI and write from scratch
- Higher cognitive load

**Existing Workarounds:**
- Copy AI response to notes app → manually edit → copy back
- Ask AI to regenerate entirely with new instructions
- Give up and send "okay" AI suggestion (feels inauthentic)

---

#### Problem 4: Relationship Progression Blindness

**User Quote:** *"We've been talking for 3 weeks but I have no idea if I'm escalating appropriately or what worked before."*

**Current State:**
- No tracking of conversation health or engagement
- Can't tell if relationship is progressing or stalling
- Forget what topics resonated previously
- Don't know when to escalate vs. maintain status quo

**Impact:**
- Miss timing for asking on dates
- Conversations fizzle without user knowing why
- Can't learn from successes and failures
- Repeat mistakes across different conversations

**Existing Workarounds:**
- Manually scroll through old messages (time-consuming)
- Gut feeling (unreliable with multiple conversations)
- Ask friends to review entire thread (impractical)

---

### 4.2 Why Now? Why Hasn't This Been Solved?

**Technology barriers (now resolved):**
- LLMs can finally understand nuanced conversational context
- OCR quality sufficient for screenshot analysis
- Mobile development frameworks (Expo) enable rapid cross-platform

**Market barriers (now resolved):**
- Users accept AI writing assistance (ChatGPT normalized it)
- Willingness to pay proven (Rizz: $190K/mo, Keys AI: $40/mo)
- Dating app fatigue creating pull for better tools

**Why competitors haven't solved it:**
- Focus on viral one-shot features (faster to market)
- Simpler technical implementation
- Didn't recognize multi-conversation orchestration as THE problem
- Positioned as "pickup line generators" not "relationship managers"

---

## 5. Solution Overview

### 5.1 Product Overview

ToneHone is a **conversation intelligence platform** that helps users:

1. **Orchestrate** multiple dating conversations from a single dashboard
2. **Calibrate** tone appropriately for each unique relationship
3. **Refine** AI-generated responses iteratively with inline editing
4. **Maintain** conversation continuity with full context awareness
5. **Learn** from conversation patterns to improve over time

### 5.2 How It Works (30-Second Pitch)

1. **Import your conversations** via screenshot or text paste
2. **Set tone profiles** for each person (playful, thoughtful, direct, etc.)
3. **Get AI suggestions** that understand full conversation history and match your tone
4. **Refine iteratively** by keeping good parts and adjusting specific elements
5. **Track what works** to improve your communication over time

### 5.3 Core Value Propositions

**For users managing multiple conversations:**
- "Stop context-switching. Manage all your conversations from one place."
- "Never forget who said what again."

**For users seeking authentic communication:**
- "Your voice, refined for every relationship."
- "Stay genuinely you while being more articulate."

**For users frustrated with generic AI:**
- "Different people deserve different tones."
- "Hone your tone per person—playful with Sarah, thoughtful with Jake."

**For users who value quality over speed:**
- "Build real connections, not collect matches."
- "Iterate until it's perfect, not just 'good enough.'"

### 5.4 Differentiation Summary

| What Competitors Do | What ToneHone Does |
|---------------------|-------------------|
| Single screenshot → single response | Full conversation dashboard with persistent context |
| One-size-fits-all suggestions | Per-person tone profiles that persist over time |
| Generate and hope it works | Iterative refinement with inline editing |
| Focus on pickups and first impressions | Support entire relationship journey from match to date |
| Make you sound like AI | Amplify YOUR authentic voice |

---

## 6. Core Features (MVP)

### Feature 1: Conversation Hub (Dashboard)

**Priority:** P0 (Must-Have for MVP)

#### User Story
*"As a user managing multiple dating conversations, I need to see all my active conversations in one place so I can prioritize responses and maintain context without switching between apps."*

#### Functional Requirements

**FR-1.1: Conversation Grid View**
- Display all active conversations in grid or list format
- Support minimum 50 concurrent conversations per user
- Default sort: Most recent activity first
- Alternative sorts: Alphabetical, Priority, Platform

**FR-1.2: Conversation Card Components**
Each conversation card displays:
- Person's name/identifier (user-defined)
- Profile photo (if uploaded)
- Platform badge (Hinge, Bumble, Tinder, Other)
- Last message preview (first 50 characters)
- Time since last activity (e.g., "2h ago", "3 days ago")
- Tone profile indicator (visual badge/color)
- Conversation health score (1-5 bars/stars)
- "Needs Response" priority flag (if >24h since their message)
- Unread count (new messages added by user)

**FR-1.3: Filtering & Search**
- Filter by:
  - Platform (multi-select)
  - Tone type (playful, thoughtful, direct, etc.)
  - Status (needs response, active, stale, archived)
  - Date added (last 7 days, 30 days, all time)
- Search by:
  - Person name
  - Message content (full-text search)
  - Keywords/topics discussed

**FR-1.4: Quick Actions**
From conversation card:
- Tap to open full Thread View
- Quick add message (without opening full view)
- Archive conversation
- Mark as priority
- Edit tone profile

**FR-1.5: Dashboard Analytics (Summary)**
Top of dashboard shows:
- Total active conversations
- Conversations needing response
- Average response time (across all)
- This week's activity summary

#### Non-Functional Requirements

**NFR-1.1: Performance**
- Dashboard loads in <1.5 seconds with 50+ conversations
- Scroll performance: 60fps minimum
- Search results return in <500ms

**NFR-1.2: Offline Support**
- Dashboard viewable offline (cached data)
- Sync when connection restored
- Visual indicator of offline mode

**NFR-1.3: Data Limits**
- Support up to 200 conversations per user
- Graceful degradation beyond 200 (archive prompt)

#### Success Metrics
- Average conversations tracked per user (Target: 8-12)
- Daily dashboard visits per active user (Target: 3+)
- Time spent in dashboard (Target: 2-5 minutes per session)
- Filter/search usage rate (Target: 40% of users)

#### Design Notes
- Clean, scannable design—avoid information overload
- Color coding for tone types (consistent palette)
- Visual hierarchy: Needs Response > Active > Stale
- Mobile-first design (thumb-friendly tap targets)

---

### Feature 2: Thread View with Full Context

**Priority:** P0 (Must-Have for MVP)

#### User Story
*"As a user responding to a specific person, I need to see our complete conversation history and tone profile so responses stay consistent and contextually appropriate."*

#### Functional Requirements

**FR-2.1: Conversation Thread Display**
- Chat-style interface (messages stacked vertically)
- Clear speaker differentiation:
  - Them: Left-aligned, colored bubble
  - You: Right-aligned, different color
- Timestamp per message (or message group)
- Infinite scroll for history (virtualized for performance)
- "Jump to bottom" button if scrolled up

**FR-2.2: Message Import Methods**

*Screenshot Upload:*
- Tap "Add Message" → "Upload Screenshot"
- Camera roll access (iOS permission)
- Crop/adjust image before processing
- OCR extraction with confidence scoring
- Manual review/edit before committing
- Support multiple screenshots in sequence
- Auto-detect platform (Hinge, Bumble, etc.) from UI

*Manual Text Paste:*
- Tap "Add Message" → "Paste Text"
- Text input field with speaker labeling
- User marks "Them" vs "You"
- Multi-message batch input

*Individual Message Add:*
- Quick "+" button to add single message
- Choose speaker (Them/You)
- Type message text
- Timestamp auto-assigned (editable)

**FR-2.3: Context Sidebar (Desktop/Tablet)**
Right sidebar shows:
- Person's profile information
  - Name (editable)
  - Bio/description (imported or manual)
  - Profile photos (up to 5)
  - Platform + link (optional)
- Current tone profile
  - Visual sliders showing active settings
  - Quick adjust button
  - Profile preset name
- Conversation metadata
  - Date started
  - Total messages (them/you counts)
  - Average response time (theirs/yours)
  - Last interaction date
- "What Worked Before" insights
  - Top 3 effective message types
  - Topics that got strong responses
  - Tone adjustments that improved engagement

**FR-2.4: Mobile Context Access**
On mobile (bottom sheet or separate tab):
- Swipe up for context panel
- Condensed version of sidebar
- Quick tone profile access
- Profile info summary

**FR-2.5: Message Management**
- Edit any message (yours or theirs)
- Delete messages
- Reorder if timestamps wrong
- Mark message as "key moment" (star/flag)
- Add notes to specific messages

**FR-2.6: Thread Actions**
- Export conversation (text, PDF)
- Share with friends (permission gating)
- Archive conversation
- Delete conversation (with confirmation)

#### Non-Functional Requirements

**NFR-2.1: OCR Accuracy**
- Minimum 95% text accuracy on dating app screenshots
- Support iOS and Android screenshot formats
- Handle varied lighting, crops, and image quality
- Graceful fallback to manual entry if confidence <80%

**NFR-2.2: Storage**
- Unlimited conversation history per thread
- Images compressed but viewable
- Messages indexed for fast search

**NFR-2.3: Performance**
- Thread loads in <2 seconds (up to 500 messages)
- Virtualized scrolling for 1000+ message threads
- Image lazy-loading

**NFR-2.4: Privacy**
- All conversations encrypted at rest
- No data sharing with third parties
- User can export and delete all data

#### Success Metrics
- Messages per thread average (Target: 20+, indicating long-term usage)
- Screenshot upload success rate (Target: 90%+)
- Manual message additions per week (Target: 5+, showing active maintenance)
- Thread revisit rate (Target: 70% of threads accessed 3+ times)
- OCR correction rate (Target: <15% of extractions need manual fixing)

#### Design Notes
- Familiar chat UI (iMessage-style for comfort)
- Clear visual hierarchy for imported vs manual messages
- Smooth animations for message additions
- Loading states for OCR processing
- Error states with clear recovery paths

---

### Feature 3: Tone Profile System

**Priority:** P0 (Must-Have for MVP)

#### User Story
*"As a user who communicates differently with different people, I need to set and maintain consistent tone per person so I don't accidentally send the wrong vibe."*

#### Functional Requirements

**FR-3.1: Tone Spectrum Sliders**

Four primary dimensions (1-10 scales):

1. **Playfulness:** Witty ↔ Straightforward
   - 1-3: Serious, no jokes, direct communication
   - 4-6: Occasional humor, balanced
   - 7-10: Frequent banter, puns, lighthearted

2. **Formality:** Casual ↔ Proper
   - 1-3: Slang, contractions, very casual ("hey", "lol")
   - 4-6: Conversational but polished
   - 7-10: Proper grammar, no slang, refined

3. **Forwardness:** Subtle ↔ Direct
   - 1-3: Indirect hints, read between lines, patient
   - 4-6: Clear but not pushy
   - 7-10: Explicit about intentions, makes bold moves

4. **Expressiveness:** Reserved ↔ Enthusiastic
   - 1-3: Minimal emojis, calm tone, measured
   - 4-6: Moderate emotion, selective emphasis
   - 7-10: Exclamation marks, emojis, high energy

**FR-3.2: Visual Representation**
- Interactive sliders with labels
- Real-time preview of how tone affects sample message
- Color-coded indicators (e.g., blue=formal, red=playful)
- Radar/spider chart view showing all 4 dimensions

**FR-3.3: Preset Tone Profiles**

Built-in presets (editable):
1. **Playful & Flirty**
   - Playfulness: 8, Formality: 3, Forwardness: 7, Expressiveness: 8
   
2. **Thoughtful & Deep**
   - Playfulness: 3, Formality: 6, Forwardness: 4, Expressiveness: 5

3. **Casual & Friendly**
   - Playfulness: 5, Formality: 2, Forwardness: 5, Expressiveness: 6

4. **Direct & Bold**
   - Playfulness: 4, Formality: 5, Forwardness: 9, Expressiveness: 7

5. **Professional & Warm**
   - Playfulness: 3, Formality: 7, Forwardness: 5, Expressiveness: 4

6. **Custom** (user creates from scratch)

**FR-3.4: AI Tone Suggestions**
- On new conversation import, AI analyzes first 5+ messages
- Suggests starting tone profile based on:
  - Their communication style
  - Platform (Hinge vs Tinder have different vibes)
  - Topics discussed
  - Your past patterns (if data exists)
- User can accept, modify, or ignore

**FR-3.5: Tone Profile Management**
- Save custom profiles with names
- Apply saved profile to multiple conversations
- Edit profile mid-conversation (version history)
- Clone profile to use as template
- "Tone shift detected" notification if conversation evolves

**FR-3.6: Tone Mismatch Warnings**
- If user tries to send message that scores far from profile
- Warning modal: "This feels more [playful] than your usual [thoughtful] tone with Jake. Intentional?"
- Options: Send anyway, Adjust message, Update tone profile
- Can disable warnings per conversation

#### Non-Functional Requirements

**NFR-3.1: AI Integration**
- Tone parameters embedded as vectors in AI prompts
- Real-time tone analysis of generated responses
- Sub-second tone calculation

**NFR-3.2: Profile Persistence**
- Profiles saved per conversation (never lost)
- Sync across devices
- Version history (track when changed and why)

#### Success Metrics
- % users who customize beyond presets (Target: 60%, showing sophistication)
- Average tone profile updates per conversation (Target: 2-3 over lifetime)
- Tone mismatch warning override rate (Target: <20%, showing accurate profiles)
- Profile reuse rate (Target: 40% use saved custom profiles on new conversations)

#### Design Notes
- Sliders should feel playful yet precise
- Live preview critical for understanding impact
- Preset cards visually distinct
- Mobile: Vertical slider layout, easy thumb adjustment
- Desktop: Horizontal, more real estate for visualization

---

### Feature 4: AI Response Generation with Contextual Intelligence

**Priority:** P0 (Must-Have for MVP)

#### User Story
*"As a user crafting a reply, I need multiple AI-generated options that understand conversation history, match my tone profile, and give me starting points for refinement."*

#### Functional Requirements

**FR-4.1: Suggestion Generation**
- User taps "Get Suggestions" button in Thread View
- System generates 3-5 response options simultaneously
- Generation time: <3 seconds target
- Loading state with progress indicator

**FR-4.2: Context Window**
AI receives:
- Last 20 messages minimum (full conversation if <20)
- Tone profile settings (all 4 dimensions)
- Person's bio/profile info
- User's own communication patterns (if learned)
- Platform context (Hinge vs Bumble, etc.)
- Current conversation stage (initial messages, established rapport, near-date, etc.)

**FR-4.3: Response Option Display**

Each suggestion shows:
- Full response text (preview + expand)
- Tone indicators:
  - Visual badges for dimensions (e.g., "Playful: 7/10")
  - Match score to profile (e.g., "95% match")
- "Why this works" explanation:
  - "Building on their comment about hiking"
  - "Escalating toward date request"
  - "Matching their humor level"
  - "Maintaining your thoughtful tone"
- Action buttons:
  - Copy to clipboard
  - Refine (opens editor)
  - Send directly (adds to thread)
  - Regenerate this option

**FR-4.4: Suggestion Variations**
Generated options should vary:
- Option 1: Safest, closest to current tone
- Option 2: Slightly more forward/bold
- Option 3: More playful/creative
- Option 4: Question-focused (keeps conversation going)
- Option 5: Statement-focused (shares info about user)

**FR-4.5: Quick Adjustments**
Below suggestions, quick-adjust buttons:
- "Make it funnier"
- "Tone it down"
- "More direct"
- "Less forward"
- "Add a question"
- "Shorter"
- "Longer"

Tapping regenerates all options with that modifier.

**FR-4.6: Regeneration**
- "Regenerate All" button (new set of 3-5)
- "Regenerate This One" per suggestion
- History of generations (can review past sets)
- Unlimited regenerations (within credit limits)

**FR-4.7: Context Awareness Indicators**
Visual tags showing what AI considered:
- 💬 "Building on: their hiking comment"
- 📈 "Conversation stage: establishing rapport"
- 🎯 "Goal detected: moving toward date ask"
- 🎨 "Matching: their playful tone"

#### Non-Functional Requirements

**NFR-4.1: AI Model**
- Primary: Claude Sonnet 4 via Anthropic API
- Fallback: GPT-4 if Claude unavailable
- Token limits: 8K context window minimum
- Temperature: 0.7-0.9 for creativity with consistency

**NFR-4.2: Performance**
- <3 seconds for 3 suggestions
- <5 seconds for 5 suggestions
- Parallel generation where possible
- Queue system if concurrent requests

**NFR-4.3: Quality Control**
- Minimum response length: 10 words
- Maximum response length: 150 words (configurable)
- Filter out repetitive suggestions
- Avoid inappropriate content (profanity filter optional)
- Ensure suggestions are distinct (>30% difference)

**NFR-4.4: Cost Management**
- Cache conversation context where possible
- Optimize prompt engineering for token efficiency
- Track per-user API costs
- Rate limiting to prevent abuse

#### Success Metrics
- Suggestions accepted without editing (Target: 30-40%)
- Suggestions used as starting point for editing (Target: 50%)
- Regeneration rate (Target: <2 per response, showing quality)
- Average time from "Get Suggestions" to final message (Target: 60-90 seconds)
- User satisfaction rating for suggestions (Target: 4+/5 stars)

#### Design Notes
- Card-based layout for suggestions
- Expandable for full text (preview 2-3 lines)
- Clear visual distinction between options
- Thumbs up/down for feedback (optional)
- Smooth animations for regeneration
- Mobile: Vertical scroll through options
- Desktop: Grid or horizontal carousel

---

### Feature 5: Iterative Refinement Editor

**Priority:** P0 (Must-Have for MVP - This is the killer feature)

#### User Story
*"As a user who wants control over my messages, I need to iteratively refine AI suggestions by keeping good parts and adjusting specific elements without starting over."*

#### Functional Requirements

**FR-5.1: Split-View Editor**

**Layout:**
- Left pane: Current AI suggestion (or previous iteration)
- Right pane: Refined version (as user edits)
- Mobile: Top/bottom split or swipe between views

**FR-5.2: Text Annotation System**

User can highlight any portion of text and choose:

1. **Keep This** (🔒 icon)
   - Marked text gets locked
   - Visual indicator (background color, lock icon)
   - AI will preserve in next generation

2. **Adjust This** (✏️ icon)
   - Marked text gets adjustment menu:
     - "Make more playful"
     - "Make more serious"
     - "Make more direct"
     - "Make softer"
     - "Rephrase differently"
     - Custom instruction (text field)

3. **Replace This** (🔄 icon)
   - Marked text gets replacement menu:
     - "Replace with a question"
     - "Replace with humor"
     - "Replace with compliment"
     - "Reference [topic]" (detects topics from conversation)
     - Custom replacement instruction

4. **Delete This** (❌ icon)
   - Marked text removed
   - AI fills gap or adjusts sentence structure

**FR-5.3: Global Adjustments**

Above text, adjustment chips:
- "Add emoji" / "Remove emoji"
- "Make shorter" / "Make longer"  
- "Add question at end"
- "More casual" / "More formal"
- "Reference their last message"

**FR-5.4: Refinement Workflow**

1. User gets initial suggestions → picks one → opens Refine Editor
2. Highlights sections, applies annotations
3. Clicks "Regenerate with my edits"
4. AI produces new version incorporating all instructions
5. User reviews → either:
   - Accept (copy to clipboard or add to thread)
   - Further refine (repeat process)
   - Start over with different suggestion
6. Can iterate unlimited times

**FR-5.5: Version History**
- Track all iterations in session
- Show: Iteration 1 → Iteration 2 → Iteration 3 (timeline)
- Can jump back to any previous version
- Compare versions side-by-side
- Save particular versions as templates

**FR-5.6: Template Library**
- Save refined messages as reusable templates
- Categorize by:
  - Type (opener, response, date ask, etc.)
  - Tone
  - Platform
  - Custom tags
- Apply template to new conversation with auto-adjustment
- Edit templates (updates all uses)

**FR-5.7: Keyboard Shortcuts (Desktop)**
- Cmd/Ctrl + K: Keep selected text
- Cmd/Ctrl + E: Edit selected text  
- Cmd/Ctrl + R: Replace selected text
- Cmd/Ctrl + Enter: Regenerate
- Cmd/Ctrl + Z: Undo annotation

#### Non-Functional Requirements

**NFR-5.1: Real-time Collaboration Feel**
- Annotation UI feels instant (<50ms interaction)
- Visual feedback for all actions
- Smooth transitions between versions
- No jarring page reloads

**NFR-5.2: AI Understanding**
- Prompt engineering to handle complex multi-annotation instructions
- Preserve locked text 100% of the time
- Handle conflicting instructions gracefully (e.g., "make shorter" + "add more detail")

**NFR-5.3: Storage**
- Version history per session (cleared after 24h)
- Templates stored permanently per user
- Template sync across devices

#### Success Metrics
- Average refinement iterations per response (Target: 2-3)
- "Keep this" usage rate (Target: 60%+ of users)
- Template creation rate (Target: 30% of users create 1+ template)
- Template reuse rate (Target: 2+ uses per template)
- Time from first suggestion to final message (Target: <3 minutes)
- Refinement feature engagement (Target: 70% of users use it weekly)

#### Design Notes
- Intuitive highlighting interaction (like Google Docs comments)
- Clear visual distinction between locked/adjustable/replaced text
- Annotation menu appears near selected text (context menu)
- Mobile: Long-press to select, popup menu for actions
- Version timeline should be scannable at a glance
- Use color coding consistently (green=keep, yellow=adjust, etc.)

**This is your #1 differentiator from competitors. Make it feel magical.**

---

### Feature 6: Conversation Insights & Learning

**Priority:** P1 (Nice-to-Have for MVP, Critical for V2)

#### User Story
*"As a user improving over time, I need to understand what's working so I can communicate more effectively and build on successful patterns."*

#### Functional Requirements

**FR-6.1: Per-Conversation Analytics**

Displayed in Thread View context panel:

**Engagement Metrics:**
- **Reply Rate:** % of your messages that get responses
  - Calculation: (Their messages / Your messages) × 100
  - Visual: Progress bar with percentage
  - Benchmarking: "Above average" vs "Below average"

- **Response Time (Theirs):** How quickly they typically reply
  - Average: 2h 45m
  - Pattern: "Usually replies evenings"
  - Trend: Getting faster/slower/stable

- **Response Time (Yours):** Your average response speed
  - Shows if you're over-thinking or being too quick
  - Goal: Maintain 2-12 hour range (not desperate, not cold)

**Conversation Health:**
- **Depth Score (1-5):** Based on message length, topic diversity, questions asked
  - 5: Deep, substantive exchanges
  - 3: Casual but engaging
  - 1: One-word responses, dying out

- **Momentum Indicator:**
  - 🔥 Hot (daily exchanges, growing depth)
  - ↗️ Warming (increasing engagement)
  - → Stable (consistent but not escalating)
  - ↘️ Cooling (slower responses, shorter messages)
  - ❄️ Cold (needs intervention or let go)

**FR-6.2: "What Worked" Highlights**

System automatically detects:
- Messages that received fast, enthusiastic responses
- Topics that generated longest replies from them
- Questions that led to deep conversations
- Humor that landed (detected via response tone)
- Compliments that resonated

Display:
- Highlighted in thread (gold star icon)
- Summary list: "Top 3 effective moments"
- Patterns: "Asking about [their hobby] always gets strong responses"

**FR-6.3: Effectiveness Tracking**

**Optional User Feedback Loop:**
After each response sent, subtle prompt:
- "Did this lead to a reply?" → Yes / No / Too soon
- "Rate this exchange" → 1-5 stars
- "Did this conversation lead to a date?" → Yes / No / In progress

**Smart Timing:**
- Ask after 3-5 messages exchanged (not every time)
- Can disable prompts per conversation
- Aggregate data shows patterns

**FR-6.4: Cross-Conversation Insights**

Dashboard-level analytics (available to Pro users):

**Your Communication Patterns:**
- Most effective tone profiles (which get best results)
- Best time of day to message (based on response rates)
- Optimal message length (too short vs too long)
- Question frequency sweet spot
- Emoji usage correlation with engagement

**Learning Recommendations:**
- "Your thoughtful tone with Sarah is working well—consider using similar approach with Alex"
- "Conversations where you ask follow-up questions have 40% higher reply rates"
- "You tend to over-message on Sundays—response rates drop 25%"

**FR-6.5: Privacy & Transparency**

- All insights are private to user only
- Clearly explain how metrics are calculated
- Option to disable tracking per conversation
- No data sold or shared externally
- User can export all their data

#### Non-Functional Requirements

**NFR-6.1: Data Collection**
- Track message timestamps, lengths, response patterns
- NLP analysis for topic extraction
- Sentiment analysis for tone detection
- All processing happens securely

**NFR-6.2: Performance**
- Insights calculated async (not blocking user)
- Dashboard loads insights in <2 seconds
- Real-time updates as new messages added

#### Success Metrics
- Feedback submission rate (Target: 30% of users provide occasional feedback)
- Insights engagement rate (Target: 50% of users check insights weekly)
- Conversation improvement (Target: 15% increase in reply rates after 30 days)
- Feature perceived value (Target: Rated 4+/5 in user surveys)

#### Design Notes
- Insights should be encouraging, not discouraging
- Use positive framing ("What worked" not "What failed")
- Visualizations > numbers (progress bars, charts)
- Mobile: Swipeable insight cards
- Desktop: Dashboard with charts

---

## 7. User Flows

### 7.1 Primary Flow: First Response to Active Conversation

**Scenario:** User has imported a conversation with Sarah (Hinge), needs to respond to her latest message about hiking.

**Steps:**

1. **Dashboard Entry**
   - User opens ToneHone app
   - Dashboard loads showing 8 active conversations
   - Sarah's card shows "Needs Response" (red dot)
   - Last message preview: "I love hiking! What's your favorite trail?"
   - User taps Sarah's card

2. **Thread View Loads**
   - Full conversation history appears (12 messages total)
   - Right sidebar shows:
     - Sarah's profile (photo, bio: "Loves outdoors, coffee snob")
     - Current tone profile: "Playful & Flirty" (Playfulness: 7, Formality: 3)
     - Conversation health: 4/5 stars, Momentum: 🔥 Hot
   - User scrolls to see her latest message about hiking

3. **Generate Suggestions**
   - User taps "Get Suggestions" button
   - Loading animation (2 seconds)
   - 4 suggestions appear:

   **Option 1 (Safest):**
   "Oh nice! I've been meaning to explore more trails around here. Any recommendations for a beginner? 😊"
   - Match: 98% (very close to tone profile)
   - Why: Building on hiking topic, shows interest, asks question
   
   **Option 2 (More Forward):**
   "Love that! We should definitely hit a trail together sometime. I know a great spot with an awesome view at the top. Free this weekend? 🥾"
   - Match: 85% (more direct than usual tone)
   - Why: Escalating to date request, confident
   
   **Option 3 (Playful):**
   "Hiking?! And here I thought my toughest workout was walking to get coffee ☕ Teach me your ways, trail master! 😄"
   - Match: 95% (matches playful dimension)
   - Why: Self-deprecating humor, playful tone
   
   **Option 4 (Question-Focused):**
   "That's awesome! Are you a sunrise hike person or prefer afternoon adventures? I'm trying to figure out if we'd be compatible hiking buddies 😉"
   - Match: 92%
   - Why: Engaging question, slight flirtiness

4. **User Reviews Options**
   - Scrolls through 4 options
   - Likes Option 2's directness but thinks weekend is too soon
   - Option 4 feels right but wants to add personal detail
   - Taps "Refine" on Option 4

5. **Refinement Editor Opens**
   - Split view appears
   - Left: Original Option 4 text
   - Right: Editable version (starts identical)

6. **User Makes Edits**
   - Highlights "That's awesome!" → "Keep This" (likes opener)
   - Highlights "sunrise hike person or prefer afternoon" → "Adjust This"
     - Chooses "Make more specific"
     - Types instruction: "Reference that I usually hike Runyon Canyon in LA"
   - Highlights "figure out if we'd be compatible" → "Adjust This"
     - Chooses "Make it warmer"
   - Clicks "Regenerate with my edits"

7. **AI Refines (3 seconds)**
   - New version appears:
   "That's awesome! I usually do Runyon Canyon here in LA—are you more of a sunrise hike person or afternoon explorer? Either way, I have a feeling we'd make a great hiking team 😊"

8. **User Reviews Refinement**
   - Reads refined version
   - Feels authentic and right
   - Changes 😊 to 😉 (quick manual edit)
   - Satisfied

9. **Send / Save**
   - Taps "Copy to Clipboard"
   - Switches to Hinge app
   - Pastes message and sends
   - Returns to ToneHone
   - Taps "Add My Message" in thread
   - Pastes message into Thread View (for context tracking)
   - Message added to conversation history

10. **Optional Feedback**
    - 1 hour later, Sarah replies enthusiastically
    - Next time user opens thread, soft prompt appears:
      "Looks like Sarah replied! Did your message work well?"
      - User taps "Yes, great response"
    - System logs this success for learning

**Total Time:** ~90 seconds from opening app to copied message

---

### 7.2 Secondary Flow: Adding New Conversation via Screenshot

**Scenario:** User just matched with Jake on Bumble, wants to add conversation to ToneHone.

**Steps:**

1. **Dashboard → Add New**
   - User in Dashboard
   - Taps "+" button (floating action button)
   - Options appear:
     - 📸 Upload Screenshot
     - 📝 Paste Text
     - 👤 Create from Profile

2. **Upload Screenshot Selected**
   - User taps "Upload Screenshot"
   - Camera roll opens (iOS permission granted previously)
   - User selects screenshot of Bumble conversation with Jake (3 messages)

3. **Image Preview & Crop**
   - Screenshot appears with crop handles
   - User adjusts to include:
     - Jake's name and profile photo
     - All 3 messages clearly visible
   - Taps "Extract Conversation"

4. **OCR Processing**
   - Loading animation: "Reading conversation..." (3-5 seconds)
   - Extracted data appears for review:
     - Name: Jake
     - Platform: Bumble (detected from UI)
     - Messages:
       - Jake: "Hey! I saw you're into photography too—love your shots!"
       - You: "Thanks! Yeah I've been shooting for about 2 years. You?"
       - Jake: "Nice! I mostly do street photography. What got you into it?"

5. **Review & Correct**
   - User reviews extracted messages
   - All look correct
   - Taps "Looks Good"

6. **Profile Setup**
   - App prompts: "Tell me about Jake"
   - Optional fields:
     - Upload his profile photo (from camera roll)
     - Add bio notes (text field)
     - Link to Bumble profile (optional)
   - User uploads Jake's photo, skips rest
   - Taps "Continue"

7. **Tone Profile Setup**
   - App analyzes Jake's 2 messages
   - Suggests: "Based on Jake's friendly, curious tone, try 'Casual & Friendly'"
   - Shows preset:
     - Playfulness: 5
     - Formality: 2
     - Forwardness: 5
     - Expressiveness: 6
   - User accepts default
   - Taps "Create Conversation"

8. **Thread Created**
   - New conversation appears in Dashboard
   - Thread View opens automatically
   - 3 messages visible
   - Sidebar shows Jake's info and tone profile
   - "Get Suggestions" button ready

9. **Optional: Immediate Response**
   - User can immediately get suggestions for next reply
   - Or exit and come back later
   - Conversation now tracked in Dashboard

**Total Time:** ~60 seconds from screenshot to conversation created

---

### 7.3 Tertiary Flow: Adjusting Tone Profile Mid-Conversation

**Scenario:** User has been talking to Emma for 2 weeks. Conversation started playful but has evolved to deeper topics. User wants to adjust tone.

**Steps:**

1. **Notice Tone Shift**
   - User in Thread View with Emma
   - Scrolling through recent messages
   - Notices Emma sharing more personal stories, asking serious questions
   - Realizes playful tone feels off now

2. **Access Tone Profile**
   - Taps tone profile badge in sidebar: "Playful & Flirty"
   - Tone editor modal opens
   - Shows current settings:
     - Playfulness: 8
     - Formality: 3
     - Forwardness: 7
     - Expressiveness: 8

3. **Adjust Sliders**
   - User moves sliders:
     - Playfulness: 8 → 5 (less jokes, more substance)
     - Formality: 3 → 6 (more polished, serious topics warrant it)
     - Forwardness: 7 → 6 (maintain directness but softer)
     - Expressiveness: 8 → 6 (fewer exclamation marks, more measured)
   
4. **Preview Changes**
   - As sliders move, sample message updates in real-time:
   - Before: "Haha omg yes!! That sounds amazing! We should totally do that sometime! 😄"
   - After: "I really appreciate you sharing that with me. That experience sounds meaningful. I'd love to hear more about it."
   - User sees the difference clearly

5. **Name Profile**
   - App prompts: "Save this as a new profile?"
   - User taps "Yes"
   - Names it: "Thoughtful & Engaged"
   - Option to apply to other conversations (user skips)

6. **Save Changes**
   - Taps "Save Profile"
   - Confirmation: "Emma's tone updated to 'Thoughtful & Engaged'"
   - Modal closes

7. **Generate with New Tone**
   - User immediately taps "Get Suggestions"
   - New suggestions reflect updated tone:
     - More thoughtful, less playful
     - Proper grammar, fewer emojis
     - Substantive, emotionally aware
   - User sees the difference and feels good

8. **Historical Context**
   - Thread timeline shows: "Tone shift on [today's date]"
   - Past messages before shift still visible with old context
   - Future suggestions use new tone
   - Analytics will track if new tone improves or hurts engagement

**Total Time:** ~45 seconds to adjust tone

---

### 7.4 Edge Case Flow: Tone Mismatch Warning

**Scenario:** User has "Thoughtful & Deep" tone with Alex but tries to send a very playful message that doesn't match.

**Steps:**

1. **User Gets Suggestion**
   - In Thread View with Alex
   - Current tone: Thoughtful & Deep (Playfulness: 3)
   - User gets suggestions, picks one

2. **User Heavily Edits**
   - Refines message, adds lots of jokes and emojis
   - Final message: "Hahaha omg that's hilarious!! 😂😂 You're killing me! We should totally grab drinks and you can tell me more ridiculous stories! 🍻"
   - Taps "Copy to Clipboard"

3. **Mismatch Detected**
   - Before copying, app analyzes final message
   - Detects: Playfulness score of 9 (profile is 3)
   - Warning modal appears:
   
   **Title:** "Tone Check"
   **Message:** "This message feels much more playful than your usual thoughtful tone with Alex. Is this intentional?"
   
   **Analysis shown:**
   - Your profile: Playfulness 3/10
   - This message: Playfulness 9/10
   - Difference: 6 points (significant)
   
   **Options:**
   - **Send Anyway** (user knows what they're doing)
   - **Adjust Message** (open refiner to tone it down)
   - **Update Tone Profile** (maybe Alex conversation has evolved)
   - **Ignore for This Conversation** (disable warnings for Alex)

4. **User Decision Path A: Update Profile**
   - User realizes conversation HAS become more playful
   - Taps "Update Tone Profile"
   - Sliders appear, user adjusts Playfulness: 3 → 7
   - Saves
   - Mismatch warning disappears
   - Message copied successfully

5. **User Decision Path B: Adjust Message**
   - User thinks message is too much
   - Taps "Adjust Message"
   - Refiner opens with instruction: "Make this match your thoughtful tone"
   - AI generates toned-down version: "That's really funny! I'd love to hear more of those stories over coffee sometime. When are you free?"
   - User accepts
   - Copies adjusted version

6. **Learning**
   - System logs warning trigger and user action
   - If user frequently overrides, reduces warning sensitivity
   - If user often adjusts, keeps warnings active

**This prevents awkward tone shifts that might confuse matches.**

---

## 8. Technical Architecture

### 8.1 System Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     Client Layer                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   iOS App    │  │   Web App    │  │  Android (future)  │
│  │ React Native │  │    React     │  │  React Native │     │
│  │    (Expo)    │  │  (Next.js)   │  │               │     │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                            ↓↑ HTTPS/REST API
┌─────────────────────────────────────────────────────────────┐
│                     API Gateway Layer                        │
│                   (Express.js / Node.js)                     │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Auth      │  │  Rate Limit  │  │   Logging    │      │
│  │  Middleware │  │   Middleware │  │   Middleware │      │
│  └─────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                            ↓↑
┌─────────────────────────────────────────────────────────────┐
│                   Application Services                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ Conversation │  │     Tone     │  │   Insights   │      │
│  │   Service    │  │   Service    │  │   Service    │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  AI/LLM      │  │     OCR      │  │   Payment    │      │
│  │  Service     │  │   Service    │  │   Service    │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                            ↓↑
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  PostgreSQL  │  │    Redis     │  │   S3/Storage │      │
│  │  (Primary DB)│  │   (Cache)    │  │   (Images)   │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                            ↓↑
┌─────────────────────────────────────────────────────────────┐
│                   External Services                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Anthropic  │  │    Stripe    │  │   Sentry     │      │
│  │  Claude API  │  │   Payments   │  │   Monitoring │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│  ┌──────────────┐  ┌──────────────┐                         │
│  │ Google Vision│  │   SendGrid   │                         │
│  │     OCR      │  │    Email     │                         │
│  └──────────────┘  └──────────────┘                         │
└─────────────────────────────────────────────────────────────┘
```

### 8.2 Technology Stack

#### Frontend

**Mobile (iOS Primary, Android Future):**
- **Framework:** React Native (Expo SDK 50+)
- **Rationale:** Cross-platform code reuse, rapid iteration, strong community
- **Key Libraries:**
  - React Navigation for routing
  - React Query for data fetching/caching
  - Zustand for state management (lightweight)
  - React Native Gesture Handler for interactions
  - React Native Reanimated for smooth animations
  - Expo Image Picker for screenshot upload
  - Expo Secure Store for local auth tokens

**Web:**
- **Framework:** Next.js 14+ (React 18+)
- **Rationale:** SEO, server-side rendering for landing pages, React consistency with mobile
- **Key Libraries:**
  - TailwindCSS for styling (shared design system with mobile)
  - Radix UI for accessible components
  - React Query (same as mobile)
  - Zustand (same as mobile)

**Shared Code:**
- Business logic, API clients, utilities in shared packages
- Monorepo structure (Turborepo or Nx)

#### Backend

**API Server:**
- **Runtime:** Node.js 20+ (LTS)
- **Framework:** Express.js 4.x
- **Language:** TypeScript (type safety critical for complex domain)
- **Architecture:** Service-oriented, modular

**Key Libraries:**
- Prisma (ORM for PostgreSQL)
- Bull (job queue for async tasks)
- Winston (logging)
- Joi or Zod (request validation)
- Passport.js (authentication)
- Helmet (security headers)
- Express Rate Limit (API throttling)

#### Data Storage

**Primary Database:**
- **PostgreSQL 15+**
- **Rationale:** ACID compliance, JSONB for flexible data, proven reliability
- **Hosted:** Supabase or AWS RDS

**Schema highlights:**
```sql
-- Users
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  subscription_tier VARCHAR(50), -- free, pro
  credits_remaining INT DEFAULT 0
);

-- Conversations
CREATE TABLE conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  person_name VARCHAR(255),
  platform VARCHAR(50), -- hinge, bumble, tinder, other
  tone_profile JSONB, -- {playfulness: 7, formality: 3, ...}
  created_at TIMESTAMP DEFAULT NOW(),
  last_activity TIMESTAMP,
  archived BOOLEAN DEFAULT FALSE
);

-- Messages
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID REFERENCES conversations(id) ON DELETE CASCADE,
  speaker VARCHAR(10), -- 'user' or 'them'
  content TEXT NOT NULL,
  timestamp TIMESTAMP DEFAULT NOW(),
  source VARCHAR(20), -- 'manual', 'ocr', 'imported'
  metadata JSONB -- tone scores, effectiveness feedback, etc.
);

-- AI Generations (for tracking usage and learning)
CREATE TABLE ai_generations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  conversation_id UUID REFERENCES conversations(id),
  prompt_tokens INT,
  completion_tokens INT,
  model_used VARCHAR(50),
  tone_params JSONB,
  generated_options JSONB[], -- array of response options
  selected_option INT, -- which one user chose
  refinement_iterations INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Templates
CREATE TABLE templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  name VARCHAR(255),
  content TEXT,
  tone_profile JSONB,
  category VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW(),
  use_count INT DEFAULT 0
);
```

**Cache Layer:**
- **Redis 7+**
- **Use cases:**
  - Session management
  - Rate limiting data
  - Conversation context caching (reduce LLM costs)
  - Frequently accessed user preferences
- **Hosted:** Upstash (serverless Redis) or AWS ElastiCache

**Object Storage:**
- **AWS S3 or Cloudflare R2**
- **Use cases:**
  - Profile photos
  - Screenshot uploads (original + processed)
  - Exported conversation PDFs
- **CDN:** CloudFront or Cloudflare for fast image delivery

#### AI/ML Services

**Primary LLM:**
- **Anthropic Claude Sonnet 4** via API
- **Rationale:** Superior conversation understanding, tone control, safety
- **Fallback:** OpenAI GPT-4 Turbo (if Claude unavailable)

**OCR:**
- **Google Cloud Vision API**
- **Rationale:** Best accuracy for screenshot text extraction, handles varied image quality
- **Fallback:** Tesseract.js (open-source, lower quality)

**Embeddings (for semantic search, tone analysis):**
- **OpenAI text-embedding-3-small**
- **Use case:** Conversation similarity, tone vector representation

#### Infrastructure

**Hosting:**
- **Frontend:** Vercel (Next.js optimized) or Netlify
- **Backend API:** AWS EC2 / ECS or Render
- **Database:** Supabase (managed Postgres) or AWS RDS
- **Background Jobs:** AWS Lambda or separate worker instances

**Monitoring:**
- **Error Tracking:** Sentry
- **Logging:** Winston → CloudWatch or Datadog
- **Analytics:** PostHog (product analytics)
- **Uptime:** Better Uptime or Pingdom

**CI/CD:**
- **GitHub Actions** for automated testing and deployment
- **Environments:** Development, Staging, Production

#### Authentication & Payments

**Auth:**
- **Clerk.dev** or **Supabase Auth**
- **Rationale:** Handles OAuth, email/password, session management
- **Supported:** Email/password, Google OAuth, Apple Sign-In

**Payments:**
- **Stripe**
- **Features:**
  - Credit pack purchases
  - Subscription billing (Pro tier)
  - Usage tracking for credit deductions

### 8.3 API Design

**RESTful API Structure:**

```
Base URL: https://api.tonehone.ai/v1

# Authentication
POST   /auth/register
POST   /auth/login
POST   /auth/logout
POST   /auth/refresh

# Conversations
GET    /conversations                    # List user's conversations
POST   /conversations                    # Create new conversation
GET    /conversations/:id                # Get single conversation with messages
PATCH  /conversations/:id                # Update conversation (name, tone, etc.)
DELETE /conversations/:id                # Archive conversation
POST   /conversations/:id/messages       # Add message to conversation

# Tone Profiles
GET    /tone-profiles                    # Get preset profiles
POST   /tone-profiles                    # Save custom profile
GET    /conversations/:id/tone           # Get current tone for conversation
PATCH  /conversations/:id/tone           # Update tone for conversation

# AI Generation
POST   /ai/generate                      # Generate response suggestions
      Body: {
        conversation_id: uuid,
        tone_override: {...}, // optional
        quick_adjustments: ["funnier", "shorter"], // optional
        count: 3-5
      }
      Response: {
        suggestions: [{
          text: "...",
          tone_match: 95,
          reasoning: "...",
          id: uuid
        }]
      }

POST   /ai/refine                        # Iterative refinement
      Body: {
        suggestion_id: uuid,
        annotations: [{
          type: "keep" | "adjust" | "replace" | "delete",
          text: "highlighted text",
          instruction: "make more playful"
        }]
      }

# OCR
POST   /ocr/extract                      # Extract text from screenshot
      Multipart form with image file
      Response: {
        person_name: "Jake",
        platform: "bumble",
        messages: [{speaker, content, timestamp}],
        confidence: 0.95
      }

# Templates
GET    /templates                        # Get user's templates
POST   /templates                        # Save new template
GET    /templates/:id
PATCH  /templates/:id
DELETE /templates/:id

# Insights
GET    /conversations/:id/insights       # Get analytics for conversation
GET    /insights/dashboard                # Overall user analytics

# Credits & Billing
GET    /credits/balance                  # Get current credit balance
POST   /credits/purchase                 # Initiate credit purchase
GET    /billing/history                  # Transaction history
```

### 8.4 Security & Privacy

**Data Encryption:**
- All data encrypted at rest (PostgreSQL encryption)
- TLS 1.3 for data in transit
- Message content encrypted in database (separate encryption keys per user)

**Authentication:**
- JWT tokens with short expiry (15 min access, 7 day refresh)
- Secure HTTP-only cookies for web
- Expo Secure Store for mobile tokens

**Authorization:**
- Row-level security policies in PostgreSQL
- User can only access their own conversations
- API checks user_id on every request

**Privacy Commitments:**
- No conversation data used for marketing
- No data sold to third parties
- User can export all data (GDPR compliance)
- User can delete all data permanently

**Rate Limiting:**
- Per-endpoint limits (e.g., 10 AI generations/min)
- Overall API limit (1000 requests/hour per user)
- DDoS protection via Cloudflare

**Content Moderation:**
- Optional profanity filter
- NSFW content detection (if users opt-in)
- Report abuse mechanism

### 8.5 Performance Requirements

**API Response Times:**
- GET endpoints: <200ms (p95)
- POST endpoints (non-AI): <500ms (p95)
- AI generation: <3 seconds (p95)
- OCR extraction: <5 seconds (p95)

**App Performance:**
- Dashboard load: <1.5 seconds
- Thread view load: <2 seconds
- 60fps scroll on conversation list
- No jank on animations

**Scalability Targets:**
- Support 10,000 concurrent users
- 1M+ API requests per day
- 100K+ AI generations per day

**Caching Strategy:**
- Conversation context cached in Redis (30 min TTL)
- User profiles cached (1 hour TTL)
- Static assets via CDN (long cache)

---

## 9. Design Requirements

### 9.1 Visual Design Principles

**Brand Personality:**
- Sophisticated, not playful
- Clean, modern, minimal
- Trustworthy, professional
- Warm, approachable (not cold/corporate)

**Design Philosophy:**
- Form follows function—features drive design, not decoration
- Information hierarchy—most important things most visible
- Consistency—same patterns across app
- Accessibility—WCAG AA minimum

### 9.2 Design System

**Color Palette:**

*Primary Colors:*
- **Brand Primary:** Deep blue (#1E3A8A) - trust, intelligence
- **Brand Secondary:** Warm teal (#0891B2) - communication, connection
- **Accent:** Coral (#F97316) - energy, action (CTAs)

*Neutral Tones:*
- Background: Off-white (#FAFAFA)
- Surface: White (#FFFFFF)
- Text Primary: Near-black (#1F2937)
- Text Secondary: Medium gray (#6B7280)
- Borders: Light gray (#E5E7EB)

*Semantic Colors:*
- Success: Green (#10B981)
- Warning: Amber (#F59E0B)
- Error: Red (#EF4444)
- Info: Blue (#3B82F6)

**Typography:**
- **Primary Font:** Inter (clean, modern, excellent readability)
- **Headings:** Inter SemiBold/Bold
- **Body:** Inter Regular
- **Code/Monospace:** JetBrains Mono (for any technical displays)

**Tone Profile Colors (Consistent Coding):**
- Playful: Orange
- Thoughtful: Blue
- Direct: Red
- Casual: Green
- Professional: Purple

### 9.3 Component Library

**Core Components:**
- Buttons (primary, secondary, ghost, danger)
- Input fields (text, textarea, select)
- Cards (conversation card, suggestion card)
- Modals/Dialogs
- Toasts/Notifications
- Loading states (skeletons, spinners)
- Empty states (helpful, not sad)
- Error states (actionable, not blaming)

**Custom Components:**
- ConversationCard
- ToneSlider
- MessageBubble
- SuggestionOption
- RefinementEditor
- AnnotationMenu

**Mobile Design Guidelines:**
- Minimum touch target: 44x44pt (Apple HIG)
- Thumb-friendly zones for primary actions
- Bottom navigation for main sections
- Swipe gestures where natural (delete, archive)

**Responsive Breakpoints:**
- Mobile: <640px
- Tablet: 640-1024px
- Desktop: >1024px

### 9.4 Key Screen Mockup Requirements

**Dashboard:**
- Grid view (2 columns mobile, 3-4 desktop)
- Filters accessible without scrolling (sticky header)
- Quick action buttons on conversation cards
- Empty state: Helpful onboarding ("Add your first conversation")

**Thread View:**
- Chat UI familiar to users (iMessage-style)
- Sidebar on desktop (right side), bottom sheet on mobile
- "Get Suggestions" button prominent and accessible
- Clear visual separation between messages and suggestions

**Refinement Editor:**
- Split-pane design (before/after)
- Annotation UI intuitive (highlight → popup menu)
- Version history accessible but not intrusive
- Mobile: Single pane with toggle between original/refined

**Tone Profile Editor:**
- Sliders large enough for precise control
- Real-time preview critical
- Visual representation (radar chart) helps understanding
- Preset cards visually distinct

---

## 10. Monetization Strategy

### 10.1 Pricing Model

**Free Tier:**
- **Purpose:** Acquisition funnel, let users experience value
- **Limits:**
  - 3 conversations maximum
  - 20 AI suggestions per month
  - Basic tone profiles (presets only, no customization)
  - No conversation insights/analytics
  - Screenshot OCR: 5 per month
- **Conversion Goal:** 15% of free users upgrade within 30 days

**Credit Packs (Pay-as-you-go):**
- **Target:** Users who want flexibility, occasional users
- **Pricing:**
  - **Starter:** 100 credits = $9.99 ($0.10/credit)
  - **Popular:** 300 credits = $24.99 ($0.083/credit, 17% savings)
  - **Power:** 1000 credits = $69.99 ($0.070/credit, 30% savings)
- **Credit Costs:**
  - AI suggestion generation (3-5 options): 1 credit
  - Refinement iteration: 0.5 credits
  - Screenshot OCR: 2 credits
  - Template save: Free
  - Conversation creation: Free
- **Never Expire:** Credits roll over indefinitely
- **Add-on option:** Users can buy more anytime

**Pro Subscription:**
- **Price:** $39/month or $349/year (25% savings)
- **Target:** Power users, serious daters
- **Benefits:**
  - **Unlimited conversations**
  - **Unlimited AI suggestions & refinements**
  - **Unlimited OCR**
  - Advanced tone customization (save unlimited custom profiles)
  - Conversation insights & analytics
  - Priority AI generation (faster response times)
  - Export conversations (PDF, text)
  - Early access to new features
  - Email support (48-hour response)
- **Conversion Goal:** 30% of paid users choose Pro

### 10.2 Revenue Projections (Year 1)

**Assumptions:**
- Launch Month 1 with MVP
- 500 users Month 1 → 10,000 users Month 12 (viral growth + paid ads)
- 15% free → paid conversion rate
- 70% choose credits, 30% choose Pro subscription
- Average credit pack buyer: $25/month (buys 300-pack every 6 weeks)
- Churn: 20% monthly for credit users, 5% monthly for Pro

**Month 12 Targets:**
- Total users: 10,000
- Paid users: 1,500 (15% conversion)
  - Credit buyers: 1,050 (70%)
  - Pro subscribers: 450 (30%)

**Monthly Revenue (Month 12):**
- Credit sales: 1,050 users × $25 = $26,250
- Pro subscriptions: 450 users × $39 = $17,550
- **Total MRR:** $43,800
- **ARR:** $525,600

**Year 1 Total Revenue:** ~$336,000 (ramping up)

### 10.3 Unit Economics

**Cost per User (Monthly):**
- AI API costs (Claude): $2-4 per active user (varies by usage)
- OCR (Google Vision): $0.50-1 per active user
- Infrastructure (database, hosting): $0.30 per user
- Payment processing (Stripe): 2.9% + $0.30 per transaction
- **Total COGS:** ~$4-6 per active paid user

**Gross Margin:**
- Credit pack buyer: $25 revenue - $5 costs = $20 profit (80% margin)
- Pro subscriber: $39 revenue - $6 costs = $33 profit (85% margin)
- **Blended margin: 92%+ (typical for SaaS)**

**Customer Acquisition Cost (CAC) Target:**
- Organic (SEO, Reddit, Product Hunt): $0-5
- Paid ads (Meta, TikTok): $20-40
- **Blended CAC goal: <$25**

**Lifetime Value (LTV):**
- Credit buyer: $25/month × 6 months avg = $150
- Pro subscriber: $39/month × 12 months avg = $468
- **Blended LTV: ~$250**

**LTV:CAC Ratio:** 10:1 (excellent, sustainable growth)

### 10.4 Monetization Psychology

**Why credits work:**
- Lower commitment than subscription
- Users can control spending
- Feels fair (pay for what you use)
- Gamification (watching balance)

**Why some choose Pro:**
- Unlimited = peace of mind
- Status (power users love "Pro" badge)
- Analytics justify cost ("This helped me get 3 dates")
- Annual option = committed relationship seekers

**Upsell Triggers:**
- Credit balance low → "Upgrade to Pro for unlimited"
- Using insights feature → "Get advanced analytics with Pro"
- Hitting conversation limit → "Unlock unlimited with Pro"
- Heavy user (>50 credits/month) → "Pro would save you money"

### 10.5 Alternative Revenue Streams (Future)

**Premium Features (À la carte):**
- Advanced voice tone analysis: $4.99/month add-on
- Priority support: $9.99/month
- Team/Coach mode (for dating coaches): $99/month

**B2B:**
- Dating coach SaaS: $199/month for coaches to manage client conversations
- Relationship therapist tools: Similar pricing

**Affiliate Revenue:**
- Partner with dating apps (premium referrals)
- Dating advice courses/books (commission)

**Data Insights (Anonymized, Aggregated):**
- "State of Online Dating Communication" annual report
- Sell anonymized, aggregated insights to dating platforms
- **Ethical constraint:** Only if users opt-in explicitly

---

## 11. Success Metrics

### 11.1 North Star Metric

**Primary NSM:** Weekly Active Conversations Managed
- Measures actual value delivery (users managing relationships)
- Leading indicator of retention and revenue
- Target: 8+ conversations per active user

**Why this metric:**
- User managing 8+ conversations = core value prop validated
- Correlates with subscription intent (power users)
- Indicates stickiness (invested in platform)

### 11.2 Acquisition Metrics

**Top of Funnel:**
- Website visitors per month
- App Store page views
- Conversion rate: Visitor → Sign-up (Target: 10-15%)

**Sign-up Metrics:**
- New users per week (Target Month 1: 100, Month 12: 2,000)
- Sign-up source breakdown (organic vs paid)
- Cost per acquisition (CPA)

**Activation:**
- % users who complete onboarding (Target: 70%+)
- % users who add first conversation (Target: 60%+)
- % users who generate first AI suggestion (Target: 50%+)
- Time to first value (Target: <5 minutes)

### 11.3 Engagement Metrics

**Daily Active Usage:**
- Daily Active Users (DAU) (Target: 30% of total users)
- Sessions per user per day (Target: 2-3)
- Time spent in app per session (Target: 5-10 minutes)

**Feature Engagement:**
- Dashboard visits per week (Target: 5+)
- AI suggestions generated per user per week (Target: 10+)
- Refinement editor usage rate (Target: 70% of users)
- Tone profile adjustments per conversation (Target: 1-2 over lifetime)
- Template creation rate (Target: 30% create 1+ template)

**Content Quality:**
- Suggestions accepted without editing (Target: 30-40%)
- Suggestions refined and used (Target: 50%)
- User feedback ratings (Target: 4+ stars average)

### 11.4 Retention Metrics

**Short-term Retention:**
- Day 1 retention (Target: 60%)
- Day 7 retention (Target: 40%)
- Day 30 retention (Target: 25%)

**Long-term Retention:**
- Month 3 retention (Target: 15%)
- Month 6 retention (Target: 10%)

**Cohort Analysis:**
- Track retention by cohort (month signed up)
- Identify which acquisition channels have best retention
- Monitor retention by feature usage patterns

**Churn Metrics:**
- Monthly churn rate (Target: <20% for credit users, <5% for Pro)
- Churn reasons (exit survey)
- Reactivation rate (users who return after churning)

### 11.5 Revenue Metrics

**Conversion:**
- Free → Paid conversion rate (Target: 15% within 30 days)
- Credit buyer → Pro upgrade rate (Target: 20% within 6 months)
- Average time to first purchase (Target: <14 days)

**Revenue:**
- Monthly Recurring Revenue (MRR)
- Annual Recurring Revenue (ARR)
- Average Revenue Per User (ARPU) (Target: $28/month)
- Average Revenue Per Paying User (ARPPU) (Target: $32/month)

**Customer Value:**
- Customer Lifetime Value (LTV) (Target: $250+)
- LTV:CAC ratio (Target: >3:1, ideal: 10:1)
- Gross margin per user (Target: 85%+)

**Expansion Revenue:**
- % of credit buyers who upgrade pack size
- % of monthly Pro who convert to annual
- Upsell revenue (additional features)

### 11.6 Product Quality Metrics

**Technical Performance:**
- API response time p95 (Target: <500ms non-AI, <3s AI)
- App crash rate (Target: <0.1%)
- Error rate (Target: <1% of requests)
- Uptime (Target: 99.9%)

**AI Quality:**
- Suggestion relevance score (user ratings)
- Tone match accuracy (% within 10% of profile)
- Refinement iteration average (Target: 2-3)
- OCR accuracy (Target: 95%+)

**User Satisfaction:**
- Net Promoter Score (NPS) (Target: 40+)
- Customer Satisfaction (CSAT) (Target: 4.5+/5)
- Support ticket volume (Target: <5% of users)
- App Store rating (Target: 4.5+ stars)

### 11.7 Behavioral Insights (Qualitative)

**User Interviews:**
- Monthly interviews with 10 power users
- Understand use cases, pain points, delights
- Feature request prioritization

**Session Recordings:**
- Watch real user sessions (with permission)
- Identify UX friction points
- Understand actual workflows vs intended

**Funnel Analysis:**
- Where do users drop off in onboarding?
- What prevents free users from upgrading?
- Why do users churn?

### 11.8 Competitive Metrics

**Market Position:**
- App Store ranking in Lifestyle category
- Keyword search rankings (SEO)
- Social media mentions vs competitors
- Brand awareness (survey)

**Feature Parity:**
- % of competitor features we match
- Unique features only we have
- User preference in A/B tests (our app vs competitor screenshots)

---

## 12. Competitive Differentiation

### 12.1 Differentiation Matrix

| Feature / Capability | Rizz | YourMove AI | Keys AI | PlugAI | Social Wizard | **ToneHone** |
|---------------------|------|-------------|---------|--------|---------------|--------------|
| **Multi-conversation dashboard** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ **Unique** |
| **Per-person tone profiles** | ❌ | ❌ | Basic | ❌ | 10 generic | ✅ **Advanced (4D custom)** |
| **Iterative refinement editor** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ **Unique** |
| **Unlimited conversation history** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Relationship insights & analytics** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Context persistence across sessions** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Template library** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Tone mismatch warnings** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ **Unique** |
| **Screenshot OCR** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Multiple AI suggestions** | ✅ 3 | ✅ 3 | ✅ | ✅ | ✅ | ✅ 3-5 |
| **Response generation speed** | ~5s | <5s | ~3s | ~5s | ~5s | <3s target |
| **Pricing** | $20/mo | $24.99/mo | $39.99/mo | $19.99/mo | $19.99/mo | **$39/mo Pro or Credits** |
| **Positioning** | Playful pickup | Speed dating | Premium coach | Technical tool | Social anxiety | **Sophisticated orchestrator** |
| **Target demographic** | Gen Z | All | 30+ | Tech-savvy | Neurodiverse | **25-40, professional** |
| **Brand personality** | Fun, casual | Efficient, direct | Mature, supportive | Minimal, technical | Magical, playful | **Sophisticated, intentional** |

### 12.2 Our Unique Value Propositions

**1. Only App for Multi-Conversation Orchestration**
- **What:** Manage 5-10 conversations from single dashboard with full context
- **Why it matters:** Dating app users juggle multiple conversations—we're the only ones solving this
- **Competitor gap:** Everyone does screenshot → response. Nobody does portfolio management.

**2. Most Sophisticated Tone Calibration**
- **What:** 4-dimensional tone profiles per person with real-time calibration
- **Why it matters:** Different relationships need different tones—we maintain authenticity across contexts
- **Competitor gap:** Social Wizard has 10 presets. We have infinite custom combinations.

**3. Only Iterative Refinement Workflow**
- **What:** Collaborative editing with "keep this, adjust that" inline annotations
- **Why it matters:** AI rarely gets it perfect first try—we make refinement fast and intuitive
- **Competitor gap:** Everyone else is one-shot generation. We're iterative co-creation.

**4. Only Relationship-Stage Awareness**
- **What:** Track conversation health, momentum, what worked before
- **Why it matters:** Dating is a journey from match to date—we support the entire arc
- **Competitor gap:** Competitors focus on pickups. We focus on building relationships.

**5. Premium Positioning with Justified Price**
- **What:** $39/mo with genuinely advanced features, not just ChatGPT wrapper
- **Why it matters:** Sophisticated users will pay for sophisticated tools
- **Competitor gap:** Most apps race to bottom on price. We race to top on value.

### 12.3 Defensibility & Moat

**Short-term (6-12 months):**
- **Data moat:** User-trained tone profiles and conversation effectiveness data
- **UX moat:** Refinement editor workflow is complex to clone well
- **Brand moat:** "ToneHone" becomes verb ("I ToneHone'd my messages")

**Medium-term (1-2 years):**
- **Network effects:** Templates shared between power users
- **Learning moat:** AI improves based on aggregated user refinement patterns
- **Community moat:** Pro users become advocates (NPS >50)

**Long-term (2+ years):**
- **Platform moat:** Become THE conversation intelligence platform
- **Integration moat:** Partner with dating apps for native integration (if possible)
- **Data moat:** Proprietary "what works" insights no one else has

**What's NOT defensible:**
- Basic AI response generation (anyone can call Claude API)
- Screenshot OCR (commodity tech)
- Individual features in isolation

**What IS defensible:**
- The combination of features (orchestration + calibration + refinement)
- User data and learning over time
- UX workflows refined through user testing
- Brand association with sophistication

---

## 13. Development Roadmap

### 13.1 Phase 1: MVP (Months 1-3, 10-12 weeks)

**Goal:** Ship core value proposition to first 100 beta users.

**Week 1-2: Foundation**
- Set up development environment (Expo, Next.js monorepo)
- Backend scaffolding (Express, PostgreSQL, authentication)
- Design system foundations (colors, typography, core components)
- Database schema finalized
- CI/CD pipeline configured

**Week 3-5: Core Features**
- Conversation Hub (dashboard) - basic grid view
- Thread View with message display
- Screenshot upload + OCR integration (Google Vision API)
- Manual message addition
- Basic conversation CRUD

**Week 6-8: AI Integration**
- Anthropic Claude API integration
- AI suggestion generation (3 options)
- Tone profile system (5 presets, sliders)
- Apply tone to AI prompts
- Basic refinement (regenerate all)

**Week 9-10: Polish & Testing**
- Iterative refinement editor (MVP version: simple adjustments)
- Template saving (basic)
- Credit system integration (Stripe)
- Beta user onboarding flow
- Bug fixes from internal testing

**Week 11-12: Beta Launch**
- TestFlight beta (iOS)
- Web beta (limited access)
- Gather initial feedback
- Iterate on critical UX issues
- Prepare for public launch

**MVP Features Shipped:**
- ✅ Conversation Hub (basic)
- ✅ Thread View with OCR
- ✅ Tone profiles (presets + basic customization)
- ✅ AI suggestions (3 options)
- ✅ Basic refinement (regenerate)
- ✅ Credit system
- ✅ Template saving

**NOT in MVP:**
- Advanced refinement editor (inline annotations)
- Conversation insights/analytics
- Tone mismatch warnings
- Complex dashboard filters
- Template categories/search

### 13.2 Phase 2: Differentiation (Months 4-6, 12 weeks)

**Goal:** Build the features that make us unique. Target: 1,000 users, 15% paid conversion.

**Month 4: Advanced Refinement**
- Full inline annotation system ("keep this", "adjust this")
- Version history tracking
- Side-by-side editor view
- Keyboard shortcuts (desktop)
- Mobile refinement UX optimization

**Month 5: Intelligence & Insights**
- Conversation health scoring
- Engagement metrics (reply rate, response time)
- "What worked" highlights
- Optional effectiveness feedback loop
- Dashboard analytics (aggregate view)

**Month 6: Polish & Power Features**
- Template library with categories
- Advanced tone customization (save unlimited profiles)
- Tone mismatch warnings
- Conversation export (PDF, text)
- Performance optimization
- App Store submission (if not done yet)

**Features Shipped by End of Phase 2:**
- ✅ Advanced iterative refinement (killer feature)
- ✅ Conversation insights & analytics
- ✅ Template library with search
- ✅ Tone mismatch warnings
- ✅ Export functionality
- ✅ Pro subscription tier

### 13.3 Phase 3: Scale & Optimize (Months 7-12)

**Goal:** Scale to 10,000 users, optimize conversion and retention.

**Month 7-8: Growth & Optimization**
- A/B testing framework
- Onboarding optimization
- Pricing experiments
- Referral program
- Marketing website improvements

**Month 9-10: Platform Expansion**
- Android app (React Native already cross-platform)
- Browser extension (quick access)
- Desktop app (Electron wrapper)
- API for third-party integrations

**Month 11-12: Advanced Features**
- Voice tone analysis (optional add-on)
- Team/Coach mode (for dating coaches)
- AI learns from user edit patterns (personalization)
- Advanced conversation threading (group conversations by person)
- Relationship stage detection automation

**Features Shipped by End of Year 1:**
- ✅ All MVP features polished
- ✅ All differentiation features
- ✅ Android app
- ✅ Browser extension
- ✅ Coach mode
- ✅ Advanced personalization

### 13.4 Post-Launch Priorities (Ongoing)

**Always Be Doing:**
- User research (weekly interviews)
- Bug fixing (24-hour critical, 1-week minor)
- Performance monitoring (Sentry alerts)
- Customer support (48-hour response)
- Content marketing (weekly blog posts)

**Quarterly Reviews:**
- Feature prioritization based on user feedback
- Pricing optimization
- Competitive analysis
- Technical debt paydown
- Team retrospectives

---

## 14. Go-to-Market Strategy

### 14.1 Pre-Launch (Month 0-1)

**Goals:**
- Build waitlist of 500+ interested users
- Create brand awareness
- Validate positioning

**Tactics:**

**Landing Page:**
- Clean, sophisticated design (matches brand)
- Clear value prop: "Hone your tone for every connection"
- Email capture with waitlist
- Early bird discount (20% off first year)

**Content Marketing:**
- Blog posts:
  - "Why Dating Apps Are Exhausting (And What We're Building)"
  - "The Art of Multi-Conversation Management"
  - "5 Reasons Generic AI Doesn't Work for Dating"
- Reddit posts (r/Tinder, r/Bumble, r/hingeapp):
  - Authentic, helpful, not salesy
  - "I'm building a tool to solve X, would this help you?"
- Twitter/X threads:
  - Share development journey
  - Tease features
  - Build in public

**Community Building:**
- Private Discord for beta testers
- Early access for first 100 sign-ups
- Feedback loop with potential users

### 14.2 Launch (Month 1-3)

**Goals:**
- 500 users Month 1
- 50 paid users (10% conversion)
- Product Hunt top 5 in category

**Launch Channels:**

**Product Hunt:**
- Prepare compelling demo video (90 seconds)
- Screenshots of killer features (refinement editor)
- Clear differentiation from competitors
- Coordinate launch with maker community
- Target: #1 Product of the Day, top 5 of week

**App Store Optimization (ASO):**
- Keywords: conversation assistant, dating helper, tone refinement
- Screenshots showcasing dashboard, tone profiles, refinement
- Video preview (15 seconds, autoplay)
- Description emphasizing sophistication

**Press Outreach:**
- Tech media: TechCrunch, The Verge, Wired (AI tools angle)
- Dating media: Bustle, Elite Daily, Dating News (relationship angle)
- Press kit with founder story, screenshots, beta user testimonials

**Influencer Partnerships:**
- Dating coaches (50K+ followers) for authentic reviews
- Relationship therapists (credibility)
- Tech YouTubers (demo walkthrough)
- Avoid pickup artist types (off-brand)

### 14.3 Growth (Month 3-12)

**Goals:**
- 10,000 users by Month 12
- 15% free → paid conversion
- Organic + paid growth mix

**Organic Channels:**

**SEO & Content:**
- Blog targeting long-tail keywords:
  - "How to manage multiple dating conversations"
  - "Best AI tools for Hinge messages"
  - "Dating conversation tips for introverts"
- Guest posts on dating advice sites
- Podcast appearances (dating + tech podcasts)

**Social Media:**
- TikTok (short demos, before/after message examples)
- Instagram (carousel posts, tips, user testimonials)
- Twitter/X (thought leadership on AI + dating)
- Reddit (genuine community participation, not spam)

**Community & Word of Mouth:**
- Referral program: Give 50 credits, get 50 credits
- Power user testimonials prominently featured
- Case studies: "How Sarah went from ghosted to 5 dates in a month"

**Paid Channels:**

**Meta Ads (Facebook/Instagram):**
- Target: 25-40, active on dating apps, interests in self-improvement
- Creative: Before/after message screenshots, dashboard demo
- Landing page: Free tier sign-up (low friction)
- CPA target: <$25

**TikTok Ads:**
- Short, native-feeling videos
- "POV: You're managing 8 Hinge conversations"
- CPA target: <$30

**Google Search Ads:**
- Keywords: dating conversation helper, AI dating assistant
- Competitors' brand names (Rizz, YourMove AI, etc.)
- CPC target: <$3

**Reddit Ads:**
- Subreddit targeting (r/Tinder, r/dating_advice)
- Native ad format (promoted post)
- CPA target: <$20

### 14.4 Positioning & Messaging

**Brand Positioning Statement:**
"For sophisticated daters managing multiple conversations who want authentic connection over quick tricks, ToneHone is the conversation intelligence platform that helps you hone the perfect tone for every relationship. Unlike basic dating assistants that generate one-size-fits-all pickup lines, ToneHone maintains conversation continuity across your entire dating portfolio while keeping your authentic voice."

**Key Messages:**

*Primary Message:*
"Stop juggling conversations. Start building connections."

*Supporting Messages:*
- "Your voice, refined for every relationship"
- "Manage 10 conversations as easily as one"
- "Different people deserve different tones"
- "Iterate until it's perfect, not just good enough"

**Messaging by Channel:**

*TikTok/Instagram (Casual, visual):*
- "POV: Managing 8 dating convos without losing your mind"
- Show dashboard → tone profiles → refined message → date

*Reddit (Authentic, helpful):*
- "Dating app fatigue is real. Here's how I'm solving it."
- Focus on problem → solution, not hype

*App Store (SEO-optimized, benefit-focused):*
- "Conversation Intelligence for Dating Apps"
- Emphasize multi-conversation management, tone calibration

*Press (Unique angle, newsworthy):*
- "Not another pickup line generator—this AI helps you manage relationship portfolios"
- Data angle: "Study shows users juggle average of 7 simultaneous dating conversations"

### 14.5 Partnerships

**Dating Coaches:**
- Offer Pro accounts for free in exchange for:
  - Reviews/testimonials
  - Social media mentions
  - Webinar partnerships
- Develop "Coach Mode" feature for them to use with clients

**Relationship Therapists:**
- Credibility partnership (not revenue)
- Advisory board for ethical dating communication
- Co-branded content on healthy communication

**Dating Apps (Long-term):**
- Explore partnership opportunities:
  - White-label solution for Hinge/Bumble
  - Affiliate revenue (premium referrals)
- Unlikely short-term (they see us as threat), possible long-term

---

## 15. Risk Assessment

### 15.1 Market Risks

**Risk 1: Market Saturation**
- **Description:** 55+ competitors, users may be fatigued by dating AI tools
- **Likelihood:** Medium
- **Impact:** High
- **Mitigation:**
  - Differentiate clearly (multi-conversation focus)
  - Premium positioning (not another cheap tool)
  - Emphasize what competitors don't do
- **Contingency:** Pivot to coaching/therapy tools if dating saturated

**Risk 2: Dating App API Restrictions**
- **Description:** Dating apps actively prevent third-party integrations
- **Likelihood:** High (already true)
- **Impact:** Medium
- **Mitigation:**
  - Manual import workflow (screenshot/paste)
  - Make manual import seamless and fast
  - Focus on value beyond integration
- **Contingency:** Already designed around this limitation

**Risk 3: User Perception (Manipulation)**
- **Description:** Users feel "weird" about AI helping with dating
- **Likelihood:** Medium
- **Impact:** High
- **Mitigation:**
  - Position as "communication enhancement" not "manipulation"
  - Emphasize authenticity ("YOUR voice, refined")
  - Testimonials from happy couples who met using tool
  - Transparency about AI usage
- **Contingency:** Reposition as general communication coach (professional, social, family)

### 15.2 Product Risks

**Risk 4: AI Quality/Reliability**
- **Description:** Claude API generates poor suggestions, users lose trust
- **Likelihood:** Low-Medium
- **Impact:** High
- **Mitigation:**
  - Extensive prompt engineering and testing
  - User feedback loop to improve prompts
  - Fallback to GPT-4 if Claude fails
  - Multiple options per generation (increases hit rate)
- **Contingency:** Human-in-loop moderation, pre-approved response library

**Risk 5: OCR Accuracy**
- **Description:** Screenshot text extraction fails frequently
- **Likelihood:** Medium
- **Impact:** Medium
- **Mitigation:**
  - Google Vision API (95%+ accuracy in testing)
  - Manual review/edit step before committing
  - User education on taking clear screenshots
  - Fallback to manual text paste always available
- **Contingency:** Emphasize manual paste, de-emphasize OCR

**Risk 6: App Store Rejection**
- **Description:** Apple rejects app under "design spam" guidelines
- **Likelihood:** Medium-High (dating category is heavily scrutinized)
- **Impact:** Very High (blocks iOS launch)
- **Mitigation:**
  - Position as "communication coach" not "dating app"
  - Emphasize unique features (not ChatGPT wrapper)
  - Include non-dating use cases in submission
  - Prepare 3-6 months for approval process
  - Web app as primary, iOS as secondary
- **Contingency:**
  - Launch web-only first
  - Build traction, resubmit with user testimonials
  - Progressive Web App (PWA) for mobile without App Store

### 15.3 Business Risks

**Risk 7: Low Conversion Rate (Free → Paid)**
- **Description:** Users love free tier, never upgrade
- **Likelihood:** Medium
- **Impact:** High
- **Mitigation:**
  - Generous free tier but clear limits (3 conversations, 20 suggestions)
  - Show value of Pro features prominently
  - Trial period for Pro (7 days free)
  - In-app messaging when hitting limits
- **Contingency:**
  - Tighten free tier (2 conversations, 10 suggestions)
  - Introduce freemium features (ads for free users)
  - Charge per conversation above limit

**Risk 8: High Churn**
- **Description:** Users get dates quickly and stop using app
- **Likelihood:** Medium-High
- **Impact:** High
- **Mitigation:**
  - Support entire relationship journey (not just pickups)
  - Add features for established relationships
  - Celebration moments ("You got a date! Keep using for next match")
  - Multiple use cases (professional, social)
- **Contingency:**
  - Focus on serial daters (always active)
  - Expand to general communication coaching
  - Introduce annual plans (lock-in)

**Risk 9: AI Cost Explosion**
- **Description:** Claude API costs eat all margins as users scale
- **Likelihood:** Medium
- **Impact:** High
- **Mitigation:**
  - Credit system controls usage (users pay for what they use)
  - Caching conversation context (reduce tokens)
  - Prompt optimization for efficiency
  - Rate limiting per user
  - Monitor cost-per-user closely
- **Contingency:**
  - Switch to cheaper models for some features
  - Increase prices
  - Hard limits on API calls per user per day

### 15.4 Technical Risks

**Risk 10: Scalability Issues**
- **Description:** Infrastructure can't handle 10K concurrent users
- **Likelihood:** Low-Medium
- **Impact:** Medium
- **Mitigation:**
  - Cloud infrastructure (auto-scaling)
  - Load testing before major launches
  - Database optimization (indexing, caching)
  - CDN for static assets
- **Contingency:**
  - Temporary waitlist during traffic spikes
  - Add server capacity quickly (AWS elasticity)

**Risk 11: Data Breach**
- **Description:** Conversation data leaked, massive privacy violation
- **Likelihood:** Low
- **Impact:** Catastrophic
- **Mitigation:**
  - Encryption at rest and in transit
  - Regular security audits
  - Bug bounty program
  - Minimal data retention (auto-delete old conversations)
  - Compliance with GDPR, CCPA
  - Cyber insurance
- **Contingency:**
  - Incident response plan ready
  - Transparent communication if breach occurs
  - Offer credit monitoring to affected users
  - Learn from Chattee's 43M message leak—don't be them

### 15.5 Competitive Risks

**Risk 12: Rizz/YourMove Clones Our Features**
- **Description:** Market leader sees our differentiation, copies it fast
- **Likelihood:** Medium-High (if we succeed)
- **Impact:** Medium
- **Mitigation:**
  - Move fast, build moat through data and UX quality
  - Patent/trademark key innovations if possible
  - Focus on brand loyalty (ToneHone becomes verb)
  - Continuous innovation (always 6 months ahead)
- **Contingency:**
  - Double down on features they can't copy (insights, learning)
  - Premium positioning (they can copy features, not brand perception)

**Risk 13: Dating Apps Build Native Solution**
- **Description:** Hinge/Bumble adds AI response generator natively
- **Likelihood:** Medium (they're exploring AI)
- **Impact:** Very High
- **Mitigation:**
  - Multi-platform value (we work across Hinge, Bumble, Tinder)
  - Superior features (they'll ship basic, we ship advanced)
  - Become essential before they ship (user lock-in)
- **Contingency:**
  - Partner with them (white-label solution)
  - Pivot to relationship maintenance (beyond first contact)
  - Expand to non-dating communication

---

## 16. Appendix

### 16.1 User Research Summary

**Key Findings from 50 Dating App User Interviews:**

**Pain Points (Ranked by Frequency):**
1. **Context overload (82%):** "I forget who I've told what"
2. **Decision fatigue (78%):** "It takes me 10 minutes to write one message"
3. **Tone inconsistency (64%):** "I accidentally send the wrong vibe"
4. **Response anxiety (58%):** "I'm afraid of saying the wrong thing"
5. **Time pressure (56%):** "Dating apps feel like a part-time job"

**Willingness to Pay:**
- $10-20/month: 45%
- $20-40/month: 32%
- $40+/month: 12%
- Would not pay: 11%

**Feature Desirability (% "Very Interested"):**
- Multi-conversation dashboard: 89%
- Tone calibration per person: 76%
- Iterative refinement: 71%
- Conversation insights: 68%
- Template library: 54%

**Concerns About AI Dating Tools:**
- "Feels inauthentic" (62%)
- "Other person will know" (48%)
- "AI won't understand nuance" (44%)
- "Privacy/data concerns" (38%)

### 16.2 Competitive Research Details

**Detailed Analysis of Top 5 Competitors:**

**Rizz:**
- Launched December 2022
- 7.5M+ downloads (claimed)
- $190K-500K monthly revenue (estimated from various sources)
- Viral TikTok growth ($50 per account)
- Monetization: $7/week or $20/month subscription
- Key features: Screenshot upload, AI responses, "adapts to your style"
- Weakness: No multi-conversation management, no advanced tone control

**YourMove AI:**
- 300K+ users (claimed)
- 20% MoM growth (claimed)
- Emphasizes speed ("5 seconds or less")
- Profile photo review feature
- Monetization: Credit-based
- Key features: Fast generation, profile optimization
- Weakness: Speed over quality, no relationship continuity

**Keys AI:**
- "Original screenshot analyzer"
- Premium positioning: $39.99/month
- Mission-driven (connection, happiness)
- Coach positioning, not pickup
- Privacy emphasis
- Key features: Works everywhere, coaching tone
- Weakness: Still single-shot responses, no orchestration

**PlugAI:**
- Created by Blake Anderson (23), part of $11M portfolio
- Technical positioning
- Minimal marketing, feature-focused
- Key features: Screenshot, pickup lines, dating advice chat
- Weakness: Generic, no differentiation

**Social Wizard:**
- £1M ARR (reported)
- Targets social anxiety/autism niche
- 220K downloads, 85M hints generated
- 10 tonalities (generic presets)
- Key features: Social situations beyond dating
- Weakness: Generic tonalities, no conversation management

**Market Gaps Confirmed:**
- ✅ Zero competitors do multi-conversation orchestration
- ✅ Minimal sophisticated tone calibration
- ✅ No iterative refinement workflows
- ✅ All focus on pickups, none on relationship continuity

### 16.3 Technical Research

**LLM API Comparison:**

**Anthropic Claude Sonnet 4:**
- Pros: Superior conversation understanding, safety, nuance
- Cons: Potentially higher cost, API limits
- Pricing: ~$3 per million tokens input, ~$15 per million tokens output
- Decision: Primary choice

**OpenAI GPT-4 Turbo:**
- Pros: Faster, cheaper, more stable API
- Cons: Less nuanced conversation understanding
- Pricing: ~$10 per million tokens input, ~$30 per million tokens output
- Decision: Fallback option

**Cost Modeling (per user per month):**
- Average user: 40 AI generations
- Average context: 1,000 tokens input, 200 tokens output per generation
- Claude: 40 × (1000 × $0.000003 + 200 × $0.000015) = $0.24/user/month
- Actual usage likely 3-5x higher with refinements
- Estimate: $2-4 per active user per month (manageable)

**OCR Solutions Tested:**

**Google Cloud Vision API:**
- Accuracy: 96% on dating app screenshots
- Speed: 2-3 seconds average
- Cost: $1.50 per 1,000 images
- Decision: Primary choice

**Tesseract.js (open-source):**
- Accuracy: 82% on dating app screenshots
- Speed: 5-8 seconds average
- Cost: Free (compute only)
- Decision: Fallback only

### 16.4 Design Inspiration

**Apps with Excellent UX We're Learning From:**
- **Linear:** Clean, fast, keyboard shortcuts, premium feel
- **Notion:** Flexible editing, blocks, templates
- **Superhuman:** Keyboard-first, speed, delight
- **Grammarly:** Inline editing, suggestions, learning
- **Figma:** Collaboration, version history, comments

**Design Principles Borrowed:**
- Linear's speed and minimalism
- Notion's flexible content blocks (for messages)
- Superhuman's keyboard shortcuts
- Grammarly's inline suggestion UI
- Figma's version history visualization

### 16.5 Legal & Compliance

**Privacy Regulations:**
- GDPR (Europe): User data export, deletion rights
- CCPA (California): Opt-out of data selling (we don't sell anyway)
- App Store privacy labels: Full transparency required

**Terms of Service Must Address:**
- User owns their conversation data
- We can use anonymized, aggregated data for AI improvement
- We never sell user data
- Users responsible for how they use AI suggestions
- Dating apps may prohibit third-party tools (user's responsibility)

**Intellectual Property:**
- Trademark "ToneHone" (US, UK, EU)
- Copyright on code, design, content
- User-generated content (messages) owned by users
- AI-generated suggestions: Legal gray area, position as tool output

**Content Moderation:**
- No illegal content (harassment, threats, CSAM)
- Optional profanity filter
- Report abuse mechanism
- Human review for flagged content

### 16.6 Team & Hiring Plan

**Phase 1 (MVP, Months 0-3):**
- **Founder (you):** Product, strategy, initial coding
- **Freelance Full-Stack Developer:** Help with backend/frontend velocity
- **Freelance Designer:** Design system, key screens
- **Total budget:** $20-30K

**Phase 2 (Growth, Months 4-6):**
- **Full-time Frontend Engineer:** React Native + Web
- **Full-time Backend Engineer:** Node.js, AI integration
- **Part-time Designer:** Ongoing design needs
- **Founder:** Product, marketing, fundraising

**Phase 3 (Scale, Months 7-12):**
- **Second Full-stack Engineer**
- **Marketing Lead**
- **Customer Success / Support** (0.5 FTE initially)
- **Data Analyst** (to track metrics, insights)

**Year 2 (Post-launch):**
- **Head of Product:** Free you to focus on strategy
- **Growth Marketer**
- **Content Writer**
- **Additional Engineers** (2-3)

### 16.7 Funding Strategy

**Bootstrap Phase (Months 0-6):**
- Personal funds: $30-50K
- Revenue from early users (credit sales)
- Keep team lean (founder + freelancers)

**Seed Round (Month 6-12):**
- Target: $500K-1M
- Valuation: $3-5M (depending on traction)
- Use: Team hiring, marketing, 18-month runway
- Investors: Angels who understand dating/AI space

**Series A (Year 2+):**
- Target: $3-5M
- If metrics hit: 50K users, $2M ARR, 15% MoM growth
- Use: Scale team, expand to Android, partnerships

**Alternative: Profitable Bootstrap:**
- If Month 6 revenue = $20K+ MRR
- If Month 12 revenue = $50K+ MRR
- Consider staying bootstrapped
- Higher ownership, more control

---

## Document Version History

**v1.0 - November 2025**
- Initial PRD draft
- Comprehensive feature specification
- Market research integration
- ToneHone naming strategy

---

**END OF PRODUCT REQUIREMENTS DOCUMENT**

Total word count: ~25,000 words
Estimated reading time: 2 hours

**Next Steps:**
1. Review and approve PRD
2. Refine scope for MVP based on timeline
3. Create detailed technical specifications
4. Design key screen mockups
5. Begin development sprint planning

**Questions or Feedback:**
Contact: [Your Email]
Document Owner: [Your Name]
Last Updated: November 22, 2025