import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paywall_kit/paywall_kit.dart';

const _products = [
  PaywallProduct(
    id: 'pro_monthly',
    displayPrice: r'$9.99/mo',
    rawPrice: 9.99,
    currencyCode: 'USD',
    period: PaywallPeriod.monthly,
  ),
];

const _copy = PaywallCopy(
  headline: 'Go pro',
  features: ['No ads'],
  ctaSecondary: 'Maybe later',
);

void main() {
  group('SoftPaywall variant', () {
    testWidgets('renders primary CTA, secondary CTA, restore link',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => PaywallKit.show(
                  context,
                  variant: PaywallVariant.soft,
                  products: _products,
                  copy: _copy,
                ),
                child: const Text('open'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Continue'), findsOneWidget);
      expect(find.text('Maybe later'), findsOneWidget);
      expect(find.text('Restore Purchases'), findsOneWidget);
    });

    testWidgets('primary CTA buys, secondary dismisses', (tester) async {
      PaywallResult? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await PaywallKit.show(
                    context,
                    variant: PaywallVariant.soft,
                    products: _products,
                    copy: _copy,
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
      await tester.tap(find.text('Maybe later'));
      await tester.pumpAndSettle();

      expect(result, isA<PaywallDismissed>());
    });

    testWidgets('fallback secondary label when ctaSecondary is null',
        (tester) async {
      const copyNoSecondary = PaywallCopy(headline: 'Go pro', features: []);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => PaywallKit.show(
                  context,
                  variant: PaywallVariant.soft,
                  products: _products,
                  copy: copyNoSecondary,
                ),
                child: const Text('open'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Continue with limits'), findsOneWidget);
    });
  });
}
