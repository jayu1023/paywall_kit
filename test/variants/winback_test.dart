import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paywall_kit/paywall_kit.dart';

const _discounted = PaywallProduct(
  id: 'pro_annual',
  displayPrice: r'$34.99/yr',
  rawPrice: 34.99,
  currencyCode: 'USD',
  period: PaywallPeriod.annual,
  originalPrice: 69.99,
);

const _noDiscount = PaywallProduct(
  id: 'pro_monthly',
  displayPrice: r'$9.99/mo',
  rawPrice: 9.99,
  currencyCode: 'USD',
  period: PaywallPeriod.monthly,
);

const _copy = PaywallCopy(
  headline: 'We miss you',
  features: ['Welcome back!'],
);

void main() {
  group('Winback variant', () {
    testWidgets('shows discount badge and strikethrough original price',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => PaywallKit.show(
                  context,
                  variant: PaywallVariant.winback,
                  products: const [_discounted],
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

      // 50% off
      expect(find.textContaining('50%'), findsOneWidget);
      // discounted price visible
      expect(find.text(r'$34.99/yr'), findsOneWidget);
      // original price formatted with strikethrough style
      expect(find.textContaining(r'$69.99'), findsOneWidget);
    });

    testWidgets('CTA "Reactivate" returns PaywallPurchased', (tester) async {
      PaywallResult? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await PaywallKit.show(
                    context,
                    variant: PaywallVariant.winback,
                    products: const [_discounted],
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
      await tester.tap(find.text('Reactivate'));
      await tester.pumpAndSettle();

      expect(result, isA<PaywallPurchased>());
      expect((result! as PaywallPurchased).product.id, 'pro_annual');
    });

    testWidgets('falls back gracefully when no originalPrice provided',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => PaywallKit.show(
                  context,
                  variant: PaywallVariant.winback,
                  products: const [_noDiscount],
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

      // No "% OFF" badge when no discount info
      expect(find.textContaining('% OFF'), findsNothing);
      // Price is still shown
      expect(find.text(r'$9.99/mo'), findsOneWidget);
    });
  });
}
