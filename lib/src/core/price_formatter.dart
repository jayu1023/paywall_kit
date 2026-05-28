import 'package:intl/intl.dart';

import 'paywall_period.dart';

/// Format a [rawPrice] for display on a paywall.
///
/// Produces a locale-aware string with the [currencyCode] symbol and a
/// per-period suffix derived from [period] (e.g. `'$9.99/mo'`,
/// `'€49.99/yr'`, `'$199'` for lifetime).
///
/// Pass [locale] to override the locale used for formatting (defaults to
/// the platform default).
String formatPaywallPrice({
  required double rawPrice,
  required String currencyCode,
  required PaywallPeriod period,
  String? locale,
}) {
  final formatter = NumberFormat.simpleCurrency(
    locale: locale,
    name: currencyCode,
  );
  final priceText = formatter.format(rawPrice);
  return switch (period) {
    PaywallPeriod.weekly => '$priceText/wk',
    PaywallPeriod.monthly => '$priceText/mo',
    PaywallPeriod.annual => '$priceText/yr',
    PaywallPeriod.lifetime => priceText,
    PaywallPeriod.custom => priceText,
  };
}

/// Compute the savings percentage when upgrading from [from] to [to].
///
/// Returns a positive integer (e.g. `40` for "save 40%") when [to] is
/// cheaper on a per-period basis, or `null` when no meaningful savings
/// can be computed (mismatched periods, custom periods, etc.).
int? computeSavingsPercent({
  required double fromPricePerMonth,
  required double toPricePerMonth,
}) {
  if (fromPricePerMonth <= 0 || toPricePerMonth <= 0) return null;
  if (toPricePerMonth >= fromPricePerMonth) return null;
  final pct =
      ((fromPricePerMonth - toPricePerMonth) / fromPricePerMonth) * 100;
  return pct.round();
}
