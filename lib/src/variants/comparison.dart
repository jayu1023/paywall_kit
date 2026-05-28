import 'package:flutter/material.dart';

import '../adapters/paywall_scope.dart';
import '../core/paywall_copy.dart';
import '../core/paywall_kit.dart';
import '../core/paywall_product.dart';
import '../theme/paywall_theme.dart';
import '_common.dart';

/// Internal: variant F-VAR-02 — Comparison Table.
///
/// Free vs Pro (vs Lifetime) column comparison. Each product becomes a
/// column; features render as ✓ rows. The product carrying a
/// [PaywallProduct.badge] is visually highlighted.
class ComparisonVariant extends StatefulWidget {
  /// Creates a comparison variant.
  const ComparisonVariant({
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

  /// Products to compare. The first is treated as the "default" column.
  final List<PaywallProduct> products;

  /// Optional CTA-tap callback.
  final PaywallCtaCallback? onCtaTap;

  @override
  State<ComparisonVariant> createState() => _ComparisonVariantState();
}

class _ComparisonVariantState extends State<ComparisonVariant> {
  late PaywallProduct _selected =
      widget.products.firstWhere(
        (p) => p.badge != null,
        orElse: () => widget.products.first,
      );

  Future<void> _onContinue() async {
    final navigator = Navigator.of(context);
    final adapter = PaywallScope.of(context).adapter;
    final product = _selected;
    widget.onCtaTap?.call(product);
    final result = await adapter.buy(product);
    if (!mounted) return;
    navigator.pop(result);
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.copy.headline,
                      textAlign: TextAlign.center,
                      style: theme.headlineStyle ??
                          TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: theme.onSurface,
                          ),
                    ),
                    if (widget.copy.subhead != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.copy.subhead!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    for (final product in widget.products)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ProductCard(
                          theme: theme,
                          product: product,
                          features: product.perks.isNotEmpty
                              ? product.perks
                              : widget.copy.features,
                          isSelected: product == _selected,
                          onTap: () => setState(() => _selected = product),
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
                    label:
                        '${widget.copy.ctaPrimary} · ${_selected.displayPrice}',
                    onPressed: _onContinue,
                  ),
                  const SizedBox(height: 8),
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

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.theme,
    required this.product,
    required this.features,
    required this.isSelected,
    required this.onTap,
  });

  final PaywallTheme theme;
  final PaywallProduct product;
  final List<String> features;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? theme.primary : theme.outline;
    return Material(
      color: theme.surface,
      borderRadius: theme.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: theme.cardRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: theme.cardRadius,
            border: Border.all(
              color: borderColor,
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
                      product.id,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.onSurface,
                      ),
                    ),
                  ),
                  if (product.badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.badge!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.accent,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                product.displayPrice,
                style: theme.priceStyle ??
                    TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: theme.onSurface,
                    ),
              ),
              if (features.isNotEmpty) ...[
                const SizedBox(height: 12),
                for (final f in features)
                  PaywallFeatureRow(theme: theme, text: f),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
