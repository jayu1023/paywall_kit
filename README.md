# paywall_kit

> **12 conversion-optimized, drop-in Flutter paywall screens.** Backend-agnostic — works with `in_app_purchase` (native, free) or RevenueCat via a single adapter swap. No vendor lock-in.

[![pub.dev](https://img.shields.io/badge/pub.dev-paywall__kit-blue)](https://pub.dev/packages/paywall_kit) · 0.1.0 ship target

```dart
final result = await PaywallKit.show(
  context,
  variant: PaywallVariant.lifetime,
  products: [monthly, annual, lifetime],
  copy: PaywallCopy(
    headline: 'Unlock everything',
    features: ['No ads', 'Cloud sync', 'AI assistant'],
  ),
  adapter: IapAdapter(),  // or PreviewAdapter(), or your own
);

switch (result) {
  case PaywallPurchased(:final product): grant(product);
  case PaywallRestored(:final products): restore(products);
  case PaywallDismissed(): break;
  case PaywallErrored(:final error): logError(error);
}
```

## Install

```yaml
dependencies:
  paywall_kit: ^0.1.0
```

## The 12 variants

| Variant | Best for |
|---|---|
| `carousel` | Onboarding flows with swipeable feature highlights |
| `comparison` | Multi-tier offers (Free / Pro / Lifetime) |
| `trialToggle` | Subscriptions with a free-trial conversion play |
| `lifetime` | Indie-style one-time-purchase apps |
| `soft` | Non-blocking nudge with a "continue with limits" escape |
| `hard` | Onboarding-blocking, no skip |
| `winback` | Lapsed-subscriber re-engagement with discount |
| `family` | Family Sharing-compatible multi-seat tier |
| `minimal` | Pieter Levels aesthetic — single price, single CTA |
| `storytelling` | Long-scroll with testimonials + social proof |
| `gamified` | Reward-unlock framing with progress ring |
| `reverseTrial` | "You're on Pro for 7 days" post-onboarding pattern |

Run the example app to tap through every variant: `cd example && flutter run`.

## Backend adapters

`PaywallAdapter` is the bridge between variants and your purchase system.

| Adapter | When to use |
|---|---|
| `PreviewAdapter` *(default)* | Design / preview / when you handle purchases yourself in `onPurchaseSuccess`. Returns `PaywallPurchased` instantly. |
| `IapAdapter` | Native App Store / Google Play via `package:in_app_purchase`. |
| Your own | Implement `PaywallAdapter` for RevenueCat, Stripe, Paddle, etc. See [`doc/ADAPTERS.md`](doc/ADAPTERS.md) for a complete RevenueCat example. |

```dart
// IAP
adapter: IapAdapter()

// Custom (RevenueCat shown in doc/ADAPTERS.md)
adapter: const RevenueCatAdapter()

// Preview (default)
adapter: const PreviewAdapter()
```

## Theming

```dart
// One brand color → full theme
theme: PaywallTheme.brand(primary: Colors.indigo)

// Or inherit from Material's ColorScheme
theme: PaywallTheme.fromTheme(context)

// Or hand-craft every token
theme: PaywallTheme(
  primary: ..., onPrimary: ..., surface: ..., accent: ...,
  cardRadius: ..., buttonRadius: ..., padding: ...,
)
```

Dark mode + RTL (Arabic, Hebrew) work out of the box. Locale-aware price formatting via `intl`.

## Compared to `purchases_ui_flutter`

|  | `purchases_ui_flutter` | **`paywall_kit`** |
|---|---|---|
| Variants | 1 customizable template | **12 hand-crafted layouts** |
| Backend | RevenueCat only | **IAP, RevenueCat, Stripe, custom** |
| Vendor lock-in | RC dashboard required | **None** |
| Theming | RC dashboard config | **Code-defined** `PaywallTheme` |
| Free option | Requires RC project | **Yes** (native `in_app_purchase`) |

## Status

🚧 v0.1.0 ship target: **2026-06-11**. See [`PHASES.md`](PHASES.md) for the build plan and [`TRACKER.md`](TRACKER.md) for current progress.

## License

BSD-3-Clause (planned)
