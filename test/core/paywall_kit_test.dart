import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paywall_kit/paywall_kit.dart';

const _product = PaywallProduct(
  id: 'pro_monthly',
  displayPrice: r'$9.99/mo',
  rawPrice: 9.99,
  currencyCode: 'USD',
  period: PaywallPeriod.monthly,
);

const _copy = PaywallCopy(
  headline: 'Unlock everything',
  features: ['No ads', 'Cloud sync'],
);

void main() {
  group('PaywallKit.show', () {
    testWidgets('fires onView synchronously then awaits user interaction',
        (tester) async {
      var viewed = 0;
      late Future<PaywallResult> pending;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  pending = PaywallKit.show(
                    context,
                    variant: PaywallVariant.minimal,
                    products: const [_product],
                    copy: _copy,
                    onView: () => viewed++,
                  );
                },
                child: const Text('show'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('show'));
      await tester.pumpAndSettle();

      // onView fires immediately when the route is pushed.
      expect(viewed, equals(1));

      // Close the placeholder coming-soon route so the future resolves.
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(await pending, isA<PaywallDismissed>());
    });

    testWidgets('asserts on empty products list', (tester) async {
      late Object? caught;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  try {
                    await PaywallKit.show(
                      context,
                      variant: PaywallVariant.minimal,
                      products: const [],
                      copy: _copy,
                    );
                  } catch (e) {
                    caught = e;
                  }
                },
                child: const Text('show'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('show'));
      await tester.pump();
      expect(caught, isA<AssertionError>());
    });

    testWidgets('unimplemented variant shows "coming soon" placeholder',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  PaywallKit.show(
                    context,
                    variant: PaywallVariant.gamified,
                    products: const [_product],
                    copy: _copy,
                  );
                },
                child: const Text('show'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('show'));
      await tester.pumpAndSettle();

      expect(find.textContaining('coming soon'), findsOneWidget);
    });
  });
}
