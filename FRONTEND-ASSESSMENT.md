# ToneHone Frontend Architecture Assessment

**Version:** 1.0
**Date:** November 27, 2025
**Author:** Frontend Developer Agent
**Status:** Technical Assessment for Development Planning

---

## Executive Summary

This assessment provides a comprehensive frontend architecture strategy for ToneHone, a conversation intelligence platform with 6 core features and a killer differentiator: the **Iterative Refinement Editor**. The platform targets iOS (React Native/Expo) + Web (Next.js), requiring sophisticated state management, real-time UI interactions, and performance optimization for managing 50+ conversations with 500+ messages each.

**Key Findings:**
- **State Management:** Zustand is optimal for this use case (lightweight, TypeScript-first, minimal boilerplate)
- **Critical Challenge:** The split-view Refinement Editor with text annotation system requires custom-built interactions
- **Performance Priority:** Virtualized lists, aggressive memoization, and optimistic UI updates are mandatory
- **Accessibility Risk:** Complex tone sliders and annotation UI need WCAG AA compliance strategy
- **Mobile-First:** Thumb zones, swipe gestures, and bottom sheets are architectural requirements

---

## Table of Contents

1. [React Component Architecture](#1-react-component-architecture)
2. [State Management Strategy](#2-state-management-strategy)
3. [Form Handling](#3-form-handling)
4. [Iterative Refinement Editor](#4-iterative-refinement-editor)
5. [Performance Optimization](#5-performance-optimization)
6. [Responsive Design Strategy](#6-responsive-design-strategy)
7. [Accessibility Considerations](#7-accessibility-considerations)
8. [Animation & Interaction Design](#8-animation--interaction-design)
9. [Real-Time Collaboration Feel](#9-real-time-collaboration-feel)
10. [Design System & Component Library](#10-design-system--component-library)
11. [Prioritized Roadmap](#11-prioritized-roadmap)
12. [Technical Challenges & Solutions](#12-technical-challenges--solutions)

---

## 1. React Component Architecture

### 1.1 Component Hierarchy

```
App/
├── Navigation/
│   ├── BottomTabNavigator (Mobile)
│   ├── SidebarNavigation (Desktop)
│   └── TopBar
├── Screens/
│   ├── Dashboard/
│   │   ├── ConversationGrid
│   │   ├── FilterBar
│   │   ├── SearchInput
│   │   └── DashboardAnalytics
│   ├── ThreadView/
│   │   ├── MessageList (Virtualized)
│   │   ├── MessageBubble
│   │   ├── ContextSidebar (Desktop)
│   │   ├── ContextBottomSheet (Mobile)
│   │   └── ActionBar
│   ├── SuggestionView/
│   │   ├── SuggestionCard[]
│   │   ├── QuickAdjustmentChips
│   │   └── RegenerateButton
│   ├── RefinementEditor/
│   │   ├── SplitPane (Desktop)
│   │   ├── OriginalTextPane
│   │   ├── RefinedTextPane
│   │   ├── TextAnnotationMenu
│   │   ├── VersionTimeline
│   │   └── GlobalAdjustments
│   ├── ToneProfileEditor/
│   │   ├── ToneSlider[] (4 dimensions)
│   │   ├── RadarChart
│   │   ├── PresetCards
│   │   └── LivePreview
│   └── Settings/
├── Shared Components/
│   ├── ConversationCard
│   ├── MessageInput
│   ├── LoadingStates (Skeleton, Spinner)
│   ├── EmptyStates
│   ├── ErrorBoundary
│   └── Toast/Notification
└── Utilities/
    ├── API Client (React Query)
    ├── State Store (Zustand)
    ├── Auth Provider
    └── Theme Provider
```

### 1.2 Component Design Patterns

**Container/Presenter Pattern:**
```typescript
// Container: Data fetching & state
// File: /Users/pierreventer/Projects/tonehone/src/features/dashboard/containers/DashboardContainer.tsx
export const DashboardContainer = () => {
  const { data, isLoading } = useConversations();
  const filters = useFilterStore();

  if (isLoading) return <DashboardSkeleton />;

  return <DashboardPresenter
    conversations={data}
    filters={filters}
    onFilterChange={filters.update}
  />;
};

// Presenter: Pure UI
// File: /Users/pierreventer/Projects/tonehone/src/features/dashboard/components/DashboardPresenter.tsx
export const DashboardPresenter = ({ conversations, filters, onFilterChange }) => (
  <View>
    <FilterBar filters={filters} onChange={onFilterChange} />
    <ConversationGrid conversations={conversations} />
  </View>
);
```

**Compound Components for Complex UI:**
```typescript
// File: /Users/pierreventer/Projects/tonehone/src/features/refinement/components/RefinementEditor.tsx
export const RefinementEditor = ({ suggestion }) => (
  <RefinementEditor.Root>
    <RefinementEditor.Header>
      <VersionTimeline />
      <GlobalAdjustments />
    </RefinementEditor.Header>

    <RefinementEditor.Content>
      <RefinementEditor.OriginalPane text={suggestion.text} />
      <RefinementEditor.RefinedPane text={refinedText} />
    </RefinementEditor.Content>

    <RefinementEditor.Actions>
      <Button variant="secondary">Discard</Button>
      <Button variant="primary">Accept</Button>
    </RefinementEditor.Actions>
  </RefinementEditor.Root>
);
```

**Custom Hooks for Business Logic:**
```typescript
// File: /Users/pierreventer/Projects/tonehone/src/hooks/useMessageGeneration.ts
export const useMessageGeneration = (conversationId: string) => {
  const mutation = useMutation({
    mutationFn: (options: GenerationOptions) =>
      api.ai.generate({ conversationId, ...options }),
    onSuccess: (data) => {
      // Optimistic update
      queryClient.setQueryData(['suggestions', conversationId], data);
    }
  });

  return {
    generate: mutation.mutate,
    isGenerating: mutation.isPending,
    suggestions: mutation.data?.suggestions,
    error: mutation.error
  };
};
```

### 1.3 Component Organization Strategy

**Feature-based folder structure:**
```
src/
├── features/
│   ├── dashboard/
│   │   ├── components/
│   │   ├── containers/
│   │   ├── hooks/
│   │   ├── types.ts
│   │   └── index.ts
│   ├── thread/
│   ├── refinement/
│   ├── tone-profile/
│   └── insights/
├── shared/
│   ├── components/
│   ├── hooks/
│   ├── utils/
│   └── types/
└── core/
    ├── api/
    ├── store/
    ├── theme/
    └── navigation/
```

---

## 2. State Management Strategy

### 2.1 Why Zustand Over Alternatives

**Comparison Matrix:**

| Feature | Zustand | Redux Toolkit | Jotai | Context API |
|---------|---------|---------------|-------|-------------|
| Bundle size | 1.2KB | 15KB | 2.9KB | 0 (built-in) |
| TypeScript support | Excellent | Excellent | Good | Manual |
| Learning curve | Minimal | Moderate | Minimal | Low |
| Boilerplate | Very low | Moderate | Very low | High |
| DevTools | Yes | Yes | Yes | No |
| Async handling | Built-in | Built-in | Via atoms | Manual |
| Performance | Excellent | Good | Excellent | Poor (re-renders) |
| **Recommendation** | **WINNER** | Overkill | Good alternative | Avoid for global state |

**Why Zustand wins for ToneHone:**
1. **Lightweight:** Mobile bundle size critical (React Native startup performance)
2. **TypeScript-first:** Type inference works perfectly with conversation/message types
3. **No boilerplate:** No actions, reducers, or providers needed
4. **Selective subscriptions:** Components only re-render when their slice changes
5. **Middleware support:** Persist, immer, devtools all available
6. **React Native compatible:** Works identically on web and mobile

### 2.2 Store Architecture

**File: /Users/pierreventer/Projects/tonehone/src/core/store/index.ts**

```typescript
import { create } from 'zustand';
import { devtools, persist } from 'zustand/middleware';
import { immer } from 'zustand/middleware/immer';

// Slices
import { createConversationSlice } from './slices/conversation';
import { createFilterSlice } from './slices/filters';
import { createUISlice } from './slices/ui';
import { createAuthSlice } from './slices/auth';

// Combined store type
export type AppStore =
  & ReturnType<typeof createConversationSlice>
  & ReturnType<typeof createFilterSlice>
  & ReturnType<typeof createUISlice>
  & ReturnType<typeof createAuthSlice>;

// Create store with middleware
export const useStore = create<AppStore>()(
  devtools(
    persist(
      immer((...a) => ({
        ...createConversationSlice(...a),
        ...createFilterSlice(...a),
        ...createUISlice(...a),
        ...createAuthSlice(...a),
      })),
      {
        name: 'tonehone-store',
        partialize: (state) => ({
          // Only persist auth and some UI preferences
          auth: state.auth,
          ui: {
            theme: state.ui.theme,
            preferredView: state.ui.preferredView
          }
        })
      }
    )
  )
);

// Selectors for optimized re-renders
export const selectConversations = (state: AppStore) => state.conversations;
export const selectActiveConversation = (state: AppStore) =>
  state.conversations.find(c => c.id === state.activeConversationId);
export const selectFilteredConversations = (state: AppStore) => {
  const { conversations, filters } = state;
  return conversations.filter(c =>
    (!filters.platform || c.platform === filters.platform) &&
    (!filters.needsResponse || c.needsResponse)
  );
};
```

**File: /Users/pierreventer/Projects/tonehone/src/core/store/slices/conversation.ts**

```typescript
import { StateCreator } from 'zustand';
import { Conversation, Message } from '@/types';

export interface ConversationSlice {
  conversations: Conversation[];
  activeConversationId: string | null;

  // Actions
  addConversation: (conversation: Conversation) => void;
  updateConversation: (id: string, updates: Partial<Conversation>) => void;
  deleteConversation: (id: string) => void;
  addMessage: (conversationId: string, message: Message) => void;
  setActiveConversation: (id: string | null) => void;
}

export const createConversationSlice: StateCreator<
  ConversationSlice,
  [["zustand/immer", never]],
  [],
  ConversationSlice
> = (set) => ({
  conversations: [],
  activeConversationId: null,

  addConversation: (conversation) =>
    set((state) => {
      state.conversations.push(conversation);
    }),

  updateConversation: (id, updates) =>
    set((state) => {
      const conv = state.conversations.find(c => c.id === id);
      if (conv) Object.assign(conv, updates);
    }),

  deleteConversation: (id) =>
    set((state) => {
      state.conversations = state.conversations.filter(c => c.id !== id);
    }),

  addMessage: (conversationId, message) =>
    set((state) => {
      const conv = state.conversations.find(c => c.id === conversationId);
      if (conv) conv.messages.push(message);
    }),

  setActiveConversation: (id) =>
    set((state) => {
      state.activeConversationId = id;
    })
});
```

### 2.3 Server State Management (React Query)

**File: /Users/pierreventer/Projects/tonehone/src/core/api/queries/conversations.ts**

```typescript
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from '@/core/api/client';
import { Conversation, Message } from '@/types';

// Query keys factory
export const conversationKeys = {
  all: ['conversations'] as const,
  lists: () => [...conversationKeys.all, 'list'] as const,
  list: (filters: string) => [...conversationKeys.lists(), filters] as const,
  details: () => [...conversationKeys.all, 'detail'] as const,
  detail: (id: string) => [...conversationKeys.details(), id] as const,
  messages: (id: string) => [...conversationKeys.detail(id), 'messages'] as const,
};

// Fetch conversations list
export const useConversations = (filters?: ConversationFilters) => {
  return useQuery({
    queryKey: conversationKeys.list(JSON.stringify(filters || {})),
    queryFn: () => api.conversations.list(filters),
    staleTime: 30000, // 30 seconds
    gcTime: 5 * 60 * 1000, // 5 minutes
  });
};

// Fetch single conversation with messages
export const useConversation = (id: string) => {
  return useQuery({
    queryKey: conversationKeys.detail(id),
    queryFn: () => api.conversations.get(id),
    enabled: !!id,
  });
};

// Create conversation (optimistic update)
export const useCreateConversation = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: CreateConversationInput) =>
      api.conversations.create(data),

    // Optimistic update
    onMutate: async (newConversation) => {
      await queryClient.cancelQueries({ queryKey: conversationKeys.lists() });

      const previousConversations = queryClient.getQueryData(
        conversationKeys.lists()
      );

      queryClient.setQueryData(conversationKeys.lists(), (old: Conversation[] = []) => [
        { ...newConversation, id: 'temp-' + Date.now(), createdAt: new Date() },
        ...old
      ]);

      return { previousConversations };
    },

    // Rollback on error
    onError: (err, newConversation, context) => {
      queryClient.setQueryData(
        conversationKeys.lists(),
        context?.previousConversations
      );
    },

    // Refetch on success
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: conversationKeys.lists() });
    }
  });
};

// Add message to conversation
export const useAddMessage = (conversationId: string) => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (message: CreateMessageInput) =>
      api.conversations.addMessage(conversationId, message),

    onMutate: async (newMessage) => {
      await queryClient.cancelQueries({
        queryKey: conversationKeys.messages(conversationId)
      });

      const previousMessages = queryClient.getQueryData(
        conversationKeys.messages(conversationId)
      );

      queryClient.setQueryData(
        conversationKeys.messages(conversationId),
        (old: Message[] = []) => [...old, {
          ...newMessage,
          id: 'temp-' + Date.now(),
          timestamp: new Date()
        }]
      );

      return { previousMessages };
    },

    onError: (err, newMessage, context) => {
      queryClient.setQueryData(
        conversationKeys.messages(conversationId),
        context?.previousMessages
      );
    },

    onSuccess: () => {
      queryClient.invalidateQueries({
        queryKey: conversationKeys.detail(conversationId)
      });
    }
  });
};
```

### 2.4 State Synchronization Strategy

**Local state (Zustand) for:**
- UI state (modals, filters, active views)
- Form state (drafts, temporary edits)
- Navigation state
- User preferences

**Server state (React Query) for:**
- Conversations and messages (source of truth is backend)
- AI-generated suggestions
- Tone profiles
- Analytics/insights

**AsyncStorage (React Native) for:**
- Auth tokens (via Expo SecureStore)
- Offline message queue
- User preferences backup

---

## 3. Form Handling

### 3.1 Form Library Choice: React Hook Form

**Why React Hook Form:**
- Uncontrolled inputs (better performance for long forms)
- Built-in validation with TypeScript support
- 1/10 the re-renders of Formik
- Works identically on React Native and Web
- Excellent DevTools

### 3.2 Tone Slider Implementation

**File: /Users/pierreventer/Projects/tonehone/src/features/tone-profile/components/ToneSlider.tsx**

```typescript
import { useController, Control } from 'react-hook-form';
import { View, Text, StyleSheet } from 'react-native';
import Slider from '@react-native-community/slider';
import { ToneProfileForm } from '../types';

interface ToneSliderProps {
  name: keyof ToneProfileForm;
  control: Control<ToneProfileForm>;
  label: string;
  leftLabel: string;
  rightLabel: string;
  color: string;
}

export const ToneSlider = ({
  name,
  control,
  label,
  leftLabel,
  rightLabel,
  color
}: ToneSliderProps) => {
  const { field } = useController({
    name,
    control,
    defaultValue: 5,
  });

  return (
    <View style={styles.container}>
      <Text style={styles.label}>{label}</Text>

      <View style={styles.sliderRow}>
        <Text style={styles.endLabel}>{leftLabel}</Text>

        <Slider
          style={styles.slider}
          minimumValue={1}
          maximumValue={10}
          step={1}
          value={field.value}
          onValueChange={field.onChange}
          minimumTrackTintColor={color}
          maximumTrackTintColor="#E5E7EB"
          thumbTintColor={color}
          // Accessibility
          accessibilityLabel={`${label} slider`}
          accessibilityValue={{
            min: 1,
            max: 10,
            now: field.value,
            text: `${field.value} out of 10`
          }}
        />

        <Text style={styles.endLabel}>{rightLabel}</Text>
      </View>

      <Text style={styles.value}>{field.value}/10</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginBottom: 24,
  },
  label: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 8,
  },
  sliderRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  slider: {
    flex: 1,
    height: 40,
  },
  endLabel: {
    fontSize: 12,
    color: '#6B7280',
    width: 80,
  },
  value: {
    textAlign: 'center',
    fontSize: 14,
    fontWeight: '600',
    color: '#1F2937',
    marginTop: 4,
  },
});
```

**File: /Users/pierreventer/Projects/tonehone/src/features/tone-profile/components/ToneProfileForm.tsx**

```typescript
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { ToneSlider } from './ToneSlider';
import { LivePreview } from './LivePreview';

// Validation schema
const toneProfileSchema = z.object({
  playfulness: z.number().min(1).max(10),
  formality: z.number().min(1).max(10),
  forwardness: z.number().min(1).max(10),
  expressiveness: z.number().min(1).max(10),
  name: z.string().optional(),
});

type ToneProfileForm = z.infer<typeof toneProfileSchema>;

export const ToneProfileEditor = ({
  conversationId,
  initialValues
}: ToneProfileEditorProps) => {
  const { control, handleSubmit, watch, formState: { isDirty } } = useForm<ToneProfileForm>({
    resolver: zodResolver(toneProfileSchema),
    defaultValues: initialValues || {
      playfulness: 5,
      formality: 5,
      forwardness: 5,
      expressiveness: 5,
    },
  });

  const mutation = useUpdateToneProfile(conversationId);

  // Watch all fields for live preview
  const currentValues = watch();

  const onSubmit = (data: ToneProfileForm) => {
    mutation.mutate(data);
  };

  return (
    <View style={styles.container}>
      <ToneSlider
        name="playfulness"
        control={control}
        label="Playfulness"
        leftLabel="Straightforward"
        rightLabel="Witty"
        color="#F97316"
      />

      <ToneSlider
        name="formality"
        control={control}
        label="Formality"
        leftLabel="Casual"
        rightLabel="Proper"
        color="#0891B2"
      />

      <ToneSlider
        name="forwardness"
        control={control}
        label="Forwardness"
        leftLabel="Subtle"
        rightLabel="Direct"
        color="#EF4444"
      />

      <ToneSlider
        name="expressiveness"
        control={control}
        label="Expressiveness"
        leftLabel="Reserved"
        rightLabel="Enthusiastic"
        color="#10B981"
      />

      <LivePreview toneValues={currentValues} />

      <Button
        onPress={handleSubmit(onSubmit)}
        disabled={!isDirty || mutation.isPending}
      >
        {mutation.isPending ? 'Saving...' : 'Save Tone Profile'}
      </Button>
    </View>
  );
};
```

### 3.3 Refinement Editor Form State

**File: /Users/pierreventer/Projects/tonehone/src/features/refinement/hooks/useRefinementState.ts**

```typescript
import { useState, useCallback } from 'react';
import { Annotation, RefinementIteration } from '../types';

export const useRefinementState = (initialText: string) => {
  const [iterations, setIterations] = useState<RefinementIteration[]>([
    { id: '0', text: initialText, annotations: [], timestamp: new Date() }
  ]);
  const [currentIterationIndex, setCurrentIterationIndex] = useState(0);

  const currentIteration = iterations[currentIterationIndex];

  const addAnnotation = useCallback((annotation: Annotation) => {
    setIterations(prev => {
      const updated = [...prev];
      const current = { ...updated[currentIterationIndex] };
      current.annotations = [...current.annotations, annotation];
      updated[currentIterationIndex] = current;
      return updated;
    });
  }, [currentIterationIndex]);

  const removeAnnotation = useCallback((annotationId: string) => {
    setIterations(prev => {
      const updated = [...prev];
      const current = { ...updated[currentIterationIndex] };
      current.annotations = current.annotations.filter(a => a.id !== annotationId);
      updated[currentIterationIndex] = current;
      return updated;
    });
  }, [currentIterationIndex]);

  const applyRefinement = useCallback((refinedText: string) => {
    const newIteration: RefinementIteration = {
      id: String(iterations.length),
      text: refinedText,
      annotations: [],
      timestamp: new Date(),
      parentId: currentIteration.id,
    };

    setIterations(prev => [...prev, newIteration]);
    setCurrentIterationIndex(iterations.length);
  }, [iterations.length, currentIteration]);

  const jumpToIteration = useCallback((index: number) => {
    setCurrentIterationIndex(index);
  }, []);

  return {
    currentIteration,
    iterations,
    currentIterationIndex,
    addAnnotation,
    removeAnnotation,
    applyRefinement,
    jumpToIteration,
  };
};
```

---

## 4. Iterative Refinement Editor

### 4.1 Architecture Overview

**This is the killer feature. Must be perfect.**

**Core Requirements:**
1. Split-view (original | refined)
2. Text selection and annotation
3. Multiple annotation types (keep, adjust, replace, delete)
4. Real-time visual feedback
5. Version history timeline
6. Keyboard shortcuts (desktop)
7. Mobile-optimized interactions

### 4.2 Text Annotation System

**File: /Users/pierreventer/Projects/tonehone/src/features/refinement/components/AnnotatableText.tsx**

```typescript
import React, { useState, useRef, useCallback } from 'react';
import { View, Text, StyleSheet, Pressable } from 'react-native';
import { AnnotationMenu } from './AnnotationMenu';
import { Annotation, AnnotationType } from '../types';

interface AnnotatableTextProps {
  text: string;
  annotations: Annotation[];
  onAddAnnotation: (annotation: Annotation) => void;
  onRemoveAnnotation: (id: string) => void;
  editable: boolean;
}

export const AnnotatableText = ({
  text,
  annotations,
  onAddAnnotation,
  onRemoveAnnotation,
  editable
}: AnnotatableTextProps) => {
  const [selection, setSelection] = useState<{ start: number; end: number } | null>(null);
  const [menuVisible, setMenuVisible] = useState(false);
  const [menuPosition, setMenuPosition] = useState({ x: 0, y: 0 });

  const textRef = useRef<Text>(null);

  const handleTextSelection = useCallback((event: any) => {
    if (!editable) return;

    const { selection: sel } = event.nativeEvent;
    if (sel.start === sel.end) {
      setSelection(null);
      setMenuVisible(false);
      return;
    }

    setSelection({ start: sel.start, end: sel.end });

    // Calculate menu position (simplified - use proper measurement in production)
    setMenuPosition({ x: event.nativeEvent.pageX, y: event.nativeEvent.pageY });
    setMenuVisible(true);
  }, [editable]);

  const handleAnnotationSelect = useCallback((type: AnnotationType, instruction?: string) => {
    if (!selection) return;

    const selectedText = text.substring(selection.start, selection.end);

    const annotation: Annotation = {
      id: Date.now().toString(),
      type,
      start: selection.start,
      end: selection.end,
      text: selectedText,
      instruction,
    };

    onAddAnnotation(annotation);
    setSelection(null);
    setMenuVisible(false);
  }, [selection, text, onAddAnnotation]);

  // Render text with annotation highlights
  const renderAnnotatedText = () => {
    const segments: JSX.Element[] = [];
    let lastIndex = 0;

    // Sort annotations by start position
    const sorted = [...annotations].sort((a, b) => a.start - b.start);

    sorted.forEach((annotation, idx) => {
      // Plain text before annotation
      if (annotation.start > lastIndex) {
        segments.push(
          <Text key={`plain-${idx}`}>
            {text.substring(lastIndex, annotation.start)}
          </Text>
        );
      }

      // Annotated text
      segments.push(
        <Pressable
          key={`annotation-${annotation.id}`}
          onPress={() => editable && onRemoveAnnotation(annotation.id)}
        >
          <Text style={[styles.annotation, getAnnotationStyle(annotation.type)]}>
            {annotation.text}
            {annotation.type === 'keep' && ' 🔒'}
            {annotation.type === 'adjust' && ' ✏️'}
            {annotation.type === 'replace' && ' 🔄'}
            {annotation.type === 'delete' && ' ❌'}
          </Text>
        </Pressable>
      );

      lastIndex = annotation.end;
    });

    // Remaining text
    if (lastIndex < text.length) {
      segments.push(
        <Text key="plain-end">{text.substring(lastIndex)}</Text>
      );
    }

    return segments;
  };

  return (
    <View style={styles.container}>
      <Text
        ref={textRef}
        style={styles.text}
        selectable={editable}
        onSelectionChange={handleTextSelection}
      >
        {renderAnnotatedText()}
      </Text>

      {menuVisible && (
        <AnnotationMenu
          position={menuPosition}
          onSelect={handleAnnotationSelect}
          onClose={() => setMenuVisible(false)}
        />
      )}
    </View>
  );
};

const getAnnotationStyle = (type: AnnotationType) => {
  switch (type) {
    case 'keep':
      return { backgroundColor: '#D1FAE5', color: '#065F46' }; // Green
    case 'adjust':
      return { backgroundColor: '#FEF3C7', color: '#92400E' }; // Yellow
    case 'replace':
      return { backgroundColor: '#DBEAFE', color: '#1E40AF' }; // Blue
    case 'delete':
      return { backgroundColor: '#FEE2E2', color: '#991B1B' }; // Red
  }
};

const styles = StyleSheet.create({
  container: {
    position: 'relative',
  },
  text: {
    fontSize: 16,
    lineHeight: 24,
    color: '#1F2937',
  },
  annotation: {
    paddingHorizontal: 4,
    paddingVertical: 2,
    borderRadius: 4,
    fontWeight: '500',
  },
});
```

### 4.3 Split-View Layout

**File: /Users/pierreventer/Projects/tonehone/src/features/refinement/components/SplitPane.tsx**

```typescript
import React from 'react';
import { View, ScrollView, StyleSheet, useWindowDimensions } from 'react-native';
import { AnnotatableText } from './AnnotatableText';
import { useRefinementState } from '../hooks/useRefinementState';

interface SplitPaneProps {
  originalText: string;
  onRefine: (annotations: Annotation[]) => void;
}

export const SplitPane = ({ originalText, onRefine }: SplitPaneProps) => {
  const { width } = useWindowDimensions();
  const isMobile = width < 768;

  const {
    currentIteration,
    addAnnotation,
    removeAnnotation,
  } = useRefinementState(originalText);

  if (isMobile) {
    // Mobile: Single pane with toggle
    return (
      <MobileSinglePane
        text={currentIteration.text}
        annotations={currentIteration.annotations}
        onAddAnnotation={addAnnotation}
        onRemoveAnnotation={removeAnnotation}
      />
    );
  }

  // Desktop: Side-by-side
  return (
    <View style={styles.container}>
      <View style={styles.pane}>
        <Text style={styles.paneTitle}>Original</Text>
        <ScrollView style={styles.scrollView}>
          <AnnotatableText
            text={originalText}
            annotations={[]}
            onAddAnnotation={() => {}}
            onRemoveAnnotation={() => {}}
            editable={false}
          />
        </ScrollView>
      </View>

      <View style={styles.divider} />

      <View style={styles.pane}>
        <Text style={styles.paneTitle}>Refined</Text>
        <ScrollView style={styles.scrollView}>
          <AnnotatableText
            text={currentIteration.text}
            annotations={currentIteration.annotations}
            onAddAnnotation={addAnnotation}
            onRemoveAnnotation={removeAnnotation}
            editable={true}
          />
        </ScrollView>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    flexDirection: 'row',
  },
  pane: {
    flex: 1,
    padding: 16,
  },
  divider: {
    width: 1,
    backgroundColor: '#E5E7EB',
  },
  paneTitle: {
    fontSize: 14,
    fontWeight: '600',
    color: '#6B7280',
    marginBottom: 12,
    textTransform: 'uppercase',
    letterSpacing: 0.5,
  },
  scrollView: {
    flex: 1,
  },
});
```

### 4.4 Version Timeline Component

**File: /Users/pierreventer/Projects/tonehone/src/features/refinement/components/VersionTimeline.tsx**

```typescript
import React from 'react';
import { View, Text, ScrollView, Pressable, StyleSheet } from 'react-native';
import { RefinementIteration } from '../types';
import { formatDistanceToNow } from 'date-fns';

interface VersionTimelineProps {
  iterations: RefinementIteration[];
  currentIndex: number;
  onSelectIteration: (index: number) => void;
}

export const VersionTimeline = ({
  iterations,
  currentIndex,
  onSelectIteration
}: VersionTimelineProps) => {
  return (
    <ScrollView
      horizontal
      style={styles.container}
      contentContainerStyle={styles.content}
      showsHorizontalScrollIndicator={false}
    >
      {iterations.map((iteration, index) => {
        const isActive = index === currentIndex;
        const isFuture = index > currentIndex;

        return (
          <React.Fragment key={iteration.id}>
            <Pressable
              style={[
                styles.dot,
                isActive && styles.dotActive,
                isFuture && styles.dotFuture,
              ]}
              onPress={() => onSelectIteration(index)}
              accessibilityLabel={`Version ${index + 1}`}
              accessibilityState={{ selected: isActive }}
            >
              <Text style={styles.dotText}>{index + 1}</Text>
            </Pressable>

            {index < iterations.length - 1 && (
              <View style={[styles.line, isFuture && styles.lineFuture]} />
            )}
          </React.Fragment>
        );
      })}
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    maxHeight: 60,
  },
  content: {
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
  },
  dot: {
    width: 32,
    height: 32,
    borderRadius: 16,
    backgroundColor: '#E5E7EB',
    alignItems: 'center',
    justifyContent: 'center',
  },
  dotActive: {
    backgroundColor: '#0891B2',
  },
  dotFuture: {
    opacity: 0.4,
  },
  dotText: {
    fontSize: 12,
    fontWeight: '600',
    color: '#1F2937',
  },
  line: {
    width: 40,
    height: 2,
    backgroundColor: '#0891B2',
    marginHorizontal: 4,
  },
  lineFuture: {
    backgroundColor: '#E5E7EB',
  },
});
```

### 4.5 Annotation Menu

**File: /Users/pierreventer/Projects/tonehone/src/features/refinement/components/AnnotationMenu.tsx**

```typescript
import React, { useState } from 'react';
import { View, Text, Pressable, StyleSheet, Modal, TextInput } from 'react-native';
import { AnnotationType } from '../types';

interface AnnotationMenuProps {
  position: { x: number; y: number };
  onSelect: (type: AnnotationType, instruction?: string) => void;
  onClose: () => void;
}

export const AnnotationMenu = ({ position, onSelect, onClose }: AnnotationMenuProps) => {
  const [showCustomInput, setShowCustomInput] = useState(false);
  const [customInstruction, setCustomInstruction] = useState('');
  const [selectedType, setSelectedType] = useState<AnnotationType | null>(null);

  const handleQuickSelect = (type: AnnotationType) => {
    if (type === 'adjust' || type === 'replace') {
      setSelectedType(type);
      setShowCustomInput(true);
    } else {
      onSelect(type);
    }
  };

  const handleCustomSubmit = () => {
    if (selectedType && customInstruction.trim()) {
      onSelect(selectedType, customInstruction);
      setCustomInstruction('');
      setShowCustomInput(false);
    }
  };

  if (showCustomInput) {
    return (
      <Modal
        visible={true}
        transparent
        animationType="fade"
        onRequestClose={onClose}
      >
        <Pressable style={styles.backdrop} onPress={onClose}>
          <View style={styles.customInputContainer}>
            <Text style={styles.customInputTitle}>
              {selectedType === 'adjust' ? 'How should this be adjusted?' : 'Replace with...'}
            </Text>

            <TextInput
              style={styles.customInput}
              value={customInstruction}
              onChangeText={setCustomInstruction}
              placeholder="Enter instruction..."
              autoFocus
              multiline
            />

            <View style={styles.customInputActions}>
              <Pressable style={styles.cancelButton} onPress={onClose}>
                <Text>Cancel</Text>
              </Pressable>
              <Pressable style={styles.submitButton} onPress={handleCustomSubmit}>
                <Text style={styles.submitButtonText}>Apply</Text>
              </Pressable>
            </View>
          </View>
        </Pressable>
      </Modal>
    );
  }

  return (
    <Modal
      visible={true}
      transparent
      animationType="fade"
      onRequestClose={onClose}
    >
      <Pressable style={styles.backdrop} onPress={onClose}>
        <View style={[styles.menu, { top: position.y, left: position.x }]}>
          <MenuItem
            icon="🔒"
            label="Keep This"
            description="Preserve in refinement"
            onPress={() => handleQuickSelect('keep')}
          />

          <MenuItem
            icon="✏️"
            label="Adjust This"
            description="Modify with instructions"
            onPress={() => handleQuickSelect('adjust')}
          />

          <MenuItem
            icon="🔄"
            label="Replace This"
            description="Generate alternative"
            onPress={() => handleQuickSelect('replace')}
          />

          <MenuItem
            icon="❌"
            label="Delete This"
            description="Remove from message"
            onPress={() => handleQuickSelect('delete')}
            destructive
          />
        </View>
      </Pressable>
    </Modal>
  );
};

const MenuItem = ({ icon, label, description, onPress, destructive = false }) => (
  <Pressable
    style={({ pressed }) => [
      styles.menuItem,
      pressed && styles.menuItemPressed,
      destructive && styles.menuItemDestructive,
    ]}
    onPress={onPress}
  >
    <Text style={styles.menuIcon}>{icon}</Text>
    <View style={styles.menuTextContainer}>
      <Text style={[styles.menuLabel, destructive && styles.destructiveText]}>
        {label}
      </Text>
      <Text style={styles.menuDescription}>{description}</Text>
    </View>
  </Pressable>
);

const styles = StyleSheet.create({
  backdrop: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.3)',
  },
  menu: {
    position: 'absolute',
    backgroundColor: 'white',
    borderRadius: 12,
    padding: 8,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
    elevation: 8,
    minWidth: 240,
  },
  menuItem: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 12,
    borderRadius: 8,
  },
  menuItemPressed: {
    backgroundColor: '#F3F4F6',
  },
  menuItemDestructive: {
    backgroundColor: '#FEE2E2',
  },
  menuIcon: {
    fontSize: 20,
    marginRight: 12,
  },
  menuTextContainer: {
    flex: 1,
  },
  menuLabel: {
    fontSize: 14,
    fontWeight: '600',
    color: '#1F2937',
  },
  menuDescription: {
    fontSize: 12,
    color: '#6B7280',
    marginTop: 2,
  },
  destructiveText: {
    color: '#991B1B',
  },
  customInputContainer: {
    position: 'absolute',
    top: '40%',
    left: '10%',
    right: '10%',
    backgroundColor: 'white',
    borderRadius: 12,
    padding: 20,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
    elevation: 8,
  },
  customInputTitle: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 12,
  },
  customInput: {
    borderWidth: 1,
    borderColor: '#E5E7EB',
    borderRadius: 8,
    padding: 12,
    fontSize: 14,
    minHeight: 80,
    textAlignVertical: 'top',
  },
  customInputActions: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    gap: 12,
    marginTop: 16,
  },
  cancelButton: {
    paddingHorizontal: 16,
    paddingVertical: 8,
  },
  submitButton: {
    backgroundColor: '#0891B2',
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 8,
  },
  submitButtonText: {
    color: 'white',
    fontWeight: '600',
  },
});
```

---

## 5. Performance Optimization

### 5.1 Virtualized Lists for Large Data Sets

**File: /Users/pierreventer/Projects/tonehone/src/features/thread/components/MessageList.tsx**

```typescript
import React, { useCallback } from 'react';
import { FlashList } from '@shopify/flash-list';
import { MessageBubble } from './MessageBubble';
import { Message } from '@/types';

interface MessageListProps {
  messages: Message[];
  conversationId: string;
}

export const MessageList = ({ messages, conversationId }: MessageListProps) => {
  const renderItem = useCallback(({ item }: { item: Message }) => (
    <MessageBubble
      message={item}
      conversationId={conversationId}
    />
  ), [conversationId]);

  const getItemType = useCallback((item: Message) => {
    return item.speaker; // 'user' or 'them' for different layouts
  }, []);

  return (
    <FlashList
      data={messages}
      renderItem={renderItem}
      estimatedItemSize={80}
      getItemType={getItemType}
      keyExtractor={(item) => item.id}
      inverted // Start from bottom like a chat
      // Performance optimizations
      drawDistance={500}
      removeClippedSubviews={true}
      maxToRenderPerBatch={10}
      windowSize={5}
    />
  );
};
```

**Why FlashList over FlatList:**
- 10x better performance on large lists
- Automatic blank space minimization
- Better recycling of components
- Built by Shopify specifically for React Native

### 5.2 Memoization Strategy

**File: /Users/pierreventer/Projects/tonehone/src/features/dashboard/components/ConversationCard.tsx**

```typescript
import React, { memo } from 'react';
import { View, Text, Pressable, StyleSheet } from 'react-native';
import { Conversation } from '@/types';
import { formatDistanceToNow } from 'date-fns';

interface ConversationCardProps {
  conversation: Conversation;
  onPress: (id: string) => void;
}

// Memoize to prevent re-renders when other conversations update
export const ConversationCard = memo<ConversationCardProps>(({
  conversation,
  onPress
}) => {
  const handlePress = () => onPress(conversation.id);

  return (
    <Pressable
      style={({ pressed }) => [
        styles.card,
        pressed && styles.cardPressed,
        conversation.needsResponse && styles.cardNeedsResponse,
      ]}
      onPress={handlePress}
      accessibilityLabel={`Conversation with ${conversation.personName}`}
      accessibilityHint="Tap to open conversation"
    >
      <View style={styles.header}>
        <Text style={styles.name}>{conversation.personName}</Text>
        <Text style={styles.platform}>{conversation.platform}</Text>
      </View>

      <Text style={styles.lastMessage} numberOfLines={2}>
        {conversation.lastMessage}
      </Text>

      <View style={styles.footer}>
        <Text style={styles.timestamp}>
          {formatDistanceToNow(new Date(conversation.lastActivity), { addSuffix: true })}
        </Text>

        {conversation.needsResponse && (
          <View style={styles.badge}>
            <Text style={styles.badgeText}>Needs Response</Text>
          </View>
        )}
      </View>
    </Pressable>
  );
}, (prevProps, nextProps) => {
  // Custom comparison - only re-render if conversation actually changed
  return (
    prevProps.conversation.id === nextProps.conversation.id &&
    prevProps.conversation.lastMessage === nextProps.conversation.lastMessage &&
    prevProps.conversation.lastActivity === nextProps.conversation.lastActivity &&
    prevProps.conversation.needsResponse === nextProps.conversation.needsResponse
  );
});

const styles = StyleSheet.create({
  card: {
    backgroundColor: 'white',
    borderRadius: 12,
    padding: 16,
    marginBottom: 12,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 2,
  },
  cardPressed: {
    opacity: 0.8,
  },
  cardNeedsResponse: {
    borderLeftWidth: 4,
    borderLeftColor: '#F97316',
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 8,
  },
  name: {
    fontSize: 16,
    fontWeight: '600',
    color: '#1F2937',
  },
  platform: {
    fontSize: 12,
    color: '#6B7280',
    textTransform: 'capitalize',
  },
  lastMessage: {
    fontSize: 14,
    color: '#4B5563',
    lineHeight: 20,
    marginBottom: 8,
  },
  footer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  timestamp: {
    fontSize: 12,
    color: '#9CA3AF',
  },
  badge: {
    backgroundColor: '#FEF3C7',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 6,
  },
  badgeText: {
    fontSize: 11,
    fontWeight: '600',
    color: '#92400E',
  },
});
```

### 5.3 Code Splitting & Lazy Loading

**File: /Users/pierreventer/Projects/tonehone/src/navigation/AppNavigator.tsx**

```typescript
import React, { lazy, Suspense } from 'react';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { LoadingScreen } from '@/shared/components/LoadingScreen';

// Lazy load heavy screens
const Dashboard = lazy(() => import('@/features/dashboard/screens/Dashboard'));
const ThreadView = lazy(() => import('@/features/thread/screens/ThreadView'));
const RefinementEditor = lazy(() => import('@/features/refinement/screens/RefinementEditor'));
const ToneProfileEditor = lazy(() => import('@/features/tone-profile/screens/ToneProfileEditor'));

const Stack = createNativeStackNavigator();

export const AppNavigator = () => {
  return (
    <Suspense fallback={<LoadingScreen />}>
      <Stack.Navigator>
        <Stack.Screen
          name="Dashboard"
          component={Dashboard}
          options={{ title: 'Conversations' }}
        />
        <Stack.Screen
          name="Thread"
          component={ThreadView}
          options={{ title: 'Thread' }}
        />
        <Stack.Screen
          name="Refinement"
          component={RefinementEditor}
          options={{ title: 'Refine Message', presentation: 'modal' }}
        />
        <Stack.Screen
          name="ToneProfile"
          component={ToneProfileEditor}
          options={{ title: 'Tone Profile', presentation: 'modal' }}
        />
      </Stack.Navigator>
    </Suspense>
  );
};
```

### 5.4 Optimistic UI Updates

**File: /Users/pierreventer/Projects/tonehone/src/features/thread/hooks/useSendMessage.ts**

```typescript
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from '@/core/api/client';
import { Message } from '@/types';
import { conversationKeys } from '@/core/api/queries/conversations';

export const useSendMessage = (conversationId: string) => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (messageData: { content: string; speaker: 'user' | 'them' }) =>
      api.conversations.addMessage(conversationId, messageData),

    // Optimistic update - show message immediately
    onMutate: async (newMessage) => {
      // Cancel outgoing refetches
      await queryClient.cancelQueries({
        queryKey: conversationKeys.messages(conversationId)
      });

      // Snapshot previous value
      const previousMessages = queryClient.getQueryData<Message[]>(
        conversationKeys.messages(conversationId)
      );

      // Optimistically update
      queryClient.setQueryData<Message[]>(
        conversationKeys.messages(conversationId),
        (old = []) => [
          ...old,
          {
            id: `temp-${Date.now()}`,
            ...newMessage,
            timestamp: new Date().toISOString(),
            status: 'sending', // Show sending indicator
          }
        ]
      );

      return { previousMessages };
    },

    // Rollback on error
    onError: (err, newMessage, context) => {
      queryClient.setQueryData(
        conversationKeys.messages(conversationId),
        context?.previousMessages
      );

      // Show error toast
      toast.error('Failed to send message');
    },

    // Update with server data on success
    onSuccess: (serverMessage) => {
      queryClient.setQueryData<Message[]>(
        conversationKeys.messages(conversationId),
        (old = []) => {
          // Replace temp message with server version
          return old.map(msg =>
            msg.id.startsWith('temp-') ? serverMessage : msg
          );
        }
      );
    },
  });
};
```

### 5.5 Image Optimization

**File: /Users/pierreventer/Projects/tonehone/src/shared/components/OptimizedImage.tsx**

```typescript
import React from 'react';
import { Image as ExpoImage } from 'expo-image';
import { StyleSheet } from 'react-native';

interface OptimizedImageProps {
  uri: string;
  width: number;
  height: number;
  blurhash?: string;
  alt?: string;
}

export const OptimizedImage = ({
  uri,
  width,
  height,
  blurhash,
  alt
}: OptimizedImageProps) => {
  return (
    <ExpoImage
      source={{ uri }}
      placeholder={blurhash}
      contentFit="cover"
      transition={200}
      style={{ width, height, borderRadius: 8 }}
      accessibilityLabel={alt}
      // Caching
      cachePolicy="memory-disk"
      // Lazy loading
      priority="normal"
    />
  );
};
```

### 5.6 Performance Monitoring

**File: /Users/pierreventer/Projects/tonehone/src/core/performance/monitoring.ts**

```typescript
import { performance } from 'react-native-performance';
import * as Sentry from '@sentry/react-native';

// Mark critical user interactions
export const markPerformance = (name: string) => {
  performance.mark(name);
};

// Measure time between marks
export const measurePerformance = (name: string, startMark: string, endMark: string) => {
  const measure = performance.measure(name, startMark, endMark);

  // Send to analytics if too slow
  if (measure.duration > 1000) {
    Sentry.captureMessage(`Slow operation: ${name} took ${measure.duration}ms`, 'warning');
  }

  return measure;
};

// Usage in components:
// markPerformance('dashboard-load-start');
// ... load data ...
// markPerformance('dashboard-load-end');
// measurePerformance('dashboard-load', 'dashboard-load-start', 'dashboard-load-end');
```

---

## 6. Responsive Design Strategy

### 6.1 Mobile-First Breakpoint System

**File: /Users/pierreventer/Projects/tonehone/src/core/theme/breakpoints.ts**

```typescript
import { useWindowDimensions } from 'react-native';

export const BREAKPOINTS = {
  mobile: 0,
  tablet: 640,
  desktop: 1024,
  wide: 1440,
} as const;

export const useBreakpoint = () => {
  const { width } = useWindowDimensions();

  return {
    isMobile: width < BREAKPOINTS.tablet,
    isTablet: width >= BREAKPOINTS.tablet && width < BREAKPOINTS.desktop,
    isDesktop: width >= BREAKPOINTS.desktop,
    isWide: width >= BREAKPOINTS.wide,
    width,
  };
};

// Responsive value helper
export const useResponsiveValue = <T,>(values: {
  mobile: T;
  tablet?: T;
  desktop?: T;
}) => {
  const { isMobile, isTablet } = useBreakpoint();

  if (isMobile) return values.mobile;
  if (isTablet) return values.tablet || values.mobile;
  return values.desktop || values.tablet || values.mobile;
};
```

### 6.2 Responsive Layout Components

**File: /Users/pierreventer/Projects/tonehone/src/shared/components/ResponsiveLayout.tsx**

```typescript
import React from 'react';
import { View, StyleSheet } from 'react-native';
import { useBreakpoint } from '@/core/theme/breakpoints';

interface ResponsiveLayoutProps {
  sidebar?: React.ReactNode;
  children: React.ReactNode;
}

export const ResponsiveLayout = ({ sidebar, children }: ResponsiveLayoutProps) => {
  const { isDesktop } = useBreakpoint();

  if (!isDesktop || !sidebar) {
    return <View style={styles.container}>{children}</View>;
  }

  return (
    <View style={styles.desktopContainer}>
      <View style={styles.sidebar}>{sidebar}</View>
      <View style={styles.main}>{children}</View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  desktopContainer: {
    flex: 1,
    flexDirection: 'row',
  },
  sidebar: {
    width: 300,
    borderRightWidth: 1,
    borderRightColor: '#E5E7EB',
  },
  main: {
    flex: 1,
  },
});
```

### 6.3 Thumb Zone Optimization (Mobile)

**File: /Users/pierreventer/Projects/tonehone/src/shared/components/MobileActionBar.tsx**

```typescript
import React from 'react';
import { View, Pressable, Text, StyleSheet } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

interface Action {
  label: string;
  icon: string;
  onPress: () => void;
  primary?: boolean;
}

interface MobileActionBarProps {
  actions: Action[];
}

export const MobileActionBar = ({ actions }: MobileActionBarProps) => {
  const insets = useSafeAreaInsets();

  return (
    <View style={[styles.container, { paddingBottom: insets.bottom }]}>
      {actions.map((action, index) => (
        <Pressable
          key={index}
          style={({ pressed }) => [
            styles.button,
            action.primary && styles.primaryButton,
            pressed && styles.buttonPressed,
          ]}
          onPress={action.onPress}
          accessibilityLabel={action.label}
        >
          <Text style={styles.icon}>{action.icon}</Text>
          <Text style={[
            styles.label,
            action.primary && styles.primaryLabel,
          ]}>
            {action.label}
          </Text>
        </Pressable>
      ))}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    backgroundColor: 'white',
    borderTopWidth: 1,
    borderTopColor: '#E5E7EB',
    paddingHorizontal: 16,
    paddingTop: 12,
    gap: 12,
  },
  button: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 12,
    borderRadius: 8,
    backgroundColor: '#F3F4F6',
    // Minimum touch target: 44x44pt (Apple HIG)
    minHeight: 44,
  },
  primaryButton: {
    backgroundColor: '#0891B2',
  },
  buttonPressed: {
    opacity: 0.7,
  },
  icon: {
    fontSize: 20,
    marginBottom: 4,
  },
  label: {
    fontSize: 12,
    fontWeight: '600',
    color: '#1F2937',
  },
  primaryLabel: {
    color: 'white',
  },
});
```

### 6.4 Responsive Grid System

**File: /Users/pierreventer/Projects/tonehone/src/features/dashboard/components/ConversationGrid.tsx**

```typescript
import React from 'react';
import { FlatList, StyleSheet, useWindowDimensions } from 'react-native';
import { ConversationCard } from './ConversationCard';
import { Conversation } from '@/types';

interface ConversationGridProps {
  conversations: Conversation[];
  onSelectConversation: (id: string) => void;
}

export const ConversationGrid = ({
  conversations,
  onSelectConversation
}: ConversationGridProps) => {
  const { width } = useWindowDimensions();

  // Responsive columns: 1 (mobile), 2 (tablet), 3-4 (desktop)
  const numColumns = width < 640 ? 1 : width < 1024 ? 2 : width < 1440 ? 3 : 4;

  return (
    <FlatList
      data={conversations}
      renderItem={({ item }) => (
        <ConversationCard
          conversation={item}
          onPress={onSelectConversation}
        />
      )}
      keyExtractor={(item) => item.id}
      numColumns={numColumns}
      key={numColumns} // Force re-render on column change
      contentContainerStyle={styles.container}
      columnWrapperStyle={numColumns > 1 ? styles.row : undefined}
    />
  );
};

const styles = StyleSheet.create({
  container: {
    padding: 16,
  },
  row: {
    gap: 16,
  },
});
```

---

## 7. Accessibility Considerations

### 7.1 WCAG AA Compliance Checklist

**Color Contrast:**
```typescript
// File: /Users/pierreventer/Projects/tonehone/src/core/theme/colors.ts

// All color combinations must meet WCAG AA standard (4.5:1 for normal text, 3:1 for large)
export const COLORS = {
  text: {
    primary: '#1F2937',    // Contrast ratio: 15:1 on white ✓
    secondary: '#6B7280',  // Contrast ratio: 5.3:1 on white ✓
    disabled: '#9CA3AF',   // Contrast ratio: 2.8:1 on white ✗ (use larger text or bold)
  },
  background: {
    white: '#FFFFFF',
    offWhite: '#FAFAFA',
  },
  interactive: {
    primary: '#0891B2',    // Contrast ratio: 3.8:1 on white (OK for large text/icons)
    primaryText: '#FFFFFF', // 13.5:1 on #0891B2 ✓
  },
};

// Utility to check contrast
export const checkContrast = (foreground: string, background: string): boolean => {
  // Implementation using color-contrast library
  const ratio = getContrastRatio(foreground, background);
  return ratio >= 4.5; // AA standard for normal text
};
```

### 7.2 Screen Reader Support

**File: /Users/pierreventer/Projects/tonehone/src/features/dashboard/components/ConversationCard.tsx**

```typescript
// Enhanced version with full accessibility
export const ConversationCard = ({ conversation, onPress }) => {
  const accessibilityLabel = `Conversation with ${conversation.personName} on ${conversation.platform}.
    Last message: ${conversation.lastMessage}.
    ${conversation.needsResponse ? 'Needs response.' : ''}
    Last activity ${formatDistanceToNow(new Date(conversation.lastActivity))} ago.`;

  const accessibilityHint = 'Double tap to open conversation';

  return (
    <Pressable
      onPress={() => onPress(conversation.id)}
      accessibilityRole="button"
      accessibilityLabel={accessibilityLabel}
      accessibilityHint={accessibilityHint}
      accessibilityState={{
        selected: conversation.id === selectedId,
      }}
    >
      {/* Visual content */}
    </Pressable>
  );
};
```

### 7.3 Keyboard Navigation (Desktop)

**File: /Users/pierreventer/Projects/tonehone/src/features/refinement/hooks/useKeyboardShortcuts.ts**

```typescript
import { useEffect } from 'react';
import { Platform } from 'react-native';

interface Shortcuts {
  [key: string]: () => void;
}

export const useKeyboardShortcuts = (shortcuts: Shortcuts) => {
  useEffect(() => {
    if (Platform.OS !== 'web') return;

    const handleKeyDown = (event: KeyboardEvent) => {
      const { key, metaKey, ctrlKey, shiftKey } = event;
      const modifier = metaKey || ctrlKey;

      // Build key combination string
      const combo = [
        modifier && 'mod',
        shiftKey && 'shift',
        key.toLowerCase(),
      ].filter(Boolean).join('+');

      if (shortcuts[combo]) {
        event.preventDefault();
        shortcuts[combo]();
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [shortcuts]);
};

// Usage in RefinementEditor:
const RefinementEditor = () => {
  const { addAnnotation, regenerate, acceptRefinement } = useRefinementState();

  useKeyboardShortcuts({
    'mod+k': () => addAnnotation('keep'),
    'mod+e': () => addAnnotation('adjust'),
    'mod+r': () => addAnnotation('replace'),
    'mod+enter': regenerate,
    'mod+shift+enter': acceptRefinement,
  });

  // ... rest of component
};
```

### 7.4 Focus Management

**File: /Users/pierreventer/Projects/tonehone/src/shared/hooks/useFocusTrap.ts**

```typescript
import { useEffect, useRef } from 'react';
import { findNodeHandle, AccessibilityInfo } from 'react-native';

// Trap focus within modal/dialog
export const useFocusTrap = (isActive: boolean) => {
  const containerRef = useRef<View>(null);

  useEffect(() => {
    if (!isActive) return;

    const handle = findNodeHandle(containerRef.current);
    if (handle) {
      AccessibilityInfo.setAccessibilityFocus(handle);
    }

    return () => {
      // Restore focus to previous element when modal closes
    };
  }, [isActive]);

  return containerRef;
};
```

### 7.5 Alternative Text for Dynamic Content

**File: /Users/pierreventer/Projects/tonehone/src/features/tone-profile/components/ToneSlider.tsx**

```typescript
<Slider
  // ... other props
  accessibilityLabel={`${label} slider`}
  accessibilityValue={{
    min: 1,
    max: 10,
    now: field.value,
    text: `${field.value} out of 10. ${getAccessibilityDescription(label, field.value)}`
  }}
  accessibilityHint="Swipe up or down to adjust"
/>

const getAccessibilityDescription = (dimension: string, value: number) => {
  switch (dimension) {
    case 'Playfulness':
      if (value <= 3) return 'Straightforward and serious';
      if (value <= 7) return 'Balanced with occasional humor';
      return 'Very witty and playful';
    // ... other dimensions
  }
};
```

---

## 8. Animation & Interaction Design

### 8.1 Animation Library: Reanimated 3

**Why Reanimated:**
- Runs on UI thread (60fps guaranteed)
- Shared values for cross-screen animations
- Works identically on iOS/Android/Web
- Supports gestures via react-native-gesture-handler

### 8.2 Micro-interactions

**File: /Users/pierreventer/Projects/tonehone/src/shared/components/AnimatedButton.tsx**

```typescript
import React from 'react';
import { Pressable, StyleSheet } from 'react-native';
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withSpring,
  withTiming,
} from 'react-native-reanimated';

const AnimatedPressable = Animated.createAnimatedComponent(Pressable);

export const AnimatedButton = ({ children, onPress, style }) => {
  const scale = useSharedValue(1);
  const opacity = useSharedValue(1);

  const animatedStyle = useAnimatedStyle(() => ({
    transform: [{ scale: scale.value }],
    opacity: opacity.value,
  }));

  const handlePressIn = () => {
    scale.value = withSpring(0.95, { damping: 15 });
    opacity.value = withTiming(0.8, { duration: 100 });
  };

  const handlePressOut = () => {
    scale.value = withSpring(1, { damping: 15 });
    opacity.value = withTiming(1, { duration: 100 });
  };

  return (
    <AnimatedPressable
      onPress={onPress}
      onPressIn={handlePressIn}
      onPressOut={handlePressOut}
      style={[style, animatedStyle]}
    >
      {children}
    </AnimatedPressable>
  );
};
```

### 8.3 Page Transitions

**File: /Users/pierreventer/Projects/tonehone/src/navigation/animations.ts**

```typescript
import { TransitionPresets } from '@react-navigation/stack';

export const SCREEN_TRANSITIONS = {
  // iOS-style slide from right
  slideFromRight: {
    ...TransitionPresets.SlideFromRightIOS,
    transitionSpec: {
      open: { animation: 'spring', config: { stiffness: 1000, damping: 500, mass: 3 } },
      close: { animation: 'spring', config: { stiffness: 1000, damping: 500, mass: 3 } },
    },
  },

  // Modal fade + slide from bottom
  modal: {
    ...TransitionPresets.ModalPresentationIOS,
    cardStyle: { backgroundColor: 'transparent' },
    transitionSpec: {
      open: { animation: 'timing', config: { duration: 300 } },
      close: { animation: 'timing', config: { duration: 250 } },
    },
  },

  // Fade transition
  fade: {
    transitionSpec: {
      open: { animation: 'timing', config: { duration: 200 } },
      close: { animation: 'timing', config: { duration: 150 } },
    },
    cardStyleInterpolator: ({ current }) => ({
      cardStyle: { opacity: current.progress },
    }),
  },
};
```

### 8.4 Loading States

**File: /Users/pierreventer/Projects/tonehone/src/shared/components/Skeleton.tsx**

```typescript
import React, { useEffect } from 'react';
import { View, StyleSheet } from 'react-native';
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withRepeat,
  withTiming,
  interpolate,
} from 'react-native-reanimated';

interface SkeletonProps {
  width: number | string;
  height: number;
  borderRadius?: number;
}

export const Skeleton = ({ width, height, borderRadius = 4 }: SkeletonProps) => {
  const shimmer = useSharedValue(0);

  useEffect(() => {
    shimmer.value = withRepeat(
      withTiming(1, { duration: 1500 }),
      -1, // infinite
      false
    );
  }, []);

  const animatedStyle = useAnimatedStyle(() => ({
    opacity: interpolate(shimmer.value, [0, 0.5, 1], [0.3, 0.6, 0.3]),
  }));

  return (
    <Animated.View
      style={[
        styles.skeleton,
        { width, height, borderRadius },
        animatedStyle,
      ]}
    />
  );
};

const styles = StyleSheet.create({
  skeleton: {
    backgroundColor: '#E5E7EB',
  },
});

// Dashboard loading skeleton
export const DashboardSkeleton = () => (
  <View style={styles.container}>
    {[1, 2, 3, 4].map(i => (
      <View key={i} style={styles.card}>
        <Skeleton width="60%" height={20} />
        <Skeleton width="100%" height={40} borderRadius={8} />
        <Skeleton width="40%" height={16} />
      </View>
    ))}
  </View>
);
```

### 8.5 Gesture Interactions

**File: /Users/pierreventer/Projects/tonehone/src/features/dashboard/components/SwipeableConversationCard.tsx**

```typescript
import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { GestureDetector, Gesture } from 'react-native-gesture-handler';
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withSpring,
  runOnJS,
} from 'react-native-reanimated';

interface SwipeableCardProps {
  conversation: Conversation;
  onArchive: (id: string) => void;
  onPrioritize: (id: string) => void;
}

export const SwipeableConversationCard = ({
  conversation,
  onArchive,
  onPrioritize
}: SwipeableCardProps) => {
  const translateX = useSharedValue(0);

  const panGesture = Gesture.Pan()
    .onChange((event) => {
      translateX.value = event.translationX;
    })
    .onEnd((event) => {
      // Swipe left to archive
      if (event.translationX < -120) {
        translateX.value = withSpring(-500);
        runOnJS(onArchive)(conversation.id);
        return;
      }

      // Swipe right to prioritize
      if (event.translationX > 120) {
        runOnJS(onPrioritize)(conversation.id);
      }

      // Reset position
      translateX.value = withSpring(0);
    });

  const cardStyle = useAnimatedStyle(() => ({
    transform: [{ translateX: translateX.value }],
  }));

  const archiveStyle = useAnimatedStyle(() => ({
    opacity: translateX.value < -60 ? 1 : 0,
  }));

  const prioritizeStyle = useAnimatedStyle(() => ({
    opacity: translateX.value > 60 ? 1 : 0,
  }));

  return (
    <View style={styles.container}>
      {/* Background actions */}
      <Animated.View style={[styles.actionLeft, prioritizeStyle]}>
        <Text style={styles.actionText}>⭐ Prioritize</Text>
      </Animated.View>

      <Animated.View style={[styles.actionRight, archiveStyle]}>
        <Text style={styles.actionText}>🗄️ Archive</Text>
      </Animated.View>

      {/* Swipeable card */}
      <GestureDetector gesture={panGesture}>
        <Animated.View style={[styles.card, cardStyle]}>
          <ConversationCard conversation={conversation} />
        </Animated.View>
      </GestureDetector>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    position: 'relative',
    marginBottom: 12,
  },
  card: {
    backgroundColor: 'white',
  },
  actionLeft: {
    position: 'absolute',
    left: 0,
    top: 0,
    bottom: 0,
    justifyContent: 'center',
    alignItems: 'flex-start',
    paddingLeft: 16,
    backgroundColor: '#10B981',
    borderRadius: 12,
    width: '100%',
  },
  actionRight: {
    position: 'absolute',
    right: 0,
    top: 0,
    bottom: 0,
    justifyContent: 'center',
    alignItems: 'flex-end',
    paddingRight: 16,
    backgroundColor: '#EF4444',
    borderRadius: 12,
    width: '100%',
  },
  actionText: {
    color: 'white',
    fontWeight: '600',
  },
});
```

---

## 9. Real-Time Collaboration Feel

### 9.1 Optimistic Updates Strategy

**Make every action feel instant, even with 500ms API latency.**

**Principles:**
1. Update UI immediately (optimistic)
2. Queue API call in background
3. Rollback only on error
4. Show subtle "syncing" indicator for transparency

### 9.2 Typing Indicators for AI Generation

**File: /Users/pierreventer/Projects/tonehone/src/features/suggestions/components/TypingIndicator.tsx**

```typescript
import React, { useEffect } from 'react';
import { View, StyleSheet } from 'react-native';
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withRepeat,
  withSequence,
  withTiming,
} from 'react-native-reanimated';

export const TypingIndicator = () => {
  const dot1 = useSharedValue(0);
  const dot2 = useSharedValue(0);
  const dot3 = useSharedValue(0);

  useEffect(() => {
    const sequence = withRepeat(
      withSequence(
        withTiming(1, { duration: 200 }),
        withTiming(0, { duration: 200 })
      ),
      -1
    );

    dot1.value = sequence;

    setTimeout(() => {
      dot2.value = sequence;
    }, 100);

    setTimeout(() => {
      dot3.value = sequence;
    }, 200);
  }, []);

  const dot1Style = useAnimatedStyle(() => ({
    opacity: dot1.value,
    transform: [{ translateY: -dot1.value * 8 }],
  }));

  const dot2Style = useAnimatedStyle(() => ({
    opacity: dot2.value,
    transform: [{ translateY: -dot2.value * 8 }],
  }));

  const dot3Style = useAnimatedStyle(() => ({
    opacity: dot3.value,
    transform: [{ translateY: -dot3.value * 8 }],
  }));

  return (
    <View style={styles.container}>
      <Animated.View style={[styles.dot, dot1Style]} />
      <Animated.View style={[styles.dot, dot2Style]} />
      <Animated.View style={[styles.dot, dot3Style]} />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    padding: 16,
  },
  dot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: '#0891B2',
  },
});
```

### 9.3 Real-time Sync Status

**File: /Users/pierreventer/Projects/tonehone/src/shared/components/SyncIndicator.tsx**

```typescript
import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import Animated, { FadeIn, FadeOut } from 'react-native-reanimated';
import { useIsFetching, useIsMutating } from '@tanstack/react-query';

export const SyncIndicator = () => {
  const isFetching = useIsFetching();
  const isMutating = useIsMutating();

  const isActive = isFetching > 0 || isMutating > 0;

  if (!isActive) return null;

  return (
    <Animated.View
      entering={FadeIn}
      exiting={FadeOut}
      style={styles.container}
    >
      <View style={styles.dot} />
      <Text style={styles.text}>Syncing...</Text>
    </Animated.View>
  );
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    paddingHorizontal: 12,
    paddingVertical: 6,
    backgroundColor: '#E0F2FE',
    borderRadius: 16,
  },
  dot: {
    width: 6,
    height: 6,
    borderRadius: 3,
    backgroundColor: '#0891B2',
  },
  text: {
    fontSize: 12,
    color: '#075985',
    fontWeight: '500',
  },
});
```

---

## 10. Design System & Component Library

### 10.1 Component Library Recommendation: Tamagui

**Why Tamagui:**
- Universal (React Native + Web from single codebase)
- Performance-optimized (compile-time optimization)
- Fully typed with TypeScript
- Built-in responsive props
- Accessible by default

**Alternative:** Build custom with Radix UI (web) + React Native built-ins (mobile)

### 10.2 Token-based Design System

**File: /Users/pierreventer/Projects/tonehone/src/core/theme/tokens.ts**

```typescript
export const TOKENS = {
  colors: {
    primary: {
      50: '#EFF6FF',
      100: '#DBEAFE',
      500: '#0891B2',
      600: '#0E7490',
      900: '#164E63',
    },
    neutral: {
      50: '#FAFAFA',
      100: '#F3F4F6',
      200: '#E5E7EB',
      500: '#6B7280',
      900: '#1F2937',
    },
    semantic: {
      success: '#10B981',
      warning: '#F59E0B',
      error: '#EF4444',
      info: '#3B82F6',
    },
    tone: {
      playful: '#F97316',
      thoughtful: '#0891B2',
      direct: '#EF4444',
      casual: '#10B981',
      professional: '#8B5CF6',
    },
  },

  spacing: {
    xs: 4,
    sm: 8,
    md: 12,
    lg: 16,
    xl: 24,
    '2xl': 32,
    '3xl': 48,
  },

  typography: {
    fontFamily: {
      primary: 'Inter',
      mono: 'JetBrains Mono',
    },
    fontSize: {
      xs: 12,
      sm: 14,
      base: 16,
      lg: 18,
      xl: 20,
      '2xl': 24,
      '3xl': 30,
    },
    fontWeight: {
      regular: '400',
      medium: '500',
      semibold: '600',
      bold: '700',
    },
    lineHeight: {
      tight: 1.25,
      normal: 1.5,
      relaxed: 1.75,
    },
  },

  borderRadius: {
    sm: 4,
    md: 8,
    lg: 12,
    xl: 16,
    full: 9999,
  },

  shadows: {
    sm: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 1 },
      shadowOpacity: 0.05,
      shadowRadius: 2,
      elevation: 1,
    },
    md: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 0.1,
      shadowRadius: 4,
      elevation: 2,
    },
    lg: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 4 },
      shadowOpacity: 0.15,
      shadowRadius: 8,
      elevation: 4,
    },
  },
};
```

### 10.3 Component Specifications

**File: /Users/pierreventer/Projects/tonehone/src/shared/components/Button.tsx**

```typescript
import React from 'react';
import { Pressable, Text, ActivityIndicator, StyleSheet } from 'react-native';
import { TOKENS } from '@/core/theme/tokens';

type ButtonVariant = 'primary' | 'secondary' | 'ghost' | 'danger';
type ButtonSize = 'sm' | 'md' | 'lg';

interface ButtonProps {
  children: string;
  onPress: () => void;
  variant?: ButtonVariant;
  size?: ButtonSize;
  disabled?: boolean;
  loading?: boolean;
  fullWidth?: boolean;
  icon?: React.ReactNode;
}

export const Button = ({
  children,
  onPress,
  variant = 'primary',
  size = 'md',
  disabled = false,
  loading = false,
  fullWidth = false,
  icon,
}: ButtonProps) => {
  const isDisabled = disabled || loading;

  return (
    <Pressable
      onPress={onPress}
      disabled={isDisabled}
      style={({ pressed }) => [
        styles.base,
        styles[variant],
        styles[size],
        fullWidth && styles.fullWidth,
        pressed && styles.pressed,
        isDisabled && styles.disabled,
      ]}
      accessibilityRole="button"
      accessibilityState={{ disabled: isDisabled, busy: loading }}
    >
      {loading ? (
        <ActivityIndicator
          color={variant === 'primary' ? 'white' : TOKENS.colors.primary[500]}
        />
      ) : (
        <>
          {icon}
          <Text style={[styles.text, styles[`${variant}Text`]]}>{children}</Text>
        </>
      )}
    </Pressable>
  );
};

const styles = StyleSheet.create({
  base: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: TOKENS.borderRadius.md,
    gap: TOKENS.spacing.sm,
  },

  // Variants
  primary: {
    backgroundColor: TOKENS.colors.primary[500],
  },
  secondary: {
    backgroundColor: TOKENS.colors.neutral[100],
    borderWidth: 1,
    borderColor: TOKENS.colors.neutral[200],
  },
  ghost: {
    backgroundColor: 'transparent',
  },
  danger: {
    backgroundColor: TOKENS.colors.semantic.error,
  },

  // Sizes
  sm: {
    paddingHorizontal: TOKENS.spacing.md,
    paddingVertical: TOKENS.spacing.sm,
    minHeight: 36,
  },
  md: {
    paddingHorizontal: TOKENS.spacing.lg,
    paddingVertical: TOKENS.spacing.md,
    minHeight: 44,
  },
  lg: {
    paddingHorizontal: TOKENS.spacing.xl,
    paddingVertical: TOKENS.spacing.lg,
    minHeight: 52,
  },

  // States
  pressed: {
    opacity: 0.8,
  },
  disabled: {
    opacity: 0.5,
  },
  fullWidth: {
    width: '100%',
  },

  // Text
  text: {
    fontFamily: TOKENS.typography.fontFamily.primary,
    fontWeight: TOKENS.typography.fontWeight.semibold,
  },
  primaryText: {
    color: 'white',
    fontSize: TOKENS.typography.fontSize.base,
  },
  secondaryText: {
    color: TOKENS.colors.neutral[900],
    fontSize: TOKENS.typography.fontSize.base,
  },
  ghostText: {
    color: TOKENS.colors.primary[500],
    fontSize: TOKENS.typography.fontSize.base,
  },
  dangerText: {
    color: 'white',
    fontSize: TOKENS.typography.fontSize.base,
  },
});
```

---

## 11. Prioritized Roadmap

### Phase 1: CRITICAL (MVP Must-Haves)

**Sprint 1-2 (Weeks 1-4): Foundation**
- [ ] Project setup (Expo, Next.js monorepo)
- [ ] Design system implementation (tokens, base components)
- [ ] Authentication flow (Clerk/Supabase Auth)
- [ ] API client setup (React Query configuration)
- [ ] State management (Zustand stores)
- [ ] Navigation structure

**Sprint 3-4 (Weeks 5-8): Dashboard & Thread View**
- [ ] ConversationCard component with virtualization
- [ ] Dashboard grid with filters/search
- [ ] Thread View with message display (virtualized)
- [ ] Message import (manual text paste)
- [ ] Basic conversation CRUD operations
- [ ] Optimistic UI updates

**Sprint 5-6 (Weeks 9-12): Tone Profile System**
- [ ] ToneSlider component (4 dimensions)
- [ ] Tone profile form with React Hook Form
- [ ] Preset profiles UI
- [ ] Live preview component
- [ ] Tone profile persistence

**Sprint 7-8 (Weeks 13-16): AI Suggestions**
- [ ] AI generation API integration (Claude Sonnet 4)
- [ ] Suggestion card display (3-5 options)
- [ ] Quick adjustment chips
- [ ] Regeneration functionality
- [ ] Loading states with typing indicator

**Sprint 9-11 (Weeks 17-22): Refinement Editor (KILLER FEATURE)**
- [ ] Split-pane layout (responsive)
- [ ] Text selection implementation
- [ ] Annotation menu (keep, adjust, replace, delete)
- [ ] AnnotatableText component with highlighting
- [ ] Version timeline component
- [ ] Refinement API integration
- [ ] Keyboard shortcuts (desktop)
- [ ] Mobile gesture handling

**Sprint 12 (Week 23-24): Polish & Testing**
- [ ] Screenshot OCR integration (Google Cloud Vision)
- [ ] Error states and retry logic
- [ ] Accessibility audit (WCAG AA compliance)
- [ ] Performance optimization (lazy loading, memoization)
- [ ] E2E testing (critical user flows)
- [ ] Beta testing with 20-50 users

### Phase 2: HIGH-PRIORITY (V1.0 Launch)

**Sprint 13-14 (Weeks 25-28): Insights & Analytics**
- [ ] Per-conversation analytics
- [ ] Dashboard-level insights
- [ ] Engagement metrics visualization
- [ ] "What Worked" highlights

**Sprint 15-16 (Weeks 29-32): Templates & Advanced Features**
- [ ] Template library UI
- [ ] Template creation/editing
- [ ] Template categorization
- [ ] Tone mismatch warnings
- [ ] Export conversations (PDF, text)

**Sprint 17 (Week 33-34): Monetization**
- [ ] Stripe integration
- [ ] Credit pack purchase flow
- [ ] Pro subscription UI
- [ ] Usage tracking
- [ ] Paywall components

**Sprint 18 (Week 35-36): Final Polish**
- [ ] Onboarding flow
- [ ] Empty states
- [ ] Animations polish
- [ ] Marketing landing page
- [ ] App Store assets

### Phase 3: NICE-TO-HAVE (Post-Launch)

**Future Sprints:**
- [ ] Voice tone analysis
- [ ] Multi-language support
- [ ] Team/Coach mode
- [ ] Advanced analytics (ML insights)
- [ ] Browser extension (screenshot capture)
- [ ] Android app
- [ ] Desktop app (Electron)

---

## 12. Technical Challenges & Solutions

### Challenge 1: Text Selection on Mobile (Refinement Editor)

**Problem:** React Native's built-in TextInput selection is limited. Need granular text selection with custom UI.

**Solution:**
- **Web:** Use native browser selection API with `window.getSelection()`
- **Mobile:** Use `react-native-selectable-text` or build custom solution with:
  - Long-press gesture to start selection
  - Draggable handles for start/end
  - Custom highlight renderer
- **Alternative:** Use web-view component for refinement editor on mobile (hybrid approach)

**Implementation:**
```typescript
// File: /Users/pierreventer/Projects/tonehone/src/features/refinement/components/MobileTextSelector.tsx
import React, { useState } from 'react';
import { GestureDetector, Gesture } from 'react-native-gesture-handler';
import SelectableText from 'react-native-selectable-text';

export const MobileTextSelector = ({ text, onSelect }) => {
  return (
    <SelectableText
      value={text}
      onSelection={(event) => {
        const { start, end, text: selectedText } = event.nativeEvent;
        onSelect({ start, end, text: selectedText });
      }}
      // Custom styling for selected text
      selectionColor="#DBEAFE"
      menuItems={['Keep', 'Adjust', 'Replace', 'Delete']}
      onPress={(eventType) => {
        // Handle menu item selection
      }}
    />
  );
};
```

### Challenge 2: Performance with 50+ Conversations

**Problem:** Dashboard re-renders on every state change, causing jank.

**Solution:**
1. Use FlashList for virtualization (only render visible items)
2. Memoize ConversationCard components
3. Use React Query's selective subscriptions
4. Implement windowing for filters

**Implementation:**
```typescript
// Selective re-rendering with Zustand
const conversations = useStore(selectFilteredConversations, shallow);

// Only re-render when specific conversation changes
const conversation = useStore(
  (state) => state.conversations.find(c => c.id === id),
  (prev, next) => prev?.lastActivity === next?.lastActivity
);
```

### Challenge 3: Real-time Collaboration Feel with Network Latency

**Problem:** API calls take 300-500ms, making UI feel sluggish.

**Solution:**
1. Optimistic updates (update UI immediately)
2. Request deduplication (React Query)
3. Prefetching (predictive loading)
4. Background sync queue

**Implementation:**
```typescript
// Prefetch next likely screen
const prefetchConversation = (id: string) => {
  queryClient.prefetchQuery({
    queryKey: conversationKeys.detail(id),
    queryFn: () => api.conversations.get(id),
  });
};

// On hover/focus, prefetch data
<ConversationCard
  onHoverIn={() => prefetchConversation(conversation.id)}
/>
```

### Challenge 4: AI Generation Cost Management

**Problem:** Claude API calls expensive ($0.003/1K tokens). Unoptimized prompts = high costs.

**Solution:**
1. Prompt optimization (reduce token count)
2. Context windowing (only last 20 messages)
3. Caching conversation context in Redis
4. Rate limiting per user tier
5. Batch generation (3-5 suggestions in single call)

**Implementation:**
```typescript
// Optimized prompt structure
const buildPrompt = (conversation: Conversation, toneProfile: ToneProfile) => {
  const lastMessages = conversation.messages.slice(-20); // Only last 20
  const context = formatMessagesForPrompt(lastMessages); // Condensed format

  return `Context: ${context}
Tone: playfulness=${toneProfile.playfulness}/10, formality=${toneProfile.formality}/10
Generate 3 response options.`;
};

// Cache in Redis (30 min TTL)
const getCachedContext = async (conversationId: string) => {
  const cached = await redis.get(`context:${conversationId}`);
  if (cached) return JSON.parse(cached);

  const context = await buildContext(conversationId);
  await redis.setex(`context:${conversationId}`, 1800, JSON.stringify(context));
  return context;
};
```

### Challenge 5: Cross-Platform Consistency (Mobile vs Web)

**Problem:** Different interaction paradigms (touch vs mouse, gestures vs clicks).

**Solution:**
1. Shared component library with platform-specific implementations
2. Feature detection (not platform detection)
3. Progressive enhancement
4. Monorepo with shared business logic

**Implementation:**
```typescript
// File: /Users/pierreventer/Projects/tonehone/src/shared/components/adaptive/AdaptiveButton.tsx

import { Platform } from 'react-native';
import { WebButton } from './WebButton';
import { NativeButton } from './NativeButton';

export const AdaptiveButton = Platform.select({
  web: WebButton,
  ios: NativeButton,
  android: NativeButton,
  default: NativeButton,
});
```

### Challenge 6: Accessibility for Complex Tone Sliders

**Problem:** Screen readers struggle with custom slider components.

**Solution:**
1. Use `accessibilityValue` with descriptive text
2. Support keyboard navigation (arrow keys)
3. Provide alternative input method (number input)
4. Clear visual and audio feedback

**Implementation:**
```typescript
<Slider
  accessibilityLabel="Playfulness slider"
  accessibilityValue={{
    min: 1,
    max: 10,
    now: value,
    text: `${value} out of 10. ${getDescription(value)}`
  }}
  accessibilityActions={[
    { name: 'increment', label: 'Increase playfulness' },
    { name: 'decrement', label: 'Decrease playfulness' },
  ]}
  onAccessibilityAction={(event) => {
    switch (event.nativeEvent.actionName) {
      case 'increment':
        setValue(v => Math.min(10, v + 1));
        break;
      case 'decrement':
        setValue(v => Math.max(1, v - 1));
        break;
    }
  }}
/>
```

### Challenge 7: Bundle Size for Mobile App

**Problem:** React Native apps can become bloated quickly.

**Solution:**
1. Code splitting with lazy loading
2. Tree shaking (remove unused code)
3. Optimize images (WebP, compression)
4. Use Hermes engine (iOS/Android)
5. Remove console.log in production

**Implementation:**
```typescript
// metro.config.js
module.exports = {
  transformer: {
    minifierConfig: {
      compress: {
        drop_console: true, // Remove console.log in production
      },
    },
  },
};

// Use dynamic imports
const HeavyComponent = lazy(() => import('./HeavyComponent'));
```

---

## Conclusion

This frontend architecture assessment provides a comprehensive blueprint for building ToneHone's sophisticated conversation intelligence platform. The recommendations prioritize:

1. **Performance:** Virtualization, memoization, and optimistic updates ensure 60fps interactions even with large datasets.
2. **Developer Experience:** TypeScript, Zustand, and React Query minimize boilerplate while maintaining type safety.
3. **User Experience:** Mobile-first design, smooth animations, and real-time collaboration feel create a premium product.
4. **Accessibility:** WCAG AA compliance ensures inclusivity from day one.
5. **Scalability:** Component-based architecture and state management patterns support future growth.

**Next Steps:**
1. Review this assessment with backend and iOS specialists
2. Create detailed component specifications for design team
3. Set up development environment and CI/CD pipelines
4. Begin Phase 1, Sprint 1 implementation
5. Schedule weekly architecture reviews to address emerging challenges

**Critical Success Factors:**
- The Refinement Editor must feel magical (this is the killer feature)
- Performance must be sub-3s load times on mobile
- Accessibility cannot be an afterthought
- Mobile-first but desktop-optimized (not just responsive)

---

**File Paths Referenced:**
- `/Users/pierreventer/Projects/tonehone/tonehone-PRD.md` (source document)
- `/Users/pierreventer/Projects/tonehone/FRONTEND-ASSESSMENT.md` (this assessment)

All code examples use absolute paths and follow ToneHone's proposed architecture from the PRD.
