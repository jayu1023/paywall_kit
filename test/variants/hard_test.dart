import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paywall_kit/paywall_kit.dart';

const _products = [
  PaywallProduct(
    id: 'pro_annual',
    displayPrice: r'$69.99/yr',
    rawPrice: 69.99,
    currencyCode: 'USD',
    period: PaywallPeriod.annual,
  ),
];

const _copy = PaywallCopy(
  headline: 'Unlock everything',
  features: ['No ads', 'AI assistant'],
);

void main() {
  group('HardPaywall variant', () {
    testWidgets('renders dominant CTA with price', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => PaywallKit.show(
                  context,
                  variant: PaywallVariant.hard,
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

      expect(find.text('Unlock everything'), findsOneWidget);
      expect(find.textContaining(r'$69.99'), findsOneWidget);
    });

    testWidgets('CTA buys', (tester) async {
      PaywallResult? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await PaywallKit.show(
                    context,
                    variant: PaywallVariant.hard,
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

    testWidgets('subtle close button is present and works', (tester) async {
      PaywallResult? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await PaywallKit.show(
                    context,
                    variant: PaywallVariant.hard,
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
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();

      expect(result, isA<PaywallDismissed>());
    });
  });
}
