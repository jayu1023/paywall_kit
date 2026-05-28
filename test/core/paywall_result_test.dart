import 'package:flutter_test/flutter_test.dart';
import 'package:paywall_kit/paywall_kit.dart';

const _product = PaywallProduct(
  id: 'pro_monthly',
  displayPrice: r'$9.99/mo',
  rawPrice: 9.99,
  currencyCode: 'USD',
  period: PaywallPeriod.monthly,
);

void main() {
  group('PaywallResult', () {
    test('PaywallPurchased equality', () {
      const a = PaywallPurchased(product: _product, transactionId: 'tx1');
      const b = PaywallPurchased(product: _product, transactionId: 'tx1');
      const c = PaywallPurchased(product: _product, transactionId: 'tx2');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('PaywallRestored equality on products list', () {
      const a = PaywallRestored(products: [_product]);
      const b = PaywallRestored(products: [_product]);
      const c = PaywallRestored(products: []);
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('PaywallDismissed singletons are equal', () {
      expect(const PaywallDismissed(), equals(const PaywallDismissed()));
    });

    test('PaywallErrored holds error payload', () {
      final err = StateError('boom');
      final r = PaywallErrored(error: err);
      expect(r.error, equals(err));
      expect(r.stackTrace, isNull);
    });

    test('sealed switch is exhaustive over all 4 cases', () {
      String describe(PaywallResult r) => switch (r) {
            PaywallPurchased() => 'purchased',
            PaywallRestored() => 'restored',
            PaywallDismissed() => 'dismissed',
            PaywallErrored() => 'errored',
          };
      expect(
        describe(const PaywallPurchased(product: _product)),
        'purchased',
      );
      expect(
        describe(const PaywallRestored(products: [])),
        'restored',
      );
      expect(describe(const PaywallDismissed()), 'dismissed');
      expect(
        describe(PaywallErrored(error: Exception('x'))),
        'errored',
      );
    });
  });
}
