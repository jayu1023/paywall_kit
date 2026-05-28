import 'package:flutter/material.dart';

import '../adapters/paywall_scope.dart';
import '../core/paywall_copy.dart';
import '../core/paywall_kit.dart';
import '../core/paywall_product.dart';
import '../core/paywall_testimonial.dart';
import '../theme/paywall_theme.dart';
import '_common.dart';

/// Internal: variant F-VAR-10 — Storytelling.
///
/// Long-scroll narrative with testimonials and social-proof badge.
/// Surfaces [PaywallCopy.testimonials] and [PaywallCopy.socialProof];
/// the variant renders with sensible empty-state behavior when either is
/// absent.
class StorytellingVariant extends StatelessWidget {
  /// Creates a storytelling variant.
  const StorytellingVariant({
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
                    if (copy.socialProof != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          copy.socialProof!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: theme.accent,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      copy.headline,
                      style: theme.headlineStyle ??
                          TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: theme.onSurface,
                          ),
                    ),
                    if (copy.subhead != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        copy.subhead!,
                        style: TextStyle(
                          fontSize: 17,
                          color: theme.onSurface.withValues(alpha: 0.75),
                          height: 1.4,
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    for (final f in copy.features)
                      PaywallFeatureRow(theme: theme, text: f),
                    if (copy.testimonials.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      Text(
                        'What customers say',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: theme.onSurface.withValues(alpha: 0.6),
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (final t in copy.testimonials)
                        _TestimonialCard(theme: theme, testimonial: t),
                    ],
                    const SizedBox(height: 24),
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

class _TestimonialCard extends StatelessWidget {
  const _TestimonialCard({required this.theme, required this.testimonial});

  final PaywallTheme theme;
  final PaywallTestimonial testimonial;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: theme.cardRadius,
        border: Border.all(color: theme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"${testimonial.quote}"',
            style: TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: theme.onSurface,
              height: 1.4,
            ),
          ),
          if (testimonial.author != null || testimonial.role != null) ...[
            const SizedBox(height: 8),
            Text(
              [testimonial.author, testimonial.role]
                  .whereType<String>()
                  .join(' · '),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
