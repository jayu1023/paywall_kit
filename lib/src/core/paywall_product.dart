import 'paywall_period.dart';

/// A single purchasable tier displayed on a paywall.
///
/// Decoupled from any specific IAP backend — adapters
/// (`IapAdapter`, `RevenueCatAdapter`, custom) translate native product
/// objects into [PaywallProduct] before the variant renders.
class PaywallProduct {
  /// Creates a paywall product.
  const PaywallProduct({
    required this.id,
    required this.displayPrice,
    required this.rawPrice,
    required this.currencyCode,
    required this.period,
    this.perks = const <String>[],
    this.trialPeriod,
    this.originalPrice,
    this.badge,
  });

  /// Stable identifier — the App Store / Play Store / RC product ID.
  final String id;

  /// Locale-formatted price for display (e.g. `'$9.99/mo'`).
  ///
  /// If null is passed by callers, adapters can fall back to
  /// `formatPaywallPrice(...)` to produce a sensible default.
  final String displayPrice;

  /// Raw numeric price in the [currencyCode] currency. Used for savings
  /// calculations and sorting; never shown to users directly (use
  /// [displayPrice] for that).
  final double rawPrice;

  /// ISO 4217 currency code (e.g. `'USD'`, `'EUR'`, `'INR'`).
  final String currencyCode;

  /// Billing cadence for this product.
  final PaywallPeriod period;

  /// Per-product perk override. When non-empty, the variant should
  /// prefer these over the global perks list in [PaywallCopy.features].
  final List<String> perks;

  /// Free trial length, when offered (e.g. `'7 days'`, `'1 month'`).
  final String? trialPeriod;

  /// Original (pre-discount) price for win-back / promo paywalls. Pass
  /// the raw numeric value; formatting happens in the variant.
  final double? originalPrice;

  /// Short badge to display on the product card (e.g. `'Best value'`,
  /// `'Save 40%'`).
  final String? badge;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaywallProduct &&
          other.id == id &&
          other.displayPrice == displayPrice &&
          other.rawPrice == rawPrice &&
          other.currencyCode == currencyCode &&
          other.period == period &&
          _listEquals(other.perks, perks) &&
          other.trialPeriod == trialPeriod &&
          other.originalPrice == originalPrice &&
          other.badge == badge;

  @override
  int get hashCode => Object.hash(
        id,
        displayPrice,
        rawPrice,
        currencyCode,
        period,
        Object.hashAll(perks),
        trialPeriod,
        originalPrice,
        badge,
      );

  @override
  String toString() => 'PaywallProduct($id, $displayPrice, $period)';
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
