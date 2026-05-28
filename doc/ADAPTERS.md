# Adapters

paywall_kit ships UI variants that are completely backend-agnostic.
A `PaywallAdapter` bridges the variants to whichever purchase system
your app uses.

Two implementations ship in the box:

- `PreviewAdapter` — no-op. Every `buy` succeeds instantly with
  `PaywallPurchased`; `restore` returns an empty `PaywallRestored`. This
  is the default when you don't pass `adapter:` to `PaywallKit.show` —
  useful for design / preview, or when you handle real purchases
  yourself inside `onPurchaseSuccess`.
- `IapAdapter` — wraps `package:in_app_purchase`. Talks to App Store and
  Google Play. See "Using IapAdapter" below.

For RevenueCat, Stripe, Paddle, or any other backend, implement
`PaywallAdapter` in your app. The full interface is just two methods.

---

## Using `PreviewAdapter` (default)

```dart
await PaywallKit.show(
  context,
  variant: PaywallVariant.lifetime,
  products: [PaywallProduct(...)],
  copy: PaywallCopy(...),
  // adapter omitted → PreviewAdapter is used
);
```

`PaywallPurchased` comes back instantly. Useful when you want to wire
the real purchase yourself:

```dart
final result = await PaywallKit.show(
  context,
  variant: PaywallVariant.lifetime,
  products: [PaywallProduct(...)],
  copy: PaywallCopy(...),
  onCtaTap: (product) async {
    // Run your purchase logic here.
    await yourBackend.charge(product.id);
  },
);
```

---

## Using `IapAdapter`

The native adapter wraps `package:in_app_purchase` directly.

```dart
import 'package:paywall_kit/paywall_kit.dart';

final iap = IapAdapter(consumable: false);

final result = await PaywallKit.show(
  context,
  variant: PaywallVariant.lifetime,
  products: [
    PaywallProduct(
      id: 'pro_lifetime',  // must match App Store / Play Store product ID
      displayPrice: '\$199',
      rawPrice: 199,
      currencyCode: 'USD',
      period: PaywallPeriod.lifetime,
    ),
  ],
  copy: PaywallCopy(headline: 'Lifetime access', features: [...]),
  adapter: iap,
);

switch (result) {
  case PaywallPurchased(:final product, :final transactionId):
    await grantEntitlement(product.id, transactionId);
  case PaywallRestored(:final products):
    for (final p in products) await grantEntitlement(p.id, null);
  case PaywallDismissed():
    break;
  case PaywallErrored(:final error):
    log.error('purchase failed', error);
}
```

### IAP setup checklist

1. App Store: create products in App Store Connect → "In-App Purchases".
   Product IDs must match what you pass to `PaywallProduct.id`.
2. Play Store: create products in Play Console → "Monetization →
   Products → In-app products / Subscriptions".
3. Add the iOS capability "In-App Purchase" in Xcode.
4. Use sandbox test users (App Store) / internal-testing track (Play)
   for development.
5. Pass `consumable: true` to `IapAdapter` for tip-jar / single-use
   products; leave it false for subscriptions and lifetime unlocks.

---

## Writing your own adapter

The `PaywallAdapter` interface is small:

```dart
abstract class PaywallAdapter {
  Future<PaywallResult> buy(PaywallProduct product);
  Future<PaywallResult> restore();
}
```

Both methods **must not throw** — wrap any exceptions in
`PaywallErrored(error: e, stackTrace: st)`.

### Recipe: RevenueCat

```dart
import 'package:paywall_kit/paywall_kit.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatAdapter extends PaywallAdapter {
  RevenueCatAdapter();

  @override
  Future<PaywallResult> buy(PaywallProduct product) async {
    try {
      final offerings = await Purchases.getOfferings();
      final pkg = offerings.current?.availablePackages.firstWhere(
        (p) => p.storeProduct.identifier == product.id,
      );
      if (pkg == null) {
        return PaywallErrored(
          error: StateError('Package not found in current offering: ${product.id}'),
        );
      }
      final info = await Purchases.purchasePackage(pkg);
      final entitlementActive =
          info.entitlements.active.values.any((e) => e.productIdentifier == product.id);
      if (!entitlementActive) {
        return PaywallErrored(error: StateError('Entitlement not active after purchase'));
      }
      return PaywallPurchased(product: product);
    } on PurchasesErrorCode catch (e, st) {
      if (e == PurchasesErrorCode.purchaseCancelledError) {
        return const PaywallDismissed();
      }
      return PaywallErrored(error: e, stackTrace: st);
    } catch (e, st) {
      return PaywallErrored(error: e, stackTrace: st);
    }
  }

  @override
  Future<PaywallResult> restore() async {
    try {
      final info = await Purchases.restorePurchases();
      final restored = info.entitlements.active.values
          .map((e) => PaywallProduct(
                id: e.productIdentifier,
                displayPrice: '',
                rawPrice: 0,
                currencyCode: '',
                period: PaywallPeriod.custom,
              ))
          .toList();
      return PaywallRestored(products: restored);
    } catch (e, st) {
      return PaywallErrored(error: e, stackTrace: st);
    }
  }
}
```

Configure RevenueCat once in `main()`:

```dart
await Purchases.configure(PurchasesConfiguration('your_api_key'));
```

Then pass `RevenueCatAdapter()` into `PaywallKit.show(adapter: ...)`.

### Recipe: Stripe (web / cross-platform)

For Stripe Checkout you typically redirect to a hosted URL, then check
entitlement after the user returns. Skeleton:

```dart
class StripeCheckoutAdapter extends PaywallAdapter {
  StripeCheckoutAdapter({required this.checkoutSessionFactory});

  /// App-supplied function that creates a Stripe Checkout Session for
  /// the given product ID and returns the session URL.
  final Future<String> Function(String productId) checkoutSessionFactory;

  @override
  Future<PaywallResult> buy(PaywallProduct product) async {
    try {
      final url = await checkoutSessionFactory(product.id);
      // Open url, poll for entitlement, or use webhooks.
      // Return PaywallPurchased on success, PaywallDismissed on
      // user-cancel, PaywallErrored on failure.
      throw UnimplementedError('App-specific entitlement polling');
    } catch (e, st) {
      return PaywallErrored(error: e, stackTrace: st);
    }
  }

  @override
  Future<PaywallResult> restore() async {
    // Check entitlement via your own backend.
    throw UnimplementedError('App-specific entitlement check');
  }
}
```

---

## Testing your adapter

A `FakeAdapter` for widget tests:

```dart
class FakeAdapter extends PaywallAdapter {
  FakeAdapter({this.buyResult, this.restoreResult});

  final PaywallResult? buyResult;
  final PaywallResult? restoreResult;

  @override
  Future<PaywallResult> buy(PaywallProduct product) async =>
      buyResult ?? PaywallPurchased(product: product);

  @override
  Future<PaywallResult> restore() async =>
      restoreResult ?? const PaywallRestored(products: []);
}

testWidgets('error path surfaces PaywallErrored', (tester) async {
  final result = await PaywallKit.show(
    context,
    variant: PaywallVariant.lifetime,
    products: [/* ... */],
    copy: PaywallCopy(/* ... */),
    adapter: FakeAdapter(
      buyResult: PaywallErrored(error: 'Card declined'),
    ),
  );
  expect(result, isA<PaywallErrored>());
});
```
