import 'package:flutter/material.dart';

import '../core/paywall_result.dart';
import '../theme/paywall_theme.dart';

/// Internal: top-right close button shared across all variants.
///
/// Pops the variant route with [PaywallDismissed]. The dispatcher in
/// `PaywallKit.show` translates the result into the `onDismiss` callback.
class PaywallCloseButton extends StatelessWidget {
  /// Creates a close button.
  const PaywallCloseButton({required this.theme, super.key});

  /// Theme tokens.
  final PaywallTheme theme;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close),
      color: theme.onSurface.withValues(alpha: 0.6),
      tooltip: 'Close',
      onPressed: () =>
          Navigator.of(context).pop(const PaywallDismissed()),
    );
  }
}

/// Internal: "Restore Purchases" link shared across all variants.
///
/// Phase 5 wires this to the active adapter. For Phase 2 it pops with an
/// empty [PaywallRestored] when tapped (so end-to-end tests pass).
class PaywallRestoreButton extends StatelessWidget {
  /// Creates a restore button.
  const PaywallRestoreButton({
    required this.theme,
    required this.text,
    super.key,
  });

  /// Theme tokens.
  final PaywallTheme theme;

  /// Display string (from [PaywallCopy.restoreText]).
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context)
          .pop(const PaywallRestored(products: [])),
      child: Text(
        text,
        style: TextStyle(color: theme.primary),
      ),
    );
  }
}

/// Internal: a CTA-grade primary button used across variants.
class PaywallPrimaryButton extends StatelessWidget {
  /// Creates a primary button.
  const PaywallPrimaryButton({
    required this.theme,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    super.key,
  });

  /// Theme tokens.
  final PaywallTheme theme;

  /// Label text.
  final String label;

  /// Tap handler.
  final VoidCallback onPressed;

  /// When false, renders disabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: theme.primary,
          foregroundColor: theme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: theme.buttonRadius),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Internal: feature row with check icon (used by Carousel, Trial,
/// Lifetime, Soft, Minimal variants).
class PaywallFeatureRow extends StatelessWidget {
  /// Creates a feature row.
  const PaywallFeatureRow({
    required this.theme,
    required this.text,
    super.key,
  });

  /// Theme tokens.
  final PaywallTheme theme;

  /// Feature label.
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 22, color: theme.success),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.bodyStyle ??
                  TextStyle(
                    fontSize: 16,
                    color: theme.onSurface,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
