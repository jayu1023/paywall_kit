import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paywall_kit/paywall_kit.dart';

const _product = PaywallProduct(
  id: 'pro_annual',
  displayPrice: r'$69.99/yr',
  rawPrice: 69.99,
  currencyCode: 'USD',
  period: PaywallPeriod.annual,
);

const _testimonials = [
  PaywallTestimonial(
    quote: 'Changed how I work.',
    author: 'Alex P.',
    role: 'Indie developer',
  ),
  PaywallTestimonial(
    quote: 'Worth every penny.',
    author: 'Sam K.',
  ),
];

const _copy = PaywallCopy(
  headline: 'Built for serious creators',
  features: ['Unlimited everything'],
  testimonials: _testimonials,
  socialProof: 'Trusted by 10,000+ devs',
);

void main() {
  group('Storytelling variant', () {
    testWidgets('renders social-proof badge, testimonials, and CTA',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => PaywallKit.show(
                  context,
                  variant: PaywallVariant.storytelling,
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

      expect(find.text('Trusted by 10,000+ devs'), findsOneWidget);
      expect(find.textContaining('Changed how I work'), findsOneWidget);
      expect(find.textContaining('Alex P.'), findsOneWidget);
      expect(find.textContaining('Indie developer'), findsOneWidget);
      expect(find.textContaining('Worth every penny'), findsOneWidget);
    });

    testWidgets('omits "What customers say" when no testimonials provided',
        (tester) async {
      const copyNoTestimonials = PaywallCopy(
        headline: 'Pro',
        features: [],
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => PaywallKit.show(
                  context,
                  variant: PaywallVariant.storytelling,
                  products: const [_product],
                  copy: copyNoTestimonials,
                ),
                child: const Text('open'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('What customers say'), findsNothing);
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
                    variant: PaywallVariant.storytelling,
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
      await tester.tap(find.textContaining('Continue'));
      await tester.pumpAndSettle();

      expect(result, isA<PaywallPurchased>());
      expect((result! as PaywallPurchased).product.id, 'pro_annual');
    });
  });
}
