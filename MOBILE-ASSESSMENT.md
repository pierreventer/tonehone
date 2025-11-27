# ToneHone Mobile Development Assessment
## Expert Analysis: Cross-Platform Architecture & Implementation Strategy

**Prepared by:** Mobile Development Specialist
**Date:** November 27, 2025
**Project:** ToneHone - Conversation Intelligence Platform
**Status:** Pre-MVP Technical Planning

---

## Executive Summary

After comprehensive review of the ToneHone PRD, this assessment identifies **critical architectural decisions** that will determine the success of a cross-platform mobile application with complex state management, real-time AI interactions, and offline-first requirements.

**Key Finding:** The PRD specifies React Native/Expo for iOS + Web, but the current codebase shows a native SwiftUI implementation. This represents a **critical fork in the road** that must be addressed immediately.

**Recommendation:** **Pivot to React Native/Expo** as specified in PRD for these reasons:
1. True cross-platform code sharing (iOS, Android, Web) - 70-80% code reuse
2. Faster iteration cycles for MVP development
3. Web deployment via React Native Web or Next.js with shared components
4. Mature ecosystem for OCR, image handling, offline sync, and state management
5. Significantly faster time-to-market for multi-platform launch

---

## 1. React Native/Expo Architecture Evaluation

### 1.1 CRITICAL: Platform Strategy Decision

**Current State Analysis:**
- PRD specifies: React Native (Expo SDK 50+) for mobile
- Codebase shows: Native SwiftUI implementation (ToneHoneApp.swift, ContentView.swift)
- **This mismatch must be resolved before any development proceeds**

**Decision Required:**

| Option | Pros | Cons | Recommendation |
|--------|------|------|----------------|
| **React Native/Expo** | Cross-platform (iOS/Android/Web), faster development, 70-80% code sharing, mature ecosystem | Slightly lower performance vs native, some native modules required for advanced features | **STRONGLY RECOMMENDED** |
| **Native SwiftUI** | Best iOS performance, native feel, direct iOS API access | Zero Android support, complete rewrite for Android, separate web codebase, 3x development time | Not recommended given cross-platform requirements |
| **Hybrid Approach** | React Native for most screens, SwiftUI for performance-critical | Complex bridge code, harder to maintain, team needs both skillsets | Only if specific performance issues proven |

**CRITICAL ITEMS (Must Address for MVP):**

- [ ] **DECISION POINT 1:** Commit to React Native/Expo or native SwiftUI (recommend RN)
- [ ] If React Native: Archive current SwiftUI code and initialize Expo project
- [ ] If SwiftUI: Update PRD to reflect native-first strategy and plan Android separately

### 1.2 Expo vs Bare React Native

**For ToneHone, recommend Expo Managed Workflow:**

**Pros:**
- OTA (Over-the-Air) updates for rapid bug fixes without App Store review
- Built-in: Expo Image Picker (screenshot upload), Expo Secure Store (tokens), Expo Camera
- Simplified build process (EAS Build)
- Built-in push notifications via Expo Push
- Faster development iteration

**Cons:**
- Limited to Expo SDK modules (but 95% of needed functionality is available)
- Larger bundle size (not critical for this app)

**Critical Features Requiring Custom Native Modules:**
- None identified - Expo SDK covers all requirements:
  - Image picker: `expo-image-picker`
  - OCR: Can use Google Cloud Vision API (no native module needed)
  - Secure storage: `expo-secure-store`
  - Navigation: `@react-navigation/native`
  - Offline storage: `@react-native-async-storage/async-storage` or SQLite

**HIGH PRIORITY ITEMS:**

- [ ] Set up Expo managed workflow with EAS Build
- [ ] Configure app.json for iOS and Android targets
- [ ] Set up Expo development build for testing native features
- [ ] Configure EAS Update for OTA updates post-launch

---

## 2. Cross-Platform Code Sharing Strategy

### 2.1 Monorepo Architecture (CRITICAL)

**Recommended Structure:**
```
tonehone/
├── apps/
│   ├── mobile/              # Expo React Native app
│   │   ├── app/             # Expo Router (file-based routing)
│   │   ├── src/
│   │   │   ├── screens/     # Platform-specific screen implementations
│   │   │   ├── navigation/  # Mobile navigation setup
│   │   │   └── components/  # Mobile-specific UI components
│   │   └── app.json
│   └── web/                 # Next.js 14+ web app
│       ├── app/             # App Router
│       ├── pages/           # Page components
│       └── next.config.js
├── packages/
│   ├── shared-ui/           # Shared React components (70% reuse)
│   │   ├── ConversationCard/
│   │   ├── MessageBubble/
│   │   ├── ToneSlider/
│   │   ├── SuggestionOption/
│   │   └── RefinementEditor/
│   ├── shared-logic/        # 100% reusable business logic
│   │   ├── hooks/           # useConversations, useToneProfile, etc.
│   │   ├── stores/          # Zustand stores
│   │   ├── api/             # API clients (React Query)
│   │   └── utils/           # Helpers, formatters, validators
│   ├── shared-types/        # TypeScript types (100% reuse)
│   └── design-system/       # Design tokens, theme
└── turbo.json               # Turborepo config
```

**Code Reuse Targets:**
- Business logic: 100% (API clients, state management, utilities)
- UI components: 70-80% (with platform-specific variants)
- Navigation: 40% (concepts shared, implementation differs)
- Native features: 0% (platform-specific)

**CRITICAL ITEMS:**

- [ ] Set up Turborepo monorepo structure
- [ ] Create `packages/shared-logic` for Zustand stores and React Query hooks
- [ ] Create `packages/shared-ui` with platform-agnostic components
- [ ] Configure TypeScript path mapping for imports (`@tonehone/shared-ui`, etc.)
- [ ] Set up shared ESLint and Prettier configs

### 2.2 Platform-Specific Code Strategy

**Where Platform-Specific Code is Required:**

1. **Navigation:**
   - Mobile: Bottom tabs, stack navigation, modals
   - Web: Sidebar navigation, URL-based routing
   - **Solution:** Shared navigation logic, platform-specific nav components

2. **Layout:**
   - Mobile: Full-screen, swipe gestures, bottom sheets
   - Web: Split-pane, hover states, keyboard shortcuts
   - **Solution:** Responsive hooks, platform-specific layout wrappers

3. **Image Upload:**
   - Mobile: `expo-image-picker` (camera roll + camera)
   - Web: File input + drag-and-drop
   - **Solution:** Abstract `useImagePicker()` hook with platform implementations

4. **Text Selection (Refinement Editor):**
   - Mobile: Long-press, context menu
   - Web: Mouse selection, keyboard shortcuts
   - **Solution:** Platform detection, conditional rendering

**HIGH PRIORITY ITEMS:**

- [ ] Create platform abstraction layer for image upload
- [ ] Design responsive layout system for conversation hub (grid vs list)
- [ ] Plan bottom sheet (mobile) vs modal (web) component variants

---

## 3. Performance Optimization for Scrolling Large Lists

### 3.1 Conversation Hub Performance (CRITICAL)

**Challenge:** Dashboard must render 50-200 conversation cards at 60fps.

**Solution: FlashList (replacement for FlatList)**
```typescript
import { FlashList } from "@shopify/flash-list";

// In ConversationHub
<FlashList
  data={conversations}
  renderItem={({ item }) => <ConversationCard conversation={item} />}
  estimatedItemSize={120}  // Critical for FlashList performance
  keyExtractor={(item) => item.id}
  removeClippedSubviews={true}
  maxToRenderPerBatch={10}
  windowSize={5}
  getItemType={(item) => item.type}  // For heterogeneous lists
/>
```

**Why FlashList over FlatList:**
- 10x better performance for large lists
- No blank screens during fast scrolling
- Better memory management
- Maintained by Shopify, production-proven

**CRITICAL ITEMS:**

- [ ] Use `@shopify/flash-list` for conversation list (not FlatList)
- [ ] Implement `estimatedItemSize` based on ConversationCard height
- [ ] Memoize ConversationCard with React.memo
- [ ] Use `getItemType` for priority conversations vs regular

### 3.2 Thread View Virtualization

**Challenge:** Thread view can have 500-1000+ messages.

**Solution: Inverted FlashList with Bottom Anchor**
```typescript
<FlashList
  data={messages}
  renderItem={({ item }) => <MessageBubble message={item} />}
  estimatedItemSize={80}
  inverted  // Chat-style (newest at bottom)
  maintainVisibleContentPosition={{
    minIndexForVisible: 0,
    autoscrollToTopThreshold: 10,
  }}
  onEndReached={loadMoreMessages}  // Pagination for old messages
  onEndReachedThreshold={0.5}
/>
```

**Message Bubble Optimization:**
```typescript
const MessageBubble = React.memo(({ message }) => {
  // Optimize renders - only re-render if message data changes
}, (prev, next) => prev.message.id === next.message.id);
```

**CRITICAL ITEMS:**

- [ ] Use FlashList inverted for thread view
- [ ] Implement pagination (load 50 messages at a time)
- [ ] Memoize MessageBubble to prevent unnecessary re-renders
- [ ] Use `maintainVisibleContentPosition` to prevent scroll jump when new messages load

### 3.3 Image Lazy Loading

**Challenge:** Profile photos and screenshots in conversation list.

**Solution: Expo Image with Blurhash**
```typescript
import { Image } from 'expo-image';

<Image
  source={{ uri: conversation.profilePhoto }}
  placeholder={conversation.blurhash}  // Tiny blurred placeholder
  contentFit="cover"
  transition={200}
  cachePolicy="memory-disk"  // Aggressive caching
  style={{ width: 60, height: 60, borderRadius: 30 }}
/>
```

**HIGH PRIORITY ITEMS:**

- [ ] Use `expo-image` (not `<Image>` from React Native)
- [ ] Generate blurhash placeholders on backend for all images
- [ ] Configure disk cache limits (100MB for images)
- [ ] Implement image compression for screenshot uploads (max 1MB)

---

## 4. Image Handling (Screenshot Upload, OCR, Caching)

### 4.1 Screenshot Upload Flow (CRITICAL)

**Step 1: Image Picker**
```typescript
import * as ImagePicker from 'expo-image-picker';

const pickImage = async () => {
  const { status } = await ImagePicker.requestMediaLibraryPermissionsAsync();
  if (status !== 'granted') {
    // Show error modal
    return;
  }

  const result = await ImagePicker.launchImageLibraryAsync({
    mediaTypes: ImagePicker.MediaTypeOptions.Images,
    allowsEditing: true,  // Built-in crop
    aspect: [9, 16],      // Portrait aspect for screenshots
    quality: 0.8,         // Compress to 80% quality
  });

  if (!result.canceled) {
    await uploadAndProcessImage(result.assets[0].uri);
  }
};
```

**Step 2: Image Cropping (CRITICAL UX)**
- Expo's `allowsEditing` provides basic crop
- For advanced crop: Consider `react-native-image-crop-picker`

**Step 3: Upload + OCR**
```typescript
const uploadAndProcessImage = async (uri: string) => {
  // Show loading state
  setIsProcessing(true);

  // Create FormData for multipart upload
  const formData = new FormData();
  formData.append('image', {
    uri,
    type: 'image/jpeg',
    name: 'screenshot.jpg',
  } as any);

  try {
    // Upload to backend
    const response = await fetch('https://api.tonehone.ai/v1/ocr/extract', {
      method: 'POST',
      body: formData,
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    const data = await response.json();

    // Show review screen with extracted data
    navigation.navigate('ReviewOCR', {
      extractedData: data,
      originalImage: uri
    });
  } catch (error) {
    // Show error with retry option
    showErrorToast('Failed to process image. Please try again.');
  } finally {
    setIsProcessing(false);
  }
};
```

**CRITICAL ITEMS:**

- [ ] Implement permission handling for camera roll (iOS: Info.plist, Android: AndroidManifest.xml)
- [ ] Add image compression before upload (target: <1MB per image)
- [ ] Implement retry logic for failed uploads
- [ ] Show progress indicator during OCR processing (3-5 seconds)
- [ ] Design OCR review screen for manual corrections

**HIGH PRIORITY ITEMS:**

- [ ] Implement image crop with aspect ratio guides for dating app screenshots
- [ ] Cache original images locally for re-processing if OCR fails
- [ ] Support batch upload (multiple screenshots at once)

### 4.2 Image Caching Strategy

**Three-Tier Caching:**

1. **Memory Cache (Fast, Limited):**
   - Expo Image handles this automatically
   - Keep 50-100 images in memory

2. **Disk Cache (Medium, 100MB limit):**
   - Expo Image handles this automatically
   - Configure in app.json:
   ```json
   {
     "expo": {
       "plugins": [
         [
           "expo-image",
           {
             "cacheLimit": 100  // 100MB
           }
         ]
       ]
     }
   }
   ```

3. **Remote Cache (Slow, Unlimited):**
   - CloudFront/Cloudflare CDN
   - Serve images via CDN URLs

**CRITICAL ITEMS:**

- [ ] Configure expo-image disk cache limit (100MB)
- [ ] Implement cache invalidation when user deletes conversation
- [ ] Preload profile images for conversations in viewport

---

## 5. Offline-First Architecture (CRITICAL)

### 5.1 Why Offline-First Matters for ToneHone

**User Scenarios Requiring Offline Support:**
1. User views conversation history on subway (no connection)
2. User drafts message refinements while offline
3. App syncs changes when connection restored
4. Cached conversation data prevents loading delays

**What Works Offline vs Requires Connection:**

| Feature | Offline Support | Notes |
|---------|----------------|-------|
| View conversation list | Full | Cached from last sync |
| View thread history | Full | All messages cached |
| View tone profiles | Full | Stored locally |
| Read insights | Full | Cached analytics |
| **Generate AI suggestions** | **Requires connection** | Cannot work offline |
| **OCR upload** | **Requires connection** | Cannot work offline |
| Add manual message | Partial | Can draft, syncs when online |
| Edit tone profile | Partial | Can edit, syncs when online |

### 5.2 Offline Storage Strategy

**Option A: AsyncStorage (Simple, Recommended for MVP)**
```typescript
import AsyncStorage from '@react-native-async-storage/async-storage';

// Simple key-value storage
// Good for: Conversations, messages, profiles, settings
// Limit: ~6MB on iOS, ~infinite on Android

// Example: Cache conversations
const cacheConversations = async (conversations) => {
  await AsyncStorage.setItem(
    '@conversations',
    JSON.stringify(conversations)
  );
};

const getCachedConversations = async () => {
  const data = await AsyncStorage.getItem('@conversations');
  return data ? JSON.parse(data) : [];
};
```

**Option B: WatermelonDB (Complex, Better for Scale)**
```typescript
// Reactive database with SQLite under the hood
// Good for: >1000 messages per conversation, complex queries
// Pros: Reactive (auto-updates UI), excellent performance
// Cons: Steeper learning curve, more setup

// Only consider if:
// - Users have 100+ conversations with 500+ messages each
// - Need complex filtering/search across all conversations
```

**RECOMMENDATION: Start with AsyncStorage, migrate to WatermelonDB if needed post-MVP.**

**CRITICAL ITEMS:**

- [ ] Use AsyncStorage for conversation and message caching
- [ ] Implement sync queue for offline changes (messages, tone edits)
- [ ] Show visual indicator when offline (banner or icon)
- [ ] Prevent AI generation when offline (show helpful error)
- [ ] Auto-retry failed syncs when connection restored

### 5.3 Sync Strategy with React Query

**React Query for Offline-First:**
```typescript
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';

// Fetch conversations with caching
const useConversations = () => {
  return useQuery({
    queryKey: ['conversations'],
    queryFn: fetchConversations,
    staleTime: 5 * 60 * 1000,  // Consider fresh for 5 minutes
    cacheTime: 24 * 60 * 60 * 1000,  // Keep in cache for 24 hours
    refetchOnMount: 'always',
    refetchOnReconnect: true,  // Auto-refetch when online
    placeholderData: (previousData) => previousData,  // Show stale data while refetching
  });
};

// Optimistic updates for adding messages
const useAddMessage = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: addMessage,
    onMutate: async (newMessage) => {
      // Cancel outgoing refetches
      await queryClient.cancelQueries({ queryKey: ['conversations', newMessage.conversationId] });

      // Snapshot previous value
      const previousMessages = queryClient.getQueryData(['conversations', newMessage.conversationId]);

      // Optimistically update
      queryClient.setQueryData(['conversations', newMessage.conversationId], (old) => {
        return [...old, { ...newMessage, id: 'temp-' + Date.now(), synced: false }];
      });

      return { previousMessages };
    },
    onError: (err, newMessage, context) => {
      // Rollback on error
      queryClient.setQueryData(
        ['conversations', newMessage.conversationId],
        context.previousMessages
      );
    },
    onSettled: (data, error, variables) => {
      // Refetch after mutation
      queryClient.invalidateQueries({ queryKey: ['conversations', variables.conversationId] });
    },
  });
};
```

**CRITICAL ITEMS:**

- [ ] Configure React Query with aggressive caching (24h cache time)
- [ ] Implement optimistic updates for message additions
- [ ] Implement retry logic for failed mutations (3 retries with exponential backoff)
- [ ] Persist React Query cache to AsyncStorage for true offline support:
  ```typescript
  import { createAsyncStoragePersister } from '@tanstack/query-async-storage-persister';

  const persister = createAsyncStoragePersister({
    storage: AsyncStorage,
  });
  ```

**HIGH PRIORITY ITEMS:**

- [ ] Implement background sync when app returns to foreground
- [ ] Show sync status indicator (syncing, synced, failed)
- [ ] Handle conflict resolution (e.g., message added on both offline client and server)

---

## 6. State Management Strategy (Zustand)

### 6.1 Why Zustand is Perfect for ToneHone

**PRD specifies Zustand. Excellent choice because:**
- Lightweight (~1KB)
- No boilerplate (unlike Redux)
- React Query handles server state, Zustand handles client state
- Easy to test
- Built-in TypeScript support
- No context provider hell

**State Ownership:**

| State Type | Manager | Example |
|------------|---------|---------|
| **Server State** | React Query | Conversations, messages, tone profiles (from API) |
| **Client State** | Zustand | UI state, navigation state, form drafts, filters |
| **Local State** | React useState | Component-specific state (modal open, input value) |

### 6.2 Zustand Store Architecture

**File Structure:**
```
packages/shared-logic/src/stores/
├── useConversationStore.ts   # Conversation hub state (filters, sorts)
├── useEditorStore.ts          # Refinement editor state
├── useAuthStore.ts            # Auth tokens, user info
└── index.ts
```

**Example: Conversation Hub Store**
```typescript
import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import AsyncStorage from '@react-native-async-storage/async-storage';

interface ConversationStore {
  // State
  filters: {
    platforms: string[];
    tones: string[];
    status: 'all' | 'needs-response' | 'active' | 'stale';
  };
  sortBy: 'recent' | 'alphabetical' | 'priority';
  searchQuery: string;

  // Actions
  setFilters: (filters: Partial<ConversationStore['filters']>) => void;
  setSortBy: (sortBy: ConversationStore['sortBy']) => void;
  setSearchQuery: (query: string) => void;
  clearFilters: () => void;
}

export const useConversationStore = create<ConversationStore>()(
  persist(
    (set) => ({
      // Initial state
      filters: {
        platforms: [],
        tones: [],
        status: 'all',
      },
      sortBy: 'recent',
      searchQuery: '',

      // Actions
      setFilters: (filters) => set((state) => ({
        filters: { ...state.filters, ...filters },
      })),
      setSortBy: (sortBy) => set({ sortBy }),
      setSearchQuery: (query) => set({ searchQuery: query }),
      clearFilters: () => set({
        filters: { platforms: [], tones: [], status: 'all' },
        searchQuery: '',
      }),
    }),
    {
      name: 'conversation-store',
      storage: {
        getItem: async (name) => {
          const value = await AsyncStorage.getItem(name);
          return value ? JSON.parse(value) : null;
        },
        setItem: async (name, value) => {
          await AsyncStorage.setItem(name, JSON.stringify(value));
        },
        removeItem: async (name) => {
          await AsyncStorage.removeItem(name);
        },
      },
    }
  )
);
```

**Example: Refinement Editor Store**
```typescript
interface Annotation {
  id: string;
  type: 'keep' | 'adjust' | 'replace' | 'delete';
  text: string;
  instruction?: string;
}

interface EditorStore {
  currentIteration: string;  // Current text being edited
  iterations: string[];      // Version history
  annotations: Annotation[];

  setCurrentIteration: (text: string) => void;
  addAnnotation: (annotation: Annotation) => void;
  removeAnnotation: (id: string) => void;
  clearAnnotations: () => void;
  undoIteration: () => void;
  reset: () => void;
}

export const useEditorStore = create<EditorStore>((set) => ({
  currentIteration: '',
  iterations: [],
  annotations: [],

  setCurrentIteration: (text) => set((state) => ({
    currentIteration: text,
    iterations: [...state.iterations, text],
  })),
  addAnnotation: (annotation) => set((state) => ({
    annotations: [...state.annotations, annotation],
  })),
  removeAnnotation: (id) => set((state) => ({
    annotations: state.annotations.filter((a) => a.id !== id),
  })),
  clearAnnotations: () => set({ annotations: [] }),
  undoIteration: () => set((state) => {
    const newIterations = state.iterations.slice(0, -1);
    return {
      iterations: newIterations,
      currentIteration: newIterations[newIterations.length - 1] || '',
    };
  }),
  reset: () => set({
    currentIteration: '',
    iterations: [],
    annotations: [],
  }),
}));
```

**CRITICAL ITEMS:**

- [ ] Set up Zustand stores in `packages/shared-logic/src/stores/`
- [ ] Implement persistence for conversation filters (user preference)
- [ ] Implement editor store for refinement workflow state
- [ ] Create auth store for token management
- [ ] Do NOT use Zustand for server data (use React Query instead)

**HIGH PRIORITY ITEMS:**

- [ ] Add devtools integration for debugging:
  ```typescript
  import { devtools } from 'zustand/middleware';

  export const useStore = create(
    devtools(
      (set) => ({ ... }),
      { name: 'ConversationStore' }
    )
  );
  ```
- [ ] Implement Zustand selectors for performance:
  ```typescript
  // Bad: Re-renders on any store change
  const store = useConversationStore();

  // Good: Only re-renders when filters change
  const filters = useConversationStore((state) => state.filters);
  ```

---

## 7. Navigation Patterns

### 7.1 Mobile Navigation Structure (CRITICAL)

**Recommended: React Navigation v6 with Bottom Tabs**

**Navigation Hierarchy:**
```
AppNavigator
├── AuthStack (if not logged in)
│   ├── Login
│   ├── Signup
│   └── Onboarding
└── MainTabs (bottom tabs)
    ├── ConversationTab
    │   └── ConversationStack
    │       ├── ConversationHub (list)
    │       ├── ThreadView
    │       ├── RefinementEditor (modal)
    │       └── ToneProfileEditor (modal)
    ├── InsightsTab
    │   └── InsightsStack
    │       ├── Dashboard
    │       └── ConversationInsights
    ├── TemplatesTab
    │   └── TemplatesStack
    │       ├── TemplateLibrary
    │       └── TemplateEditor
    └── SettingsTab
        └── SettingsStack
            ├── Settings
            ├── Billing
            └── Privacy
```

**Bottom Tab Implementation:**
```typescript
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { Ionicons } from '@expo/vector-icons';

const Tab = createBottomTabNavigator();

function MainTabs() {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        tabBarIcon: ({ focused, color, size }) => {
          const icons = {
            Conversations: focused ? 'chatbubbles' : 'chatbubbles-outline',
            Insights: focused ? 'analytics' : 'analytics-outline',
            Templates: focused ? 'documents' : 'documents-outline',
            Settings: focused ? 'settings' : 'settings-outline',
          };
          return <Ionicons name={icons[route.name]} size={size} color={color} />;
        },
        tabBarActiveTintColor: '#1E3A8A',  // Brand primary
        tabBarInactiveTintColor: '#6B7280',
        headerShown: false,
      })}
    >
      <Tab.Screen name="Conversations" component={ConversationStack} />
      <Tab.Screen name="Insights" component={InsightsStack} />
      <Tab.Screen name="Templates" component={TemplatesStack} />
      <Tab.Screen name="Settings" component={SettingsStack} />
    </Tab.Navigator>
  );
}
```

**Modal Navigation (Refinement Editor):**
```typescript
import { createNativeStackNavigator } from '@react-navigation/native-stack';

const Stack = createNativeStackNavigator();

function ConversationStack() {
  return (
    <Stack.Navigator>
      <Stack.Screen
        name="ConversationHub"
        component={ConversationHub}
        options={{ title: 'Conversations' }}
      />
      <Stack.Screen
        name="ThreadView"
        component={ThreadView}
        options={({ route }) => ({
          title: route.params.personName,
          headerBackTitle: 'Back',
        })}
      />
      {/* Modal screens */}
      <Stack.Group screenOptions={{ presentation: 'modal' }}>
        <Stack.Screen
          name="RefinementEditor"
          component={RefinementEditor}
          options={{ title: 'Refine Message' }}
        />
        <Stack.Screen
          name="ToneProfileEditor"
          component={ToneProfileEditor}
          options={{ title: 'Edit Tone' }}
        />
      </Stack.Group>
    </Stack.Navigator>
  );
}
```

**CRITICAL ITEMS:**

- [ ] Set up React Navigation with bottom tabs as primary navigation
- [ ] Implement stack navigators for each tab
- [ ] Use modal presentation for refinement editor and tone editor
- [ ] Configure deep linking for push notifications and web sharing
- [ ] Implement navigation state persistence (restore on app restart)

**HIGH PRIORITY ITEMS:**

- [ ] Add floating action button (FAB) on ConversationHub for "Add Conversation"
- [ ] Implement swipe gestures for navigation (swipe back, swipe to delete)
- [ ] Add navigation guards for unsaved changes in editor

### 7.2 Deep Linking Strategy

**Deep Link Scenarios:**
1. Push notification: "New match replied!" → Opens specific thread
2. Web share: Share conversation link → Opens app to that conversation
3. Email: Billing receipt → Opens Settings > Billing

**Configuration:**
```typescript
// app.json
{
  "expo": {
    "scheme": "tonehone",
    "android": {
      "intentFilters": [
        {
          "action": "VIEW",
          "data": [
            {
              "scheme": "https",
              "host": "tonehone.app",
              "pathPrefix": "/conversations"
            }
          ]
        }
      ]
    },
    "ios": {
      "associatedDomains": ["applinks:tonehone.app"]
    }
  }
}

// Linking configuration
const linking = {
  prefixes: ['tonehone://', 'https://tonehone.app'],
  config: {
    screens: {
      MainTabs: {
        screens: {
          Conversations: {
            screens: {
              ThreadView: 'conversations/:id',
            },
          },
        },
      },
    },
  },
};

<NavigationContainer linking={linking}>
  <AppNavigator />
</NavigationContainer>
```

**CRITICAL ITEMS:**

- [ ] Configure deep linking for conversation threads
- [ ] Set up associated domains for iOS universal links
- [ ] Implement Android intent filters for app links
- [ ] Handle authentication in deep link flow (redirect to login if needed)

---

## 8. Mobile-Specific UX Challenges

### 8.1 Split-View Editor on Mobile (CRITICAL CHALLENGE)

**The Problem:**
- PRD describes split-view refinement editor (left: original, right: edited)
- Mobile screens (390px wide on iPhone 14) cannot fit two text columns comfortably
- Horizontal split = ~175px per column = unreadable

**Solution: Swipeable Tabs with Visual Diff**

**Design A: Swipeable Panes (Recommended)**
```typescript
import { TabView, SceneMap, TabBar } from 'react-native-tab-view';

const RefinementEditorMobile = () => {
  const [index, setIndex] = useState(0);
  const [routes] = useState([
    { key: 'original', title: 'Original' },
    { key: 'refined', title: 'Refined' },
  ]);

  const renderScene = SceneMap({
    original: OriginalPane,
    refined: RefinedPane,
  });

  return (
    <TabView
      navigationState={{ index, routes }}
      renderScene={renderScene}
      onIndexChange={setIndex}
      renderTabBar={(props) => (
        <TabBar
          {...props}
          indicatorStyle={{ backgroundColor: '#1E3A8A' }}
          style={{ backgroundColor: 'white' }}
        />
      )}
      swipeEnabled={true}  // Swipe between panes
    />
  );
};
```

**Design B: Expandable Accordion (Alternative)**
- Show refined version by default
- "Show Original" button expands accordion above
- User can collapse/expand to compare

**Design C: Overlay Diff View**
- Show refined version by default
- Tap "Compare" button
- Original text shows in translucent overlay
- Differences highlighted

**CRITICAL ITEMS:**

- [ ] Implement swipeable tab view for refinement editor on mobile
- [ ] Design bottom sheet for annotation menu (replace right-click context menu)
- [ ] Test text selection UX on mobile (long-press to select, menu appears)
- [ ] Implement haptic feedback for text selection and annotations

**HIGH PRIORITY ITEMS:**

- [ ] Add visual indicators for changes (highlight modified sections)
- [ ] Implement "Compare" mode with side-by-side scroll sync on larger phones
- [ ] Design keyboard shortcuts for iPad (Cmd+K for keep, etc.)

### 8.2 Tone Sliders on Mobile

**The Problem:**
- PRD specifies 4 tone dimensions with 1-10 sliders
- Sliders need to be precise but also thumb-friendly
- Need real-time preview of tone effect

**Solution: Vertical Sliders with Haptic Feedback**

```typescript
import Slider from '@react-native-community/slider';
import * as Haptics from 'expo-haptics';

const ToneSlider = ({ label, value, onChange }) => {
  const handleValueChange = (newValue) => {
    // Haptic feedback at each integer step
    if (Math.round(newValue) !== Math.round(value)) {
      Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    }
    onChange(Math.round(newValue));
  };

  return (
    <View style={styles.sliderContainer}>
      <Text style={styles.label}>{label}</Text>
      <View style={styles.sliderRow}>
        <Text style={styles.minLabel}>1</Text>
        <Slider
          style={styles.slider}
          minimumValue={1}
          maximumValue={10}
          step={1}
          value={value}
          onValueChange={handleValueChange}
          minimumTrackTintColor="#1E3A8A"
          maximumTrackTintColor="#E5E7EB"
          thumbTintColor="#1E3A8A"
        />
        <Text style={styles.maxLabel}>10</Text>
      </View>
      <Text style={styles.valueLabel}>{value}</Text>
    </View>
  );
};
```

**Layout Options:**

**Option A: Vertical Stack (Recommended for Mobile)**
```
[Playfulness]    [Witty ← ● → Straightforward]    [7]
[Formality]      [Casual ← ● → Proper]             [3]
[Forwardness]    [Subtle ← ● → Direct]             [6]
[Expressiveness] [Reserved ← ● → Enthusiastic]     [8]
```

**Option B: Radar Chart (Tablet/iPad)**
- Shows all 4 dimensions in spider chart
- Tap dimension to adjust with slider
- More visual, less precise

**CRITICAL ITEMS:**

- [ ] Use `@react-native-community/slider` (built-in Slider is deprecated)
- [ ] Implement haptic feedback for slider steps
- [ ] Add real-time preview text showing tone effect
- [ ] Design preset tone cards (tap to apply entire profile)

**HIGH PRIORITY ITEMS:**

- [ ] Add "Reset to Default" button for each slider
- [ ] Implement tone profile comparison view (current vs preset)
- [ ] Design radar chart visualization for tone overview

### 8.3 Screenshot Upload UX

**Critical Flow:**
1. User taps "+" in conversation hub
2. Options: "Upload Screenshot" | "Paste Text" | "Manual Entry"
3. User taps "Upload Screenshot"
4. Native image picker opens (camera roll)
5. User selects screenshot
6. **Crop screen** with guides for dating app UI
7. User confirms crop
8. Loading screen: "Reading conversation..." (3-5s OCR)
9. **Review screen** with extracted messages (editable)
10. User confirms or corrects
11. Conversation created and added to hub

**UX Enhancements:**

**A. Crop Guides for Popular Apps**
```typescript
const CROP_PRESETS = {
  hinge: { aspect: [9, 19.5], guideText: 'Align top with match name' },
  bumble: { aspect: [9, 19.5], guideText: 'Include full conversation' },
  tinder: { aspect: [9, 16], guideText: 'Capture all messages' },
};

// Show platform selection before crop
// Apply appropriate aspect ratio and guide text
```

**B. Multi-Screenshot Upload**
```typescript
// Allow selecting multiple screenshots at once
const pickMultipleImages = async () => {
  const result = await ImagePicker.launchImageLibraryAsync({
    mediaTypes: ImagePicker.MediaTypeOptions.Images,
    allowsMultipleSelection: true,  // iOS 14+
    quality: 0.8,
  });

  // Process each image in sequence
  // Show progress: "Processing 2 of 5 screenshots..."
};
```

**C. OCR Confidence Warnings**
```typescript
// After OCR processing
if (ocrResult.confidence < 0.85) {
  showAlert(
    'Low Confidence',
    'We had trouble reading this screenshot. Please review carefully.',
    [{ text: 'Review', onPress: () => navigateToReview() }]
  );
}
```

**CRITICAL ITEMS:**

- [ ] Design crop screen with platform-specific guides
- [ ] Implement OCR loading screen with progress indicator
- [ ] Design review screen for manual corrections
- [ ] Add platform auto-detection from screenshot UI
- [ ] Implement error states (OCR failed, low confidence, network error)

**HIGH PRIORITY ITEMS:**

- [ ] Support batch screenshot upload (import full conversation at once)
- [ ] Add screenshot tips screen ("For best results, capture full conversation")
- [ ] Implement re-process option if OCR extraction is wrong

---

## 9. Push Notifications and Background Sync

### 9.1 Push Notification Strategy

**Use Cases for Push Notifications:**

1. **Re-engagement (Primary):**
   - "You have 3 conversations waiting for responses"
   - "Sarah replied 2 hours ago - time to respond?"
   - Trigger: User hasn't opened app in 24h + has pending conversations

2. **Insights (Secondary):**
   - "Your 'Thoughtful' tone has 40% higher reply rates"
   - "You're most successful messaging in evenings"
   - Trigger: Weekly insights summary

3. **Credit Reminders:**
   - "You have 5 credits remaining"
   - "Your Pro subscription renews tomorrow"

**Implementation with Expo Push:**

```typescript
import * as Notifications from 'expo-notifications';
import Constants from 'expo-constants';

// Request permission
const registerForPushNotifications = async () => {
  if (Constants.isDevice) {
    const { status: existingStatus } = await Notifications.getPermissionsAsync();
    let finalStatus = existingStatus;

    if (existingStatus !== 'granted') {
      const { status } = await Notifications.requestPermissionsAsync();
      finalStatus = status;
    }

    if (finalStatus !== 'granted') {
      alert('Failed to get push token for notifications!');
      return;
    }

    const token = (await Notifications.getExpoPushTokenAsync()).data;

    // Send token to backend
    await sendTokenToBackend(token);
  }
};

// Handle notification tap
Notifications.addNotificationResponseReceivedListener((response) => {
  const { conversationId } = response.notification.request.content.data;

  if (conversationId) {
    navigation.navigate('ThreadView', { id: conversationId });
  }
});

// Configure notification behavior
Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: true,
    shouldSetBadge: true,
  }),
});
```

**Backend Notification Sending:**
```typescript
// Node.js backend
import { Expo } from 'expo-server-sdk';

const expo = new Expo();

const sendPushNotification = async (userId: string, message: string, data: any) => {
  const user = await getUserPushToken(userId);

  if (!Expo.isExpoPushToken(user.pushToken)) {
    return;
  }

  const notification = {
    to: user.pushToken,
    sound: 'default',
    title: 'ToneHone',
    body: message,
    data,
    badge: 1,
  };

  await expo.sendPushNotificationsAsync([notification]);
};
```

**CRITICAL ITEMS:**

- [ ] Implement push notification permission request (during onboarding)
- [ ] Send Expo push token to backend on registration
- [ ] Implement deep linking from notifications to specific conversations
- [ ] Design notification copy (friendly, not spammy)
- [ ] Implement badge count for unread/pending conversations

**HIGH PRIORITY ITEMS:**

- [ ] Add notification preferences in settings (which types to receive)
- [ ] Implement quiet hours (no notifications 10pm-8am)
- [ ] Add notification action buttons ("Reply" opens app, "Snooze" delays)

### 9.2 Background Sync Strategy

**Challenge:** Mobile apps are suspended when backgrounded. How to sync data?

**Solution A: App State Change Sync (Recommended for MVP)**
```typescript
import { AppState } from 'react-native';

useEffect(() => {
  const subscription = AppState.addEventListener('change', (nextAppState) => {
    if (nextAppState === 'active') {
      // App came to foreground - sync now
      queryClient.refetchQueries({ queryKey: ['conversations'] });
      queryClient.refetchQueries({ queryKey: ['messages'] });
    }
  });

  return () => {
    subscription.remove();
  };
}, []);
```

**Solution B: Background Fetch (iOS)**
```typescript
import * as BackgroundFetch from 'expo-background-fetch';
import * as TaskManager from 'expo-task-manager';

const BACKGROUND_FETCH_TASK = 'background-fetch';

TaskManager.defineTask(BACKGROUND_FETCH_TASK, async () => {
  // Fetch new messages from API
  const newMessages = await fetchNewMessages();

  if (newMessages.length > 0) {
    // Schedule local notification
    await Notifications.scheduleNotificationAsync({
      content: {
        title: 'New Messages',
        body: `You have ${newMessages.length} new messages`,
      },
      trigger: null,  // Immediate
    });
  }

  return BackgroundFetch.BackgroundFetchResult.NewData;
});

// Register background fetch
BackgroundFetch.registerTaskAsync(BACKGROUND_FETCH_TASK, {
  minimumInterval: 60 * 15,  // 15 minutes (iOS minimum)
  stopOnTerminate: false,
  startOnBoot: true,
});
```

**CRITICAL ITEMS:**

- [ ] Implement foreground sync on app activation
- [ ] Use React Query's `refetchOnReconnect` for automatic sync
- [ ] Implement offline queue for mutations (send when online)

**HIGH PRIORITY ITEMS (Post-MVP):**

- [ ] Implement background fetch for iOS (check for new messages every 15 min)
- [ ] Implement WorkManager for Android (background sync)
- [ ] Add sync status indicator in UI ("Last synced 5 minutes ago")

---

## 10. Testing Strategy for Mobile

### 10.1 Testing Pyramid

**Unit Tests (70%):**
- Test business logic in `packages/shared-logic`
- Test Zustand stores
- Test utility functions
- Tool: Jest

**Integration Tests (20%):**
- Test React components with mocked API
- Test navigation flows
- Test React Query hooks
- Tool: Jest + React Native Testing Library

**E2E Tests (10%):**
- Test critical user flows on real devices
- Test on iOS and Android
- Tool: Detox or Maestro

### 10.2 Unit Testing (CRITICAL)

**Testing Zustand Stores:**
```typescript
// useConversationStore.test.ts
import { renderHook, act } from '@testing-library/react-hooks';
import { useConversationStore } from './useConversationStore';

describe('useConversationStore', () => {
  beforeEach(() => {
    useConversationStore.setState({
      filters: { platforms: [], tones: [], status: 'all' },
      sortBy: 'recent',
      searchQuery: '',
    });
  });

  it('should update filters', () => {
    const { result } = renderHook(() => useConversationStore());

    act(() => {
      result.current.setFilters({ platforms: ['hinge'] });
    });

    expect(result.current.filters.platforms).toEqual(['hinge']);
  });

  it('should clear filters', () => {
    const { result } = renderHook(() => useConversationStore());

    act(() => {
      result.current.setFilters({ platforms: ['hinge'] });
      result.current.clearFilters();
    });

    expect(result.current.filters.platforms).toEqual([]);
  });
});
```

**Testing React Query Hooks:**
```typescript
// useConversations.test.ts
import { renderHook, waitFor } from '@testing-library/react-hooks';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useConversations } from './useConversations';

const createWrapper = () => {
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: { retry: false },
    },
  });

  return ({ children }) => (
    <QueryClientProvider client={queryClient}>
      {children}
    </QueryClientProvider>
  );
};

describe('useConversations', () => {
  it('should fetch conversations', async () => {
    const { result } = renderHook(() => useConversations(), {
      wrapper: createWrapper(),
    });

    await waitFor(() => expect(result.current.isSuccess).toBe(true));

    expect(result.current.data).toBeDefined();
  });
});
```

**CRITICAL ITEMS:**

- [ ] Set up Jest for unit testing
- [ ] Write tests for all Zustand stores (80%+ coverage)
- [ ] Write tests for all React Query hooks
- [ ] Write tests for utility functions (date formatting, tone calculations, etc.)
- [ ] Set up CI to run tests on every PR

### 10.3 Component Testing

**Testing React Components:**
```typescript
// ConversationCard.test.tsx
import { render, fireEvent } from '@testing-library/react-native';
import { ConversationCard } from './ConversationCard';

const mockConversation = {
  id: '1',
  personName: 'Sarah',
  platform: 'hinge',
  lastMessage: 'Hey there!',
  lastActivity: new Date('2025-11-27T10:00:00'),
  toneProfile: 'playful',
  healthScore: 4,
  needsResponse: true,
};

describe('ConversationCard', () => {
  it('should render conversation details', () => {
    const { getByText } = render(
      <ConversationCard conversation={mockConversation} />
    );

    expect(getByText('Sarah')).toBeTruthy();
    expect(getByText('Hey there!')).toBeTruthy();
  });

  it('should call onPress when tapped', () => {
    const onPress = jest.fn();
    const { getByTestId } = render(
      <ConversationCard
        conversation={mockConversation}
        onPress={onPress}
      />
    );

    fireEvent.press(getByTestId('conversation-card'));

    expect(onPress).toHaveBeenCalledWith(mockConversation.id);
  });

  it('should show needs-response indicator', () => {
    const { getByTestId } = render(
      <ConversationCard conversation={mockConversation} />
    );

    expect(getByTestId('needs-response-badge')).toBeTruthy();
  });
});
```

**CRITICAL ITEMS:**

- [ ] Set up React Native Testing Library
- [ ] Write tests for ConversationCard, MessageBubble, ToneSlider
- [ ] Test accessibility (screen reader compatibility)
- [ ] Test responsive layout (different screen sizes)

### 10.4 E2E Testing (HIGH PRIORITY)

**Tool Recommendation: Maestro (easier than Detox)**

```yaml
# .maestro/onboarding.yaml
appId: com.tonehone.app
---
- launchApp
- assertVisible: "Welcome to ToneHone"
- tapOn: "Get Started"
- inputText: "test@example.com"
- tapOn: "Continue"
- assertVisible: "Create your first conversation"
```

**Critical E2E Test Flows:**
1. **Onboarding:** Sign up → Create first conversation → Upload screenshot
2. **Core Flow:** View dashboard → Open thread → Generate suggestions → Refine → Copy
3. **Offline:** Disconnect network → View cached conversations → Reconnect → Sync

**CRITICAL ITEMS:**

- [ ] Set up Maestro for E2E testing
- [ ] Write test for core user flow (dashboard → thread → generate → refine)
- [ ] Write test for screenshot upload flow
- [ ] Test on iOS and Android devices

**HIGH PRIORITY ITEMS:**

- [ ] Test offline behavior (cache, sync queue)
- [ ] Test push notification deep linking
- [ ] Test error states (network failure, API errors)

---

## 11. Priority Breakdown

### 11.1 CRITICAL ITEMS (Must Address for MVP)

**Architecture & Setup:**
- [ ] **DECISION:** Commit to React Native/Expo or native SwiftUI
- [ ] If React Native: Set up Expo managed workflow with monorepo structure
- [ ] Configure Turborepo with `packages/shared-logic`, `packages/shared-ui`
- [ ] Set up React Query with persistence for offline support
- [ ] Set up Zustand stores for client state

**Performance:**
- [ ] Use `@shopify/flash-list` for conversation list (not FlatList)
- [ ] Use `expo-image` for all images with blurhash placeholders
- [ ] Implement message pagination in thread view (50 messages at a time)
- [ ] Memoize ConversationCard and MessageBubble components

**Offline-First:**
- [ ] Use AsyncStorage for conversation caching
- [ ] Configure React Query with 24h cache time and persistence
- [ ] Implement optimistic updates for message additions
- [ ] Show offline indicator when network unavailable

**Image Handling:**
- [ ] Implement screenshot upload with `expo-image-picker`
- [ ] Design OCR review screen for manual corrections
- [ ] Implement image compression (max 1MB per upload)
- [ ] Configure expo-image disk cache (100MB limit)

**Navigation:**
- [ ] Set up React Navigation with bottom tabs
- [ ] Implement modal presentation for refinement editor
- [ ] Configure deep linking for push notifications

**Mobile UX:**
- [ ] Design swipeable tabs for refinement editor (not split-view)
- [ ] Implement tone sliders with haptic feedback
- [ ] Design bottom sheet for annotation menu on mobile
- [ ] Implement text selection UX (long-press + context menu)

**Testing:**
- [ ] Set up Jest for unit tests (Zustand stores, React Query hooks)
- [ ] Write tests for critical business logic (80%+ coverage)
- [ ] Set up React Native Testing Library for component tests

### 11.2 HIGH PRIORITY ITEMS (Should Address for v1.0)

**Performance:**
- [ ] Implement virtualized scrolling for 1000+ message threads
- [ ] Generate and serve blurhash placeholders for all images
- [ ] Implement background image preloading

**Offline-First:**
- [ ] Implement sync queue for offline changes
- [ ] Add sync status indicator ("Last synced 5 minutes ago")
- [ ] Implement conflict resolution for offline changes

**Image Handling:**
- [ ] Support batch screenshot upload
- [ ] Add platform-specific crop guides (Hinge, Bumble, Tinder)
- [ ] Implement screenshot tips screen

**Push Notifications:**
- [ ] Implement push notification permission request
- [ ] Send Expo push token to backend
- [ ] Implement badge count for pending conversations
- [ ] Add notification preferences in settings

**Mobile UX:**
- [ ] Add visual diff highlighting in refinement editor
- [ ] Implement radar chart visualization for tone profiles
- [ ] Design keyboard shortcuts for iPad

**Testing:**
- [ ] Set up Maestro for E2E testing
- [ ] Write E2E test for core user flow
- [ ] Test on physical iOS and Android devices
- [ ] Test offline behavior

### 11.3 NICE-TO-HAVE ITEMS (Future Enhancements)

**Performance:**
- [ ] Evaluate WatermelonDB if AsyncStorage performance degrades
- [ ] Implement request deduplication for parallel API calls
- [ ] Add bundle size analysis and code splitting

**Offline-First:**
- [ ] Implement background fetch for iOS (check for new messages every 15 min)
- [ ] Implement WorkManager for Android background sync
- [ ] Add conflict resolution UI for diverged data

**Image Handling:**
- [ ] Implement AI-powered crop detection (auto-crop to conversation area)
- [ ] Add image editing tools (brightness, contrast, crop fine-tuning)
- [ ] Support screenshot stitching (combine multiple screenshots)

**Push Notifications:**
- [ ] Implement quiet hours (no notifications 10pm-8am)
- [ ] Add notification action buttons ("Reply", "Snooze")
- [ ] Implement rich notifications with message preview

**Mobile UX:**
- [ ] Implement 3D Touch / Haptic Touch preview for conversations
- [ ] Add Siri Shortcuts ("Generate response for Sarah")
- [ ] Implement Apple Watch companion app (view conversations)
- [ ] Add iPad split-view support (sidebar + detail)

**Testing:**
- [ ] Implement visual regression testing (screenshot diffs)
- [ ] Add performance testing (measure FPS, memory usage)
- [ ] Implement chaos testing (random API failures)

---

## 12. Technical Risks and Mitigation Strategies

### Risk 1: React Native Performance for Complex Text Editing

**Risk Level:** HIGH
**Impact:** Refinement editor could feel sluggish on mid-range Android devices

**Mitigation:**
- Use `react-native-reanimated` for smooth animations
- Debounce text input (300ms) before triggering re-renders
- Use `React.memo` aggressively on text components
- Test on low-end Android device (e.g., Samsung Galaxy A13)
- Fallback: Simplify editor on low-end devices (remove real-time preview)

### Risk 2: OCR Accuracy on Varied Screenshot Quality

**Risk Level:** MEDIUM
**Impact:** Users frustrated by poor OCR extraction, abandon feature

**Mitigation:**
- Set minimum image quality requirements (show tips before upload)
- Implement manual review screen (always show extracted data for confirmation)
- Add "Re-process" option if OCR fails
- Use Google Cloud Vision API (95%+ accuracy on clear screenshots)
- Fallback: Allow manual text paste if screenshot upload fails

### Risk 3: Offline Sync Conflicts

**Risk Level:** MEDIUM
**Impact:** User adds message offline, server already has newer message, conflict on sync

**Mitigation:**
- Implement "last write wins" for simple conflicts
- For critical conflicts (tone profile changed on both client and server):
  - Show conflict resolution modal
  - Let user choose which version to keep
- Use timestamps for conflict detection
- Test offline scenarios extensively

### Risk 4: App Store Rejection (Dating/AI Content)

**Risk Level:** LOW-MEDIUM
**Impact:** App rejected by Apple for "dating scam" or "inappropriate content"

**Mitigation:**
- Clearly position as "communication tool" not "dating bot" in App Store description
- Implement content moderation (optional profanity filter)
- Add privacy policy and terms of service (required for App Store)
- Include "Human in the loop" messaging (AI assists, user controls)
- Prepare App Review notes explaining the product's value

### Risk 5: High API Costs (Claude/GPT-4)

**Risk Level:** MEDIUM
**Impact:** AI generation costs exceed revenue, negative unit economics

**Mitigation:**
- Implement aggressive prompt optimization (reduce token usage)
- Cache conversation context in Redis (avoid re-sending full history)
- Set per-user rate limits (10 generations per 5 minutes)
- Implement credit system to gate usage
- Monitor per-user costs in real-time, flag abusers
- Consider cheaper models for non-critical features (e.g., tone analysis)

### Risk 6: Cross-Platform UI Inconsistencies

**Risk Level:** LOW
**Impact:** App looks/feels different on iOS vs Android, confusing users

**Mitigation:**
- Use shared design system (`packages/design-system`)
- Test on both platforms regularly (not just iOS)
- Use platform-specific components where appropriate:
  - iOS: Bottom sheet, haptic feedback
  - Android: Material Design ripple effects, FAB
- Follow platform conventions (iOS: swipe back, Android: hardware back button)

### Risk 7: Large Bundle Size (Expo)

**Risk Level:** LOW
**Impact:** Slow app downloads, user drop-off during install

**Mitigation:**
- Use Expo EAS Build (optimized builds)
- Enable Hermes engine (faster JS execution, smaller bundle)
- Use code splitting for optional features
- Remove unused dependencies
- Target bundle size: <50MB (iOS), <30MB (Android)

---

## 13. Recommended Development Sequence

### Phase 1: Foundation (Weeks 1-2)

**Goal:** Set up architecture, prove core technologies work

1. **Decision & Setup:**
   - Commit to React Native/Expo or SwiftUI
   - Initialize Expo project with TypeScript
   - Set up monorepo (Turborepo)
   - Configure shared packages

2. **Core Infrastructure:**
   - Set up React Query with persistence
   - Set up Zustand stores
   - Implement auth flow (login/signup screens)
   - Set up navigation (bottom tabs, stacks)

3. **Proof of Concept:**
   - Build simple conversation list (hardcoded data)
   - Build simple thread view (hardcoded messages)
   - Test FlashList performance with 100+ items

**Deliverable:** Working app shell with navigation and data fetching

### Phase 2: Core Features (Weeks 3-5)

**Goal:** Implement MVP features (conversation hub, thread view, tone profiles)

1. **Conversation Hub:**
   - ConversationCard component
   - Filters and search
   - Add conversation flow

2. **Thread View:**
   - Message list with FlashList
   - Message bubble component
   - Add message (manual text input)

3. **Tone Profiles:**
   - Tone slider component
   - Preset tone profiles
   - Save/load tone per conversation

**Deliverable:** Users can create conversations and set tone profiles

### Phase 3: AI Integration (Weeks 6-7)

**Goal:** Implement AI generation and refinement

1. **AI Suggestions:**
   - Generate suggestions API integration
   - Suggestion cards UI
   - Regenerate functionality

2. **Refinement Editor (Mobile):**
   - Swipeable tab view
   - Text selection (long-press)
   - Annotation menu (bottom sheet)
   - Refinement API integration

**Deliverable:** Users can generate and refine AI suggestions

### Phase 4: Image Upload & OCR (Week 8)

**Goal:** Screenshot upload works end-to-end

1. **Image Upload:**
   - Expo Image Picker integration
   - Image crop screen
   - Upload to backend

2. **OCR Integration:**
   - OCR API integration
   - Review screen for extracted data
   - Error handling

**Deliverable:** Users can import conversations via screenshot

### Phase 5: Offline & Performance (Week 9)

**Goal:** App works offline, performs well

1. **Offline Support:**
   - AsyncStorage caching
   - React Query persistence
   - Offline indicator

2. **Performance Optimization:**
   - Memoization (React.memo)
   - Image optimization (blurhash, compression)
   - Bundle size optimization

**Deliverable:** App works offline and scrolls smoothly

### Phase 6: Push Notifications & Polish (Week 10)

**Goal:** Re-engagement, UX polish

1. **Push Notifications:**
   - Expo Push setup
   - Permission request
   - Deep linking from notifications

2. **UX Polish:**
   - Loading states
   - Error states
   - Empty states
   - Haptic feedback

**Deliverable:** Production-ready MVP

### Phase 7: Testing & Launch (Weeks 11-12)

**Goal:** Ship to App Store

1. **Testing:**
   - Unit tests (80%+ coverage)
   - E2E tests (critical flows)
   - Device testing (iOS, Android)

2. **App Store Submission:**
   - App Store Connect setup
   - Screenshots, description
   - Privacy policy, terms of service
   - Submit for review

**Deliverable:** App live on App Store

---

## 14. Conclusion and Recommendations

### Critical Next Steps

1. **IMMEDIATE (This Week):**
   - Make platform decision: React Native/Expo or native SwiftUI
   - If React Native: Archive SwiftUI code, initialize Expo project
   - Set up monorepo structure
   - Create ROADMAP.md with prioritized tasks

2. **WEEK 1:**
   - Set up Expo with TypeScript and navigation
   - Implement auth screens
   - Build conversation hub with hardcoded data
   - Test FlashList performance

3. **WEEK 2-4:**
   - Implement conversation hub (list, filters, add conversation)
   - Implement thread view (message list, add message)
   - Implement tone profiles (sliders, presets)

### Final Recommendation

**React Native/Expo is the right choice for ToneHone because:**

1. **Time to Market:** 70-80% code reuse across iOS, Android, Web = 3x faster than native
2. **Team Velocity:** Single codebase = easier maintenance, faster iterations
3. **Proven at Scale:** Used by Discord, Shopify, Microsoft for production apps
4. **Ecosystem Maturity:** All required features available (FlashList, Expo Image, navigation, etc.)
5. **Cost Efficiency:** Shared business logic, API clients, and state management

**Risks are manageable:**
- Performance: Mitigated by FlashList, memoization, and testing on low-end devices
- Platform differences: Mitigated by platform-specific code where needed
- OCR accuracy: Mitigated by manual review screen and Google Cloud Vision API

**Success requires:**
- Commitment to offline-first architecture from day one
- Aggressive performance testing throughout development
- Platform-specific UX for critical features (refinement editor, tone sliders)
- Comprehensive testing strategy (unit, integration, E2E)

---

## Appendix: Technology Stack Summary

| Category | Technology | Rationale |
|----------|-----------|-----------|
| **Mobile Framework** | React Native (Expo) | Cross-platform, fast iteration, mature ecosystem |
| **Monorepo** | Turborepo | Shared code, fast builds |
| **Navigation** | React Navigation v6 | Industry standard, deep linking, modals |
| **State (Server)** | React Query | Caching, offline support, auto-refetch |
| **State (Client)** | Zustand | Lightweight, no boilerplate, TypeScript |
| **Lists** | FlashList | 10x better performance than FlatList |
| **Images** | Expo Image | Blurhash, caching, better performance |
| **Image Upload** | Expo Image Picker | Native camera roll access |
| **Storage** | AsyncStorage | Simple key-value store, good for MVP |
| **Push Notifications** | Expo Push | Built-in, easy setup |
| **Testing (Unit)** | Jest | Industry standard |
| **Testing (Component)** | React Native Testing Library | React-focused, accessible |
| **Testing (E2E)** | Maestro | Easier than Detox, cross-platform |
| **Backend API** | Node.js + Express | TypeScript, matches frontend |
| **Database** | PostgreSQL (Supabase) | ACID, JSONB, managed |
| **LLM** | Claude Sonnet 4 | Superior conversation understanding |
| **OCR** | Google Cloud Vision | Best accuracy for screenshots |

---

**File Locations:**
- This assessment: `/Users/pierreventer/Projects/tonehone/MOBILE-ASSESSMENT.md`
- PRD: `/Users/pierreventer/Projects/tonehone/tonehone-PRD.md`
- Current codebase: `/Users/pierreventer/Projects/tonehone/ToneHone/` (SwiftUI - requires decision)

**Next Document to Create:**
- `ROADMAP.md` - Detailed sprint-by-sprint development plan based on this assessment
