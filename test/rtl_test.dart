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
    badge: 'Best value',
  ),
  PaywallProduct(
    id: 'pro_lifetime',
    displayPrice: r'$199',
    rawPrice: 199,
    currencyCode: 'USD',
    period: PaywallPeriod.lifetime,
    originalPrice: 299,
  ),
];

const _copy = PaywallCopy(
  headline: 'افتح كل الميزات',
  subhead: 'انضم إلى آلاف المستخدمين',
  features: ['بدون إعلانات', 'مزامنة سحابية', 'مساعد ذكاء اصطناعي'],
  ctaPrimary: 'متابعة',
  ctaSecondary: 'ربما لاحقًا',
  restoreText: 'استعادة المشتريات',
  socialProof: 'يثق به أكثر من 10,000 مطور',
  testimonials: [
    PaywallTestimonial(
      quote: 'غيّر طريقة عملي تمامًا.',
      author: 'أحمد',
      role: 'مطور مستقل',
    ),
  ],
);

void main() {
  group('RTL — every variant renders in Arabic without overflow', () {
    for (final variant in PaywallVariant.values) {
      testWidgets('$variant in ar locale', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            ),
            home: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () => PaywallKit.show(
                    context,
                    variant: variant,
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

        expect(
          tester.takeException(),
          isNull,
          reason: '$variant overflowed or threw in RTL',
        );

        // Sanity: at least one Arabic glyph from the headline is on screen.
        expect(find.text('افتح كل الميزات'), findsAtLeast(1));
      });
    }
  });
}
