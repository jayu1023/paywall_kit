import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paywall_kit/paywall_kit.dart';

const _product = PaywallProduct(
  id: 'pro_lifetime',
  displayPrice: r'$49',
  rawPrice: 49,
  currencyCode: 'USD',
  period: PaywallPeriod.lifetime,
);

const _copy = PaywallCopy(
  headline: 'Level up',
  features: ['Unlock badges', 'Unlock themes', 'Unlock streak booster'],
);

void main() {
  group('Gamified variant', () {
    testWidgets('renders reward badge with count from features.length',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => PaywallKit.show(
                  context,
                  variant: PaywallVariant.gamified,
                  products: const [_product],
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

      expect(find.text('Level up'), findsOneWidget);
      expect(find.text('+3 rewards waiting'), findsOneWidget);
      expect(find.text('Unlock badges'), findsOneWidget);
      expect(find.text('Unlock themes'), findsOneWidget);
    });

    testWidgets('CTA reads "Unlock all" and buys', (tester) async {
      PaywallResult? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await PaywallKit.show(
                    context,
                    variant: PaywallVariant.gamified,
                    products: const [_product],
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
      await tester.tap(find.textContaining('Unlock all'));
      await tester.pumpAndSettle();

      expect(result, isA<PaywallPurchased>());
    });
  });
}
