/// Billing period for a [PaywallProduct].
///
/// Drives the per-period suffix in display prices (e.g. `/mo`, `/yr`) and
/// allows variants to compute savings between tiers.
enum PaywallPeriod {
  /// Charged every week.
  weekly,

  /// Charged every month.
  monthly,

  /// Charged once per year.
  annual,

  /// One-time, non-recurring purchase.
  lifetime,

  /// Anything that doesn't fit the above buckets.
  custom,
}
