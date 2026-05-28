# paywall_kit — Claude Code Context

> **Package goal:** 12 conversion-optimized, drop-in Flutter paywall screens.
> Backend-agnostic — works with `in_app_purchase` (native, free) or RevenueCat
> via a single config flag. No vendor lock-in. Beautiful defaults.
>
> **Target:** pub.dev v0.1.0 by 2026-06-11 (~14 days). Viral launch via
> screenshot grid of all 12 variants.

---

## Project state

| Field | Value |
|---|---|
| Status | 🚧 Day 1 — scaffolded |
| Flutter SDK | 3.35.5+ (Dart 3.9.2) |
| Org | dev.jayu |
| Repo | https://github.com/jayu1023/paywall_kit |
| License | BSD-3-Clause (planned) |
| Target ship | 🚀 Jun 7, 2026 (earliest) · ⛔ Jun 11, 2026 (must-ship-by) |

---

## The user (who you're working with)

Senior Flutter dev. **Lazy by design** — wants the shortest path to a
working solution. Skip beginner explanations. Give code first, explain
only the non-obvious. Prefer pub.dev packages over hand-rolled when
reasonable. Don't pad responses.

---

## Available Claude Code skills (use these proactively)

| Skill | When to use |
|---|---|
| `flutter-expert` | Widget design, Dart idioms, perf questions |
| `flutter-testing-apps` | Adding widget tests, golden tests |
| `flutter-animating-apps` | Entrance animations, toggle animations, confetti |
| `impeccable` | Reviewing variants for visual polish |
| `ui-ux-pro-max` | Theme system, color palette choices |
| `app-store-screenshots` | Recording the launch GIF + variant grid |
| `writing-plans` | Before each multi-variant phase |
| `executing-plans` | When executing a written plan with checkpoints |
| `simplify` | Code review on adapters + theme system once they exist |

---

## Architecture

Three principles:

1. **Variant = independent widget.** Each of the 12 paywall variants is a
   self-contained widget under `lib/src/variants/`. No shared base class
   beyond `StatelessWidget`. Easier to maintain, easier to ship variants
   incrementally, easier to delete a variant that doesn't perform.

2. **Backend-agnostic via adapter pattern.** `PaywallAdapter` interface in
   `lib/src/adapters/`. Concrete implementations: `IapAdapter` (native),
   `RevenueCatAdapter` (opt-in dep — imported lazily). Adding Stripe /
   Paddle / your-own is implementing 3 methods.

3. **Theme + Copy + Products = props.** No globals, no service locator.
   `PaywallKit.show(context, variant: ..., theme: ..., copy: ..., products: ...,
   adapter: ...)`. Everything passed explicitly. Stateless by default.

### Public API contract (v0.1 — locked unless we find a real reason to change)

```dart
Future<PaywallResult> result = await PaywallKit.show(
  context,
  variant: PaywallVariant.lifetimeDeal,
  products: [monthlyProduct, annualProduct, lifetimeProduct],
  theme: PaywallTheme.brand(primary: Colors.indigo),
  copy: PaywallCopy(
    headline: 'Unlock everything',
    features: ['No ads', 'Cloud sync', 'AI assistant'],
  ),
  adapter: PaywallAdapter.iap(),  // or .revenueCat(apiKey: ...)
  onView: () {},
  onCtaTap: (product) {},
  onPurchaseSuccess: (receipt) {},
  onPurchaseFail: (error) {},
  onDismiss: () {},
);
```

---

## v0.1 scope (14-day ship)

**IN:**
- 12 variants (see FEATURES.md F-VAR-01..12)
- `IapAdapter` (in_app_purchase)
- `RevenueCatAdapter` (purchases_flutter — opt-in)
- `CustomAdapter` interface
- `PaywallTheme` + brand-color factory
- `PaywallCopy` (translation-ready strings)
- Locale-aware price formatting via `intl`
- RTL support
- Dark mode
- Restore Purchases button on every variant
- Skeleton loaders while products fetch
- Entrance + toggle animations
- Granular callbacks (`onView`, `onCtaTap`, `onPurchaseSuccess`, etc.)

**OUT (v0.2+):**
- A/B testing helper (use the callbacks + your own feature flag)
- Built-in analytics adapter (use callbacks)
- AdaptyAdapter
- Web / desktop screens (mobile-only v1)
- Custom shaders or particle effects

---

## File layout (target)

```
paywall_kit/
├── lib/
│   ├── paywall_kit.dart            # public exports only
│   └── src/
│       ├── core/
│       │   ├── paywall_kit.dart    # PaywallKit.show()
│       │   ├── paywall_product.dart
│       │   ├── paywall_copy.dart
│       │   └── paywall_result.dart
│       ├── theme/
│       │   └── paywall_theme.dart
│       ├── variants/
│       │   ├── carousel.dart
│       │   ├── comparison.dart
│       │   ├── trial_toggle.dart
│       │   ├── lifetime.dart
│       │   ├── soft.dart
│       │   ├── hard.dart
│       │   ├── winback.dart
│       │   ├── family.dart
│       │   ├── minimal.dart
│       │   ├── storytelling.dart
│       │   ├── gamified.dart
│       │   └── reverse_trial.dart
│       ├── adapters/
│       │   ├── paywall_adapter.dart       # abstract
│       │   ├── iap_adapter.dart
│       │   └── revenuecat_adapter.dart    # imports purchases_flutter conditionally
│       └── animation/
│           ├── entrance.dart
│           └── confetti.dart
├── example/
│   └── lib/main.dart               # variant grid demo
├── test/
│   ├── core/
│   ├── variants/
│   └── adapters/
├── PHASES.md
├── FEATURES.md
├── TRACKER.md
└── README.md
```

---

## Ground rules for Claude in this package

1. **No `// what this does` comments.** Only `// why` comments when the
   constraint isn't obvious.
2. **No premature abstraction.** 12 similar variants > a paywall framework.
   Resist the urge to extract a `BasePaywallScreen` — variants are simpler
   when each owns its own layout.
3. **Match existing patterns** in the codebase before introducing new ones.
4. **Run `flutter analyze` before declaring a task done.** Fix lint errors.
5. **Run `flutter test` before committing.**
6. **Use available skills proactively.** If a task fits a skill, invoke it.
7. **Keep `pubspec.yaml` deps minimal.** Currently: `in_app_purchase`,
   `intl`. RC is *opt-in via the host app*, not a paywall_kit dep.
8. **No design-system dependencies.** No shadcn, no Material 3 styling
   hacks. We render Material widgets and let user theme override.

---

## Pub.dev discoverability checklist (before publish)

- [x] `description` < 60 chars, includes "paywall" + "subscription"
- [x] `homepage` + `repository` + `issue_tracker` pointing to GitHub
- [x] `topics`: `paywall`, `subscription`, `monetization`, `iap`, `revenuecat`
- [ ] `screenshots`: at least 1 GIF (variant grid auto-scroll) + 12 still shots
- [ ] README with: install, basic usage, variant gallery, RC recipe, comparison vs `purchases_ui_flutter`
- [x] CHANGELOG.md with 0.0.1 entry
- [ ] LICENSE file (BSD-3-Clause)
- [ ] `dart pub publish --dry-run` passes with 0 warnings
- [ ] All public APIs have dartdoc comments

---

## Viral launch playbook (Phase 9)

1. **Tweet** with the 12-variant grid screenshot. Tag `@FlutterDev`, indie
   hacker accounts. Hook: "12 paywalls, drop one in, ship."
2. **r/FlutterDev** post: "I built a drop-in paywall library — 12 designs,
   no vendor lock"
3. **r/indiehackers** post: same headline
4. **Flutter Weekly** newsletter submission
5. **Awesome Flutter PR** under `### Subscriptions & In-App Purchases`
6. **Twitter thread** (Day 2): walk through 3 variants with code snippets

---

## Related project files

- `../IDEAS.md` — package backlog
- `../ROADMAP.md` — 7-package portfolio sequence + deadlines
- `~/.claude/projects/-Users-limbanijayhasmukhbhai-Downloads-jayu-pcakage/memory/` — persistent memory
