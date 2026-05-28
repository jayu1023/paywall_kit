# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] — 2026-05-28

First public release. 12 conversion-optimized, drop-in Flutter paywall screens. Backend-agnostic with `in_app_purchase` (native), RevenueCat, or any custom adapter you wire.

### Added

**Public API**
- `PaywallKit.show(...)` — single entry-point returning `Future<PaywallResult>`. Pushes a full-screen variant route.
- `PaywallVariant` enum — 12 variant identifiers: `carousel`, `comparison`, `trialToggle`, `lifetime`, `soft`, `hard`, `winback`, `family`, `minimal`, `storytelling`, `gamified`, `reverseTrial`.
- `PaywallProduct` — backend-agnostic product model (id, displayPrice, rawPrice, currencyCode, period, perks, trialPeriod, originalPrice, badge).
- `PaywallPeriod` enum — `weekly`, `monthly`, `annual`, `lifetime`, `custom`.
- `PaywallCopy` — every user-facing string in one translatable bundle (headline, subhead, features, ctas, restoreText, finePrint, privacyPolicyUrl, termsOfServiceUrl, testimonials, socialProof).
- `PaywallTestimonial` — quote + author + role for the storytelling variant.
- `PaywallResult` sealed union — `PaywallPurchased`, `PaywallRestored`, `PaywallDismissed`, `PaywallErrored`. Exhaustive `switch` supported.
- Granular callbacks: `onView`, `onCtaTap`, `onPurchaseSuccess`, `onPurchaseFail`, `onDismiss`.

**The 12 variants**
- `carousel` — swipeable feature highlights, single CTA, animated dot indicator.
- `comparison` — selectable product cards with per-card perks override and badge highlighting.
- `trialToggle` — monthly/annual toggle with auto-computed savings % and trial-aware CTA copy.
- `lifetime` — single-price hero with savings-vs-annual badge (36-month equivalence heuristic).
- `soft` — primary CTA plus secondary "Continue with limits" fallback.
- `hard` — onboarding-blocking, dominant 64-px CTA, subtle close (App Store compliant).
- `winback` — strikethrough original price + auto-computed discount % badge.
- `family` — multi-seat tier with per-person price across 6 default seats (Apple Family Sharing standard).
- `minimal` — Pieter Levels aesthetic: single price, single CTA, no clutter.
- `storytelling` — long-scroll with testimonials + social-proof badge.
- `gamified` — progress ring + trophy + "+N rewards waiting" badge, numbered reward rows.
- `reverseTrial` — "you're on Pro for X days" status badge, plan switching via chips.

**Theming**
- `PaywallTheme` — full token set (primary, onPrimary, surface, onSurface, accent, background, outline, success, radii, padding, text styles).
- `PaywallTheme.brand(primary, accent?, brightness?)` — derives the full theme from one brand color via relative-luminance contrast.
- `PaywallTheme.fromTheme(BuildContext)` — inherits from the ambient Material `ColorScheme`.
- `copyWith(...)` for granular overrides.

**Adapters**
- `PaywallAdapter` abstract interface (`buy`, `restore`). Both methods must not throw — wrap exceptions in `PaywallErrored`.
- `PreviewAdapter` (default) — instant-buy, useful for design / preview / when callers handle real purchases inside `onCtaTap`.
- `IapAdapter` — wraps `package:in_app_purchase`. Handles purchase-stream lifecycle, completion, error mapping. Optional `consumable` flag.
- `PaywallScope` — `InheritedWidget` exposing the active adapter to variants.
- Recipe doc (`doc/ADAPTERS.md`) with complete RevenueCat adapter, Stripe Checkout skeleton, and `FakeAdapter` test pattern.

**Helpers**
- `formatPaywallPrice(rawPrice, currencyCode, period, locale?)` — locale-aware via `intl`, period-suffix aware.
- `computeSavingsPercent(fromPricePerMonth, toPricePerMonth)` — pure helper for "Save 40%" badges.

**Polish**
- `PaywallEntrance` widget — subtle 280 ms fade+slide-up applied to every variant via the router.
- `AnimatedContainer` selection feedback (180 ms easeOut) on `comparison`, `trialToggle`, `reverseTrial` selectors.
- Async-capable `PaywallPrimaryButton` with built-in spinner during purchase.
- Async-capable Restore link that dispatches `adapter.restore()` and pops with the result.

**Localization**
- RTL-safe — Arabic / Hebrew supported out of the box.
- Locale-aware price formatting via `intl`.
- Every user-facing string sourced from `PaywallCopy` — paywall_kit hardcodes no copy.

**Example app**
- `example/lib/main.dart` — Material 3 demo with a 4×3 grid of all 12 variants. Tap to launch, SnackBar describes the result.

**Quality**
- 85 tests covering models, theme, adapters, widget rendering, and RTL layout across all 12 variants.
- `flutter analyze --fatal-warnings` clean under strict lint config (strict-casts, strict-inference, prefer-single-quotes, sort-constructors-first, etc.).
- GitHub Actions CI runs `dart format --set-exit-if-changed`, `flutter analyze --fatal-warnings`, and `flutter test --coverage` on every push and PR.

### Limitations (planned for v0.2)

- No async product fetching from the adapter — products are passed pre-fetched. Once `fetchProducts` lands, skeleton loaders unlock.
- No confetti animation on success. Deferred (adds dep weight, doesn't move conversion).
- `IapAdapter` is implemented but not integration-tested. Live IAP testing requires sandbox accounts / signed builds outside the unit-test suite.
- A/B testing helper not built-in. Use the `variant:` parameter with your own feature flag.

## [0.0.1] — 2026-05-28

Initial scaffold. Strict lint config, planning docs, folder structure. Not published.
