import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paywall_kit/paywall_kit.dart';

const _product = PaywallProduct(
  id: 'pro_monthly',
  displayPrice: r'$9.99/mo',
  rawPrice: 9.99,
  currencyCode: 'USD',
  period: PaywallPeriod.monthly,
);

const _copy = PaywallCopy(
  headline: 'Unlock everything',
  features: ['No ads', 'Cloud sync'],
);

void main() {
  group('PaywallKit.show — Phase 1 skeleton', () {
    testWidgets('fires onView and onDismiss, returns PaywallDismissed',
        (tester) async {
      var viewed = 0;
      var dismissed = 0;
      late PaywallResult result;

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
                    onView: () => viewed++,
                    onDismiss: () => dismissed++,
                  );
                },
                child: const Text('show'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('show'));
      await tester.pump();

      expect(viewed, equals(1));
      expect(dismissed, equals(1));
      expect(result, isA<PaywallDismissed>());
    });

    testWidgets('asserts on empty products list', (tester) async {
      late Object? caught;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  try {
                    await PaywallKit.show(
                      context,
                      variant: PaywallVariant.minimal,
                      products: const [],
                      copy: _copy,
                    );
                  } catch (e) {
                    caught = e;
                  }
                },
                child: const Text('show'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('show'));
      await tester.pump();
      expect(caught, isA<AssertionError>());
    });
  });
}
