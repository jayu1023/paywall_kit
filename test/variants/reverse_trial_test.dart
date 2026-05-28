import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paywall_kit/paywall_kit.dart';

const _monthly = PaywallProduct(
  id: 'pro_monthly',
  displayPrice: r'$9.99/mo',
  rawPrice: 9.99,
  currencyCode: 'USD',
  period: PaywallPeriod.monthly,
);

const _annual = PaywallProduct(
  id: 'pro_annual',
  displayPrice: r'$69.99/yr',
  rawPrice: 69.99,
  currencyCode: 'USD',
  period: PaywallPeriod.annual,
  trialPeriod: '14 days',
);

const _copy = PaywallCopy(
  headline: 'Keep your Pro perks',
  features: ['No ads', 'Cloud sync'],
);

void main() {
  group('ReverseTrial variant', () {
    testWidgets('renders trial-status badge using product trial duration',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => PaywallKit.show(
                  context,
                  variant: PaywallVariant.reverseTrial,
                  products: const [_monthly, _annual],
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

      // Annual is the default selection → its 14-day trial drives the
      // status badge.
      expect(find.textContaining("You're on Pro for 14 days"), findsOneWidget);
      expect(find.text('Keep your Pro perks'), findsOneWidget);
    });

    testWidgets('default selection is annual, CTA buys it', (tester) async {
      PaywallResult? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await PaywallKit.show(
                    context,
                    variant: PaywallVariant.reverseTrial,
                    products: const [_monthly, _annual],
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
      await tester.tap(find.textContaining('Keep Pro'));
      await tester.pumpAndSettle();

      expect(result, isA<PaywallPurchased>());
      expect((result! as PaywallPurchased).product.id, 'pro_annual');
    });

    testWidgets('falls back to 7 days when product has no trialPeriod',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => PaywallKit.show(
                  context,
                  variant: PaywallVariant.reverseTrial,
                  products: const [_monthly],
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

      expect(find.textContaining("You're on Pro for 7 days"), findsOneWidget);
    });
  });
}
