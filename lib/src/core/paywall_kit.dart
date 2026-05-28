import 'package:flutter/material.dart';

import '../adapters/paywall_adapter.dart';
import '../adapters/paywall_scope.dart';
import '../adapters/preview_adapter.dart';
import '../theme/paywall_theme.dart';
import '../variants/carousel.dart';
import '../variants/comparison.dart';
import '../variants/family.dart';
import '../variants/gamified.dart';
import '../variants/hard.dart';
import '../variants/lifetime.dart';
import '../variants/minimal.dart';
import '../variants/reverse_trial.dart';
import '../variants/soft.dart';
import '../variants/storytelling.dart';
import '../variants/trial_toggle.dart';
import '../variants/winback.dart';
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
class PaywallKit {
  PaywallKit._();

  /// Show a paywall and `await` the user's [PaywallResult].
  ///
  /// Pushes a full-screen variant route. Returns when the user purchases,
  /// restores, dismisses, or the purchase fails. The optional callbacks
  /// fire alongside the returned value.
  ///
  /// [adapter] controls the purchase backend. Defaults to a
  /// [PreviewAdapter] which "buys" instantly without contacting any
  /// store — useful for design / preview / when you handle real
  /// purchases inside `onCtaTap` yourself. Pass [IapAdapter] for native
  /// `in_app_purchase`, or implement [PaywallAdapter] for RevenueCat /
  /// Stripe / your-own.
  static Future<PaywallResult> show(
    BuildContext context, {
    required PaywallVariant variant,
    required List<PaywallProduct> products,
    required PaywallCopy copy,
    PaywallTheme? theme,
    PaywallAdapter? adapter,
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

    final activeTheme = theme ?? PaywallTheme.fromTheme(context);
    final activeAdapter = adapter ?? const PreviewAdapter();
    onView?.call();

    final result = await Navigator.of(context).push<PaywallResult>(
      MaterialPageRoute<PaywallResult>(
        builder: (_) => PaywallScope(
          adapter: activeAdapter,
          child: _PaywallRouter(
            variant: variant,
            products: products,
            copy: copy,
            theme: activeTheme,
            onCtaTap: onCtaTap,
          ),
        ),
        fullscreenDialog: true,
      ),
    );

    final outcome = result ?? const PaywallDismissed();
    switch (outcome) {
      case PaywallPurchased(:final product):
        onPurchaseSuccess?.call(product);
      case PaywallErrored(:final error):
        onPurchaseFail?.call(error);
      case PaywallDismissed():
        onDismiss?.call();
      case PaywallRestored():
        // Restore-purchase plumbing lives in the adapter contract; the
        // returned PaywallRestored carries the list of restored
        // products if the caller wants to surface them.
        break;
    }
    return outcome;
  }
}

/// Internal: dispatches the active [PaywallVariant] to the corresponding
/// widget. Exhaustive over all 12 enum values.
class _PaywallRouter extends StatelessWidget {
  const _PaywallRouter({
    required this.variant,
    required this.products,
    required this.copy,
    required this.theme,
    this.onCtaTap,
  });

  final PaywallVariant variant;
  final List<PaywallProduct> products;
  final PaywallCopy copy;
  final PaywallTheme theme;
  final PaywallCtaCallback? onCtaTap;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      PaywallVariant.carousel => CarouselVariant(
          theme: theme,
          copy: copy,
          products: products,
          onCtaTap: onCtaTap,
        ),
      PaywallVariant.comparison => ComparisonVariant(
          theme: theme,
          copy: copy,
          products: products,
          onCtaTap: onCtaTap,
        ),
      PaywallVariant.trialToggle => TrialToggleVariant(
          theme: theme,
          copy: copy,
          products: products,
          onCtaTap: onCtaTap,
        ),
      PaywallVariant.lifetime => LifetimeVariant(
          theme: theme,
          copy: copy,
          products: products,
          onCtaTap: onCtaTap,
        ),
      PaywallVariant.soft => SoftPaywallVariant(
          theme: theme,
          copy: copy,
          products: products,
          onCtaTap: onCtaTap,
        ),
      PaywallVariant.hard => HardPaywallVariant(
          theme: theme,
          copy: copy,
          products: products,
          onCtaTap: onCtaTap,
        ),
      PaywallVariant.winback => WinbackVariant(
          theme: theme,
          copy: copy,
          products: products,
          onCtaTap: onCtaTap,
        ),
      PaywallVariant.family => FamilyPlanVariant(
          theme: theme,
          copy: copy,
          products: products,
          onCtaTap: onCtaTap,
        ),
      PaywallVariant.minimal => MinimalVariant(
          theme: theme,
          copy: copy,
          products: products,
          onCtaTap: onCtaTap,
        ),
      PaywallVariant.storytelling => StorytellingVariant(
          theme: theme,
          copy: copy,
          products: products,
          onCtaTap: onCtaTap,
        ),
      PaywallVariant.gamified => GamifiedVariant(
          theme: theme,
          copy: copy,
          products: products,
          onCtaTap: onCtaTap,
        ),
      PaywallVariant.reverseTrial => ReverseTrialVariant(
          theme: theme,
          copy: copy,
          products: products,
          onCtaTap: onCtaTap,
        ),
    };
  }
}
