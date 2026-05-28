# paywall_kit — Phase Tracker

Living document. Update at the end of every working session.

**Source of truth for:** What's done, what's in flight, what's blocked, current velocity.

**Last updated:** 2026-05-28 (Phase 0 — kickoff)

---

## At-a-glance

| Metric | Value |
|---|---|
| Current phase | Phase 0 — Foundation 🟡 In Progress |
| Phase progress | 0 / 10 phases |
| Days elapsed | 0 |
| Days remaining (est.) | 10–14 |
| Target ship date | 🚀 Earliest: 2026-06-07 · ⛔ Must-ship-by: 2026-06-11 |
| 🔴 features done | 0 / ~50 |
| Test coverage | 0 tests |
| Open blockers | None |
| Commits | 0 |

---

## Phase status board

| # | Phase | Status | Start | End | Days | Tasks done | Blocker |
|---|---|---|---|---|---|---|---|
| 0 | Foundation | 🟡 In Progress | 2026-05-28 | — | 0.5 | 0 / 9 | — |
| 1 | Core API + Theme | ⚪ Not started | — | — | 1 | 0 / 7 | Phase 0 |
| 2 | Variants 1–4 (Carousel, Comparison, Trial, Lifetime) | ⚪ Not started | — | — | 2.5 | 0 / 6 | Phase 1 |
| 3 | Variants 5–8 (Soft, Hard, Win-back, Family) | ⚪ Not started | — | — | 2 | 0 / 5 | Phase 2 |
| 4 | Variants 9–12 (Minimal, Storytelling, Gamified, Reverse) | ⚪ Not started | — | — | 2 | 0 / 6 | Phase 3 |
| 5 | Backend Adapters (IAP + RevenueCat) | ⚪ Not started | — | — | 2 | 0 / 6 | Phase 4 |
| 6 | L10n + Animation Polish | ⚪ Not started | — | — | 1.5 | 0 / 5 | Phase 5 |
| 7 | Example App + Marketing Assets | ⚪ Not started | — | — | 1 | 0 / 4 | Phase 6 |
| 8 | Tests + Documentation | ⚪ Not started | — | — | 1 | 0 / 6 | Phase 7 |
| 9 | Publish | ⚪ Not started | — | — | 0.5 | 0 / 6 | Phase 8 |

**Legend:** ⚪ Not started · 🟡 In progress · 🟢 Done · 🔴 Blocked · ⚫ Skipped

---

## Phase 0 — Foundation 🟡 IN PROGRESS

**Goal:** Repo scaffolded, planning docs in place, deps resolved.

| Task | Status | Notes |
|---|---|---|
| `flutter create --template=package paywall_kit` | ⚪ | |
| Write `CLAUDE.md` (context, skills, layout) | ⚪ | |
| Update `pubspec.yaml` — description, topics, repo URL | ⚪ | Topics: `paywall`, `subscription`, `iap`, `monetization`, `revenuecat` |
| Add deps: `in_app_purchase`, `intl` | ⚪ | |
| Add optional dep guidance: `purchases_flutter` (RC) | ⚪ | Documented, not added |
| Strict `analysis_options.yaml` | ⚪ | strict-casts, strict-inference, single-quotes, trailing-commas |
| Create folder structure: `lib/src/{core,variants,adapters,theme,animation}/` | ⚪ | |
| Initial commit | ⚪ | |
| `flutter analyze` + `flutter test` clean | ⚪ | |

**Phase 0 verification (DoD):**
- [ ] `flutter analyze` → 0 issues
- [ ] `flutter test` → placeholder test passes
- [ ] Folder structure matches PHASES.md target layout
- [ ] Initial commit on `main`
- [ ] All deps resolve cleanly via `flutter pub get`

**Features delivered (planned):** F-CORE-01..07 (skeletons only)

---

## Phase 1 — Core API + Theme ⚪ NOT STARTED

**Goal:** `PaywallProduct`, `PaywallCopy`, `PaywallTheme`, `PaywallResult` data classes locked.

(Tasks copied from PHASES.md when phase starts.)

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

- **2026-05-28** — Project kickoff. Created `FEATURES.md`, `PHASES.md`, `TRACKER.md`. Starting Phase 0 scaffold.
