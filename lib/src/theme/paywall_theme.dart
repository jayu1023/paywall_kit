import 'package:flutter/material.dart';

/// Visual theme applied across every paywall variant.
///
/// Two factories cover most cases:
///   * [PaywallTheme.brand] — minimal config, derive everything from one
///     brand color.
///   * [PaywallTheme.fromTheme] — inherit from the ambient Material
///     [ThemeData].
///
/// The full constructor is exposed for total control.
@immutable
class PaywallTheme {
  /// Full constructor — every visual knob.
  const PaywallTheme({
    required this.primary,
    required this.onPrimary,
    required this.surface,
    required this.onSurface,
    required this.background,
    required this.outline,
    required this.success,
    required this.accent,
    this.cardRadius = const BorderRadius.all(Radius.circular(16)),
    this.buttonRadius = const BorderRadius.all(Radius.circular(12)),
    this.padding = const EdgeInsets.all(24),
    this.headlineStyle,
    this.bodyStyle,
    this.priceStyle,
  });

  /// Derive a full theme from a single brand color.
  factory PaywallTheme.brand({
    required Color primary,
    Color? accent,
    Brightness brightness = Brightness.light,
  }) {
    final isDark = brightness == Brightness.dark;
    final accentColor = accent ?? primary;
    return PaywallTheme(
      primary: primary,
      onPrimary: _bestForeground(primary),
      accent: accentColor,
      surface: isDark ? const Color(0xFF1C1C1E) : Colors.white,
      onSurface: isDark ? Colors.white : const Color(0xFF1C1C1E),
      background: isDark ? const Color(0xFF000000) : const Color(0xFFF5F5F7),
      outline:
          isDark ? const Color(0xFF38383A) : const Color(0xFFE5E5EA),
      success: const Color(0xFF34C759),
    );
  }

  /// Derive a theme from the ambient Material [ThemeData].
  factory PaywallTheme.fromTheme(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return PaywallTheme(
      primary: scheme.primary,
      onPrimary: scheme.onPrimary,
      accent: scheme.tertiary,
      surface: scheme.surface,
      onSurface: scheme.onSurface,
      background: scheme.surfaceContainerLowest,
      outline: scheme.outlineVariant,
      success: scheme.tertiary,
      headlineStyle: theme.textTheme.headlineMedium,
      bodyStyle: theme.textTheme.bodyMedium,
      priceStyle: theme.textTheme.titleLarge,
    );
  }

  /// Primary brand / CTA color.
  final Color primary;

  /// Foreground color on top of [primary]. Derived automatically for the
  /// [PaywallTheme.brand] factory.
  final Color onPrimary;

  /// Secondary accent (badges, savings highlights). Defaults to
  /// [primary] in the brand factory.
  final Color accent;

  /// Card / sheet surface color.
  final Color surface;

  /// Default text color on a [surface].
  final Color onSurface;

  /// Screen background color.
  final Color background;

  /// Hairline / divider / unselected-border color.
  final Color outline;

  /// Success state (e.g. confetti, "Best value" badge).
  final Color success;

  /// Corner radius for product cards / sheets.
  final BorderRadius cardRadius;

  /// Corner radius for the primary CTA button.
  final BorderRadius buttonRadius;

  /// Outer padding for the whole paywall screen.
  final EdgeInsets padding;

  /// Override for the headline text style. When null, the variant uses
  /// `Theme.of(context).textTheme.headlineMedium` with onSurface.
  final TextStyle? headlineStyle;

  /// Override for body / feature-list text. When null, variants fall
  /// back to `Theme.of(context).textTheme.bodyMedium`.
  final TextStyle? bodyStyle;

  /// Override for the displayed price text. When null, variants fall
  /// back to `Theme.of(context).textTheme.titleLarge`.
  final TextStyle? priceStyle;

  /// Returns a copy with the listed fields overridden.
  PaywallTheme copyWith({
    Color? primary,
    Color? onPrimary,
    Color? accent,
    Color? surface,
    Color? onSurface,
    Color? background,
    Color? outline,
    Color? success,
    BorderRadius? cardRadius,
    BorderRadius? buttonRadius,
    EdgeInsets? padding,
    TextStyle? headlineStyle,
    TextStyle? bodyStyle,
    TextStyle? priceStyle,
  }) {
    return PaywallTheme(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      accent: accent ?? this.accent,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      background: background ?? this.background,
      outline: outline ?? this.outline,
      success: success ?? this.success,
      cardRadius: cardRadius ?? this.cardRadius,
      buttonRadius: buttonRadius ?? this.buttonRadius,
      padding: padding ?? this.padding,
      headlineStyle: headlineStyle ?? this.headlineStyle,
      bodyStyle: bodyStyle ?? this.bodyStyle,
      priceStyle: priceStyle ?? this.priceStyle,
    );
  }
}

/// Returns black or white depending on which has better contrast with
/// [background].
Color _bestForeground(Color background) {
  // Relative-luminance approximation (sRGB).
  final r = background.r;
  final g = background.g;
  final b = background.b;
  final luminance = 0.299 * r + 0.587 * g + 0.114 * b;
  return luminance > 0.5 ? const Color(0xFF000000) : Colors.white;
}
