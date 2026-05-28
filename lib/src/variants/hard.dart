import 'package:flutter/material.dart';

import '../adapters/paywall_scope.dart';
import '../core/paywall_copy.dart';
import '../core/paywall_kit.dart';
import '../core/paywall_product.dart';
import '../core/paywall_result.dart';
import '../theme/paywall_theme.dart';
import '_common.dart';

/// Internal: variant F-VAR-06 — Hard Paywall.
///
/// Onboarding-blocking. Aggressive layout with a dominant CTA and no
/// secondary "skip" option. A small close button is still present —
/// App Store guidelines require users always have a way out — but it's
/// visually de-emphasized.
class HardPaywallVariant extends StatelessWidget {
  /// Creates a hard paywall.
  const HardPaywallVariant({
    required this.theme,
    required this.copy,
    required this.products,
    this.onCtaTap,
    super.key,
  });

  /// Theme tokens.
  final PaywallTheme theme;

  /// User-facing strings.
  final PaywallCopy copy;

  /// Products to offer.
  final List<PaywallProduct> products;

  /// Optional CTA-tap callback.
  final PaywallCtaCallback? onCtaTap;

  PaywallProduct get _selected => products.firstWhere(
        (p) => p.badge != null,
        orElse: () => products.first,
      );

  Future<void> _onContinue(BuildContext context) async {
    final navigator = Navigator.of(context);
    final adapter = PaywallScope.of(context).adapter;
    final product = _selected;
    onCtaTap?.call(product);
    final result = await adapter.buy(product);
    if (!context.mounted) return;
    navigator.pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: theme.padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 56),
                  Icon(
                    Icons.lock_outline,
                    size: 64,
                    color: theme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    copy.headline,
                    textAlign: TextAlign.center,
                    style: theme.headlineStyle ??
                        TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: theme.onSurface,
                        ),
                  ),
                  if (copy.subhead != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      copy.subhead!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: theme.onSurface.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  for (final f in copy.features)
                    PaywallFeatureRow(theme: theme, text: f),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: FilledButton(
                      onPressed: () => _onContinue(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.primary,
                        foregroundColor: theme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: theme.buttonRadius,
                        ),
                      ),
                      child: Text(
                        '${copy.ctaPrimary} · ${_selected.displayPrice}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  PaywallRestoreButton(
                    theme: theme,
                    text: copy.restoreText,
                  ),
                ],
              ),
            ),
            // Subtle close affordance — top-right corner, low contrast.
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close),
                color: theme.onSurface.withValues(alpha: 0.3),
                iconSize: 20,
                tooltip: 'Close',
                onPressed: () =>
                    Navigator.of(context).pop(const PaywallDismissed()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
