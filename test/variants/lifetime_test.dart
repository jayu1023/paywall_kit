import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paywall_kit/paywall_kit.dart';

const _lifetime = PaywallProduct(
  id: 'pro_lifetime',
  displayPrice: r'$199',
  rawPrice: 199,
  currencyCode: 'USD',
  period: PaywallPeriod.lifetime,
);

const _annual = PaywallProduct(
  id: 'pro_annual',
  displayPrice: r'$69.99/yr',
  rawPrice: 69.99,
  currencyCode: 'USD',
  period: PaywallPeriod.annual,
);

const _copy = PaywallCopy(
  headline: 'Lifetime access',
  features: ['No ads', 'Forever'],
);

void main() {
  group('Lifetime variant', () {
    testWidgets('renders headline, lifetime price, and CTA', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => PaywallKit.show(
                  context,
                  variant: PaywallVariant.lifetime,
                  products: const [_lifetime],
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

      expect(find.text('Lifetime access'), findsOneWidget);
      expect(find.text(r'$199'), findsOneWidget);
      expect(find.text('Get lifetime access'), findsOneWidget);
    });

    testWidgets('CTA tap returns PaywallPurchased with lifetime product',
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
                    variant: PaywallVariant.lifetime,
                    products: const [_lifetime],
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
      await tester.tap(find.text('Get lifetime access'));
      await tester.pumpAndSettle();

      expect(result, isA<PaywallPurchased>());
      expect((result! as PaywallPurchased).product.id, 'pro_lifetime');
    });

    testWidgets('shows savings badge when annual is also provided',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => PaywallKit.show(
                  context,
                  variant: PaywallVariant.lifetime,
                  products: const [_lifetime, _annual],
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

      expect(find.textContaining('Save'), findsOneWidget);
    });
  });
}
