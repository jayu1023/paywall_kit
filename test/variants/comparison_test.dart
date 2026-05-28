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
  PaywallProduct(
    id: 'pro_annual',
    displayPrice: r'$69.99/yr',
    rawPrice: 69.99,
    currencyCode: 'USD',
    period: PaywallPeriod.annual,
    badge: 'Best value',
  ),
];

const _copy = PaywallCopy(
  headline: 'Choose your plan',
  features: ['No ads', 'Cloud sync'],
);

void main() {
  group('Comparison variant', () {
    testWidgets('renders both product cards and highlights badged one',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => PaywallKit.show(
                  context,
                  variant: PaywallVariant.comparison,
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

      expect(find.text('pro_monthly'), findsOneWidget);
      expect(find.text('pro_annual'), findsOneWidget);
      expect(find.text('Best value'), findsOneWidget);
    });

    testWidgets('selects badged product by default and CTA buys it',
        (tester) async {
      PaywallResult? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await PaywallKit.show(
                    context,
                    variant: PaywallVariant.comparison,
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
      await tester.tap(find.textContaining('Continue'));
      await tester.pumpAndSettle();

      expect(result, isA<PaywallPurchased>());
      expect((result! as PaywallPurchased).product.id, 'pro_annual');
    });

    testWidgets('tapping a product card selects it', (tester) async {
      PaywallResult? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await PaywallKit.show(
                    context,
                    variant: PaywallVariant.comparison,
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
      await tester.tap(find.text('pro_monthly'));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Continue'));
      await tester.pumpAndSettle();

      expect(result, isA<PaywallPurchased>());
      expect((result! as PaywallPurchased).product.id, 'pro_monthly');
    });
  });
}
