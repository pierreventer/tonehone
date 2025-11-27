# ToneHone TypeScript Architecture Assessment

**Date:** November 27, 2025
**Specialist:** TypeScript Pro
**Version:** 1.0

---

## Executive Summary

After analyzing the ToneHone PRD, this assessment provides a comprehensive TypeScript architecture strategy focused on:
- Type-safe domain modeling for conversations, messages, and tone profiles
- Monorepo structure with shared types between React Native and Next.js
- Strict type safety for API contracts using tRPC or Zod
- Advanced type patterns for the refinement editor annotation system
- Prisma type generation and integration
- Developer experience optimization

**Critical Finding:** The iterative refinement editor (Feature 5) requires sophisticated type modeling for annotations, version history, and AI instruction composition. This is the most complex TypeScript challenge in the application.

---

## 1. Critical Items (Must Address for MVP)

### 1.1 Monorepo Structure with Shared Types

**Priority:** P0 - Foundation for entire project

**Recommendation:**
```
tonehone/
├── apps/
│   ├── mobile/              # React Native (Expo)
│   ├── web/                 # Next.js
│   └── api/                 # Express.js API
├── packages/
│   ├── types/               # Shared TypeScript types
│   ├── validators/          # Zod schemas + type inference
│   ├── api-client/          # tRPC client/procedures
│   └── ui/                  # Shared UI components (optional)
├── package.json
├── turbo.json               # Turborepo config
└── tsconfig.base.json       # Base TypeScript config
```

**Implementation:**
- Use **Turborepo** for monorepo orchestration (faster than Nx for this scale)
- Shared `@tonehone/types` package consumed by all apps
- Single source of truth for domain models
- Type-safe API contracts with tRPC or explicit Zod schemas

**Rationale:**
- React Native and Next.js need identical type definitions
- API contracts must be synchronized with frontend
- Reduces type drift and runtime errors
- Developer experience: autocomplete and type checking across boundaries

---

### 1.2 Domain Model Type System

**Priority:** P0 - Core data structures

**File:** `packages/types/src/domain.ts`

```typescript
// ============================================================================
// Core Domain Types
// ============================================================================

/**
 * Tone Profile - Four-dimensional tone calibration system
 */
export interface ToneProfile {
  playfulness: ToneValue;    // 1-10: Witty ↔ Straightforward
  formality: ToneValue;      // 1-10: Casual ↔ Proper
  forwardness: ToneValue;    // 1-10: Subtle ↔ Direct
  expressiveness: ToneValue; // 1-10: Reserved ↔ Enthusiastic
}

export type ToneValue = 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10;

export type ToneDimension = keyof ToneProfile;

/**
 * Preset tone profile configurations
 */
export type TonePreset =
  | 'playful-flirty'
  | 'thoughtful-deep'
  | 'casual-friendly'
  | 'direct-bold'
  | 'professional-warm'
  | 'custom';

export interface ToneProfileMetadata {
  id: string;
  name: string;
  preset: TonePreset;
  profile: ToneProfile;
  createdAt: Date;
  updatedAt: Date;
}

/**
 * Conversation Platform
 */
export type Platform = 'hinge' | 'bumble' | 'tinder' | 'other';

/**
 * Message Speaker
 */
export type Speaker = 'user' | 'them';

/**
 * Message Source
 */
export type MessageSource = 'manual' | 'ocr' | 'imported';

/**
 * Conversation Status
 */
export type ConversationStatus = 'active' | 'needs-response' | 'stale' | 'archived';

/**
 * Message Entity
 */
export interface Message {
  id: string;
  conversationId: string;
  speaker: Speaker;
  content: string;
  timestamp: Date;
  source: MessageSource;
  metadata?: MessageMetadata;
}

/**
 * Message metadata for analytics and AI context
 */
export interface MessageMetadata {
  toneScores?: Partial<ToneProfile>;
  effectivenessRating?: 1 | 2 | 3 | 4 | 5;
  responseTime?: number; // milliseconds
  wasAiGenerated?: boolean;
  generationId?: string;
  isKeyMoment?: boolean;
  notes?: string;
}

/**
 * Conversation Entity
 */
export interface Conversation {
  id: string;
  userId: string;
  personName: string;
  platform: Platform;
  toneProfile: ToneProfile;
  tonePreset: TonePreset;
  status: ConversationStatus;
  createdAt: Date;
  lastActivity: Date;
  archived: boolean;
  profilePhoto?: string;
  bio?: string;
  metadata: ConversationMetadata;
}

/**
 * Conversation metadata for insights
 */
export interface ConversationMetadata {
  messageCount: number;
  userMessageCount: number;
  theirMessageCount: number;
  averageResponseTime?: number;
  healthScore?: 1 | 2 | 3 | 4 | 5;
  momentum?: 'hot' | 'warming' | 'stable' | 'cooling' | 'cold';
  lastMessagePreview?: string;
}

/**
 * User Entity
 */
export interface User {
  id: string;
  email: string;
  createdAt: Date;
  subscriptionTier: 'free' | 'pro';
  creditsRemaining: number;
  preferences?: UserPreferences;
}

export interface UserPreferences {
  defaultToneProfile?: ToneProfile;
  enableToneMismatchWarnings?: boolean;
  defaultMessageLength?: 'short' | 'medium' | 'long';
  preferredAiModel?: 'claude' | 'gpt4';
}
```

---

### 1.3 AI Generation Type System

**Priority:** P0 - Core feature types

**File:** `packages/types/src/ai-generation.ts`

```typescript
/**
 * AI Response Suggestion
 */
export interface AiSuggestion {
  id: string;
  text: string;
  toneMatch: number; // 0-100 percentage
  reasoning: string;
  contextTags: ContextTag[];
  generatedAt: Date;
}

export type ContextTag =
  | { type: 'building-on'; context: string }
  | { type: 'conversation-stage'; stage: ConversationStage }
  | { type: 'goal-detected'; goal: string }
  | { type: 'matching-tone'; toneDimension: ToneDimension };

export type ConversationStage =
  | 'initial-messages'
  | 'establishing-rapport'
  | 'deepening-connection'
  | 'pre-date'
  | 'ongoing';

/**
 * AI Generation Request
 */
export interface GenerateRequest {
  conversationId: string;
  toneOverride?: Partial<ToneProfile>;
  quickAdjustments?: QuickAdjustment[];
  count?: 3 | 4 | 5;
  contextWindow?: number; // number of messages to include
}

export type QuickAdjustment =
  | 'funnier'
  | 'more-serious'
  | 'more-direct'
  | 'less-forward'
  | 'add-question'
  | 'shorter'
  | 'longer'
  | 'add-emoji'
  | 'remove-emoji';

/**
 * AI Generation Response
 */
export interface GenerateResponse {
  suggestions: AiSuggestion[];
  generationId: string;
  creditsUsed: number;
  model: 'claude-sonnet-4' | 'gpt-4-turbo';
}

/**
 * AI Generation Tracking
 */
export interface AiGeneration {
  id: string;
  userId: string;
  conversationId: string;
  promptTokens: number;
  completionTokens: number;
  modelUsed: string;
  toneParams: ToneProfile;
  generatedOptions: AiSuggestion[];
  selectedOption?: number;
  refinementIterations: number;
  createdAt: Date;
}
```

---

### 1.4 Refinement Editor Type System (CRITICAL)

**Priority:** P0 - Killer feature, most complex type modeling

**File:** `packages/types/src/refinement.ts`

```typescript
/**
 * Text Annotation for Iterative Refinement
 * This is the core of Feature 5 - the key differentiator
 */
export type AnnotationType = 'keep' | 'adjust' | 'replace' | 'delete';

export interface TextAnnotation {
  id: string;
  type: AnnotationType;
  startIndex: number;
  endIndex: number;
  selectedText: string;
  instruction?: string; // for adjust/replace types
}

/**
 * Type-safe annotation with instruction constraints
 */
export type TypedAnnotation =
  | KeepAnnotation
  | AdjustAnnotation
  | ReplaceAnnotation
  | DeleteAnnotation;

export interface KeepAnnotation extends BaseAnnotation {
  type: 'keep';
  // No instruction needed - just lock the text
}

export interface AdjustAnnotation extends BaseAnnotation {
  type: 'adjust';
  instruction: AdjustInstruction;
}

export interface ReplaceAnnotation extends BaseAnnotation {
  type: 'replace';
  instruction: ReplaceInstruction;
}

export interface DeleteAnnotation extends BaseAnnotation {
  type: 'delete';
  // No instruction needed
}

interface BaseAnnotation {
  id: string;
  startIndex: number;
  endIndex: number;
  selectedText: string;
}

/**
 * Adjustment instructions (type-safe, enumerated)
 */
export type AdjustInstruction =
  | 'make-more-playful'
  | 'make-more-serious'
  | 'make-more-direct'
  | 'make-softer'
  | 'rephrase-differently'
  | { type: 'custom'; instruction: string };

/**
 * Replacement instructions
 */
export type ReplaceInstruction =
  | 'replace-with-question'
  | 'replace-with-humor'
  | 'replace-with-compliment'
  | { type: 'reference-topic'; topic: string }
  | { type: 'custom'; instruction: string };

/**
 * Global adjustment chips
 */
export type GlobalAdjustment =
  | 'add-emoji'
  | 'remove-emoji'
  | 'make-shorter'
  | 'make-longer'
  | 'add-question-at-end'
  | 'more-casual'
  | 'more-formal'
  | 'reference-last-message';

/**
 * Refinement Request
 */
export interface RefineRequest {
  suggestionId: string;
  originalText: string;
  annotations: TypedAnnotation[];
  globalAdjustments?: GlobalAdjustment[];
  conversationContext: string[]; // recent messages for context
}

/**
 * Refinement Response
 */
export interface RefineResponse {
  refinedText: string;
  iterationNumber: number;
  appliedAnnotations: number;
  preservedSegments: TextSegment[];
  modifiedSegments: TextSegment[];
}

export interface TextSegment {
  text: string;
  startIndex: number;
  endIndex: number;
  wasModified: boolean;
  annotationId?: string;
}

/**
 * Version History for Refinement Session
 */
export interface RefinementVersion {
  versionNumber: number;
  text: string;
  annotations: TypedAnnotation[];
  globalAdjustments: GlobalAdjustment[];
  timestamp: Date;
  parentVersion?: number;
}

export interface RefinementSession {
  sessionId: string;
  conversationId: string;
  originalSuggestionId: string;
  versions: RefinementVersion[];
  currentVersion: number;
  createdAt: Date;
  expiresAt: Date; // 24 hours from creation
}

/**
 * Template for saved refined messages
 */
export interface Template {
  id: string;
  userId: string;
  name: string;
  content: string;
  toneProfile: ToneProfile;
  category: TemplateCategory;
  tags: string[];
  useCount: number;
  createdAt: Date;
  updatedAt: Date;
}

export type TemplateCategory =
  | 'opener'
  | 'response'
  | 'date-ask'
  | 'follow-up'
  | 'deep-question'
  | 'playful-banter'
  | 'other';
```

**Type Safety Benefits:**
1. **Discriminated unions** for annotations ensure type-safe handling
2. **Exhaustive pattern matching** in switches (compiler enforces all cases)
3. **No runtime type errors** when processing annotations
4. **Autocomplete** for instruction types in editor
5. **Compile-time validation** of annotation structures

---

### 1.5 API Contract Type Safety (tRPC vs Zod)

**Priority:** P0 - API/Frontend synchronization

**Recommendation:** Use **tRPC** for end-to-end type safety

**File:** `packages/api-client/src/index.ts`

```typescript
import { initTRPC } from '@trpc/server';
import { z } from 'zod';
import type { Context } from './context';

const t = initTRPC.context<Context>().create();

export const appRouter = t.router({
  // Conversations
  conversations: {
    list: t.procedure
      .input(z.object({
        status: z.enum(['active', 'needs-response', 'stale', 'archived']).optional(),
        platform: z.enum(['hinge', 'bumble', 'tinder', 'other']).optional(),
        limit: z.number().min(1).max(200).default(50),
        offset: z.number().min(0).default(0),
      }))
      .query(async ({ input, ctx }) => {
        // Return type automatically inferred
        return ctx.db.conversation.findMany({
          where: {
            userId: ctx.userId,
            status: input.status,
            platform: input.platform,
          },
          take: input.limit,
          skip: input.offset,
        });
      }),

    create: t.procedure
      .input(z.object({
        personName: z.string().min(1).max(255),
        platform: z.enum(['hinge', 'bumble', 'tinder', 'other']),
        tonePreset: z.enum(['playful-flirty', 'thoughtful-deep', 'casual-friendly', 'direct-bold', 'professional-warm', 'custom']),
        toneProfile: z.object({
          playfulness: z.number().min(1).max(10),
          formality: z.number().min(1).max(10),
          forwardness: z.number().min(1).max(10),
          expressiveness: z.number().min(1).max(10),
        }),
      }))
      .mutation(async ({ input, ctx }) => {
        return ctx.db.conversation.create({
          data: {
            userId: ctx.userId,
            ...input,
          },
        });
      }),
  },

  // AI Generation
  ai: {
    generate: t.procedure
      .input(z.object({
        conversationId: z.string().uuid(),
        toneOverride: z.object({
          playfulness: z.number().min(1).max(10).optional(),
          formality: z.number().min(1).max(10).optional(),
          forwardness: z.number().min(1).max(10).optional(),
          expressiveness: z.number().min(1).max(10).optional(),
        }).optional(),
        quickAdjustments: z.array(z.enum([
          'funnier', 'more-serious', 'more-direct', 'less-forward',
          'add-question', 'shorter', 'longer', 'add-emoji', 'remove-emoji'
        ])).optional(),
        count: z.enum([3, 4, 5]).default(3),
      }))
      .mutation(async ({ input, ctx }) => {
        // Type-safe AI generation logic
        const suggestions = await ctx.aiService.generateSuggestions(input);
        return {
          suggestions,
          generationId: generateId(),
          creditsUsed: input.count,
          model: 'claude-sonnet-4' as const,
        };
      }),

    refine: t.procedure
      .input(z.object({
        suggestionId: z.string().uuid(),
        originalText: z.string(),
        annotations: z.array(z.discriminatedUnion('type', [
          z.object({
            type: z.literal('keep'),
            id: z.string(),
            startIndex: z.number(),
            endIndex: z.number(),
            selectedText: z.string(),
          }),
          z.object({
            type: z.literal('adjust'),
            id: z.string(),
            startIndex: z.number(),
            endIndex: z.number(),
            selectedText: z.string(),
            instruction: z.union([
              z.enum(['make-more-playful', 'make-more-serious', 'make-more-direct', 'make-softer', 'rephrase-differently']),
              z.object({ type: z.literal('custom'), instruction: z.string() }),
            ]),
          }),
          // ... other annotation types
        ])),
        globalAdjustments: z.array(z.enum([
          'add-emoji', 'remove-emoji', 'make-shorter', 'make-longer',
          'add-question-at-end', 'more-casual', 'more-formal', 'reference-last-message'
        ])).optional(),
      }))
      .mutation(async ({ input, ctx }) => {
        return ctx.aiService.refineText(input);
      }),
  },

  // Templates
  templates: {
    list: t.procedure.query(async ({ ctx }) => {
      return ctx.db.template.findMany({
        where: { userId: ctx.userId },
      });
    }),

    create: t.procedure
      .input(z.object({
        name: z.string().min(1).max(255),
        content: z.string().min(1),
        toneProfile: z.object({
          playfulness: z.number().min(1).max(10),
          formality: z.number().min(1).max(10),
          forwardness: z.number().min(1).max(10),
          expressiveness: z.number().min(1).max(10),
        }),
        category: z.enum(['opener', 'response', 'date-ask', 'follow-up', 'deep-question', 'playful-banter', 'other']),
        tags: z.array(z.string()).optional(),
      }))
      .mutation(async ({ input, ctx }) => {
        return ctx.db.template.create({
          data: {
            userId: ctx.userId,
            ...input,
            useCount: 0,
          },
        });
      }),
  },
});

export type AppRouter = typeof appRouter;
```

**Frontend Usage (Type-Safe):**

```typescript
import { createTRPCReact } from '@trpc/react-query';
import type { AppRouter } from '@tonehone/api-client';

export const trpc = createTRPCReact<AppRouter>();

// In component:
function ConversationList() {
  // Fully typed query - autocomplete works!
  const { data, isLoading } = trpc.conversations.list.useQuery({
    status: 'active',
    limit: 50,
  });

  // data is typed as Conversation[]
  return (
    <div>
      {data?.map(conv => (
        <ConversationCard key={conv.id} conversation={conv} />
      ))}
    </div>
  );
}
```

**Benefits:**
- **Zero type drift** between API and frontend
- **Autocomplete** for API calls
- **Compile-time errors** if API contract changes
- **No code generation** needed (unlike GraphQL)
- **Smaller bundle size** than GraphQL
- **React Query integration** built-in

---

### 1.6 Prisma Integration and Type Generation

**Priority:** P0 - Database type safety

**File:** `apps/api/prisma/schema.prisma`

```prisma
generator client {
  provider = "prisma-client-js"
  output   = "../node_modules/.prisma/client"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id               String         @id @default(uuid()) @db.Uuid
  email            String         @unique
  createdAt        DateTime       @default(now())
  subscriptionTier String         @default("free")
  creditsRemaining Int            @default(0)
  preferences      Json?

  conversations    Conversation[]
  aiGenerations    AiGeneration[]
  templates        Template[]

  @@map("users")
}

model Conversation {
  id           String   @id @default(uuid()) @db.Uuid
  userId       String   @db.Uuid
  personName   String
  platform     String
  toneProfile  Json     // ToneProfile type
  tonePreset   String
  status       String   @default("active")
  createdAt    DateTime @default(now())
  lastActivity DateTime @default(now())
  archived     Boolean  @default(false)
  profilePhoto String?
  bio          String?
  metadata     Json     // ConversationMetadata type

  user         User      @relation(fields: [userId], references: [id], onDelete: Cascade)
  messages     Message[]
  aiGenerations AiGeneration[]

  @@index([userId, status])
  @@index([userId, lastActivity])
  @@map("conversations")
}

model Message {
  id             String   @id @default(uuid()) @db.Uuid
  conversationId String   @db.Uuid
  speaker        String   // 'user' | 'them'
  content        String   @db.Text
  timestamp      DateTime @default(now())
  source         String   // 'manual' | 'ocr' | 'imported'
  metadata       Json?    // MessageMetadata type

  conversation   Conversation @relation(fields: [conversationId], references: [id], onDelete: Cascade)

  @@index([conversationId, timestamp])
  @@map("messages")
}

model AiGeneration {
  id                   String   @id @default(uuid()) @db.Uuid
  userId               String   @db.Uuid
  conversationId       String   @db.Uuid
  promptTokens         Int
  completionTokens     Int
  modelUsed            String
  toneParams           Json     // ToneProfile type
  generatedOptions     Json[]   // AiSuggestion[] type
  selectedOption       Int?
  refinementIterations Int      @default(0)
  createdAt            DateTime @default(now())

  user                 User         @relation(fields: [userId], references: [id], onDelete: Cascade)
  conversation         Conversation @relation(fields: [conversationId], references: [id], onDelete: Cascade)

  @@index([userId, createdAt])
  @@index([conversationId])
  @@map("ai_generations")
}

model Template {
  id          String   @id @default(uuid()) @db.Uuid
  userId      String   @db.Uuid
  name        String
  content     String   @db.Text
  toneProfile Json     // ToneProfile type
  category    String
  tags        String[]
  useCount    Int      @default(0)
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  user        User     @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@index([userId, category])
  @@map("templates")
}
```

**Type Bridge for Prisma JSON fields:**

**File:** `packages/types/src/prisma-bridge.ts`

```typescript
import type { Prisma } from '@prisma/client';
import type { ToneProfile, ConversationMetadata, MessageMetadata, AiSuggestion } from './domain';

/**
 * Type-safe helpers to bridge Prisma's Json type with our domain types
 */

export function parseToneProfile(json: Prisma.JsonValue): ToneProfile {
  // Runtime validation with Zod
  return toneProfileSchema.parse(json);
}

export function serializeToneProfile(profile: ToneProfile): Prisma.JsonValue {
  return profile as Prisma.JsonValue;
}

export function parseConversationMetadata(json: Prisma.JsonValue): ConversationMetadata {
  return conversationMetadataSchema.parse(json);
}

export function parseMessageMetadata(json: Prisma.JsonValue | null): MessageMetadata | undefined {
  if (!json) return undefined;
  return messageMetadataSchema.parse(json);
}

export function parseAiSuggestions(jsonArray: Prisma.JsonValue[]): AiSuggestion[] {
  return jsonArray.map(json => aiSuggestionSchema.parse(json));
}

/**
 * Extended Prisma types with proper JSON field typing
 */
export type ConversationWithTypes = Omit<
  Prisma.ConversationGetPayload<{}>,
  'toneProfile' | 'metadata'
> & {
  toneProfile: ToneProfile;
  metadata: ConversationMetadata;
};

export type MessageWithTypes = Omit<
  Prisma.MessageGetPayload<{}>,
  'metadata'
> & {
  metadata?: MessageMetadata;
};
```

---

## 2. Type System Patterns and Best Practices

### 2.1 Discriminated Unions for Type Safety

**Use Case:** Annotation system, context tags, API responses

**Pattern:**
```typescript
// Bad: Loose typing
interface Annotation {
  type: string;
  instruction?: string;
}

// Good: Discriminated union
type Annotation =
  | { type: 'keep'; locked: true }
  | { type: 'adjust'; instruction: AdjustInstruction }
  | { type: 'replace'; instruction: ReplaceInstruction }
  | { type: 'delete' };

// Exhaustive pattern matching (compiler enforced)
function handleAnnotation(ann: Annotation) {
  switch (ann.type) {
    case 'keep':
      return lockText(ann.locked); // ann.locked is guaranteed to exist
    case 'adjust':
      return adjustText(ann.instruction); // ann.instruction is typed
    case 'replace':
      return replaceText(ann.instruction);
    case 'delete':
      return deleteText();
    // TypeScript error if we miss a case!
  }
}
```

---

### 2.2 Branded Types for IDs and Constrained Values

**Use Case:** Prevent mixing different ID types

**Pattern:**
```typescript
// Branded types for ID safety
declare const brand: unique symbol;
type Brand<T, B> = T & { [brand]: B };

export type ConversationId = Brand<string, 'ConversationId'>;
export type MessageId = Brand<string, 'MessageId'>;
export type UserId = Brand<string, 'UserId'>;
export type TemplateId = Brand<string, 'TemplateId'>;

// Constructor functions with runtime validation
export function toConversationId(id: string): ConversationId {
  if (!isUuid(id)) throw new Error('Invalid conversation ID');
  return id as ConversationId;
}

export function toMessageId(id: string): MessageId {
  if (!isUuid(id)) throw new Error('Invalid message ID');
  return id as MessageId;
}

// Usage prevents mixing IDs
function getConversation(id: ConversationId) { /* ... */ }
function getMessage(id: MessageId) { /* ... */ }

const convId = toConversationId('123-456');
const msgId = toMessageId('789-abc');

getConversation(convId);  // OK
getConversation(msgId);   // ERROR: Type 'MessageId' is not assignable to 'ConversationId'
```

---

### 2.3 Template Literal Types for Type-Safe Keys

**Use Case:** Filter/sort keys, analytics events

**Pattern:**
```typescript
// Generate type-safe filter keys
type ConversationKeys = keyof Conversation;
type FilterableKeys = Extract<ConversationKeys, 'status' | 'platform' | 'archived'>;

type SortDirection = 'asc' | 'desc';
type SortField = `${FilterableKeys}_${SortDirection}`;
// Result: 'status_asc' | 'status_desc' | 'platform_asc' | ...

// Analytics event typing
type EventCategory = 'conversation' | 'ai_generation' | 'refinement' | 'template';
type EventAction = 'create' | 'update' | 'delete' | 'view';
type AnalyticsEvent = `${EventCategory}_${EventAction}`;
// Result: 'conversation_create' | 'conversation_update' | 'ai_generation_create' | ...

function trackEvent(event: AnalyticsEvent, properties?: Record<string, unknown>) {
  // Type-safe event tracking
}

trackEvent('conversation_create'); // OK
trackEvent('invalid_event');        // ERROR
```

---

### 2.4 Utility Types for API Responses

**Pattern:**
```typescript
/**
 * API response wrapper with loading/error states
 */
export type ApiResponse<T> =
  | { status: 'idle' }
  | { status: 'loading' }
  | { status: 'success'; data: T }
  | { status: 'error'; error: ApiError };

export interface ApiError {
  code: string;
  message: string;
  details?: Record<string, unknown>;
}

/**
 * Pagination wrapper
 */
export interface Paginated<T> {
  data: T[];
  total: number;
  page: number;
  pageSize: number;
  hasMore: boolean;
}

/**
 * Partial update types (for PATCH requests)
 */
export type PartialUpdate<T> = {
  [K in keyof T]?: T[K] extends object
    ? PartialUpdate<T[K]>
    : T[K];
};

// Usage
type UpdateConversation = PartialUpdate<Conversation>;
// Allows updating any field, including nested objects
```

---

### 2.5 Generic Constraints for Reusable Components

**Use Case:** Generic list components, form inputs

**Pattern:**
```typescript
/**
 * Generic list component with type-safe item rendering
 */
interface ListProps<T extends { id: string }> {
  items: T[];
  renderItem: (item: T) => React.ReactNode;
  keyExtractor?: (item: T) => string;
  onItemClick?: (item: T) => void;
}

function List<T extends { id: string }>({
  items,
  renderItem,
  keyExtractor = (item) => item.id,
  onItemClick,
}: ListProps<T>) {
  return (
    <div>
      {items.map((item) => (
        <div
          key={keyExtractor(item)}
          onClick={() => onItemClick?.(item)}
        >
          {renderItem(item)}
        </div>
      ))}
    </div>
  );
}

// Usage: Fully typed!
<List
  items={conversations}
  renderItem={(conv) => <ConversationCard conversation={conv} />}
  onItemClick={(conv) => navigate(`/conversations/${conv.id}`)}
/>
```

---

### 2.6 Zod Schema + Type Inference

**Pattern:**
```typescript
import { z } from 'zod';

/**
 * Single source of truth: Zod schema generates both validation and types
 */
export const toneProfileSchema = z.object({
  playfulness: z.number().min(1).max(10),
  formality: z.number().min(1).max(10),
  forwardness: z.number().min(1).max(10),
  expressiveness: z.number().min(1).max(10),
});

// Infer TypeScript type from schema
export type ToneProfile = z.infer<typeof toneProfileSchema>;

// Runtime validation
function validateToneProfile(data: unknown): ToneProfile {
  return toneProfileSchema.parse(data); // Throws if invalid
}

// Safe parsing (returns Result type)
function safeParseToneProfile(data: unknown) {
  const result = toneProfileSchema.safeParse(data);
  if (result.success) {
    return result.data; // Typed as ToneProfile
  } else {
    console.error(result.error);
    return null;
  }
}
```

---

## 3. Developer Experience Improvements

### 3.1 Strict tsconfig.json Configuration

**File:** `tsconfig.base.json`

```json
{
  "compilerOptions": {
    // Type Checking
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictBindCallApply": true,
    "strictPropertyInitialization": true,
    "noImplicitThis": true,
    "alwaysStrict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,

    // Module Resolution
    "module": "ESNext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "allowJs": false,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,

    // Emit
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "removeComments": false,
    "importHelpers": true,

    // Language and Environment
    "target": "ES2022",
    "lib": ["ES2022"],
    "jsx": "react-jsx",

    // Interop Constraints
    "isolatedModules": true,
    "forceConsistentCasingInFileNames": true,

    // Completeness
    "skipLibCheck": true
  }
}
```

**App-specific configs extend base:**

```json
// apps/mobile/tsconfig.json
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": {
    "jsx": "react-native",
    "lib": ["ES2022"],
    "paths": {
      "@tonehone/types": ["../../packages/types/src"],
      "@tonehone/validators": ["../../packages/validators/src"],
      "@tonehone/api-client": ["../../packages/api-client/src"]
    }
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
```

---

### 3.2 Path Aliases for Clean Imports

**Setup:**
```json
// tsconfig.json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/types/*": ["packages/types/src/*"],
      "@/validators/*": ["packages/validators/src/*"],
      "@/api/*": ["packages/api-client/src/*"],
      "@/ui/*": ["packages/ui/src/*"],
      "@/lib/*": ["lib/*"],
      "@/components/*": ["components/*"]
    }
  }
}
```

**Usage:**
```typescript
// Before
import { Conversation } from '../../../packages/types/src/domain';

// After
import { Conversation } from '@/types/domain';
```

---

### 3.3 Type Helpers Library

**File:** `packages/types/src/helpers.ts`

```typescript
/**
 * Make specific keys required
 */
export type RequireKeys<T, K extends keyof T> = T & Required<Pick<T, K>>;

/**
 * Make specific keys optional
 */
export type OptionalKeys<T, K extends keyof T> = Omit<T, K> & Partial<Pick<T, K>>;

/**
 * Extract keys by value type
 */
export type KeysOfType<T, V> = {
  [K in keyof T]: T[K] extends V ? K : never;
}[keyof T];

// Usage: Get all string keys from Conversation
type ConversationStringKeys = KeysOfType<Conversation, string>;
// Result: 'id' | 'userId' | 'personName' | 'platform' | ...

/**
 * Deep partial (recursive)
 */
export type DeepPartial<T> = {
  [K in keyof T]?: T[K] extends object ? DeepPartial<T[K]> : T[K];
};

/**
 * Non-nullable type
 */
export type NonNullableFields<T> = {
  [K in keyof T]: NonNullable<T[K]>;
};

/**
 * Async function return type
 */
export type AsyncReturnType<T extends (...args: any) => Promise<any>> =
  T extends (...args: any) => Promise<infer R> ? R : never;

/**
 * Ensure exhaustive switch statements
 */
export function assertNever(value: never): never {
  throw new Error(`Unexpected value: ${value}`);
}
```

---

### 3.4 VSCode Integration

**File:** `.vscode/settings.json`

```json
{
  "typescript.tsdk": "node_modules/typescript/lib",
  "typescript.enablePromptUseWorkspaceTsdk": true,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
    "source.organizeImports": true
  },
  "typescript.preferences.importModuleSpecifier": "non-relative",
  "typescript.suggest.autoImports": true,
  "typescript.updateImportsOnFileMove.enabled": "always",
  "typescript.inlayHints.parameterNames.enabled": "all",
  "typescript.inlayHints.functionLikeReturnTypes.enabled": true,
  "typescript.inlayHints.variableTypes.enabled": true
}
```

---

## 4. Type Safety for Key Features

### 4.1 Conversation Dashboard - Type-Safe Filtering

**File:** `packages/types/src/filters.ts`

```typescript
/**
 * Type-safe filter builder for conversation dashboard
 */
export interface ConversationFilters {
  status?: ConversationStatus[];
  platform?: Platform[];
  dateRange?: DateRange;
  tonePreset?: TonePreset[];
  searchQuery?: string;
}

export interface DateRange {
  start: Date;
  end: Date;
}

export type SortField = 'lastActivity' | 'createdAt' | 'personName' | 'status';
export type SortOrder = 'asc' | 'desc';

export interface ConversationSort {
  field: SortField;
  order: SortOrder;
}

/**
 * Type-safe query builder
 */
export class ConversationQuery {
  private filters: ConversationFilters = {};
  private sort: ConversationSort = { field: 'lastActivity', order: 'desc' };
  private pagination = { limit: 50, offset: 0 };

  whereStatus(status: ConversationStatus[]): this {
    this.filters.status = status;
    return this;
  }

  wherePlatform(platform: Platform[]): this {
    this.filters.platform = platform;
    return this;
  }

  whereDateRange(start: Date, end: Date): this {
    this.filters.dateRange = { start, end };
    return this;
  }

  search(query: string): this {
    this.filters.searchQuery = query;
    return this;
  }

  sortBy(field: SortField, order: SortOrder = 'desc'): this {
    this.sort = { field, order };
    return this;
  }

  paginate(limit: number, offset: number): this {
    this.pagination = { limit, offset };
    return this;
  }

  build() {
    return {
      filters: this.filters,
      sort: this.sort,
      pagination: this.pagination,
    };
  }
}

// Usage:
const query = new ConversationQuery()
  .whereStatus(['active', 'needs-response'])
  .wherePlatform(['hinge', 'bumble'])
  .sortBy('lastActivity', 'desc')
  .paginate(50, 0)
  .build();
```

---

### 4.2 Refinement Editor - Type-Safe Annotation Handling

**File:** `packages/types/src/annotation-processor.ts`

```typescript
/**
 * Type-safe annotation processor for refinement editor
 */
export class AnnotationProcessor {
  private annotations: TypedAnnotation[] = [];

  addAnnotation(annotation: TypedAnnotation): this {
    // Validate no overlapping annotations
    const overlaps = this.annotations.some(
      (a) =>
        (annotation.startIndex >= a.startIndex && annotation.startIndex < a.endIndex) ||
        (annotation.endIndex > a.startIndex && annotation.endIndex <= a.endIndex)
    );

    if (overlaps) {
      throw new Error('Annotations cannot overlap');
    }

    this.annotations.push(annotation);
    return this;
  }

  getAnnotations(): readonly TypedAnnotation[] {
    return [...this.annotations];
  }

  getAnnotationAt(index: number): TypedAnnotation | undefined {
    return this.annotations.find(
      (a) => index >= a.startIndex && index < a.endIndex
    );
  }

  /**
   * Build AI prompt from annotations
   * Type-safe exhaustive handling of all annotation types
   */
  buildPrompt(originalText: string): string {
    const instructions: string[] = [];

    for (const annotation of this.annotations) {
      const segment = originalText.slice(annotation.startIndex, annotation.endIndex);

      switch (annotation.type) {
        case 'keep':
          instructions.push(`PRESERVE EXACTLY: "${segment}"`);
          break;

        case 'adjust':
          const adjustInstruction = this.formatAdjustInstruction(annotation.instruction);
          instructions.push(`ADJUST "${segment}" TO: ${adjustInstruction}`);
          break;

        case 'replace':
          const replaceInstruction = this.formatReplaceInstruction(annotation.instruction);
          instructions.push(`REPLACE "${segment}" WITH: ${replaceInstruction}`);
          break;

        case 'delete':
          instructions.push(`DELETE: "${segment}"`);
          break;

        default:
          // TypeScript ensures this is never reached
          assertNever(annotation);
      }
    }

    return instructions.join('\n');
  }

  private formatAdjustInstruction(instruction: AdjustInstruction): string {
    if (typeof instruction === 'object' && instruction.type === 'custom') {
      return instruction.instruction;
    }
    return instruction; // Type-safe string literal
  }

  private formatReplaceInstruction(instruction: ReplaceInstruction): string {
    if (typeof instruction === 'object') {
      switch (instruction.type) {
        case 'reference-topic':
          return `a reference to ${instruction.topic}`;
        case 'custom':
          return instruction.instruction;
        default:
          assertNever(instruction);
      }
    }
    return instruction;
  }
}
```

---

### 4.3 Tone Profile - Type-Safe Slider Validation

**File:** `packages/validators/src/tone.ts`

```typescript
import { z } from 'zod';

/**
 * Zod schema for tone value (1-10 only)
 */
export const toneValueSchema = z.number()
  .int()
  .min(1)
  .max(10)
  .refine((val) => val >= 1 && val <= 10, {
    message: 'Tone value must be between 1 and 10',
  });

export const toneProfileSchema = z.object({
  playfulness: toneValueSchema,
  formality: toneValueSchema,
  forwardness: toneValueSchema,
  expressiveness: toneValueSchema,
});

export const tonePresetSchema = z.enum([
  'playful-flirty',
  'thoughtful-deep',
  'casual-friendly',
  'direct-bold',
  'professional-warm',
  'custom',
]);

/**
 * Runtime validation helpers
 */
export function isToneValue(value: number): value is ToneValue {
  return Number.isInteger(value) && value >= 1 && value <= 10;
}

export function validateToneProfile(profile: unknown): ToneProfile {
  return toneProfileSchema.parse(profile);
}

/**
 * Calculate tone distance between two profiles
 * Returns 0-40 (0 = identical, 40 = max difference)
 */
export function calculateToneDistance(a: ToneProfile, b: ToneProfile): number {
  return (
    Math.abs(a.playfulness - b.playfulness) +
    Math.abs(a.formality - b.formality) +
    Math.abs(a.forwardness - b.forwardness) +
    Math.abs(a.expressiveness - b.expressiveness)
  );
}

/**
 * Detect if a message significantly deviates from tone profile
 */
export function detectToneMismatch(
  messageProfile: ToneProfile,
  expectedProfile: ToneProfile,
  threshold: number = 15
): boolean {
  return calculateToneDistance(messageProfile, expectedProfile) > threshold;
}
```

---

### 4.4 State Management - Zustand with TypeScript

**File:** `packages/types/src/store.ts`

```typescript
import { create } from 'zustand';
import { devtools, persist } from 'zustand/middleware';

/**
 * Conversation Store
 */
interface ConversationStore {
  // State
  conversations: Conversation[];
  selectedConversationId: string | null;
  filters: ConversationFilters;
  sort: ConversationSort;

  // Actions
  setConversations: (conversations: Conversation[]) => void;
  addConversation: (conversation: Conversation) => void;
  updateConversation: (id: string, updates: Partial<Conversation>) => void;
  deleteConversation: (id: string) => void;
  selectConversation: (id: string | null) => void;
  setFilters: (filters: ConversationFilters) => void;
  setSort: (sort: ConversationSort) => void;

  // Computed
  getSelectedConversation: () => Conversation | undefined;
  getFilteredConversations: () => Conversation[];
}

export const useConversationStore = create<ConversationStore>()(
  devtools(
    persist(
      (set, get) => ({
        // Initial state
        conversations: [],
        selectedConversationId: null,
        filters: {},
        sort: { field: 'lastActivity', order: 'desc' },

        // Actions
        setConversations: (conversations) => set({ conversations }),

        addConversation: (conversation) =>
          set((state) => ({
            conversations: [...state.conversations, conversation],
          })),

        updateConversation: (id, updates) =>
          set((state) => ({
            conversations: state.conversations.map((conv) =>
              conv.id === id ? { ...conv, ...updates } : conv
            ),
          })),

        deleteConversation: (id) =>
          set((state) => ({
            conversations: state.conversations.filter((conv) => conv.id !== id),
            selectedConversationId:
              state.selectedConversationId === id ? null : state.selectedConversationId,
          })),

        selectConversation: (id) => set({ selectedConversationId: id }),

        setFilters: (filters) => set({ filters }),

        setSort: (sort) => set({ sort }),

        // Computed
        getSelectedConversation: () => {
          const { conversations, selectedConversationId } = get();
          return conversations.find((c) => c.id === selectedConversationId);
        },

        getFilteredConversations: () => {
          const { conversations, filters, sort } = get();
          let filtered = [...conversations];

          // Apply filters
          if (filters.status && filters.status.length > 0) {
            filtered = filtered.filter((c) => filters.status!.includes(c.status));
          }

          if (filters.platform && filters.platform.length > 0) {
            filtered = filtered.filter((c) => filters.platform!.includes(c.platform));
          }

          if (filters.searchQuery) {
            const query = filters.searchQuery.toLowerCase();
            filtered = filtered.filter(
              (c) =>
                c.personName.toLowerCase().includes(query) ||
                c.metadata.lastMessagePreview?.toLowerCase().includes(query)
            );
          }

          // Apply sorting
          filtered.sort((a, b) => {
            const aValue = a[sort.field];
            const bValue = b[sort.field];

            if (aValue instanceof Date && bValue instanceof Date) {
              return sort.order === 'asc'
                ? aValue.getTime() - bValue.getTime()
                : bValue.getTime() - aValue.getTime();
            }

            if (typeof aValue === 'string' && typeof bValue === 'string') {
              return sort.order === 'asc'
                ? aValue.localeCompare(bValue)
                : bValue.localeCompare(aValue);
            }

            return 0;
          });

          return filtered;
        },
      }),
      {
        name: 'conversation-store',
        partialize: (state) => ({
          // Only persist these fields
          filters: state.filters,
          sort: state.sort,
          selectedConversationId: state.selectedConversationId,
        }),
      }
    )
  )
);

/**
 * Refinement Editor Store
 */
interface RefinementStore {
  // State
  session: RefinementSession | null;
  currentAnnotations: TypedAnnotation[];
  globalAdjustments: GlobalAdjustment[];

  // Actions
  startSession: (suggestionId: string, originalText: string, conversationId: string) => void;
  endSession: () => void;
  addAnnotation: (annotation: TypedAnnotation) => void;
  removeAnnotation: (id: string) => void;
  addGlobalAdjustment: (adjustment: GlobalAdjustment) => void;
  removeGlobalAdjustment: (adjustment: GlobalAdjustment) => void;
  saveVersion: (refinedText: string) => void;
  goToVersion: (versionNumber: number) => void;

  // Computed
  canUndo: () => boolean;
  canRedo: () => boolean;
}

export const useRefinementStore = create<RefinementStore>()(
  devtools((set, get) => ({
    session: null,
    currentAnnotations: [],
    globalAdjustments: [],

    startSession: (suggestionId, originalText, conversationId) =>
      set({
        session: {
          sessionId: generateId(),
          conversationId,
          originalSuggestionId: suggestionId,
          versions: [
            {
              versionNumber: 1,
              text: originalText,
              annotations: [],
              globalAdjustments: [],
              timestamp: new Date(),
            },
          ],
          currentVersion: 1,
          createdAt: new Date(),
          expiresAt: new Date(Date.now() + 24 * 60 * 60 * 1000), // 24 hours
        },
        currentAnnotations: [],
        globalAdjustments: [],
      }),

    endSession: () =>
      set({
        session: null,
        currentAnnotations: [],
        globalAdjustments: [],
      }),

    addAnnotation: (annotation) =>
      set((state) => ({
        currentAnnotations: [...state.currentAnnotations, annotation],
      })),

    removeAnnotation: (id) =>
      set((state) => ({
        currentAnnotations: state.currentAnnotations.filter((a) => a.id !== id),
      })),

    addGlobalAdjustment: (adjustment) =>
      set((state) => ({
        globalAdjustments: [...state.globalAdjustments, adjustment],
      })),

    removeGlobalAdjustment: (adjustment) =>
      set((state) => ({
        globalAdjustments: state.globalAdjustments.filter((a) => a !== adjustment),
      })),

    saveVersion: (refinedText) =>
      set((state) => {
        if (!state.session) return state;

        const newVersion: RefinementVersion = {
          versionNumber: state.session.currentVersion + 1,
          text: refinedText,
          annotations: state.currentAnnotations,
          globalAdjustments: state.globalAdjustments,
          timestamp: new Date(),
          parentVersion: state.session.currentVersion,
        };

        return {
          session: {
            ...state.session,
            versions: [...state.session.versions, newVersion],
            currentVersion: newVersion.versionNumber,
          },
          currentAnnotations: [],
          globalAdjustments: [],
        };
      }),

    goToVersion: (versionNumber) =>
      set((state) => {
        if (!state.session) return state;

        const version = state.session.versions.find((v) => v.versionNumber === versionNumber);
        if (!version) return state;

        return {
          session: {
            ...state.session,
            currentVersion: versionNumber,
          },
          currentAnnotations: version.annotations,
          globalAdjustments: version.globalAdjustments,
        };
      }),

    canUndo: () => {
      const { session } = get();
      return session ? session.currentVersion > 1 : false;
    },

    canRedo: () => {
      const { session } = get();
      return session ? session.currentVersion < session.versions.length : false;
    },
  }))
);
```

---

## 5. Compilation and Build Optimization

### 5.1 Project References for Faster Builds

**File:** `tsconfig.json` (root)

```json
{
  "files": [],
  "references": [
    { "path": "./packages/types" },
    { "path": "./packages/validators" },
    { "path": "./packages/api-client" },
    { "path": "./apps/mobile" },
    { "path": "./apps/web" },
    { "path": "./apps/api" }
  ]
}
```

**File:** `packages/types/tsconfig.json`

```json
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": {
    "composite": true,
    "outDir": "./dist",
    "rootDir": "./src"
  },
  "include": ["src/**/*"]
}
```

**Benefits:**
- Incremental compilation (only rebuild changed packages)
- Faster development builds
- Better editor performance
- Parallel compilation across packages

---

### 5.2 Build Scripts

**File:** `package.json` (root)

```json
{
  "scripts": {
    "build": "turbo run build",
    "dev": "turbo run dev --parallel",
    "type-check": "turbo run type-check",
    "lint": "turbo run lint",
    "test": "turbo run test",

    "build:types": "tsc -b packages/types",
    "build:validators": "tsc -b packages/validators",
    "build:api-client": "tsc -b packages/api-client",

    "clean": "turbo run clean && rm -rf node_modules/.cache"
  }
}
```

---

## 6. Testing Strategy with TypeScript

### 6.1 Type-Safe Test Factories

**File:** `packages/types/src/test-factories.ts`

```typescript
/**
 * Type-safe test data factories
 */
export function createMockConversation(
  overrides?: Partial<Conversation>
): Conversation {
  return {
    id: generateId(),
    userId: generateId(),
    personName: 'Test Person',
    platform: 'hinge',
    toneProfile: createMockToneProfile(),
    tonePreset: 'casual-friendly',
    status: 'active',
    createdAt: new Date(),
    lastActivity: new Date(),
    archived: false,
    metadata: {
      messageCount: 0,
      userMessageCount: 0,
      theirMessageCount: 0,
    },
    ...overrides,
  };
}

export function createMockToneProfile(
  overrides?: Partial<ToneProfile>
): ToneProfile {
  return {
    playfulness: 5,
    formality: 5,
    forwardness: 5,
    expressiveness: 5,
    ...overrides,
  };
}

export function createMockMessage(overrides?: Partial<Message>): Message {
  return {
    id: generateId(),
    conversationId: generateId(),
    speaker: 'user',
    content: 'Test message',
    timestamp: new Date(),
    source: 'manual',
    ...overrides,
  };
}

export function createMockAiSuggestion(
  overrides?: Partial<AiSuggestion>
): AiSuggestion {
  return {
    id: generateId(),
    text: 'Test AI suggestion',
    toneMatch: 95,
    reasoning: 'Test reasoning',
    contextTags: [],
    generatedAt: new Date(),
    ...overrides,
  };
}
```

---

## 7. Migration Strategy and Roadmap

### Phase 1: Foundation (Week 1-2)

**Tasks:**
1. Set up monorepo with Turborepo
2. Create `packages/types` with core domain models
3. Configure strict tsconfig.base.json
4. Set up path aliases
5. Install and configure Prisma

**Deliverables:**
- Monorepo structure
- Shared types package
- TypeScript configs
- Developer environment setup

---

### Phase 2: API Contracts (Week 2-3)

**Tasks:**
1. Set up tRPC with Zod schemas
2. Define all API procedures with full typing
3. Create Prisma schema
4. Build type bridge for Prisma JSON fields
5. Generate Prisma client

**Deliverables:**
- tRPC router with full type safety
- Prisma schema and migrations
- API client package
- Type-safe database queries

---

### Phase 3: Feature Type Systems (Week 3-5)

**Tasks:**
1. Build refinement editor type system (annotations, versions)
2. Create tone profile validation with Zod
3. Implement state management with Zustand
4. Build filter/sort type-safe query builders
5. Create test factories

**Deliverables:**
- Complete annotation type system
- Tone profile validators
- Zustand stores
- Query builders
- Test utilities

---

### Phase 4: Developer Experience (Week 5-6)

**Tasks:**
1. Add type helpers library
2. Configure VSCode settings
3. Set up ESLint with TypeScript rules
4. Add pre-commit hooks for type checking
5. Document type patterns

**Deliverables:**
- Type helpers
- Editor configuration
- Linting setup
- Git hooks
- Developer documentation

---

## 8. ROADMAP.md Integration

### Critical TypeScript Tasks for ROADMAP.md

```markdown
## TypeScript Architecture (P0 - Foundation)

### Phase 1: Monorepo Setup (Week 1)
- [ ] Initialize Turborepo monorepo structure
- [ ] Create packages/types with domain models
- [ ] Configure tsconfig.base.json with strict mode
- [ ] Set up path aliases for clean imports
- [ ] Configure apps/mobile, apps/web, apps/api TypeScript

### Phase 2: Type System Design (Week 1-2)
- [ ] Define core domain types (Conversation, Message, ToneProfile)
- [ ] Build refinement editor type system (TextAnnotation, discriminated unions)
- [ ] Create AI generation types (AiSuggestion, GenerateRequest/Response)
- [ ] Design template and version history types
- [ ] Implement branded types for IDs

### Phase 3: API Type Safety (Week 2)
- [ ] Set up tRPC with Zod schemas
- [ ] Define all API procedures with type inference
- [ ] Create Prisma schema with proper JSON field typing
- [ ] Build type bridge for Prisma JSON <-> domain types
- [ ] Configure Prisma client generation

### Phase 4: Validation Layer (Week 2-3)
- [ ] Create packages/validators with Zod schemas
- [ ] Build tone profile validation (1-10 constraints)
- [ ] Add annotation validation (no overlaps, valid ranges)
- [ ] Implement message validation (OCR confidence, content)
- [ ] Create runtime type guards

### Phase 5: State Management (Week 3)
- [ ] Set up Zustand stores with TypeScript
- [ ] Build ConversationStore with type-safe actions
- [ ] Create RefinementStore with version history
- [ ] Implement TemplateStore
- [ ] Add persistence layer with type safety

### Phase 6: Developer Experience (Week 3-4)
- [ ] Create type helpers library (RequireKeys, DeepPartial, etc.)
- [ ] Add test factories for all domain types
- [ ] Configure VSCode settings for optimal TypeScript
- [ ] Set up ESLint with TypeScript rules
- [ ] Add pre-commit hooks for type checking
- [ ] Document type patterns in TYPESCRIPT-PATTERNS.md

### Phase 7: Advanced Patterns (Week 4-5)
- [ ] Implement type-safe query builder for filters
- [ ] Create template literal types for analytics events
- [ ] Build generic components with proper constraints
- [ ] Add utility types for API responses (Paginated, ApiResponse)
- [ ] Optimize compilation with project references

## Success Metrics
- [ ] 100% type coverage in packages/types
- [ ] Zero `any` types in production code
- [ ] <5 seconds full monorepo type check
- [ ] <1 second incremental type check
- [ ] Zero type errors in CI/CD
```

---

## 9. Key Recommendations Summary

### Must Do (P0)
1. **Monorepo with Turborepo** - Single source of truth for types
2. **tRPC for API** - End-to-end type safety, no drift
3. **Discriminated unions for annotations** - Exhaustive pattern matching
4. **Strict TypeScript config** - Catch errors at compile time
5. **Zod for validation** - Runtime + compile-time type safety
6. **Prisma type bridge** - Safe JSON field handling

### Should Do (P1)
1. **Branded types for IDs** - Prevent ID mixing errors
2. **Template literal types** - Type-safe event names, filter keys
3. **Test factories** - Consistent mock data
4. **Type helpers library** - DRY type transformations
5. **VSCode optimization** - Fast editor experience

### Nice to Have (P2)
1. **Project references** - Faster builds (can add later)
2. **Advanced generic patterns** - Reusable components
3. **Type guards** - Runtime type checking
4. **Utility types** - API response wrappers

---

## 10. Risk Mitigation

### Risk: Type Complexity Overhead
**Mitigation:**
- Start with essential types, add complexity incrementally
- Use type inference where possible (let TypeScript figure it out)
- Document complex patterns with examples
- Regular team sync on type conventions

### Risk: Slow Compilation
**Mitigation:**
- Use project references for incremental builds
- Optimize tsconfig (skipLibCheck: true for node_modules)
- Split large type files into smaller modules
- Use TypeScript 5.3+ for improved performance

### Risk: Learning Curve for Team
**Mitigation:**
- Create TYPESCRIPT-PATTERNS.md with examples
- Pair programming for complex types
- Code review focus on type safety
- Regular TypeScript knowledge sharing sessions

---

## Conclusion

This TypeScript architecture provides:

**Type Safety:**
- Zero runtime type errors from API/frontend mismatch
- Exhaustive pattern matching for complex logic
- Compile-time validation of all data flows

**Developer Experience:**
- Full autocomplete across monorepo
- Instant error feedback
- Refactoring confidence
- Self-documenting code

**Maintainability:**
- Single source of truth for types
- Reusable patterns
- Testable architecture
- Scalable structure

**The refinement editor annotation system is the most critical and complex TypeScript challenge** - the discriminated union pattern with type-safe instruction handling will ensure this killer feature is rock-solid.

Ready to implement. Start with Phase 1 monorepo setup.

---

**File Locations:**
- `/Users/pierreventer/Projects/tonehone/TYPESCRIPT-ASSESSMENT.md` (this file)
- Next: Create `/Users/pierreventer/Projects/tonehone/packages/types/src/domain.ts`
- Next: Create `/Users/pierreventer/Projects/tonehone/tsconfig.base.json`
