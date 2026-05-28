import 'package:flutter/material.dart';

import '../core/paywall_copy.dart';
import '../core/paywall_kit.dart';
import '../core/paywall_period.dart';
import '../core/paywall_product.dart';
import '../core/paywall_result.dart';
import '../theme/paywall_theme.dart';
import '_common.dart';

/// Internal: variant F-VAR-12 — Reverse Trial.
///
/// "You're already on Pro for 7 days" framing. Highlights that the user
/// currently has full access and just needs to keep it. Picks the annual
/// product as default (typical post-trial conversion target); falls back
/// to the first product. Trial duration is sourced from the selected
/// product's [PaywallProduct.trialPeriod].
class ReverseTrialVariant extends StatefulWidget {
  /// Creates a reverse-trial variant.
  const ReverseTrialVariant({
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

  @override
  State<ReverseTrialVariant> createState() => _ReverseTrialVariantState();
}

class _ReverseTrialVariantState extends State<ReverseTrialVariant> {
  late PaywallProduct _selected = _initialSelection();

  PaywallProduct _initialSelection() {
    return widget.products.firstWhere(
      (p) => p.period == PaywallPeriod.annual,
      orElse: () => widget.products.first,
    );
  }

  String get _trialDuration {
    final trial = _selected.trialPeriod;
    return trial ?? '7 days';
  }

  void _onContinue() {
    widget.onCtaTap?.call(_selected);
    Navigator.of(context).pop(PaywallPurchased(product: _selected));
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: theme.success,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "You're on Pro for $_trialDuration",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: theme.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      widget.copy.headline,
                      style: theme.headlineStyle ??
                          TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: theme.onSurface,
                          ),
                    ),
                    if (widget.copy.subhead != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        widget.copy.subhead!,
                        style: TextStyle(
                          fontSize: 17,
                          color: theme.onSurface.withValues(alpha: 0.7),
                          height: 1.4,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    for (final f in widget.copy.features)
                      PaywallFeatureRow(theme: theme, text: f),
                    const SizedBox(height: 24),
                    if (widget.products.length > 1)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final p in widget.products)
                            _ProductChip(
                              theme: theme,
                              product: p,
                              isSelected: p == _selected,
                              onTap: () =>
                                  setState(() => _selected = p),
                            ),
                        ],
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
                    label: 'Keep Pro · ${_selected.displayPrice}',
                    onPressed: _onContinue,
                  ),
                  Text(
                    'Cancel anytime in the first $_trialDuration',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  PaywallRestoreButton(
                    theme: theme,
                    text: widget.copy.restoreText,
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

class _ProductChip extends StatelessWidget {
  const _ProductChip({
    required this.theme,
    required this.product,
    required this.isSelected,
    required this.onTap,
  });

  final PaywallTheme theme;
  final PaywallProduct product;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? theme.primary : theme.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? theme.primary : theme.outline,
            ),
          ),
          child: Text(
            product.displayPrice,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? theme.onPrimary : theme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
