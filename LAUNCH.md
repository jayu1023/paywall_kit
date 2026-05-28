# paywall_kit — Launch Playbook

Every post you need to make, every platform, every copy-paste-ready blurb.

**Shipped:** 2026-05-28 · **pub.dev:** https://pub.dev/packages/paywall_kit · **GitHub:** https://github.com/jayu1023/paywall_kit · **Release:** https://github.com/jayu1023/paywall_kit/releases/tag/v0.1.0

---

## ⏰ Launch timeline

| When | What |
|---|---|
| **Today (Day 0)** | Tweet, LinkedIn, r/FlutterDev post, Awesome Flutter PR, Flutter Weekly submission |
| **Day 1** | Flutter Tap newsletter tweet, r/indiehackers post |
| **Day 2** | Hacker News Show HN (best on a Tuesday or Wednesday morning, US time) |
| **Day 3–5** | dev.to + Medium long-form article |
| **Day 7** | Follow-up tweet w/ stats ("paywall_kit hit X downloads in week 1") |

---

## 📋 Checklist — tick as you go

- [ ] **1. Twitter / X** — short post w/ screenshot
- [ ] **2. LinkedIn** — long-form professional post
- [ ] **3. r/FlutterDev** — discussion-friendly post
- [ ] **4. Awesome Flutter PR** — single line in `Subscriptions & In-App Purchases`
- [ ] **5. Flutter Weekly** — newsletter submission
- [ ] **6. Flutter Tap** — tweet at `@fluttertap` newsletter
- [ ] **7. r/indiehackers** — same headline, different angle
- [ ] **8. Hacker News** — Show HN (Day 2)
- [ ] **9. dev.to article** — long-form technical writeup (Day 3–5)
- [ ] **10. Medium** — mirror of dev.to article
- [ ] **11. GitHub Discussions** — pin a "Welcome / Feedback" thread

---

## 1️⃣ Twitter / X

**Where:** https://twitter.com/compose/post

**Pre-written tweet:**

```
🚀 Just shipped paywall_kit on pub.dev

12 conversion-optimized Flutter paywall screens.
Backend-agnostic — works with in_app_purchase (free) or RevenueCat with one flag.

12 designs. Drop one in. Ship.

📦 https://pub.dev/packages/paywall_kit

#FlutterDev #IndieHackers #Flutter
```

**Steps:**
1. Open https://twitter.com/compose/post
2. Paste the tweet above
3. Attach a screenshot — open the example app (`cd example && flutter run`), screenshot the variant grid (or any one polished variant). Tweet supports up to 4 images — consider posting the grid + 3 variant screenshots
4. Click **Post**
5. Bonus: quote-tweet yourself 1 hour later with one of the variant screenshots: *"Here's the comparison variant in action"*

---

## 2️⃣ LinkedIn

**Where:** https://www.linkedin.com/feed/?shareActive=true

**Pre-written post:**

```
🚀 Just shipped my second Flutter package on pub.dev: paywall_kit

After streamdown last week (a flicker-free streaming markdown renderer for AI apps), I noticed every indie Flutter dev I know spends 2–3 days designing paywall screens for each app they ship. Existing solutions lock you into specific backends or look generic.

So I built paywall_kit:

✅ 12 conversion-optimized variants — carousel, comparison, trial-toggle, lifetime, soft, hard, win-back, family, minimal, storytelling, gamified, reverse-trial
✅ Backend-agnostic — in_app_purchase (native, free), RevenueCat, Stripe, or your own (small adapter interface)
✅ Themed in one line: PaywallTheme.brand(primary: Colors.indigo)
✅ Async-aware CTAs with built-in spinners
✅ RTL-safe (Arabic / Hebrew tested), dark mode, locale-aware price formatting
✅ 85 tests passing, 0 lint issues

The full integration:

await PaywallKit.show(
  context,
  variant: PaywallVariant.lifetime,
  products: [monthly, annual, lifetime],
  copy: PaywallCopy(headline: 'Unlock everything', features: [...]),
  adapter: IapAdapter(),
);

📦 pub.dev: https://pub.dev/packages/paywall_kit
🔧 GitHub: https://github.com/jayu1023/paywall_kit

What paywall pattern converts best in your apps? Curious to hear what I might have missed.

#Flutter #FlutterDev #MobileDevelopment #IndieHackers #SaaS #OpenSource
```

**Steps:**
1. Open LinkedIn
2. Click **Start a post**
3. Paste the text above
4. Attach the variant-grid screenshot
5. Post

---

## 3️⃣ r/FlutterDev

**Where:** https://www.reddit.com/r/FlutterDev/submit

**Title:**

```
I built a drop-in paywall library for Flutter — 12 designs, no vendor lock
```

**Post body:**

```
Hey r/FlutterDev,

After shipping streamdown (streaming markdown for AI apps) last week, I kept hearing the same complaint from indie devs: every time they ship a paid app, they spend 2–3 days hand-designing the paywall.

So I built **paywall_kit** — 12 hand-crafted paywall layouts, backend-agnostic (works with `in_app_purchase` OR RevenueCat OR your own backend via a small adapter interface).

**Quick rundown:**

- 12 variants — see the README table for which fits which use case
- Default `PreviewAdapter` for design / preview (returns success instantly — useful when you handle real purchases yourself in `onCtaTap`)
- `IapAdapter` wrapping `package:in_app_purchase` for native App Store / Play Store
- For RevenueCat / Stripe / etc, implement `PaywallAdapter` (2 methods). Full recipe in `doc/ADAPTERS.md`
- Themed via `PaywallTheme.brand(primary: Colors.indigo)` — derives the full palette
- RTL-safe (Arabic / Hebrew tested), dark mode, locale-aware price formatting via `intl`

**One-line integration:**

```dart
final result = await PaywallKit.show(
  context,
  variant: PaywallVariant.lifetime,
  products: [monthly, annual, lifetime],
  copy: PaywallCopy(headline: 'Unlock everything', features: [...]),
  adapter: IapAdapter(),
);
```

📦 https://pub.dev/packages/paywall_kit
🔧 https://github.com/jayu1023/paywall_kit

Feedback welcome — especially: which variant did I miss?
```

**Steps:**
1. Open https://www.reddit.com/r/FlutterDev/submit
2. Choose **Text post** (not link — text posts get more engagement)
3. Paste the title and body
4. **No flair needed** unless mods ask
5. Submit
6. Reply to early commenters within ~1 hour for the algorithm boost

---

## 4️⃣ Awesome Flutter PR

**Where:** https://github.com/Solido/awesome-flutter

**Steps:**
1. Fork the repo at https://github.com/Solido/awesome-flutter
2. Edit `README.md` in your fork
3. Find the section `### Subscriptions & In-App Purchases` (use Cmd-F to search)
4. Add this single line in alphabetical order:

```
- [paywall_kit](https://github.com/jayu1023/paywall_kit) - 12 conversion-optimized, drop-in Flutter paywall screens. Backend-agnostic (in_app_purchase, RevenueCat, custom).
```

5. Commit message: `Add paywall_kit to Subscriptions & In-App Purchases`
6. Open a PR titled: `Add paywall_kit (12 drop-in paywall variants)`
7. PR description:

```
**Package:** paywall_kit
**Section:** Subscriptions & In-App Purchases
**One-liner:** 12 conversion-optimized, drop-in Flutter paywall screens. Backend-agnostic.

**Why it belongs:**
- 85 tests, 0 lint issues
- BSD-3-Clause (Flutter-ecosystem compatible)
- Works with `in_app_purchase` (free) AND RevenueCat AND custom backends
- 12 distinct paywall layouts (not a single customizable template)
- Active maintenance (just shipped today)

pub.dev: https://pub.dev/packages/paywall_kit
```

---

## 5️⃣ Flutter Weekly Newsletter

**Where:** https://flutterweekly.net/submit

**Steps:**
1. Open https://flutterweekly.net/submit
2. Title: `paywall_kit — 12 drop-in Flutter paywall screens`
3. URL: `https://pub.dev/packages/paywall_kit`
4. Description (paste):

```
12 conversion-optimized, drop-in Flutter paywall screens. Backend-agnostic — works with in_app_purchase (free, native) or RevenueCat via a single adapter swap. Themed in one line, RTL-safe, 85 tests passing.
```

5. Category: **Packages**
6. Submit

---

## 6️⃣ Flutter Tap Newsletter

**Where:** Twitter — quote-tweet or reply to a recent `@fluttertap` post

**Tweet:**

```
@fluttertap 12 drop-in paywall screens for Flutter — just shipped paywall_kit on pub.dev 🚀

Backend-agnostic: in_app_purchase (free), RevenueCat, or your own. One config flag.

📦 https://pub.dev/packages/paywall_kit
```

**Steps:**
1. Open https://twitter.com/fluttertap
2. Find their most recent tweet
3. Reply with the tweet above (or quote-tweet it)
4. Attach the variant-grid screenshot

---

## 7️⃣ r/indiehackers

**Where:** https://www.reddit.com/r/indiehackers/submit

**Title:**

```
Shipped a Flutter package for paywall screens — 12 designs in one library
```

**Body:**

```
Tired of designing the paywall screen from scratch every time I ship a Flutter app.

Just shipped **paywall_kit** — 12 conversion-optimized Flutter paywall screens. Backend-agnostic — works with the free `in_app_purchase` plugin or RevenueCat via a single config swap.

The 12 variants cover the patterns I've seen in successful apps:

- **Carousel, Comparison, Trial-toggle, Lifetime** — the conversion classics
- **Soft (with skip), Hard (no skip)** — tone variants
- **Win-back, Family, Reverse-trial** — situational
- **Minimal (Pieter Levels style), Storytelling, Gamified** — aesthetic variants

One line:

```dart
await PaywallKit.show(context, variant: PaywallVariant.lifetime, products: [...], copy: PaywallCopy(...));
```

pub.dev: https://pub.dev/packages/paywall_kit
GitHub: https://github.com/jayu1023/paywall_kit

Would love feedback on which patterns convert best in your apps.
```

**Steps:**
1. Open https://www.reddit.com/r/indiehackers/submit
2. Choose **Text post**
3. Paste title + body
4. Submit

---

## 8️⃣ Hacker News — Show HN

**Where:** https://news.ycombinator.com/submit

**Important:** Best time to submit is **Tuesday or Wednesday between 7–9 AM US Pacific Time**. Avoid weekends.

**Title:**

```
Show HN: Paywall_kit – 12 drop-in paywall screens for Flutter, backend-agnostic
```

**URL field:** `https://pub.dev/packages/paywall_kit`

**Text field (the first comment you make, posted right after submission):**

```
paywall_kit gives you 12 conversion-optimized Flutter paywall screens via one API call. Backend-agnostic — works with `package:in_app_purchase` (native, free) or RevenueCat, with a small adapter interface for Stripe / Paddle / custom backends.

The architecture decision that took the longest: how to handle the async purchase flow without coupling 12 distinct UI variants to a specific backend. The variants dispatch purchases through a `PaywallAdapter` interface exposed via an `InheritedWidget` scope, plus a Future-aware primary button that manages its own spinner state. Variants stay UI-only.

The 12 variants cover common patterns:
- Common conversion: carousel, comparison, trial-toggle, lifetime, win-back, family
- Tone: soft (with skip), hard (no skip)
- Aesthetic: minimal (Pieter Levels), storytelling (testimonials + social proof), gamified (progress ring + rewards), reverse-trial ("you're on Pro for 7 days")

Quality: 85 tests passing, `flutter analyze --fatal-warnings` clean, RTL tested across all 12.

GitHub: https://github.com/jayu1023/paywall_kit

Curious what conversion patterns I missed, or which variants don't pay rent.
```

**Steps:**
1. On a Tuesday/Wednesday morning US Pacific time, open https://news.ycombinator.com/submit
2. Title: paste from above
3. URL: `https://pub.dev/packages/paywall_kit`
4. Click **submit**
5. Open your submission and **post the text above as the first comment** — HN treats this as the author's context
6. **Check back every 30 min for the first 4 hours.** Reply to every comment fast. HN ranks by velocity in the first ~2 hours.

---

## 9️⃣ dev.to article (long-form)

**Where:** https://dev.to/new

**Title:**

```
I built 12 Flutter paywall screens — here's the architecture decision that made it work
```

**Article body (markdown, paste directly into dev.to editor):**

```markdown
After shipping [streamdown](https://pub.dev/packages/streamdown) last week, I noticed every indie Flutter dev I know spends 2–3 days designing the paywall screen for each app they ship. The existing solutions lock you into specific backends or look generic.

So I built **[paywall_kit](https://pub.dev/packages/paywall_kit)** — 12 conversion-optimized paywall screens, drop-in, backend-agnostic.

This post is about the one architecture decision that mattered most.

## The problem

Each of the 12 variants needs to:

1. Render its own unique layout (carousel, comparison, lifetime, etc.)
2. Show a buy button that calls *somebody's* purchase API
3. Show a loading spinner while the purchase is pending
4. Handle success / failure / user-cancellation
5. Wire a "Restore Purchases" link (App Store rule)

If I hard-coded `in_app_purchase` into each variant, I'd lock everyone in. If I made each variant accept a callback, the spinner / state-management logic would be duplicated 12 times.

## The fix: `PaywallAdapter` + `PaywallScope`

The variants don't know anything about purchases. They render UI, fire callbacks, and dispatch buy/restore through an `InheritedWidget` that exposes the active adapter:

```dart
abstract class PaywallAdapter {
  Future<PaywallResult> buy(PaywallProduct product);
  Future<PaywallResult> restore();
}
```

Two implementations ship in the box:

- `PreviewAdapter` — instant success, useful for design / preview / when you handle purchases yourself
- `IapAdapter` — wraps `package:in_app_purchase`, handles the purchase-stream lifecycle

For RevenueCat / Stripe / Paddle, you implement the interface in your own app. The full RevenueCat recipe is in [`doc/ADAPTERS.md`](https://github.com/jayu1023/paywall_kit/blob/main/doc/ADAPTERS.md).

A `PaywallScope` `InheritedWidget` exposes the adapter:

```dart
class PaywallScope extends InheritedWidget {
  final PaywallAdapter adapter;
  // ...
  static PaywallScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PaywallScope>()!;
}
```

Inside each variant:

```dart
Future<void> _onContinue() async {
  final navigator = Navigator.of(context);
  final adapter = PaywallScope.of(context).adapter;
  final result = await adapter.buy(_selected);
  if (!mounted) return;
  navigator.pop(result);
}
```

## The async-aware button

The other duplication trap: every variant needs a spinner while the purchase is pending. Solution: a `FutureOr<void>` button that manages its own busy state.

```dart
class PaywallPrimaryButton extends StatefulWidget {
  final FutureOr<void> Function() onPressed;
  // ...
}

class _PaywallPrimaryButtonState extends State<PaywallPrimaryButton> {
  bool _busy = false;

  Future<void> _handleTap() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await widget.onPressed();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
  // ... build() shows CircularProgressIndicator when _busy
}
```

Each variant just passes its CTA handler. The button handles loading state. Zero duplication.

## What you get

```dart
final result = await PaywallKit.show(
  context,
  variant: PaywallVariant.lifetime,
  products: [monthly, annual, lifetime],
  copy: PaywallCopy(
    headline: 'Unlock everything',
    features: ['No ads', 'Cloud sync', 'AI assistant'],
  ),
  adapter: IapAdapter(),
);

switch (result) {
  case PaywallPurchased(:final product): grant(product);
  case PaywallRestored(:final products): restore(products);
  case PaywallDismissed(): break;
  case PaywallErrored(:final error): logError(error);
}
```

One line opens the paywall. Sealed `PaywallResult` makes the switch exhaustive (Dart 3). Backend-swap is one parameter.

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

## Try it

```yaml
dependencies:
  paywall_kit: ^0.1.0
```

- 📦 pub.dev: https://pub.dev/packages/paywall_kit
- 🔧 GitHub: https://github.com/jayu1023/paywall_kit
- 📖 Adapters recipe: https://github.com/jayu1023/paywall_kit/blob/main/doc/ADAPTERS.md

Feedback welcome — which variant did I miss?
```

**Tags (use all 4):** `flutter`, `dart`, `mobile`, `indiehackers`

**Cover image:** Use the variant-grid screenshot. 1000×420 is the dev.to recommended size.

**Steps:**
1. Open https://dev.to/new
2. Title field: paste from above
3. Body: paste the markdown article
4. Add the 4 tags
5. Upload cover image
6. Click **Publish**

---

## 🔟 Medium (mirror of dev.to)

**Where:** https://medium.com/new-story

**Steps:**
1. Wait 24 h after dev.to publishes (avoids duplicate-content penalties)
2. Open https://medium.com/new-story
3. Paste the same article body
4. Add `<canonical>` link to the dev.to URL via Medium's "Story settings" → "Customize canonical link"
5. Tags: `Flutter`, `Mobile App Development`, `Indie Hackers`, `Open Source`, `Programming`
6. Publish to your default profile (or submit to a publication like "Flutter Community" if you have access)

---

## 1️⃣1️⃣ GitHub Discussions — Welcome / Feedback thread

**Where:** https://github.com/jayu1023/paywall_kit/discussions

**Steps:**
1. Open the Discussions tab. If not enabled: **Settings → Features → Discussions** → enable
2. Click **New discussion**
3. Category: **Announcements**
4. Title: `👋 Welcome to paywall_kit — v0.1.0 is live`
5. Body:

```
Hey everyone — paywall_kit just shipped v0.1.0 on pub.dev 🎉

📦 https://pub.dev/packages/paywall_kit

This thread is for:
- 💡 **Variant requests** — what paywall pattern is missing?
- 🐛 **Bugs** — file issues at https://github.com/jayu1023/paywall_kit/issues
- 🎨 **Showcase** — share screenshots of paywall_kit running in your app
- ❓ **Questions** — how to wire RevenueCat, how to theme, etc.

If you ship with paywall_kit, I'd love to hear about it. Drop a reply with your app name + which variant you chose.
```

6. **Pin** the discussion (top-right ⋯ menu)

---

## 📈 Metrics to watch

| Window | Where | Healthy result |
|---|---|---|
| **24 h** | pub.dev "likes" | ≥ 5 |
| **24 h** | GitHub stars | ≥ 10 |
| **7 d** | pub.dev "likes" | ≥ 30 |
| **7 d** | GitHub stars | ≥ 50 |
| **7 d** | r/FlutterDev upvotes | ≥ 50 |
| **7 d** | dev.to reactions | ≥ 100 |
| **30 d** | pana score | 130 / 130 |
| **30 d** | Awesome Flutter PR | ✅ merged |
| **30 d** | Flutter Weekly mention | ✅ at least once |

If any of the 24 h metrics under-perform: lean harder on Twitter — reply to people asking paywall questions, share variant-specific screenshots over a few days.

---

## 💬 Response templates for common questions

**Q: "Does it work with RevenueCat?"**

> Yes — but RevenueCat isn't a hard dep. Implement `PaywallAdapter` in your app (2 methods); the full recipe is in [doc/ADAPTERS.md](https://github.com/jayu1023/paywall_kit/blob/main/doc/ADAPTERS.md). That way RC-free apps stay slim.

**Q: "Why no `purchases_flutter` dep?"**

> Adding it would force every paywall_kit user to also pull in RC's native pods/AARs (~30 MB). With the adapter interface, you only pay for what you use. The recipe ships, the dep doesn't.

**Q: "Can I customize the layout further?"**

> Theme + Copy + Products as props cover ~80% of customization. For full layout control, you can render any variant as a `Widget` directly — `PaywallKit.show` is the convenient default, not a wall.

**Q: "What about web / desktop?"**

> Variants render fine on web (the example app deploys to GitHub Pages). The blocker is the adapter — `IapAdapter` is mobile-only. On web, use the `PreviewAdapter` + your own Stripe Checkout integration.

**Q: "Why 12 variants and not 20?"**

> Each variant is a hand-crafted layout, not a config flag. Adding the 13th means another widget to maintain + test. The 12 cover ~95% of patterns I've seen in successful indie apps. v0.2 adds variants based on feedback — which one did you want?

**Q: "How is this different from `purchases_ui_flutter`?"**

> `purchases_ui_flutter` is one customizable template that requires a RevenueCat project. paywall_kit is 12 distinct layouts, works without RC, and lets you bring your own backend. Different problem.

---

## 🎯 The 60-second elevator pitch

> *"paywall_kit is 12 drop-in Flutter paywall screens. Backend-agnostic — works with `in_app_purchase` for free, or RevenueCat with one config swap, or any custom backend via a 2-method adapter interface. One line: `PaywallKit.show(context, variant: PaywallVariant.lifetime, ...)`. Saved every Flutter dev I know 2–3 days per app."*

Use that in DMs, comment replies, and the LinkedIn / Twitter bio while the launch is hot.

---

*Last updated: 2026-05-28 — same day as v0.1.0 ship.*
