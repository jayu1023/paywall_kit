import 'package:flutter/material.dart';

import '../theme/paywall_theme.dart';
import 'paywall_copy.dart';
import 'paywall_product.dart';
import 'paywall_result.dart';
import 'paywall_variant.dart';

/// Callback fired once the paywall first appears on screen.
typedef PaywallViewCallback = void Function();

/// Callback fired when the user taps a product / CTA.
typedef PaywallCtaCallback = void Function(PaywallProduct product);

/// Callback fired after a successful purchase.
typedef PaywallPurchaseSuccessCallback = void Function(
  PaywallProduct product,
);

/// Callback fired when a purchase fails.
typedef PaywallPurchaseFailCallback = void Function(Object error);

/// Callback fired when the user dismisses the paywall without buying.
typedef PaywallDismissCallback = void Function();

/// Public entry point for the package.
///
/// Phase 1 ships the API skeleton — concrete variant rendering lands in
/// Phase 2+ as each `PaywallVariant` is implemented.
class PaywallKit {
  PaywallKit._();

  /// Show a paywall and `await` the user's [PaywallResult].
  ///
  /// Stateless and side-effect-free apart from the optional callbacks
  /// (`onView`, `onCtaTap`, `onPurchaseSuccess`, `onPurchaseFail`,
  /// `onDismiss`).
  ///
  /// Phase 1 placeholder: returns [PaywallDismissed] immediately and
  /// fires `onView` + `onDismiss`. Replace in Phase 2 with the variant
  /// router.
  static Future<PaywallResult> show(
    BuildContext context, {
    required PaywallVariant variant,
    required List<PaywallProduct> products,
    required PaywallCopy copy,
    PaywallTheme? theme,
    PaywallViewCallback? onView,
    PaywallCtaCallback? onCtaTap,
    PaywallPurchaseSuccessCallback? onPurchaseSuccess,
    PaywallPurchaseFailCallback? onPurchaseFail,
    PaywallDismissCallback? onDismiss,
  }) async {
    assert(
      products.isNotEmpty,
      'PaywallKit.show requires at least one product.',
    );
    onView?.call();
    // Phase 1 skeleton — no UI mounted yet. Phase 2 introduces the
    // variant router and the actual `showModalBottomSheet` /
    // `Navigator.push` plumbing.
    onDismiss?.call();
    return const PaywallDismissed();
  }
}
