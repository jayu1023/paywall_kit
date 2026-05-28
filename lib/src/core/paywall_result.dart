import 'paywall_product.dart';

/// Outcome returned by [PaywallKit.show].
///
/// Sealed union — exhaustive `switch` on the four subtypes is the
/// recommended consumption pattern:
///
/// ```dart
/// final result = await PaywallKit.show(...);
/// switch (result) {
///   case PaywallPurchased(:final product):
///     // unlock features for product.id
///   case PaywallRestored(:final products):
///     // re-grant entitlements
///   case PaywallDismissed():
///     // user closed without buying
///   case PaywallErrored(:final error):
///     // surface the failure
/// }
/// ```
sealed class PaywallResult {
  const PaywallResult();
}

/// User completed a purchase.
final class PaywallPurchased extends PaywallResult {
  /// Creates a successful-purchase result.
  const PaywallPurchased({required this.product, this.transactionId});

  /// The product the user bought.
  final PaywallProduct product;

  /// Backend-specific transaction ID (Apple original transaction ID, Play
  /// purchase token, RC entitlement ID, etc.). Null when the adapter
  /// doesn't surface one.
  final String? transactionId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaywallPurchased &&
          other.product == product &&
          other.transactionId == transactionId;

  @override
  int get hashCode => Object.hash(product, transactionId);
}

/// User tapped "Restore" and at least one prior purchase was found.
final class PaywallRestored extends PaywallResult {
  /// Creates a restore result.
  const PaywallRestored({required this.products});

  /// All previously-purchased products surfaced by the adapter.
  final List<PaywallProduct> products;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaywallRestored && _listEquals(other.products, products);

  @override
  int get hashCode => Object.hashAll(products);
}

/// User closed the paywall without purchasing.
final class PaywallDismissed extends PaywallResult {
  /// Creates a dismissed result.
  const PaywallDismissed();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PaywallDismissed;

  @override
  int get hashCode => 0;
}

/// Purchase / restore flow failed.
final class PaywallErrored extends PaywallResult {
  /// Creates an error result.
  const PaywallErrored({required this.error, this.stackTrace});

  /// The failure surfaced by the adapter or the framework.
  final Object error;

  /// Optional stack trace for debugging.
  final StackTrace? stackTrace;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaywallErrored && other.error == error;

  @override
  int get hashCode => error.hashCode;
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
