# paywall_kit — Phase-wise Execution Plan

10 phases, **10–14 working days**. Each phase has explicit Definition of Done,
features delivered (from FEATURES.md), and Claude Code skill to invoke.

**Sequencing rule:** sequential. A phase doesn't start until the previous
phase's DoD is green.

**Target ship:** earliest Jun 7, 2026 · must-ship-by Jun 11, 2026.

---

## Phase 0 — Foundation (Day 1)

**Goal:** Repo scaffolded, planning docs in place, deps resolved.

**Tasks:**
- [ ] `flutter create --template=package paywall_kit`
- [ ] Write `CLAUDE.md` (context, skills, layout)
- [ ] Update `pubspec.yaml` — description, topics (`paywall`, `subscription`, `iap`, `monetization`, `revenuecat`), repo URL
- [ ] Add deps: `in_app_purchase`, `intl` (for locale price formatting)
- [ ] Add optional dep guidance: `purchases_flutter` (RC)
- [ ] Strict `analysis_options.yaml`
- [ ] Create folder structure: `lib/src/{core,variants,adapters,theme,animation}/`
- [ ] First commit

**DoD:** `flutter analyze` 0, `flutter test` 0, folders match plan
**Features:** F-CORE-01..07 (scaffolding only)
**Skill:** none · **Est:** 3h

---

## Phase 1 — Core API + Theme (Day 1–2)

**Goal:** `PaywallProduct`, `PaywallCopy`, `PaywallTheme`, `PaywallResult` data classes locked.

**Tasks:**
- [ ] `PaywallProduct` (id, price, displayPrice, period, perks list)
- [ ] `PaywallCopy` (headline, subhead, features, ctaPrimary, ctaSecondary, restoreText, finePrint)
- [ ] `PaywallTheme.brand(primary, accent)` factory + `PaywallTheme.fromTheme(BuildContext)` factory
- [ ] `PaywallResult` enum + payload class
- [ ] Top-level `PaywallKit.show(...)` skeleton (returns dummy `dismissed` for now)
- [ ] Locale-aware price formatter helper
- [ ] Unit tests for models + theme

**DoD:** API contract frozen. 20+ tests on models/theme.
**Features:** F-CORE-01..07, F-L10N-03, F-L10N-04
**Skill:** `flutter-expert` · **Est:** 1 day

---

## Phase 2 — Variants 1–4: Carousel, Comparison, Trial-Toggle, Lifetime (Day 3–5)

**Goal:** Top 4 highest-converting variants render with placeholder products.

**Tasks:**
- [ ] `CarouselVariant` — PageView w/ dots, swipe physics, single CTA
- [ ] `ComparisonVariant` — 2- or 3-column table, "Pro" column highlighted
- [ ] `TrialToggleVariant` — monthly/annual toggle, trial badge, savings %
- [ ] `LifetimeVariant` — single-price hero, countdown timer slot
- [ ] Wire each into `PaywallKit.show(variant: ...)`
- [ ] Widget tests per variant (renders + fires `onCtaTap`)

**DoD:** All 4 variants render in example app with stub products.
**Features:** F-VAR-01..04, F-ANIM-01, F-ANIM-03, F-QA-01
**Skill:** `flutter-expert`, `impeccable` · **Est:** 2.5 days

---

## Phase 3 — Variants 5–8: Soft, Hard, Win-back, Family (Day 6–8)

**Goal:** Next 4 variants live.

**Tasks:**
- [ ] `SoftPaywallVariant` — primary CTA + "continue with limits" secondary
- [ ] `HardPaywallVariant` — no escape, prominent CTA
- [ ] `WinbackVariant` — strikethrough original price, discount badge
- [ ] `FamilyPlanVariant` — multi-seat tier, family icon
- [ ] Widget tests per variant

**DoD:** 8 variants total render correctly.
**Features:** F-VAR-05..08, F-QA-01
**Skill:** `flutter-expert` · **Est:** 2 days

---

## Phase 4 — Variants 9–12: Minimal, Storytelling, Gamified, Reverse-Trial (Day 9–10)

**Goal:** All 12 variants shipped.

**Tasks:**
- [ ] `MinimalVariant` — Pieter Levels aesthetic, hero + one button
- [ ] `StorytellingVariant` — long-scroll, testimonial cards, social proof badges
- [ ] `GamifiedVariant` — unlock animation, streak/progress bar
- [ ] `ReverseTrialVariant` — "you're on Pro for 7 days" framing
- [ ] Widget tests per variant
- [ ] All 12 visible in example app grid screen

**DoD:** 12 variants live. Tests pass.
**Features:** F-VAR-09..12, F-ANIM-02 (Gamified only)
**Skill:** `flutter-expert`, `impeccable` · **Est:** 2 days

---

## Phase 5 — Backend Adapters (Day 11–12)

**Goal:** Real purchases work via `in_app_purchase` and (optionally) RevenueCat.

**Tasks:**
- [ ] `PaywallAdapter` abstract class (`fetchProducts`, `buy`, `restore`)
- [ ] `IapAdapter` implementation using `in_app_purchase`
- [ ] `RevenueCatAdapter` implementation (`purchases_flutter` import-on-demand)
- [ ] `CustomAdapter` interface + doc
- [ ] `PaywallConfig(backend: PaywallBackend.iap | .revenueCat | .custom(MyAdapter()))`
- [ ] Restore button wired to adapter

**DoD:** Example app makes a real sandbox IAP purchase. RC path works with a real RC project ID.
**Features:** F-ADAPT-01..04, F-RESTORE-01..02
**Skill:** `flutter-expert` · **Est:** 2 days

---

## Phase 6 — Localization + Animation Polish (Day 12–13)

**Goal:** RTL-safe, animation polished, ready for screenshot grid.

**Tasks:**
- [ ] Test all 12 variants in Arabic (RTL) — fix bugs
- [ ] Polish entrance animations (`F-ANIM-01`) — spring curves, stagger
- [ ] Skeleton loaders while products load (`F-ANIM-03`)
- [ ] Confetti on success (off by default, opt-in via theme)
- [ ] Toggle animations (`F-ANIM-04`)

**DoD:** All 12 variants look polished in both light/dark/RTL.
**Features:** F-ANIM-01..04, F-L10N-01..02
**Skill:** `impeccable` · **Est:** 1.5 days

---

## Phase 7 — Example App + Marketing Assets (Day 13)

**Goal:** Public-facing example app + the launch GIF.

**Tasks:**
- [ ] `example/lib/main.dart` — grid screen showing all 12 variants, tap to preview
- [ ] Record launch GIF (3-second auto-scroll through 12 variants)
- [ ] Take screenshots for `pubspec.yaml` `screenshots:` field
- [ ] Build example for web (GitHub Pages)

**DoD:** Example builds for iOS + Android + Web. GIF recorded.
**Features:** F-DOC-02, F-DOC-05
**Skill:** `app-store-screenshots`, `flutter-animating-apps` · **Est:** 1 day

---

## Phase 8 — Tests + Documentation (Day 14)

**Goal:** Production quality.

**Tasks:**
- [ ] 12 widget tests (one per variant), assertions on render + callbacks
- [ ] 24 golden tests (light + dark per variant) — optional but high signal
- [ ] README — install + 30-sec snippet + variant grid + RC recipe + comparison table vs `purchases_ui_flutter`
- [ ] CHANGELOG `[0.1.0]` entry
- [ ] dartdoc on every public API
- [ ] GitHub Actions CI workflow

**DoD:** `flutter test` ≥ 30 tests pass. `flutter analyze --fatal-warnings` 0. pana ≥ 130/130.
**Features:** F-DOC-01..05, F-QA-01..05
**Skill:** `flutter-testing-apps` · **Est:** 1 day

---

## Phase 9 — Publish (Day 14)

**Tasks:**
- [ ] `dart pub publish --dry-run` → 0 warnings
- [ ] Tag `v0.1.0` + push
- [ ] `dart pub publish`
- [ ] GitHub Release with changelog + GIF
- [ ] Launch: Tweet w/ GIF, r/FlutterDev, Awesome Flutter PR, Flutter Weekly submission
- [ ] Update repo's `IDEAS.md` + `ROADMAP.md` to mark ✅

**DoD:** Live on pub.dev. ≥1 organic mention within 24h.
**Features:** all
**Skill:** none · **Est:** 0.5 day

---

## Summary

| Phase | Days | Deliverable |
|---|---|---|
| 0 | 0.5 | Scaffold |
| 1 | 1 | Core API + Theme |
| 2 | 2.5 | Variants 1–4 |
| 3 | 2 | Variants 5–8 |
| 4 | 2 | Variants 9–12 |
| 5 | 2 | Adapters (IAP + RC) |
| 6 | 1.5 | L10n + animation polish |
| 7 | 1 | Example + GIF |
| 8 | 1 | Tests + docs |
| 9 | 0.5 | Publish |
| **Total** | **~14** | **paywall_kit v0.1.0 live on pub.dev** |
