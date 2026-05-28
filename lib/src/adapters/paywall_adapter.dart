import '../core/paywall_product.dart';
import '../core/paywall_result.dart';

/// Backend bridge between paywall_kit's UI and a purchase system.
///
/// Two implementations ship in v0.1:
///   * [PreviewAdapter] — no-op, returns success instantly. Default
///     when [PaywallKit.show] is called without `adapter:`.
///   * [IapAdapter] — wraps the `in_app_purchase` plugin for native
///     App Store / Play Store purchases.
///
/// For RevenueCat, Stripe, Paddle, or anything else, implement this
/// interface in your app. See `docs/ADAPTERS.md` for a complete
/// RevenueCat example.
abstract class PaywallAdapter {
  /// Creates an adapter.
  const PaywallAdapter();

  /// Attempt to purchase [product].
  ///
  /// Must return one of:
  ///   * [PaywallPurchased] — purchase completed.
  ///   * [PaywallDismissed] — user cancelled mid-flow.
  ///   * [PaywallErrored] — purchase failed for any reason.
  ///
  /// Must not throw. Wrap exceptions in [PaywallErrored].
  Future<PaywallResult> buy(PaywallProduct product);

  /// Restore previously-purchased entitlements.
  ///
  /// Must return one of:
  ///   * [PaywallRestored] — zero or more products restored (the empty
  ///     list is a valid result when the user has nothing to restore).
  ///   * [PaywallErrored] — restore failed.
  ///
  /// Must not throw.
  Future<PaywallResult> restore();
}
