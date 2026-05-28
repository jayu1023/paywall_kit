import 'package:flutter/material.dart';

import '../core/paywall_copy.dart';
import '../core/paywall_kit.dart';
import '../core/paywall_product.dart';
import '../core/paywall_result.dart';
import '../core/price_formatter.dart';
import '../theme/paywall_theme.dart';
import '_common.dart';

/// Internal: variant F-VAR-07 — Win-back.
///
/// For lapsed subscribers. Renders strikethrough original price next to
/// a prominent discounted price and a "discount %" badge. If the
/// selected product has no [PaywallProduct.originalPrice], the variant
/// falls back to the normal price (no strikethrough).
class WinbackVariant extends StatelessWidget {
  /// Creates a winback variant.
  const WinbackVariant({
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
        (p) => p.originalPrice != null,
        orElse: () => products.first,
      );

  int? _discountPercent() {
    final p = _selected;
    final original = p.originalPrice;
    if (original == null || original <= 0 || p.rawPrice >= original) {
      return null;
    }
    final pct = ((original - p.rawPrice) / original) * 100;
    return pct.round();
  }

  void _onContinue(BuildContext context) {
    final product = _selected;
    onCtaTap?.call(product);
    Navigator.of(context).pop(PaywallPurchased(product: product));
  }

  @override
  Widget build(BuildContext context) {
    final discount = _discountPercent();
    final original = _selected.originalPrice;
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (discount != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$discount% OFF — limited time',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: theme.accent,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Text(
                      copy.headline,
                      textAlign: TextAlign.center,
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
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (original != null) ...[
                          Text(
                            formatPaywallPrice(
                              rawPrice: original,
                              currencyCode: _selected.currencyCode,
                              period: _selected.period,
                            ),
                            style: TextStyle(
                              fontSize: 20,
                              color:
                                  theme.onSurface.withValues(alpha: 0.5),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Text(
                          _selected.displayPrice,
                          style: theme.priceStyle ??
                              TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: theme.onSurface,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
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
                    label: 'Reactivate',
                    onPressed: () => _onContinue(context),
                  ),
                  const SizedBox(height: 4),
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
