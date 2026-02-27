# Onboarding Analytics & Haptics Design

## Overview

새 온보딩 플로우(13개 화면)에 analytics 이벤트 트래킹과 haptic feedback을 추가한다.
모든 화면 도달/이탈, 선택값, 개별 상호작용을 추적하여 퍼널 분석 및 사용자 선호도 분석이 가능하도록 한다.

## Approach

기존 `AnalyticsService` 추상 인터페이스에 새 메서드를 추가하고, `FirebaseAnalyticsService`와 `CompositeAnalyticsService`에 구현. 타입 안전하고 기존 패턴과 100% 일관성 유지.

## New AnalyticsService Methods

```dart
logOnboardingGetStartedTapped();
logOnboardingCreatureSelected({required String creature});
logOnboardingEmojiSelected({required String emoji});
logOnboardingVibeSelected({required String vibe});
logOnboardingTaskToggled({required String task, required bool selected});
logOnboardingFakeLoadingCompleted();
logOnboardingStepCompleted({required String step});
logOnboardingBackTapped({required String fromStep});
```

Existing methods kept as-is: `logOnboardingStepViewed`, `logOnboardingComplete`, `logAiDisclosureAccepted`, `logTelegramSetupSkipped`, paywall events.

## Event Mapping Per Screen

| #   | Screen         | Event                                                | Trigger           | Haptic           |
| --- | -------------- | ---------------------------------------------------- | ----------------- | ---------------- |
| 1   | WelcomeLanding | `logOnboardingStepViewed(step: 'welcome_landing')`   | initState         | —                |
| 1   | WelcomeLanding | `logOnboardingGetStartedTapped()`                    | Get Started tap   | `mediumImpact`   |
| 2   | UserProfile    | `logOnboardingStepViewed(step: 'user_profile')`      | initState         | —                |
| 2   | UserProfile    | `logOnboardingStepCompleted(step: 'user_profile')`   | Continue tap      | `lightImpact`    |
| 3   | AgentCreation  | `logOnboardingStepViewed(step: 'agent_creation')`    | initState         | —                |
| 3   | AgentCreation  | `logOnboardingCreatureSelected(creature)`            | creature tap      | `selectionClick` |
| 3   | AgentCreation  | `logOnboardingEmojiSelected(emoji)`                  | emoji tap         | `selectionClick` |
| 3   | AgentCreation  | `logOnboardingStepCompleted(step: 'agent_creation')` | Continue tap      | `lightImpact`    |
| 4   | VibeSelection  | `logOnboardingStepViewed(step: 'vibe_selection')`    | initState         | —                |
| 4   | VibeSelection  | `logOnboardingVibeSelected(vibe)`                    | vibe tap          | `selectionClick` |
| 4   | VibeSelection  | `logOnboardingStepCompleted(step: 'vibe_selection')` | Continue tap      | `lightImpact`    |
| 5   | TaskSelection  | `logOnboardingStepViewed(step: 'task_selection')`    | initState         | —                |
| 5   | TaskSelection  | `logOnboardingTaskToggled(task, selected)`           | task toggle       | `selectionClick` |
| 5   | TaskSelection  | `logOnboardingStepCompleted(step: 'task_selection')` | Continue tap      | `lightImpact`    |
| 6   | GithubPress    | `logOnboardingStepViewed(step: 'github_press')`      | build             | —                |
| 6   | GithubPress    | `logOnboardingStepCompleted(step: 'github_press')`   | Continue tap      | `lightImpact`    |
| 7   | Tweets         | `logOnboardingStepViewed(step: 'tweets')`            | build             | —                |
| 7   | Tweets         | `logOnboardingStepCompleted(step: 'tweets')`         | Continue tap      | `lightImpact`    |
| 8   | EasySetup      | `logOnboardingStepViewed(step: 'easy_setup')`        | build             | —                |
| 8   | EasySetup      | `logOnboardingStepCompleted(step: 'easy_setup')`     | Continue tap      | `lightImpact`    |
| 9   | SafeByDesign   | `logOnboardingStepViewed(step: 'safe_by_design')`    | build             | —                |
| 9   | SafeByDesign   | `logOnboardingStepCompleted(step: 'safe_by_design')` | Continue tap      | `lightImpact`    |
| 10  | FullFeatures   | `logOnboardingStepViewed(step: 'full_features')`     | build             | —                |
| 10  | FullFeatures   | `logOnboardingStepCompleted(step: 'full_features')`  | Continue tap      | `lightImpact`    |
| 11  | FakeLoading    | `logOnboardingStepViewed(step: 'fake_loading')`      | initState         | —                |
| 11  | FakeLoading    | `logOnboardingFakeLoadingCompleted()`                | 5s animation done | `mediumImpact`   |
| 12  | AgentComplete  | `logOnboardingStepViewed(step: 'agent_complete')`    | build             | —                |
| 12  | AgentComplete  | `logOnboardingStepCompleted(step: 'agent_complete')` | Continue tap      | `mediumImpact`   |
| 13  | NewPaywall     | `logOnboardingStepViewed(step: 'paywall')`           | initState         | —                |
| 13  | NewPaywall     | existing purchase/restore events                     | existing          | existing         |
| ALL | Back button    | `logOnboardingBackTapped(fromStep)`                  | back tap          | `lightImpact`    |

## Haptic Rules

- `selectionClick` — selection/toggle interactions (creature, emoji, vibe, task)
- `lightImpact` — standard button taps, navigation, back
- `mediumImpact` — key transition points (get started, loading complete, agent complete, purchase)

## Files to Modify

1. `services/analytics/analytics_service.dart` — add 8 abstract methods
2. `services/analytics/firebase_analytics_service.dart` — implement 8 methods
3. `services/analytics/composite_analytics_service.dart` — delegate 8 methods
4. `screens/onboarding/welcome_landing_screen.dart` — add analytics + haptics
5. `screens/onboarding/user_profile_screen.dart` — add analytics + haptics
6. `screens/onboarding/agent_creation_screen.dart` — add analytics + haptics
7. `screens/onboarding/vibe_selection_screen.dart` — add analytics + haptics
8. `screens/onboarding/task_selection_screen.dart` — add analytics + haptics
9. `screens/onboarding/github_press_screen.dart` — add analytics + haptics
10. `screens/onboarding/tweets_screen.dart` — add analytics + haptics
11. `screens/onboarding/easy_setup_screen.dart` — add analytics + haptics
12. `screens/onboarding/safe_by_design_screen.dart` — add analytics + haptics
13. `screens/onboarding/full_features_screen.dart` — add analytics + haptics
14. `screens/onboarding/fake_loading_screen.dart` — add analytics + haptics
15. `screens/onboarding/agent_complete_screen.dart` — upgrade haptic + add analytics
16. `screens/onboarding/new_paywall_screen.dart` — add stepViewed analytics
