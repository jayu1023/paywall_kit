import 'package:flutter/material.dart';

import '../adapters/paywall_scope.dart';
import '../core/paywall_copy.dart';
import '../core/paywall_kit.dart';
import '../core/paywall_period.dart';
import '../core/paywall_product.dart';
import '../core/price_formatter.dart';
import '../theme/paywall_theme.dart';
import '_common.dart';

/// Default Apple Family Sharing seat count.
const int _defaultSeats = 6;

/// Internal: variant F-VAR-08 — Family Plan.
///
/// Highlights a multi-seat tier (Apple Family Sharing-compatible). Shows
/// total price + per-person breakdown across [_defaultSeats] seats. If a
/// product carries a `'family'`-flavored `badge`, that one is auto-
/// selected; otherwise the first product wins.
class FamilyPlanVariant extends StatelessWidget {
  /// Creates a family-plan variant.
  const FamilyPlanVariant({
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
        (p) =>
            p.badge?.toLowerCase().contains('family') ?? false,
        orElse: () => products.first,
      );

  String _perPersonPrice() {
    final p = _selected;
    final perPerson = p.rawPrice / _defaultSeats;
    final period = p.period == PaywallPeriod.lifetime
        ? PaywallPeriod.lifetime
        : p.period;
    final formatted = formatPaywallPrice(
      rawPrice: perPerson,
      currencyCode: p.currencyCode,
      period: period,
    );
    return '$formatted per person';
  }

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
                  children: [
                    Icon(
                      Icons.family_restroom,
                      size: 80,
                      color: theme.primary,
                    ),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 8),
                    Text(
                      copy.subhead ??
                          'Share with up to $_defaultSeats people',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.surface,
                        borderRadius: theme.cardRadius,
                        border: Border.all(color: theme.primary, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _selected.displayPrice,
                            style: theme.priceStyle ??
                                TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: theme.onSurface,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _perPersonPrice(),
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                    label: copy.ctaPrimary,
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
