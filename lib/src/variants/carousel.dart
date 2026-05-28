import 'package:flutter/material.dart';

import '../adapters/paywall_scope.dart';
import '../core/paywall_copy.dart';
import '../core/paywall_kit.dart';
import '../core/paywall_product.dart';
import '../theme/paywall_theme.dart';
import '_common.dart';

/// Internal: variant F-VAR-01 — Carousel.
///
/// Swipeable feature highlights + single CTA. One page per entry in
/// [PaywallCopy.features]; the primary CTA buys the first product (or
/// the one carrying a `badge`).
class CarouselVariant extends StatefulWidget {
  /// Creates a carousel variant.
  const CarouselVariant({
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

  /// Products to offer. Must be non-empty.
  final List<PaywallProduct> products;

  /// Optional CTA-tap callback (fired before the route pops).
  final PaywallCtaCallback? onCtaTap;

  @override
  State<CarouselVariant> createState() => _CarouselVariantState();
}

class _CarouselVariantState extends State<CarouselVariant> {
  final _pageController = PageController();
  int _page = 0;

  PaywallProduct get _selectedProduct =>
      widget.products.firstWhere(
        (p) => p.badge != null,
        orElse: () => widget.products.first,
      );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    final navigator = Navigator.of(context);
    final adapter = PaywallScope.of(context).adapter;
    final product = _selectedProduct;
    widget.onCtaTap?.call(product);
    final result = await adapter.buy(product);
    if (!mounted) return;
    navigator.pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final features = widget.copy.features;
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
              child: PageView.builder(
                controller: _pageController,
                itemCount: features.isEmpty ? 1 : features.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) {
                  final feature = features.isEmpty ? '' : features[i];
                  return Padding(
                    padding: theme.padding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (i == 0) ...[
                          Text(
                            widget.copy.headline,
                            textAlign: TextAlign.center,
                            style: theme.headlineStyle ??
                                TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: theme.onSurface,
                                ),
                          ),
                          if (widget.copy.subhead != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              widget.copy.subhead!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                color: theme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                          const SizedBox(height: 32),
                        ],
                        Icon(
                          Icons.auto_awesome,
                          size: 72,
                          color: theme.primary,
                        ),
                        const SizedBox(height: 24),
                        if (feature.isNotEmpty)
                          Text(
                            feature,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: theme.onSurface,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            _Dots(
              count: features.isEmpty ? 1 : features.length,
              activeIndex: _page,
              theme: theme,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.padding.horizontal / 2,
              ),
              child: Column(
                children: [
                  PaywallPrimaryButton(
                    theme: theme,
                    label:
                        '${widget.copy.ctaPrimary} · ${_selectedProduct.displayPrice}',
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

class _Dots extends StatelessWidget {
  const _Dots({
    required this.count,
    required this.activeIndex,
    required this.theme,
  });

  final int count;
  final int activeIndex;
  final PaywallTheme theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(count, (i) {
        final isActive = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 24 : 8,
          decoration: BoxDecoration(
            color: isActive
                ? theme.primary
                : theme.outline.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
