import 'package:flutter_test/flutter_test.dart';
import 'package:paywall_kit/paywall_kit.dart';

void main() {
  group('PaywallCopy', () {
    test('default CTA and restore strings', () {
      const copy = PaywallCopy(
        headline: 'Unlock everything',
        features: ['No ads'],
      );
      expect(copy.ctaPrimary, 'Continue');
      expect(copy.restoreText, 'Restore Purchases');
    });

    test('equality across all fields', () {
      const a = PaywallCopy(
        headline: 'h',
        features: ['a', 'b'],
        subhead: 's',
        ctaPrimary: 'Go',
        ctaSecondary: 'Later',
        finePrint: 'fp',
        privacyPolicyUrl: 'https://x/p',
        termsOfServiceUrl: 'https://x/t',
      );
      const b = PaywallCopy(
        headline: 'h',
        features: ['a', 'b'],
        subhead: 's',
        ctaPrimary: 'Go',
        ctaSecondary: 'Later',
        finePrint: 'fp',
        privacyPolicyUrl: 'https://x/p',
        termsOfServiceUrl: 'https://x/t',
      );
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('equality fails on differing features list', () {
      const a = PaywallCopy(headline: 'h', features: ['a']);
      const b = PaywallCopy(headline: 'h', features: ['a', 'b']);
      expect(a, isNot(equals(b)));
    });

    test('optional fields null by default', () {
      const copy = PaywallCopy(headline: 'h', features: []);
      expect(copy.subhead, isNull);
      expect(copy.ctaSecondary, isNull);
      expect(copy.finePrint, isNull);
      expect(copy.privacyPolicyUrl, isNull);
      expect(copy.termsOfServiceUrl, isNull);
    });
  });
}
