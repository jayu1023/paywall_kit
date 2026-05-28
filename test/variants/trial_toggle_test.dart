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
    trialPeriod: '7 days',
  ),
];

const _copy = PaywallCopy(
  headline: 'Try Pro free for 7 days',
  features: ['No ads', 'Cloud sync', 'AI assistant'],
);

void main() {
  group('TrialToggle variant', () {
    testWidgets('renders both toggle options with prices', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => PaywallKit.show(
                  context,
                  variant: PaywallVariant.trialToggle,
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

      expect(find.text('Monthly'), findsOneWidget);
      expect(find.text('Annual'), findsOneWidget);
      expect(find.text(r'$9.99/mo'), findsOneWidget);
      expect(find.text(r'$69.99/yr'), findsOneWidget);
    });

    testWidgets('default selection is annual and shows trial CTA copy',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => PaywallKit.show(
                  context,
                  variant: PaywallVariant.trialToggle,
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

      expect(find.text('Start 7 days free trial'), findsOneWidget);
    });

    testWidgets('switching to monthly updates CTA and selected product',
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
                    variant: PaywallVariant.trialToggle,
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
      await tester.tap(find.text('Monthly'));
      await tester.pumpAndSettle();
      // Monthly product has no trialPeriod so CTA falls back to copy.ctaPrimary.
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(result, isA<PaywallPurchased>());
      expect((result! as PaywallPurchased).product.id, 'pro_monthly');
    });
  });
}
