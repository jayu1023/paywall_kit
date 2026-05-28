# paywall_kit — Phase Tracker

Living document. Update at the end of every working session.

**Source of truth for:** What's done, what's in flight, what's blocked, current velocity.

**Last updated:** 2026-05-28 (Phase 1 done — Phase 2 next)

---

## At-a-glance

| Metric | Value |
|---|---|
| Current phase | Phase 2 — Variants 1–4 ⚪ Next |
| Phase progress | 2 / 10 phases complete |
| Days elapsed | 0.5 |
| Days remaining (est.) | ~10–13 |
| Target ship date | 🚀 Earliest: 2026-06-07 · ⛔ Must-ship-by: 2026-06-11 |
| 🔴 features done | 7 / ~50 (core API + theme locked) |
| Test coverage | 33 tests passing |
| Open blockers | None |
| Commits | 3 |

---

## Phase status board

| # | Phase | Status | Start | End | Days | Tasks done | Blocker |
|---|---|---|---|---|---|---|---|
| 0 | Foundation | 🟢 Done | 2026-05-28 | 2026-05-28 | 0.25 | 9 / 9 | — |
| 1 | Core API + Theme | 🟢 Done | 2026-05-28 | 2026-05-28 | 0.25 | 7 / 7 | — |
| 2 | Variants 1–4 (Carousel, Comparison, Trial, Lifetime) | ⚪ Not started | — | — | 2.5 | 0 / 6 | — |
| 3 | Variants 5–8 (Soft, Hard, Win-back, Family) | ⚪ Not started | — | — | 2 | 0 / 5 | Phase 2 |
| 4 | Variants 9–12 (Minimal, Storytelling, Gamified, Reverse) | ⚪ Not started | — | — | 2 | 0 / 6 | Phase 3 |
| 5 | Backend Adapters (IAP + RevenueCat) | ⚪ Not started | — | — | 2 | 0 / 6 | Phase 4 |
| 6 | L10n + Animation Polish | ⚪ Not started | — | — | 1.5 | 0 / 5 | Phase 5 |
| 7 | Example App + Marketing Assets | ⚪ Not started | — | — | 1 | 0 / 4 | Phase 6 |
| 8 | Tests + Documentation | ⚪ Not started | — | — | 1 | 0 / 6 | Phase 7 |
| 9 | Publish | ⚪ Not started | — | — | 0.5 | 0 / 6 | Phase 8 |

**Legend:** ⚪ Not started · 🟡 In progress · 🟢 Done · 🔴 Blocked · ⚫ Skipped

---

## Phase 0 — Foundation 🟢 COMPLETE

**Goal:** Repo scaffolded, planning docs in place, deps resolved.

| Task | Status | Notes |
|---|---|---|
| `flutter create --template=package paywall_kit` | 🟢 | Done 2026-05-28 — `dev.jayu` org |
| Write `CLAUDE.md` (context, skills, layout) | 🟢 | Done 2026-05-28 |
| Update `pubspec.yaml` — description, topics, repo URL | 🟢 | Topics: `paywall`, `subscription`, `monetization`, `iap`, `revenuecat` |
| Add deps: `in_app_purchase`, `intl` | 🟢 | `in_app_purchase ^3.2.0`, `intl ^0.20.0` |
| Add optional dep guidance: `purchases_flutter` (RC) | 🟢 | Documented in pubspec comment + CLAUDE.md |
| Strict `analysis_options.yaml` | 🟢 | strict-casts/inference/raw-types + 10 lint rules |
| Create folder structure: `lib/src/{core,variants,adapters,theme,animation}/` | 🟢 | Plus `test/{core,variants,adapters}/` |
| Initial commit | 🟢 | `f54da2c chore: scaffold paywall_kit v0.0.1` |
| `flutter analyze` + `flutter test` clean | 🟢 | analyze: 0 issues · test: 1/1 passing |

**Phase 0 verification (DoD):**
- ✅ `flutter analyze` → 0 issues
- ✅ `flutter test` → placeholder test passes
- ✅ Folder structure matches PHASES.md target layout
- ✅ Initial commit on `main`
- ✅ All deps resolve cleanly via `flutter pub get`

**Features delivered (planned):** F-CORE-01..07 (skeletons only — real APIs land in Phase 1)

**Notes:**
- Git repo initialized inside `paywall_kit/` (independent of parent project repo, same as streamdown pattern)
- LICENSE file present from `flutter create` — needs replacement with BSD-3-Clause text in Phase 8
- TODO before publish: create actual GitHub repo at https://github.com/jayu1023/paywall_kit (currently placeholder in pubspec)

---

## Phase 1 — Core API + Theme 🟢 COMPLETE

**Goal:** `PaywallProduct`, `PaywallCopy`, `PaywallTheme`, `PaywallResult` data classes locked.

| Task | Status | Notes |
|---|---|---|
| `PaywallProduct` (id, price, displayPrice, period, perks, trial, original, badge) | 🟢 | Structural equality, hashCode, toString |
| `PaywallCopy` (headline, subhead, features, ctas, restoreText, finePrint, policy URLs) | 🟢 | Defaults: `'Continue'`, `'Restore Purchases'` |
| `PaywallTheme.brand(primary, accent?, brightness?)` + `.fromTheme(context)` | 🟢 | onPrimary derived via relative luminance |
| `PaywallResult` sealed union (Purchased / Restored / Dismissed / Errored) | 🟢 | Exhaustive switch verified in tests |
| `PaywallKit.show(...)` skeleton (returns dummy `PaywallDismissed`) | 🟢 | Fires onView + onDismiss, asserts non-empty products |
| Locale-aware price formatter helper | 🟢 | `formatPaywallPrice` + `computeSavingsPercent` |
| Unit tests for models + theme (target 20+) | 🟢 | 33 tests passing |

**Phase 1 verification (DoD):**
- ✅ API contract frozen — no more changes to `PaywallProduct`, `PaywallCopy`, `PaywallResult`, `PaywallTheme` constructors without bumping major version
- ✅ 33 tests on models + theme
- ✅ `flutter analyze` → 0 issues
- ✅ All public APIs have dartdoc comments

**Features delivered:** F-CORE-01..07, F-L10N-03, F-L10N-04

**Commit:** Phase 1 work in commits 2–3 on `main`.

---

## Phase 2 — Variants 1–4 ⚪ NOT STARTED

**Goal:** Top 4 highest-converting variants render with placeholder products.

(Tasks copied from PHASES.md when phase starts.)

---

## Phase 3 — Variants 5–8 ⚪ NOT STARTED

(Tasks copied from PHASES.md when phase starts.)

---

## Phase 4 — Variants 9–12 ⚪ NOT STARTED

(Tasks copied from PHASES.md when phase starts.)

---

## Phase 5 — Backend Adapters ⚪ NOT STARTED

(Tasks copied from PHASES.md when phase starts.)

---

## Phase 6 — L10n + Animation Polish ⚪ NOT STARTED

(Tasks copied from PHASES.md when phase starts.)

---

## Phase 7 — Example App + Marketing Assets ⚪ NOT STARTED

(Tasks copied from PHASES.md when phase starts.)

---

## Phase 8 — Tests + Documentation ⚪ NOT STARTED

(Tasks copied from PHASES.md when phase starts.)

---

## Phase 9 — Publish ⚪ NOT STARTED

(Tasks copied from PHASES.md when phase starts.)

---

## Session Log

> Append a brief note after every working session. Date · what was done · what's next.

- **2026-05-28 (PM)** — Project kickoff. Created `FEATURES.md`, `PHASES.md`, `TRACKER.md`, `CLAUDE.md`. **Phase 0 complete** in ~20 min: scaffold + strict lints + folder structure + first commit (`f54da2c`). `flutter analyze` 0 issues, 1 test passing. **Next:** Phase 1 — Core API + Theme (~1 day).
- **2026-05-28 (PM)** — **Phase 1 complete** in ~1 hr (vs 1-day estimate). Built `PaywallProduct`, `PaywallCopy`, `PaywallResult` (sealed union), `PaywallVariant`/`PaywallPeriod` enums, `PaywallTheme.brand` + `.fromTheme`, `formatPaywallPrice` + `computeSavingsPercent` helpers, `PaywallKit.show` skeleton. **33 tests passing**, analyzer 0 issues, all dartdoc'd. API contract is now frozen. **Next:** Phase 2 — Variants 1–4 (Carousel, Comparison, Trial-toggle, Lifetime). ~2.5 days estimate.
