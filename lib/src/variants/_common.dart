import 'dart:async';

import 'package:flutter/material.dart';

import '../adapters/paywall_scope.dart';
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
/// Dispatches `adapter.restore()` through the ambient [PaywallScope] and
/// pops the route with the resulting [PaywallResult].
class PaywallRestoreButton extends StatefulWidget {
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
  State<PaywallRestoreButton> createState() => _PaywallRestoreButtonState();
}

class _PaywallRestoreButtonState extends State<PaywallRestoreButton> {
  bool _busy = false;

  Future<void> _handleTap() async {
    if (_busy) return;
    final navigator = Navigator.of(context);
    final adapter = PaywallScope.of(context).adapter;
    setState(() => _busy = true);
    try {
      final result = await adapter.restore();
      if (!mounted) return;
      navigator.pop(result);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _busy ? null : _handleTap,
      child: _busy
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor:
                    AlwaysStoppedAnimation<Color>(widget.theme.primary),
              ),
            )
          : Text(
              widget.text,
              style: TextStyle(color: widget.theme.primary),
            ),
    );
  }
}

/// Internal: CTA-grade primary button used across variants.
///
/// Accepts a sync or async [onPressed]. When the callback returns a
/// [Future], the button shows a spinner and disables interaction until
/// the future completes.
class PaywallPrimaryButton extends StatefulWidget {
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

  /// Sync or async tap handler.
  final FutureOr<void> Function() onPressed;

  /// When false, renders disabled.
  final bool enabled;

  @override
  State<PaywallPrimaryButton> createState() => _PaywallPrimaryButtonState();
}

class _PaywallPrimaryButtonState extends State<PaywallPrimaryButton> {
  bool _busy = false;

  Future<void> _handleTap() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await widget.onPressed();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canTap = widget.enabled && !_busy;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: canTap ? _handleTap : null,
        style: FilledButton.styleFrom(
          backgroundColor: widget.theme.primary,
          foregroundColor: widget.theme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: widget.theme.buttonRadius,
          ),
        ),
        child: _busy
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.theme.onPrimary,
                  ),
                ),
              )
            : Text(
                widget.label,
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
