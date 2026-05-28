import 'package:flutter_test/flutter_test.dart';
import 'package:paywall_kit/paywall_kit.dart';

void main() {
  group('PaywallProduct', () {
    test('equality is structural across all fields', () {
      const a = PaywallProduct(
        id: 'pro_monthly',
        displayPrice: r'$9.99/mo',
        rawPrice: 9.99,
        currencyCode: 'USD',
        period: PaywallPeriod.monthly,
        perks: ['No ads'],
      );
      const b = PaywallProduct(
        id: 'pro_monthly',
        displayPrice: r'$9.99/mo',
        rawPrice: 9.99,
        currencyCode: 'USD',
        period: PaywallPeriod.monthly,
        perks: ['No ads'],
      );
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('equality fails on differing rawPrice', () {
      const a = PaywallProduct(
        id: 'pro_monthly',
        displayPrice: r'$9.99/mo',
        rawPrice: 9.99,
        currencyCode: 'USD',
        period: PaywallPeriod.monthly,
      );
      const b = PaywallProduct(
        id: 'pro_monthly',
        displayPrice: r'$9.99/mo',
        rawPrice: 10.99,
        currencyCode: 'USD',
        period: PaywallPeriod.monthly,
      );
      expect(a, isNot(equals(b)));
    });

    test('equality fails on differing perks list', () {
      const a = PaywallProduct(
        id: 'p',
        displayPrice: r'$1',
        rawPrice: 1,
        currencyCode: 'USD',
        period: PaywallPeriod.lifetime,
        perks: ['a'],
      );
      const b = PaywallProduct(
        id: 'p',
        displayPrice: r'$1',
        rawPrice: 1,
        currencyCode: 'USD',
        period: PaywallPeriod.lifetime,
        perks: ['a', 'b'],
      );
      expect(a, isNot(equals(b)));
    });

    test('default perks list is empty const', () {
      const p = PaywallProduct(
        id: 'p',
        displayPrice: 'x',
        rawPrice: 1,
        currencyCode: 'USD',
        period: PaywallPeriod.lifetime,
      );
      expect(p.perks, isEmpty);
    });

    test('toString includes id and period', () {
      const p = PaywallProduct(
        id: 'pro_yearly',
        displayPrice: r'$99/yr',
        rawPrice: 99,
        currencyCode: 'USD',
        period: PaywallPeriod.annual,
      );
      expect(p.toString(), contains('pro_yearly'));
      expect(p.toString(), contains('annual'));
    });

    test('optional fields stay null when omitted', () {
      const p = PaywallProduct(
        id: 'p',
        displayPrice: 'x',
        rawPrice: 1,
        currencyCode: 'USD',
        period: PaywallPeriod.lifetime,
      );
      expect(p.trialPeriod, isNull);
      expect(p.originalPrice, isNull);
      expect(p.badge, isNull);
    });
  });
}
