import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paywall_kit/paywall_kit.dart';

class _FakeAdapter extends PaywallAdapter {
  const _FakeAdapter();

  @override
  Future<PaywallResult> buy(PaywallProduct product) async =>
      PaywallPurchased(product: product);

  @override
  Future<PaywallResult> restore() async =>
      const PaywallRestored(products: []);
}

const _product = PaywallProduct(
  id: 'pro_monthly',
  displayPrice: r'$9.99/mo',
  rawPrice: 9.99,
  currencyCode: 'USD',
  period: PaywallPeriod.monthly,
);

const _copy = PaywallCopy(headline: 'Pro', features: ['No ads']);

void main() {
  group('PaywallScope routes through the supplied adapter', () {
    testWidgets('custom adapter is used by variant CTA', (tester) async {
      PaywallResult? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await PaywallKit.show(
                    context,
                    variant: PaywallVariant.minimal,
                    products: const [_product],
                    copy: _copy,
                    adapter: const _FakeAdapter(),
                  );
                },
                child: const Text('open'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(result, isA<PaywallPurchased>());
      expect((result! as PaywallPurchased).product.id, 'pro_monthly');
    });

    testWidgets('Restore link dispatches adapter.restore()', (tester) async {
      PaywallResult? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await PaywallKit.show(
                    context,
                    variant: PaywallVariant.minimal,
                    products: const [_product],
                    copy: _copy,
                    adapter: const _FakeAdapter(),
                  );
                },
                child: const Text('open'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Restore Purchases'));
      await tester.pumpAndSettle();

      expect(result, isA<PaywallRestored>());
    });
  });
}
