import 'package:flutter/material.dart';

import '../adapters/paywall_scope.dart';
import '../core/paywall_copy.dart';
import '../core/paywall_kit.dart';
import '../core/paywall_product.dart';
import '../core/paywall_result.dart';
import '../theme/paywall_theme.dart';
import '_common.dart';

/// Internal: variant F-VAR-05 — Soft Paywall.
///
/// Non-blocking. Offers the purchase but lets the user proceed without
/// paying via a secondary "continue with limits" button.
class SoftPaywallVariant extends StatelessWidget {
  /// Creates a soft paywall.
  const SoftPaywallVariant({
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
    final secondaryLabel = copy.ctaSecondary ?? 'Continue with limits';
    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: PaywallCloseButton(theme: theme),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: theme.padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      copy.headline,
                      style: theme.headlineStyle ??
                          TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: theme.onSurface,
                          ),
                    ),
                    if (copy.subhead != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        copy.subhead!,
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    for (final f in copy.features)
                      PaywallFeatureRow(theme: theme, text: f),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.padding.horizontal / 2,
              ),
              child: Column(
                children: [
                  PaywallPrimaryButton(
                    theme: theme,
                    label: '${copy.ctaPrimary} · ${_selected.displayPrice}',
                    onPressed: () => _onContinue(context),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .pop(const PaywallDismissed()),
                    child: Text(
                      secondaryLabel,
                      style: TextStyle(
                        color: theme.onSurface.withValues(alpha: 0.7),
                        fontSize: 15,
                      ),
                    ),
                  ),
                  PaywallRestoreButton(
                    theme: theme,
                    text: copy.restoreText,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
