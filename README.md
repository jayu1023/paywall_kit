# paywall_kit

> 🚧 **Pre-release scaffold (v0.0.1).** This package is under active development. First public release: v0.1.0, targeted ship 2026-06-11.

**12 conversion-optimized, drop-in Flutter paywall screens. Backend-agnostic — `in_app_purchase` or RevenueCat with one flag.**

```dart
// (planned API — landing in Phase 1)
PaywallKit.show(
  context,
  variant: PaywallVariant.lifetimeDeal,
  products: [monthlyProduct, annualProduct, lifetimeProduct],
  theme: PaywallTheme.brand(primary: Colors.indigo),
  copy: PaywallCopy(
    headline: 'Unlock everything',
    features: ['No ads', 'Cloud sync', 'AI assistant'],
  ),
  onPurchase: (product) async => await iap.buy(product),
);
```

## What's coming in v0.1.0

- 12 hand-crafted paywall variants (Carousel, Comparison, Trial-toggle, Lifetime, Soft, Hard, Win-back, Family, Minimal, Storytelling, Gamified, Reverse-trial)
- `in_app_purchase` adapter (native, zero vendor lock)
- RevenueCat adapter (opt-in)
- Custom adapter interface (Stripe, Paddle, etc.)
- Fully themeable, RTL-safe, dark-mode ready
- Locale-aware price formatting

See [PHASES.md](PHASES.md) for the build plan and [FEATURES.md](FEATURES.md) for the full feature catalog.

## License

BSD-3-Clause (planned)
