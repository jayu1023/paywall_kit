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
  headline: 'Unlock everything',
  features: ['No ads', 'Cloud sync', 'AI assistant'],
);

void main() {
  group('Carousel variant', () {
    testWidgets('renders headline and CTA with selected price',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => PaywallKit.show(
                  context,
                  variant: PaywallVariant.carousel,
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
      expect(find.textContaining(r'$9.99'), findsWidgets);
    });

    testWidgets('CTA tap returns PaywallPurchased with first product',
        (tester) async {
      PaywallResult? result;
      PaywallProduct? ctaProduct;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await PaywallKit.show(
                    context,
                    variant: PaywallVariant.carousel,
                    products: _products,
                    copy: _copy,
                    onCtaTap: (p) => ctaProduct = p,
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
      expect((result! as PaywallPurchased).product, _products.first);
      expect(ctaProduct, _products.first);
    });

    testWidgets('close button returns PaywallDismissed', (tester) async {
      PaywallResult? result;
      var dismissCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await PaywallKit.show(
                    context,
                    variant: PaywallVariant.carousel,
                    products: _products,
                    copy: _copy,
                    onDismiss: () => dismissCount++,
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
      expect(dismissCount, equals(1));
    });
  });
}
