import 'package:flutter/material.dart';

import '../core/paywall_copy.dart';
import '../core/paywall_kit.dart';
import '../core/paywall_product.dart';
import '../core/paywall_result.dart';
import '../theme/paywall_theme.dart';
import '_common.dart';

/// Internal: variant F-VAR-09 — Minimal.
///
/// Pieter Levels aesthetic: single price, single CTA, nothing else.
/// Designed for indie one-screen apps where the offer is obvious.
class MinimalVariant extends StatelessWidget {
  /// Creates a minimal variant.
  const MinimalVariant({
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

  PaywallProduct get _selected => products.first;

  void _onContinue(BuildContext context) {
    final product = _selected;
    onCtaTap?.call(product);
    Navigator.of(context).pop(PaywallPurchased(product: product));
  }

  @override
  Widget build(BuildContext context) {
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
              child: Padding(
                padding: theme.padding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      copy.headline,
                      textAlign: TextAlign.center,
                      style: theme.headlineStyle ??
                          TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: theme.onSurface,
                          ),
                    ),
                    if (copy.subhead != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        copy.subhead!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          color: theme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                    const SizedBox(height: 40),
                    Text(
                      _selected.displayPrice,
                      style: theme.priceStyle ??
                          TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: theme.primary,
                          ),
                    ),
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
                    label: copy.ctaPrimary,
                    onPressed: () => _onContinue(context),
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
