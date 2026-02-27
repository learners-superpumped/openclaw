# Onboarding Analytics & Haptics Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 새 온보딩 13개 화면에 analytics 이벤트 트래킹과 haptic feedback을 추가하여 퍼널 분석 및 사용자 선호도 분석이 가능하도록 한다.

**Architecture:** 기존 `AnalyticsService` 추상 인터페이스에 8개 메서드를 추가하고, `FirebaseAnalyticsService`와 `CompositeAnalyticsService`에 구현. 각 온보딩 화면에서 `ref.read(analyticsProvider)`로 이벤트를 발화하고, `HapticFeedback`을 상호작용 시점에 호출.

**Tech Stack:** Flutter, Riverpod, Firebase Analytics, HapticFeedback (flutter/services.dart)

**Design Doc:** `docs/plans/2026-02-27-onboarding-analytics-haptics-design.md`

---

### Task 1: AnalyticsService 인터페이스에 8개 메서드 추가

**Files:**

- Modify: `deploy/app/lib/services/analytics/analytics_service.dart:14-18` (Onboarding 섹션)

**Step 1: analytics_service.dart 에 메서드 추가**

`// ── Onboarding ──` 섹션(line 14-18)에 기존 4개 메서드 아래에 8개 추가:

```dart
  // ── Onboarding ──
  Future<void> logOnboardingStepViewed({required String step});
  Future<void> logOnboardingComplete();
  Future<void> logAiDisclosureAccepted();
  Future<void> logTelegramSetupSkipped();
  Future<void> logOnboardingGetStartedTapped();
  Future<void> logOnboardingCreatureSelected({required String creature});
  Future<void> logOnboardingEmojiSelected({required String emoji});
  Future<void> logOnboardingVibeSelected({required String vibe});
  Future<void> logOnboardingTaskToggled({required String task, required bool selected});
  Future<void> logOnboardingFakeLoadingCompleted();
  Future<void> logOnboardingStepCompleted({required String step});
  Future<void> logOnboardingBackTapped({required String fromStep});
```

**Step 2: Commit**

```bash
git add deploy/app/lib/services/analytics/analytics_service.dart
git commit -m "feat(analytics): add onboarding analytics method signatures"
```

---

### Task 2: FirebaseAnalyticsService 구현

**Files:**

- Modify: `deploy/app/lib/services/analytics/firebase_analytics_service.dart:61-77` (Onboarding 섹션)

**Step 1: firebase_analytics_service.dart에 8개 메서드 구현**

line 77 (`logTelegramSetupSkipped` 메서드) 뒤에 추가:

```dart
  @override
  Future<void> logOnboardingGetStartedTapped() =>
      _analytics.logEvent(name: 'onboarding_get_started_tapped');

  @override
  Future<void> logOnboardingCreatureSelected({required String creature}) =>
      _analytics.logEvent(
        name: 'onboarding_creature_selected',
        parameters: {'creature': creature},
      );

  @override
  Future<void> logOnboardingEmojiSelected({required String emoji}) =>
      _analytics.logEvent(
        name: 'onboarding_emoji_selected',
        parameters: {'emoji': emoji},
      );

  @override
  Future<void> logOnboardingVibeSelected({required String vibe}) =>
      _analytics.logEvent(
        name: 'onboarding_vibe_selected',
        parameters: {'vibe': vibe},
      );

  @override
  Future<void> logOnboardingTaskToggled({
    required String task,
    required bool selected,
  }) => _analytics.logEvent(
    name: 'onboarding_task_toggled',
    parameters: {'task': task, 'selected': selected.toString()},
  );

  @override
  Future<void> logOnboardingFakeLoadingCompleted() =>
      _analytics.logEvent(name: 'onboarding_fake_loading_completed');

  @override
  Future<void> logOnboardingStepCompleted({required String step}) =>
      _analytics.logEvent(
        name: 'onboarding_step_completed',
        parameters: {'step': step},
      );

  @override
  Future<void> logOnboardingBackTapped({required String fromStep}) =>
      _analytics.logEvent(
        name: 'onboarding_back_tapped',
        parameters: {'from_step': fromStep},
      );
```

**Step 2: Commit**

```bash
git add deploy/app/lib/services/analytics/firebase_analytics_service.dart
git commit -m "feat(analytics): implement onboarding events in FirebaseAnalyticsService"
```

---

### Task 3: CompositeAnalyticsService 위임 구현

**Files:**

- Modify: `deploy/app/lib/services/analytics/composite_analytics_service.dart:51-65` (Onboarding 섹션)

**Step 1: composite_analytics_service.dart에 8개 메서드 위임**

line 65 (`logTelegramSetupSkipped` 메서드) 뒤에 추가:

```dart
  @override
  Future<void> logOnboardingGetStartedTapped() =>
      Future.wait(_services.map((s) => s.logOnboardingGetStartedTapped()));

  @override
  Future<void> logOnboardingCreatureSelected({required String creature}) =>
      Future.wait(
        _services.map((s) => s.logOnboardingCreatureSelected(creature: creature)),
      );

  @override
  Future<void> logOnboardingEmojiSelected({required String emoji}) =>
      Future.wait(
        _services.map((s) => s.logOnboardingEmojiSelected(emoji: emoji)),
      );

  @override
  Future<void> logOnboardingVibeSelected({required String vibe}) =>
      Future.wait(_services.map((s) => s.logOnboardingVibeSelected(vibe: vibe)));

  @override
  Future<void> logOnboardingTaskToggled({
    required String task,
    required bool selected,
  }) => Future.wait(
    _services.map((s) => s.logOnboardingTaskToggled(task: task, selected: selected)),
  );

  @override
  Future<void> logOnboardingFakeLoadingCompleted() =>
      Future.wait(_services.map((s) => s.logOnboardingFakeLoadingCompleted()));

  @override
  Future<void> logOnboardingStepCompleted({required String step}) =>
      Future.wait(
        _services.map((s) => s.logOnboardingStepCompleted(step: step)),
      );

  @override
  Future<void> logOnboardingBackTapped({required String fromStep}) =>
      Future.wait(
        _services.map((s) => s.logOnboardingBackTapped(fromStep: fromStep)),
      );
```

**Step 2: Verify build**

Run: `cd deploy/app && flutter analyze --no-fatal-infos`
Expected: No errors (warnings OK)

**Step 3: Commit**

```bash
git add deploy/app/lib/services/analytics/composite_analytics_service.dart
git commit -m "feat(analytics): implement onboarding events in CompositeAnalyticsService"
```

---

### Task 4: WelcomeLandingScreen — analytics + haptics

**Files:**

- Modify: `deploy/app/lib/screens/onboarding/welcome_landing_screen.dart`

**Step 1: Add imports and analytics/haptics**

Add import at top:

```dart
import 'package:flutter/services.dart';
import '../../providers/api_provider.dart';
```

In `initState()` (after `ref.read(offeringsProvider);`), add:

```dart
    ref.read(analyticsProvider).logOnboardingStepViewed(step: 'welcome_landing');
```

In the Get Started `onPressed` callback (before the `ref.read(onboardingScreenProvider...)`), add:

```dart
                          HapticFeedback.mediumImpact();
                          ref.read(analyticsProvider).logOnboardingGetStartedTapped();
```

**Step 2: Commit**

```bash
git add deploy/app/lib/screens/onboarding/welcome_landing_screen.dart
git commit -m "feat(analytics): add analytics & haptics to WelcomeLandingScreen"
```

---

### Task 5: UserProfileScreen — analytics + haptics

**Files:**

- Modify: `deploy/app/lib/screens/onboarding/user_profile_screen.dart`

**Step 1: Add imports**

```dart
import 'package:flutter/services.dart';
import '../../providers/api_provider.dart';
```

**Step 2: Add stepViewed in initState**

In `initState()` (after `super.initState();`):

```dart
    ref.read(analyticsProvider).logOnboardingStepViewed(step: 'user_profile');
```

**Step 3: Add haptic + stepCompleted to Continue callback**

In the `_onContinue` method, add at the top:

```dart
    HapticFeedback.lightImpact();
    ref.read(analyticsProvider).logOnboardingStepCompleted(step: 'user_profile');
```

**Step 4: Add back button haptic + analytics**

In the `onBackPressed` callback:

```dart
    HapticFeedback.lightImpact();
    ref.read(analyticsProvider).logOnboardingBackTapped(fromStep: 'user_profile');
```

**Step 5: Commit**

```bash
git add deploy/app/lib/screens/onboarding/user_profile_screen.dart
git commit -m "feat(analytics): add analytics & haptics to UserProfileScreen"
```

---

### Task 6: AgentCreationScreen — analytics + haptics

**Files:**

- Modify: `deploy/app/lib/screens/onboarding/agent_creation_screen.dart`

**Step 1: Add imports**

```dart
import 'package:flutter/services.dart';
import '../../providers/api_provider.dart';
```

**Step 2: Add stepViewed in initState**

After `super.initState();`:

```dart
    ref.read(analyticsProvider).logOnboardingStepViewed(step: 'agent_creation');
```

**Step 3: Add creature selection analytics + haptics**

In `_buildCreatureCard` `onTap`:

```dart
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedCreature = isSelected ? null : creature.key;
        });
        if (!isSelected) {
          ref.read(analyticsProvider).logOnboardingCreatureSelected(creature: creature.key);
        }
      },
```

**Step 4: Add emoji selection analytics + haptics**

In `_buildEmojiCard` `onTap`:

```dart
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedEmoji = isSelected ? null : emoji;
        });
        if (!isSelected) {
          ref.read(analyticsProvider).logOnboardingEmojiSelected(emoji: emoji);
        }
      },
```

**Step 5: Add continue + back haptics & analytics**

In `_onContinue`:

```dart
    HapticFeedback.lightImpact();
    ref.read(analyticsProvider).logOnboardingStepCompleted(step: 'agent_creation');
```

In `onBackPressed`:

```dart
    HapticFeedback.lightImpact();
    ref.read(analyticsProvider).logOnboardingBackTapped(fromStep: 'agent_creation');
```

**Step 6: Commit**

```bash
git add deploy/app/lib/screens/onboarding/agent_creation_screen.dart
git commit -m "feat(analytics): add analytics & haptics to AgentCreationScreen"
```

---

### Task 7: VibeSelectionScreen — analytics + haptics

**Files:**

- Modify: `deploy/app/lib/screens/onboarding/vibe_selection_screen.dart`

**Step 1: Add imports**

```dart
import 'package:flutter/services.dart';
import '../../providers/api_provider.dart';
```

**Step 2: Add stepViewed**

VibeSelectionScreen은 ConsumerStatefulWidget. `initState()` 에:

```dart
    ref.read(analyticsProvider).logOnboardingStepViewed(step: 'vibe_selection');
```

**Step 3: Add vibe selection haptic + analytics**

In `_buildVibeCard` `onTap`:

```dart
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedVibe = vibe.name;
        });
        ref.read(analyticsProvider).logOnboardingVibeSelected(vibe: vibe.name);
      },
```

**Step 4: Add continue + back**

In `_onContinue`:

```dart
    HapticFeedback.lightImpact();
    ref.read(analyticsProvider).logOnboardingStepCompleted(step: 'vibe_selection');
```

In `onBackPressed`:

```dart
    HapticFeedback.lightImpact();
    ref.read(analyticsProvider).logOnboardingBackTapped(fromStep: 'vibe_selection');
```

**Step 5: Commit**

```bash
git add deploy/app/lib/screens/onboarding/vibe_selection_screen.dart
git commit -m "feat(analytics): add analytics & haptics to VibeSelectionScreen"
```

---

### Task 8: TaskSelectionScreen — analytics + haptics

**Files:**

- Modify: `deploy/app/lib/screens/onboarding/task_selection_screen.dart`

**Step 1: Add imports**

```dart
import 'package:flutter/services.dart';
import '../../providers/api_provider.dart';
```

**Step 2: Add stepViewed in initState**

```dart
    ref.read(analyticsProvider).logOnboardingStepViewed(step: 'task_selection');
```

**Step 3: Add task toggle haptic + analytics**

In `_buildTaskCard` `onTap` (the GestureDetector wrapping each task card):

```dart
        HapticFeedback.selectionClick();
        final willSelect = !_selectedTasks.contains(task.label);
        ref.read(analyticsProvider).logOnboardingTaskToggled(
          task: task.label,
          selected: willSelect,
        );
```

**Step 4: Add continue + back**

In `_onContinue`:

```dart
    HapticFeedback.lightImpact();
    ref.read(analyticsProvider).logOnboardingStepCompleted(step: 'task_selection');
```

In `onBackPressed`:

```dart
    HapticFeedback.lightImpact();
    ref.read(analyticsProvider).logOnboardingBackTapped(fromStep: 'task_selection');
```

**Step 5: Commit**

```bash
git add deploy/app/lib/screens/onboarding/task_selection_screen.dart
git commit -m "feat(analytics): add analytics & haptics to TaskSelectionScreen"
```

---

### Task 9: GithubPressScreen — analytics + haptics

**Files:**

- Modify: `deploy/app/lib/screens/onboarding/github_press_screen.dart`

**Step 1: Add imports**

```dart
import 'package:flutter/services.dart';
import '../../providers/api_provider.dart';
```

**Step 2: Add stepViewed + continue + back**

GithubPressScreen은 ConsumerWidget (StatelessWidget). `build()` 첫 줄에 `_hasLoggedView` 가 없으므로 stepViewed를 `onButtonPressed` 패턴으로 관리하기 어려움. 단, ConsumerWidget은 build마다 호출되므로 중복 발화 방지가 필요.

**해결:** ConsumerStatefulWidget으로 변경하거나, stepViewed를 한번만 보내도록 처리. ConsumerWidget의 경우 `ref.read`로 호출하되 **이 화면은 StatelessWidget이라 build에서 호출하면 rebuild마다 중복 호출**됨.

→ **ConsumerStatefulWidget으로 변환**하여 `initState`에서 한 번만 호출.

또는 더 간단하게: 이 화면들의 stepViewed는 화면 진입 시 한 번만 호출해야 하므로, `_hasLoggedView` boolean을 사용하는 것보다 **ConsumerStatefulWidget 변환이 깔끔**. 그러나 기존 코드 변경 최소화를 위해 build에서 호출하되, Firebase Analytics는 동일 세션에서 같은 이벤트가 빠르게 중복 호출되어도 큰 문제 없음 (실질적으로 화면 전환이 있어야 다시 build됨).

→ **결론: ConsumerWidget인 화면들(GithubPress, Tweets, EasySetup, SafeByDesign, FullFeatures, AgentComplete)의 stepViewed는 onButtonPressed 콜백 대신, `build` 첫 줄에서 `ref.read`로 호출**. 이 화면들은 전환 시마다 새로운 위젯으로 교체되므로 첫 build에서 한 번만 호출됨.

build 메서드 첫 줄(l10n 이후):

```dart
    ref.read(analyticsProvider).logOnboardingStepViewed(step: 'github_press');
```

`onButtonPressed` 콜백에서:

```dart
      onButtonPressed: () {
        HapticFeedback.lightImpact();
        ref.read(analyticsProvider).logOnboardingStepCompleted(step: 'github_press');
        ref.read(onboardingScreenProvider.notifier).state = OnboardingStep.tweets;
      },
```

`onBackPressed` 콜백에서:

```dart
      onBackPressed: () {
        HapticFeedback.lightImpact();
        ref.read(analyticsProvider).logOnboardingBackTapped(fromStep: 'github_press');
        ref.read(onboardingScreenProvider.notifier).state = OnboardingStep.taskSelection;
      },
```

**Step 3: Commit**

```bash
git add deploy/app/lib/screens/onboarding/github_press_screen.dart
git commit -m "feat(analytics): add analytics & haptics to GithubPressScreen"
```

---

### Task 10: TweetsScreen — analytics + haptics

**Files:**

- Modify: `deploy/app/lib/screens/onboarding/tweets_screen.dart`

**Step 1: Add imports**

```dart
import 'package:flutter/services.dart';
import '../../providers/api_provider.dart';
```

**Step 2: Add stepViewed + continue + back**

build 메서드에서 (l10n 이후):

```dart
    ref.read(analyticsProvider).logOnboardingStepViewed(step: 'tweets');
```

onButtonPressed:

```dart
      onButtonPressed: () {
        HapticFeedback.lightImpact();
        ref.read(analyticsProvider).logOnboardingStepCompleted(step: 'tweets');
        ref.read(onboardingScreenProvider.notifier).state = OnboardingStep.easySetup;
      },
```

onBackPressed:

```dart
      onBackPressed: () {
        HapticFeedback.lightImpact();
        ref.read(analyticsProvider).logOnboardingBackTapped(fromStep: 'tweets');
        ref.read(onboardingScreenProvider.notifier).state = OnboardingStep.githubPress;
      },
```

**Step 3: Commit**

```bash
git add deploy/app/lib/screens/onboarding/tweets_screen.dart
git commit -m "feat(analytics): add analytics & haptics to TweetsScreen"
```

---

### Task 11: EasySetupScreen — analytics + haptics

**Files:**

- Modify: `deploy/app/lib/screens/onboarding/easy_setup_screen.dart`

**Step 1: Add imports + analytics + haptics** (same pattern as Task 9-10)

```dart
import 'package:flutter/services.dart';
import '../../providers/api_provider.dart';
```

build: `ref.read(analyticsProvider).logOnboardingStepViewed(step: 'easy_setup');`

onButtonPressed:

```dart
        HapticFeedback.lightImpact();
        ref.read(analyticsProvider).logOnboardingStepCompleted(step: 'easy_setup');
```

onBackPressed:

```dart
        HapticFeedback.lightImpact();
        ref.read(analyticsProvider).logOnboardingBackTapped(fromStep: 'easy_setup');
```

**Step 2: Commit**

```bash
git add deploy/app/lib/screens/onboarding/easy_setup_screen.dart
git commit -m "feat(analytics): add analytics & haptics to EasySetupScreen"
```

---

### Task 12: SafeByDesignScreen — analytics + haptics

**Files:**

- Modify: `deploy/app/lib/screens/onboarding/safe_by_design_screen.dart`

**Step 1: Same pattern**

```dart
import 'package:flutter/services.dart';
import '../../providers/api_provider.dart';
```

build: `ref.read(analyticsProvider).logOnboardingStepViewed(step: 'safe_by_design');`

onButtonPressed:

```dart
        HapticFeedback.lightImpact();
        ref.read(analyticsProvider).logOnboardingStepCompleted(step: 'safe_by_design');
```

onBackPressed:

```dart
        HapticFeedback.lightImpact();
        ref.read(analyticsProvider).logOnboardingBackTapped(fromStep: 'safe_by_design');
```

**Step 2: Commit**

```bash
git add deploy/app/lib/screens/onboarding/safe_by_design_screen.dart
git commit -m "feat(analytics): add analytics & haptics to SafeByDesignScreen"
```

---

### Task 13: FullFeaturesScreen — analytics + haptics

**Files:**

- Modify: `deploy/app/lib/screens/onboarding/full_features_screen.dart`

**Step 1: Same pattern**

```dart
import 'package:flutter/services.dart';
import '../../providers/api_provider.dart';
```

build: `ref.read(analyticsProvider).logOnboardingStepViewed(step: 'full_features');`

onButtonPressed:

```dart
        HapticFeedback.lightImpact();
        ref.read(analyticsProvider).logOnboardingStepCompleted(step: 'full_features');
```

onBackPressed:

```dart
        HapticFeedback.lightImpact();
        ref.read(analyticsProvider).logOnboardingBackTapped(fromStep: 'full_features');
```

**Step 2: Commit**

```bash
git add deploy/app/lib/screens/onboarding/full_features_screen.dart
git commit -m "feat(analytics): add analytics & haptics to FullFeaturesScreen"
```

---

### Task 14: FakeLoadingScreen — analytics + haptics

**Files:**

- Modify: `deploy/app/lib/screens/onboarding/fake_loading_screen.dart`

**Step 1: Add imports**

```dart
import 'package:flutter/services.dart';
import '../../providers/api_provider.dart';
```

**Step 2: Add stepViewed in initState**

In `initState()` (after `_scheduleSteps();`):

```dart
    ref.read(analyticsProvider).logOnboardingStepViewed(step: 'fake_loading');
```

**Step 3: Add fakeLoadingCompleted + haptic**

In `_scheduleSteps()`, the final Timer (5000ms) that navigates to agentComplete — add before navigation:

```dart
    _timers.add(
      Timer(const Duration(milliseconds: 5000), () {
        if (!mounted) return;
        HapticFeedback.mediumImpact();
        ref.read(analyticsProvider).logOnboardingFakeLoadingCompleted();
        ref.read(onboardingScreenProvider.notifier).state =
            OnboardingStep.agentComplete;
      }),
    );
```

**Step 4: Commit**

```bash
git add deploy/app/lib/screens/onboarding/fake_loading_screen.dart
git commit -m "feat(analytics): add analytics & haptics to FakeLoadingScreen"
```

---

### Task 15: AgentCompleteScreen — analytics + upgrade haptic

**Files:**

- Modify: `deploy/app/lib/screens/onboarding/agent_complete_screen.dart`

**Step 1: Add analytics import** (flutter/services.dart already imported)

```dart
import '../../providers/api_provider.dart';
```

**Step 2: Add stepViewed**

build 메서드에서 (l10n 이후):

```dart
    ref.read(analyticsProvider).logOnboardingStepViewed(step: 'agent_complete');
```

**Step 3: Upgrade haptic and add analytics to Continue button**

Continue `onPressed` 콜백에서:

- `HapticFeedback.lightImpact()` → `HapticFeedback.mediumImpact()`
- Add: `ref.read(analyticsProvider).logOnboardingStepCompleted(step: 'agent_complete');`

```dart
                          onPressed: () async {
                            HapticFeedback.mediumImpact();
                            ref.read(analyticsProvider).logOnboardingStepCompleted(step: 'agent_complete');
                            await ref
                                .read(secureStorageProvider)
                                .write(
                                  key: 'onboarding_completed',
                                  value: 'true',
                                );
                            ref.read(profileCompletedProvider.notifier).state =
                                true;
                          },
```

**Step 4: Commit**

```bash
git add deploy/app/lib/screens/onboarding/agent_complete_screen.dart
git commit -m "feat(analytics): add analytics & upgrade haptic in AgentCompleteScreen"
```

---

### Task 16: NewPaywallScreen — add stepViewed analytics

**Files:**

- Modify: `deploy/app/lib/screens/onboarding/new_paywall_screen.dart`

**Step 1: Add analytics provider import**

```dart
import '../../providers/api_provider.dart';
```

(flutter/services.dart already imported, HapticFeedback already used)

**Step 2: Add stepViewed in initState**

NewPaywallScreen은 ConsumerStatefulWidget. `initState()` 에서(또는 `build` 첫 호출 패턴):

initState에 추가:

```dart
    ref.read(analyticsProvider).logOnboardingStepViewed(step: 'paywall');
```

**Step 3: Add paywall purchase tapped analytics**

`_purchase()` 메서드 시작 부분에 (이미 있는 haptic 바로 뒤):

```dart
    ref.read(analyticsProvider).logPaywallPurchaseTapped(
      productId: package.storeProduct.identifier,
    );
```

**Step 4: Commit**

```bash
git add deploy/app/lib/screens/onboarding/new_paywall_screen.dart
git commit -m "feat(analytics): add stepViewed & purchase analytics to NewPaywallScreen"
```

---

### Task 17: Final verify — flutter analyze

**Step 1: Run flutter analyze**

```bash
cd deploy/app && flutter analyze --no-fatal-infos
```

Expected: 0 errors. Warnings/infos OK.

**Step 2: If errors, fix and commit fixes**

**Step 3: Final commit if any formatter changes needed**

```bash
cd deploy/app && dart format lib/
git add -A deploy/app/lib/
git commit -m "style: format onboarding analytics changes"
```
