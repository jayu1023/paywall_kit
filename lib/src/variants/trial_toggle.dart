import 'package:flutter/material.dart';

import '../core/paywall_copy.dart';
import '../core/paywall_kit.dart';
import '../core/paywall_period.dart';
import '../core/paywall_product.dart';
import '../core/paywall_result.dart';
import '../core/price_formatter.dart';
import '../theme/paywall_theme.dart';
import '_common.dart';

/// Internal: variant F-VAR-03 — Trial-with-toggle.
///
/// Monthly / annual segmented toggle with a prominent free-trial CTA.
/// Auto-selects the annual product on first frame; if the annual product
/// carries a `trialPeriod`, the CTA reads `'Start <trial> free trial'`.
class TrialToggleVariant extends StatefulWidget {
  /// Creates a trial-toggle variant.
  const TrialToggleVariant({
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

  /// Products. Should include at least one monthly + one annual.
  final List<PaywallProduct> products;

  /// Optional CTA-tap callback.
  final PaywallCtaCallback? onCtaTap;

  @override
  State<TrialToggleVariant> createState() => _TrialToggleVariantState();
}

class _TrialToggleVariantState extends State<TrialToggleVariant> {
  late PaywallProduct _selected = _initialSelection();

  PaywallProduct _initialSelection() {
    return widget.products.firstWhere(
      (p) => p.period == PaywallPeriod.annual,
      orElse: () => widget.products.first,
    );
  }

  PaywallProduct? _productForPeriod(PaywallPeriod p) {
    for (final product in widget.products) {
      if (product.period == p) return product;
    }
    return null;
  }

  int? _savingsPercent() {
    final monthly = _productForPeriod(PaywallPeriod.monthly);
    final annual = _productForPeriod(PaywallPeriod.annual);
    if (monthly == null || annual == null) return null;
    return computeSavingsPercent(
      fromPricePerMonth: monthly.rawPrice,
      toPricePerMonth: annual.rawPrice / 12,
    );
  }

  void _onContinue() {
    widget.onCtaTap?.call(_selected);
    Navigator.of(context).pop(PaywallPurchased(product: _selected));
  }

  String _ctaLabel() {
    final trial = _selected.trialPeriod;
    if (trial != null) return 'Start $trial free trial';
    return widget.copy.ctaPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final monthly = _productForPeriod(PaywallPeriod.monthly);
    final annual = _productForPeriod(PaywallPeriod.annual);
    final savings = _savingsPercent();
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
                      widget.copy.headline,
                      style: theme.headlineStyle ??
                          TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: theme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 24),
                    for (final f in widget.copy.features)
                      PaywallFeatureRow(theme: theme, text: f),
                    const SizedBox(height: 32),
                    if (monthly != null && annual != null)
                      _Toggle(
                        theme: theme,
                        monthly: monthly,
                        annual: annual,
                        selected: _selected,
                        savings: savings,
                        onSelect: (p) => setState(() => _selected = p),
                      )
                    else
                      Text(
                        _selected.displayPrice,
                        style: theme.priceStyle ??
                            TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: theme.onSurface,
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
                    label: _ctaLabel(),
                    onPressed: _onContinue,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_selected.displayPrice} · cancel anytime',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
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

class _Toggle extends StatelessWidget {
  const _Toggle({
    required this.theme,
    required this.monthly,
    required this.annual,
    required this.selected,
    required this.savings,
    required this.onSelect,
  });

  final PaywallTheme theme;
  final PaywallProduct monthly;
  final PaywallProduct annual;
  final PaywallProduct selected;
  final int? savings;
  final ValueChanged<PaywallProduct> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ToggleOption(
            theme: theme,
            product: monthly,
            label: 'Monthly',
            isSelected: selected == monthly,
            onTap: () => onSelect(monthly),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ToggleOption(
            theme: theme,
            product: annual,
            label: 'Annual',
            badge: savings != null ? 'Save $savings%' : null,
            isSelected: selected == annual,
            onTap: () => onSelect(annual),
          ),
        ),
      ],
    );
  }
}

class _ToggleOption extends StatelessWidget {
  const _ToggleOption({
    required this.theme,
    required this.product,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  final PaywallTheme theme;
  final PaywallProduct product;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.surface,
      borderRadius: theme.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: theme.cardRadius,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: theme.cardRadius,
            border: Border.all(
              color: isSelected ? theme.primary : theme.outline,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.onSurface,
                      ),
                    ),
                  ),
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badge!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: theme.success,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                product.displayPrice,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: theme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
