import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paywall_kit/paywall_kit.dart';

const _family = PaywallProduct(
  id: 'pro_family_annual',
  displayPrice: r'$99.99/yr',
  rawPrice: 99.99,
  currencyCode: 'USD',
  period: PaywallPeriod.annual,
  badge: 'Family',
);

const _copy = PaywallCopy(
  headline: 'Family plan',
  features: ['Up to 6 members', 'No ads'],
);

void main() {
  group('FamilyPlan variant', () {
    testWidgets('renders default seat copy and total price', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => PaywallKit.show(
                  context,
                  variant: PaywallVariant.family,
                  products: const [_family],
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

      expect(find.text('Family plan'), findsOneWidget);
      expect(find.text('Share with up to 6 people'), findsOneWidget);
      expect(find.text(r'$99.99/yr'), findsOneWidget);
    });

    testWidgets('shows per-person price breakdown', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => PaywallKit.show(
                  context,
                  variant: PaywallVariant.family,
                  products: const [_family],
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

      expect(find.textContaining('per person'), findsOneWidget);
    });

    testWidgets('CTA buys family product', (tester) async {
      PaywallResult? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await PaywallKit.show(
                    context,
                    variant: PaywallVariant.family,
                    products: const [_family],
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
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(result, isA<PaywallPurchased>());
      expect((result! as PaywallPurchased).product.id, 'pro_family_annual');
    });
  });
}
