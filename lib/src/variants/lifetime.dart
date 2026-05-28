import 'package:flutter/material.dart';

import '../core/paywall_copy.dart';
import '../core/paywall_kit.dart';
import '../core/paywall_period.dart';
import '../core/paywall_product.dart';
import '../core/paywall_result.dart';
import '../core/price_formatter.dart';
import '../theme/paywall_theme.dart';
import '_common.dart';

/// Internal: variant F-VAR-04 — Lifetime Deal.
///
/// One-time purchase, prominent price hero. If an annual product is also
/// passed, computes a "Save X%" vs annual badge. The first
/// [PaywallPeriod.lifetime] product is the headline offer; if none, the
/// first product is used.
class LifetimeVariant extends StatelessWidget {
  /// Creates a lifetime variant.
  const LifetimeVariant({
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

  /// Products. Should include one lifetime product (period =
  /// [PaywallPeriod.lifetime]).
  final List<PaywallProduct> products;

  /// Optional CTA-tap callback.
  final PaywallCtaCallback? onCtaTap;

  PaywallProduct get _lifetime => products.firstWhere(
        (p) => p.period == PaywallPeriod.lifetime,
        orElse: () => products.first,
      );

  PaywallProduct? get _annual {
    for (final p in products) {
      if (p.period == PaywallPeriod.annual) return p;
    }
    return null;
  }

  int? _savings() {
    final annual = _annual;
    if (annual == null) return null;
    // Lifetime "per-month equivalent" assumes 36-month lifecycle for
    // savings framing — standard indie-hacker comparison heuristic.
    final lifetimePerMonth = _lifetime.rawPrice / 36;
    return computeSavingsPercent(
      fromPricePerMonth: annual.rawPrice / 12,
      toPricePerMonth: lifetimePerMonth,
    );
  }

  void _onContinue(BuildContext context) {
    onCtaTap?.call(_lifetime);
    Navigator.of(context).pop(PaywallPurchased(product: _lifetime));
  }

  @override
  Widget build(BuildContext context) {
    final savings = _savings();
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
                    const SizedBox(height: 12),
                    Icon(
                      Icons.workspace_premium,
                      size: 88,
                      color: theme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      copy.headline,
                      textAlign: TextAlign.center,
                      style: theme.headlineStyle ??
                          TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: theme.onSurface,
                          ),
                    ),
                    if (copy.subhead != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        copy.subhead!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.surface,
                        borderRadius: theme.cardRadius,
                        border: Border.all(color: theme.primary, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Lifetime',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: theme.primary,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _lifetime.displayPrice,
                            style: theme.priceStyle ??
                                TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                  color: theme.onSurface,
                                ),
                          ),
                          if (savings != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    theme.success.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Save $savings% vs annual',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: theme.success,
                                ),
                              ),
                            ),
                          ],
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
                    label: 'Get lifetime access',
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
