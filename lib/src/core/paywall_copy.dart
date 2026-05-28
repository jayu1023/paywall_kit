/// All user-facing strings on a paywall.
///
/// Translation-ready: every string the user sees is sourced from this
/// object. paywall_kit hardcodes no copy of its own.
class PaywallCopy {
  /// Creates a paywall copy bundle.
  const PaywallCopy({
    required this.headline,
    required this.features,
    this.subhead,
    this.ctaPrimary = 'Continue',
    this.ctaSecondary,
    this.restoreText = 'Restore Purchases',
    this.finePrint,
    this.privacyPolicyUrl,
    this.termsOfServiceUrl,
  });

  /// The big headline at the top of the screen (e.g.
  /// `'Unlock everything'`).
  final String headline;

  /// Optional subhead under the headline. One-liner that elaborates on
  /// the value prop.
  final String? subhead;

  /// Bullet list of features the user unlocks. Rendered as a vertical
  /// list with checkmarks in most variants.
  final List<String> features;

  /// Label for the primary purchase button. Defaults to `'Continue'`.
  final String ctaPrimary;

  /// Optional secondary CTA (e.g. `'Maybe later'` for soft paywalls).
  final String? ctaSecondary;

  /// Label for the restore-purchases link. Defaults to
  /// `'Restore Purchases'`. App Store rules require this control on
  /// every paywall.
  final String restoreText;

  /// Optional legal fine print rendered below the CTAs.
  final String? finePrint;

  /// Privacy policy URL — opens in browser on tap.
  final String? privacyPolicyUrl;

  /// Terms of service URL — opens in browser on tap.
  final String? termsOfServiceUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaywallCopy &&
          other.headline == headline &&
          other.subhead == subhead &&
          _listEquals(other.features, features) &&
          other.ctaPrimary == ctaPrimary &&
          other.ctaSecondary == ctaSecondary &&
          other.restoreText == restoreText &&
          other.finePrint == finePrint &&
          other.privacyPolicyUrl == privacyPolicyUrl &&
          other.termsOfServiceUrl == termsOfServiceUrl;

  @override
  int get hashCode => Object.hash(
        headline,
        subhead,
        Object.hashAll(features),
        ctaPrimary,
        ctaSecondary,
        restoreText,
        finePrint,
        privacyPolicyUrl,
        termsOfServiceUrl,
      );
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
