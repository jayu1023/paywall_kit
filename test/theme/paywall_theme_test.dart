import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paywall_kit/paywall_kit.dart';

void main() {
  group('PaywallTheme.brand', () {
    test('derives white onPrimary for dark brand color', () {
      final t = PaywallTheme.brand(primary: const Color(0xFF1A1A1A));
      expect(t.onPrimary, equals(Colors.white));
    });

    test('derives black onPrimary for light brand color', () {
      final t = PaywallTheme.brand(primary: const Color(0xFFFAFAFA));
      expect(t.onPrimary, equals(const Color(0xFF000000)));
    });

    test('accent defaults to primary when not provided', () {
      final t = PaywallTheme.brand(primary: const Color(0xFF6750A4));
      expect(t.accent, equals(t.primary));
    });

    test('accent overrides primary when provided', () {
      final t = PaywallTheme.brand(
        primary: Colors.indigo,
        accent: Colors.amber,
      );
      expect(t.accent, equals(Colors.amber));
    });

    test('dark brightness flips surface + background to dark palette', () {
      final light = PaywallTheme.brand(primary: Colors.indigo);
      final dark = PaywallTheme.brand(
        primary: Colors.indigo,
        brightness: Brightness.dark,
      );
      expect(light.surface, isNot(equals(dark.surface)));
      expect(light.background, isNot(equals(dark.background)));
    });
  });

  group('PaywallTheme.fromTheme', () {
    testWidgets('inherits primary and onPrimary from ColorScheme',
        (tester) async {
      late PaywallTheme captured;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          ),
          home: Builder(
            builder: (context) {
              captured = PaywallTheme.fromTheme(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      final expected = ColorScheme.fromSeed(seedColor: Colors.teal);
      expect(captured.primary, equals(expected.primary));
      expect(captured.onPrimary, equals(expected.onPrimary));
    });
  });

  group('PaywallTheme.copyWith', () {
    test('overrides only specified fields', () {
      final base = PaywallTheme.brand(primary: Colors.indigo);
      final modified = base.copyWith(primary: Colors.red);
      expect(modified.primary, equals(Colors.red));
      expect(modified.accent, equals(base.accent));
      expect(modified.surface, equals(base.surface));
    });
  });

  group('defaults', () {
    test('card and button radii have sensible defaults', () {
      final t = PaywallTheme.brand(primary: Colors.indigo);
      expect(t.cardRadius, equals(const BorderRadius.all(Radius.circular(16))));
      expect(
        t.buttonRadius,
        equals(const BorderRadius.all(Radius.circular(12))),
      );
    });
  });
}
