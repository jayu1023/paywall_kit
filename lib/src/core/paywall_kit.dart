import 'package:flutter/material.dart';

import '../theme/paywall_theme.dart';
import '../variants/carousel.dart';
import '../variants/comparison.dart';
import '../variants/family.dart';
import '../variants/hard.dart';
import '../variants/lifetime.dart';
import '../variants/soft.dart';
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
  /// As of Phase 2, the four variants `carousel`, `comparison`,
  /// `trialToggle`, and `lifetime` are implemented. The remaining 8
  /// variants render a "coming soon" placeholder until Phases 3–4 land.
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

    final activeTheme = theme ?? PaywallTheme.fromTheme(context);
    onView?.call();

    final result = await Navigator.of(context).push<PaywallResult>(
      MaterialPageRoute<PaywallResult>(
        builder: (_) => _PaywallRouter(
          variant: variant,
          products: products,
          copy: copy,
          theme: activeTheme,
          onCtaTap: onCtaTap,
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
        // Restored is not specifically wired in Phase 2; adapter work
        // in Phase 5 will plumb this through.
        break;
    }
    return outcome;
  }
}

/// Internal: dispatches the active [PaywallVariant] to the corresponding
/// widget. Unimplemented variants render a coming-soon placeholder so the
/// router is exhaustive even before all 12 ship.
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
      _ => _ComingSoonVariant(variant: variant, theme: theme),
    };
  }
}

class _ComingSoonVariant extends StatelessWidget {
  const _ComingSoonVariant({required this.variant, required this.theme});

  final PaywallVariant variant;
  final PaywallTheme theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        foregroundColor: theme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(
            const PaywallDismissed(),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.construction,
                size: 64,
                color: theme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                '${variant.name} variant — coming soon',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: theme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Lands in a future Phase. See PHASES.md.',
                style: TextStyle(
                  color: theme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
