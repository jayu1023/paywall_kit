import 'package:flutter/material.dart';
import 'package:paywall_kit/paywall_kit.dart';

void main() => runApp(const PaywallKitDemoApp());

class PaywallKitDemoApp extends StatelessWidget {
  const PaywallKitDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'paywall_kit demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
        ),
        useMaterial3: true,
      ),
      home: const _Gallery(),
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery();

  static const _products = [
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
      perks: ['No ads', 'Cloud sync', 'AI assistant', 'Priority support'],
    ),
    PaywallProduct(
      id: 'pro_lifetime',
      displayPrice: r'$199',
      rawPrice: 199,
      currencyCode: 'USD',
      period: PaywallPeriod.lifetime,
      originalPrice: 299,
      perks: ['Everything in Pro', 'Forever'],
    ),
  ];

  static const _copy = PaywallCopy(
    headline: 'Unlock everything',
    subhead: 'Join 50,000+ creators going pro',
    features: [
      'No ads, ever',
      'Cloud sync across devices',
      'AI-powered assistant',
      'Priority email support',
    ],
    ctaPrimary: 'Continue',
    ctaSecondary: 'Maybe later',
    socialProof: 'Trusted by 50,000+ indie devs',
    testimonials: [
      PaywallTestimonial(
        quote: 'Changed how I work. Worth every penny.',
        author: 'Alex P.',
        role: 'Indie developer',
      ),
      PaywallTestimonial(
        quote: 'The AI features are unreal.',
        author: 'Sam K.',
        role: 'Designer',
      ),
    ],
  );

  static const _variants = <_VariantCard>[
    _VariantCard(
      variant: PaywallVariant.carousel,
      title: 'Carousel',
      blurb: 'Swipeable highlights, single CTA',
      icon: Icons.view_carousel,
      color: Color(0xFF6750A4),
    ),
    _VariantCard(
      variant: PaywallVariant.comparison,
      title: 'Comparison',
      blurb: 'Side-by-side product cards',
      icon: Icons.compare,
      color: Color(0xFF7D5260),
    ),
    _VariantCard(
      variant: PaywallVariant.trialToggle,
      title: 'Trial toggle',
      blurb: 'Monthly / annual, free trial',
      icon: Icons.toggle_on,
      color: Color(0xFF625B71),
    ),
    _VariantCard(
      variant: PaywallVariant.lifetime,
      title: 'Lifetime',
      blurb: 'One-time, savings vs annual',
      icon: Icons.workspace_premium,
      color: Color(0xFFB58900),
    ),
    _VariantCard(
      variant: PaywallVariant.soft,
      title: 'Soft',
      blurb: 'Skip option, gentle nudge',
      icon: Icons.air,
      color: Color(0xFF4E944F),
    ),
    _VariantCard(
      variant: PaywallVariant.hard,
      title: 'Hard',
      blurb: 'Onboarding-blocking, dominant CTA',
      icon: Icons.lock_outline,
      color: Color(0xFFB00020),
    ),
    _VariantCard(
      variant: PaywallVariant.winback,
      title: 'Win-back',
      blurb: 'Discount badge, strikethrough price',
      icon: Icons.local_offer,
      color: Color(0xFFD81B60),
    ),
    _VariantCard(
      variant: PaywallVariant.family,
      title: 'Family',
      blurb: 'Multi-seat, per-person price',
      icon: Icons.family_restroom,
      color: Color(0xFF1976D2),
    ),
    _VariantCard(
      variant: PaywallVariant.minimal,
      title: 'Minimal',
      blurb: 'Single price, single CTA',
      icon: Icons.crop_square,
      color: Color(0xFF455A64),
    ),
    _VariantCard(
      variant: PaywallVariant.storytelling,
      title: 'Storytelling',
      blurb: 'Long scroll, testimonials',
      icon: Icons.menu_book,
      color: Color(0xFF8E24AA),
    ),
    _VariantCard(
      variant: PaywallVariant.gamified,
      title: 'Gamified',
      blurb: 'Unlock rewards, progress ring',
      icon: Icons.emoji_events,
      color: Color(0xFFEF6C00),
    ),
    _VariantCard(
      variant: PaywallVariant.reverseTrial,
      title: 'Reverse trial',
      blurb: "\"You're on Pro for 7 days\"",
      icon: Icons.replay_circle_filled,
      color: Color(0xFF00897B),
    ),
  ];

  Future<void> _show(BuildContext context, PaywallVariant variant) async {
    final result = await PaywallKit.show(
      context,
      variant: variant,
      products: _products,
      copy: _copy,
      theme: PaywallTheme.fromTheme(context),
    );
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(_describe(result)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _describe(PaywallResult result) {
    return switch (result) {
      PaywallPurchased(:final product) =>
        '✅ Purchased: ${product.id} (${product.displayPrice})',
      PaywallRestored(:final products) =>
        '↻ Restored ${products.length} product(s)',
      PaywallDismissed() => '✕ Dismissed',
      PaywallErrored(:final error) => '⚠︎ Error: $error',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('paywall_kit · 12 variants'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisExtent: 168,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _variants.length,
          itemBuilder: (context, i) {
            final v = _variants[i];
            return v.build(
              context,
              onTap: () => _show(context, v.variant),
            );
          },
        ),
      ),
    );
  }
}

class _VariantCard {
  const _VariantCard({
    required this.variant,
    required this.title,
    required this.blurb,
    required this.icon,
    required this.color,
  });

  final PaywallVariant variant;
  final String title;
  final String blurb;
  final IconData icon;
  final Color color;

  Widget build(BuildContext context, {required VoidCallback onTap}) {
    return Material(
      color: color.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const Spacer(),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                blurb,
                style: TextStyle(
                  fontSize: 12,
                  color: color.withValues(alpha: 0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
