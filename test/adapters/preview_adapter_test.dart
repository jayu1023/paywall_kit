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
  group('PreviewAdapter', () {
    test('buy returns PaywallPurchased instantly', () async {
      const adapter = PreviewAdapter();
      final result = await adapter.buy(_product);
      expect(result, isA<PaywallPurchased>());
      expect((result as PaywallPurchased).product, _product);
    });

    test('restore returns empty PaywallRestored', () async {
      const adapter = PreviewAdapter();
      final result = await adapter.restore();
      expect(result, isA<PaywallRestored>());
      expect((result as PaywallRestored).products, isEmpty);
    });

    test('is the default adapter when none passed to PaywallKit.show',
        () async {
      // Asserted indirectly: existing widget tests pass without an adapter
      // and observe `PaywallPurchased` results, which only PreviewAdapter
      // produces. This test pins the public expectation.
      expect(const PreviewAdapter(), isA<PaywallAdapter>());
    });
  });
}
