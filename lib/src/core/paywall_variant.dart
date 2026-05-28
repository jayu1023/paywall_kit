/// The 12 paywall layouts shipped in v0.1.
///
/// Pass to [PaywallKit.show] via the `variant:` argument.
enum PaywallVariant {
  /// Swipeable feature highlights with a single CTA.
  carousel,

  /// Free / Pro / Lifetime column comparison table.
  comparison,

  /// Monthly / annual toggle with trial emphasis.
  trialToggle,

  /// One-time purchase with urgency timer.
  lifetime,

  /// Primary CTA plus a "continue with limits" secondary option.
  soft,

  /// Onboarding-blocking — no escape hatch.
  hard,

  /// For lapsed subscribers — discount + strikethrough price.
  winback,

  /// Multi-seat family tier.
  family,

  /// Single price, single CTA — Pieter Levels aesthetic.
  minimal,

  /// Long-scroll with testimonials and social proof.
  storytelling,

  /// Unlock-animation framing with streak / progress.
  gamified,

  /// "You're already on Pro for 7 days" reverse-trial framing.
  reverseTrial,
}
