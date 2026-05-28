import 'package:flutter/material.dart';

import '../core/paywall_copy.dart';
import '../core/paywall_kit.dart';
import '../core/paywall_product.dart';
import '../core/paywall_result.dart';
import '../theme/paywall_theme.dart';
import '_common.dart';

/// Internal: variant F-VAR-11 — Gamified.
///
/// Unlock framing with a progress ring and "level up" badges. Treats
/// `copy.features` as unlockable rewards and shows them with a +N badge.
class GamifiedVariant extends StatelessWidget {
  /// Creates a gamified variant.
  const GamifiedVariant({
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

  void _onContinue(BuildContext context) {
    final product = _selected;
    onCtaTap?.call(product);
    Navigator.of(context).pop(PaywallPurchased(product: product));
  }

  @override
  Widget build(BuildContext context) {
    final unlockCount = copy.features.length;
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
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: CircularProgressIndicator(
                              value: 0.9,
                              strokeWidth: 10,
                              backgroundColor:
                                  theme.outline.withValues(alpha: 0.3),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.primary,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.emoji_events,
                            size: 60,
                            color: theme.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      copy.headline,
                      textAlign: TextAlign.center,
                      style: theme.headlineStyle ??
                          TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: theme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '+$unlockCount rewards waiting',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: theme.success,
                        ),
                      ),
                    ),
                    if (copy.subhead != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        copy.subhead!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: theme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    for (var i = 0; i < copy.features.length; i++)
                      _RewardRow(
                        theme: theme,
                        index: i + 1,
                        text: copy.features[i],
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
                    label: 'Unlock all · ${_selected.displayPrice}',
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

class _RewardRow extends StatelessWidget {
  const _RewardRow({
    required this.theme,
    required this.index,
    required this.text,
  });

  final PaywallTheme theme;
  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$index',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: theme.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: theme.onSurface,
              ),
            ),
          ),
          Icon(
            Icons.lock,
            size: 18,
            color: theme.onSurface.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
