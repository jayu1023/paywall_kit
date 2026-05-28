import 'package:flutter_test/flutter_test.dart';
import 'package:paywall_kit/paywall_kit.dart';

void main() {
  group('formatPaywallPrice', () {
    test('monthly USD adds /mo suffix', () {
      final s = formatPaywallPrice(
        rawPrice: 9.99,
        currencyCode: 'USD',
        period: PaywallPeriod.monthly,
        locale: 'en_US',
      );
      expect(s, endsWith('/mo'));
      expect(s, contains('9.99'));
    });

    test('annual USD adds /yr suffix', () {
      final s = formatPaywallPrice(
        rawPrice: 99,
        currencyCode: 'USD',
        period: PaywallPeriod.annual,
        locale: 'en_US',
      );
      expect(s, endsWith('/yr'));
    });

    test('weekly adds /wk suffix', () {
      final s = formatPaywallPrice(
        rawPrice: 1.99,
        currencyCode: 'USD',
        period: PaywallPeriod.weekly,
        locale: 'en_US',
      );
      expect(s, endsWith('/wk'));
    });

    test('lifetime has no per-period suffix', () {
      final s = formatPaywallPrice(
        rawPrice: 199,
        currencyCode: 'USD',
        period: PaywallPeriod.lifetime,
        locale: 'en_US',
      );
      expect(s, isNot(endsWith('/mo')));
      expect(s, isNot(endsWith('/yr')));
      expect(s, isNot(endsWith('/wk')));
    });

    test('custom has no per-period suffix', () {
      final s = formatPaywallPrice(
        rawPrice: 49,
        currencyCode: 'USD',
        period: PaywallPeriod.custom,
        locale: 'en_US',
      );
      expect(s, isNot(endsWith('/mo')));
    });
  });

  group('computeSavingsPercent', () {
    test('returns positive percentage when annual is cheaper per month', () {
      // $9.99/mo vs $5.99/mo (annual @ ~$72/yr) → ~40% savings
      final pct = computeSavingsPercent(
        fromPricePerMonth: 9.99,
        toPricePerMonth: 5.99,
      );
      expect(pct, isNotNull);
      expect(pct, greaterThan(30));
      expect(pct, lessThan(50));
    });

    test('returns null when target is not cheaper', () {
      expect(
        computeSavingsPercent(
          fromPricePerMonth: 9.99,
          toPricePerMonth: 9.99,
        ),
        isNull,
      );
      expect(
        computeSavingsPercent(
          fromPricePerMonth: 5,
          toPricePerMonth: 10,
        ),
        isNull,
      );
    });

    test('returns null on non-positive inputs', () {
      expect(
        computeSavingsPercent(fromPricePerMonth: 0, toPricePerMonth: 5),
        isNull,
      );
      expect(
        computeSavingsPercent(fromPricePerMonth: 5, toPricePerMonth: 0),
        isNull,
      );
    });
  });
}
