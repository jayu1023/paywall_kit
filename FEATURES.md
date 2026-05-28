# paywall_kit — Feature Catalog

Every capability the package ships (or plans to). Each feature has a unique
ID for cross-referencing in PHASES.md.

**Legend:** 🔴 Must-have (v0.1) · 🟡 Should-have (v0.1) · 🟢 Nice-to-have (v0.2+)

---

## 1. Core API

| ID | Feature | Priority | Notes |
|---|---|---|---|
| F-CORE-01 | `PaywallKit.show(context, variant: ...)` single entry-point | 🔴 | One line to launch a paywall |
| F-CORE-02 | `PaywallScreen(...)` widget for embedding in custom flows | 🔴 | Returns a `Widget`, not just a `showModal` |
| F-CORE-03 | `PaywallProduct` model (id, price, period, perks) | 🔴 | Decoupled from any specific IAP backend |
| F-CORE-04 | `PaywallCopy` model (headline, features, CTAs, fine print) | 🔴 | Translation-ready strings |
| F-CORE-05 | `PaywallTheme` (colors, radii, typography, spacing) | 🔴 | Single `PaywallTheme.brand(...)` factory |
| F-CORE-06 | `PaywallResult` enum (purchased / restored / dismissed / error) | 🔴 | Return value from `show()` |
| F-CORE-07 | Dark/light mode auto-switch | 🔴 | Honors `Theme.of(context).brightness` |

## 2. The 12 Variants

| ID | Variant | Priority | Notes |
|---|---|---|---|
| F-VAR-01 | Carousel — swipeable feature highlights | 🔴 | The "Headspace" style |
| F-VAR-02 | Comparison Table — Free vs Pro vs Lifetime columns | 🔴 | Notion-style 3-column |
| F-VAR-03 | Trial-with-toggle — monthly/annual switch | 🔴 | "7-day free trial" emphasis |
| F-VAR-04 | Lifetime Deal — one-time purchase + urgency timer | 🔴 | Indie-hacker favorite |
| F-VAR-05 | Soft Paywall — "continue with limits" option | 🔴 | Non-blocking variant |
| F-VAR-06 | Hard Paywall — onboarding-blocking | 🔴 | Aggressive monetization |
| F-VAR-07 | Win-back — for lapsed subscribers, discount offer | 🔴 | Detects lapsed status |
| F-VAR-08 | Family Plan — multi-seat tier | 🔴 | Apple Family Sharing aware |
| F-VAR-09 | Minimal — single price, single CTA (Pieter Levels style) | 🔴 | The "indie" look |
| F-VAR-10 | Storytelling — long-scroll w/ testimonials, social proof | 🔴 | Long-form conversion |
| F-VAR-11 | Gamified — "unlock" animation, streak/progress framing | 🔴 | Duolingo-style |
| F-VAR-12 | Reverse Trial — "you're already on Pro for 7 days" | 🔴 | RC-Lab winning pattern |

## 3. Backend Adapters

| ID | Feature | Priority | Notes |
|---|---|---|---|
| F-ADAPT-01 | `IapAdapter` for native `in_app_purchase` package | 🔴 | Zero-cost, no vendor lock |
| F-ADAPT-02 | `RevenueCatAdapter` for the RC SDK | 🔴 | Optional dep, opt-in |
| F-ADAPT-03 | `CustomAdapter` interface for any backend | 🔴 | Stripe / Paddle / your own |
| F-ADAPT-04 | Adapter selection via `PaywallConfig(backend: ...)` | 🔴 | One config flag |
| F-ADAPT-05 | `AdaptyAdapter` | 🟢 | v0.2 if requested |

## 4. Animation & Motion

| ID | Feature | Priority | Notes |
|---|---|---|---|
| F-ANIM-01 | Hero-style entrance animations per variant | 🔴 | Spring-physics defaults |
| F-ANIM-02 | Confetti / celebration animation on successful purchase | 🟡 | Optional, off by default |
| F-ANIM-03 | Skeleton loaders while product info loads | 🔴 | Avoids price flash |
| F-ANIM-04 | Smooth toggle animations (monthly ↔ annual) | 🔴 | 60fps spring |

## 5. Localization

| ID | Feature | Priority | Notes |
|---|---|---|---|
| F-L10N-01 | All strings via `PaywallCopy` (translatable) | 🔴 | No hardcoded strings |
| F-L10N-02 | RTL support (Arabic/Hebrew) | 🟡 | Test with Arabic locale |
| F-L10N-03 | Locale-aware price formatting | 🔴 | $9.99 vs €9,99 |
| F-L10N-04 | Built-in English copy templates per variant | 🔴 | Starter content |

## 6. Analytics & Hooks

| ID | Feature | Priority | Notes |
|---|---|---|---|
| F-ANALYTIC-01 | `onView`, `onPurchaseStart`, `onPurchaseSuccess`, `onPurchaseFail` callbacks | 🔴 | Hook into any analytics |
| F-ANALYTIC-02 | `onDismiss`, `onCtaTap` granular hooks | 🔴 | Funnel debugging |
| F-ANALYTIC-03 | Built-in Posthog adapter | 🟢 | v0.2 |
| F-ANALYTIC-04 | Built-in Mixpanel adapter | 🟢 | v0.2 |

## 7. A/B Testing Hook

| ID | Feature | Priority | Notes |
|---|---|---|---|
| F-AB-01 | `PaywallVariant` selectable at runtime | 🔴 | Read from feature flag |
| F-AB-02 | `PaywallExperiment` helper to randomize per-user | 🟡 | Built-in 50/50 split |
| F-AB-03 | Posthog feature-flag integration example | 🟡 | Doc only |

## 8. Restore Purchases

| ID | Feature | Priority | Notes |
|---|---|---|---|
| F-RESTORE-01 | "Restore Purchases" link on every variant | 🔴 | App Store requirement |
| F-RESTORE-02 | Restore flow handled by adapter | 🔴 | Returns receipt + status |

## 9. Documentation & Marketing

| ID | Feature | Priority | Notes |
|---|---|---|---|
| F-DOC-01 | README with grid of all 12 variants | 🔴 | The conversion screenshot |
| F-DOC-02 | Example app showcasing all 12 | 🔴 | `example/main.dart` |
| F-DOC-03 | Recipe doc: "How to wire RevenueCat" | 🔴 | |
| F-DOC-04 | Recipe doc: "How to A/B test variants" | 🟡 | |
| F-DOC-05 | Launch GIF: auto-scrolling grid | 🔴 | Viral asset |

## 10. Quality

| ID | Feature | Priority | Notes |
|---|---|---|---|
| F-QA-01 | Widget test per variant (renders, taps fire callbacks) | 🔴 | 12 tests minimum |
| F-QA-02 | Golden tests per variant (light + dark) | 🟡 | 24 goldens |
| F-QA-03 | `flutter analyze --fatal-warnings` clean | 🔴 | |
| F-QA-04 | pana score ≥ 130/130 | 🔴 | |
| F-QA-05 | GitHub Actions CI on push/PR | 🔴 | |
