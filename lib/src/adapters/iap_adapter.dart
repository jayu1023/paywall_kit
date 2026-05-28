import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../core/paywall_period.dart';
import '../core/paywall_product.dart';
import '../core/paywall_result.dart';
import 'paywall_adapter.dart';

/// Native adapter wrapping `package:in_app_purchase`.
///
/// Works with App Store and Google Play products configured in the host
/// app's developer console. The product `id` in [PaywallProduct] must
/// match the store-side product identifier exactly.
///
/// Test purchases require store-side setup (sandbox accounts, signed
/// builds). See the README "IAP setup" recipe for the full checklist.
class IapAdapter extends PaywallAdapter {
  /// Creates an IAP adapter.
  ///
  /// Set [consumable] to true for tip-jar / single-use products. Leave
  /// false for subscriptions and lifetime unlocks.
  IapAdapter({this.consumable = false, InAppPurchase? iap})
      : _iap = iap ?? InAppPurchase.instance;

  /// Whether products bought via this adapter are consumable.
  final bool consumable;

  final InAppPurchase _iap;

  @override
  Future<PaywallResult> buy(PaywallProduct product) async {
    try {
      final response = await _iap.queryProductDetails({product.id});
      if (response.error != null) {
        return PaywallErrored(error: response.error!);
      }
      if (response.notFoundIDs.contains(product.id) ||
          response.productDetails.isEmpty) {
        return PaywallErrored(
          error: StateError('Product not found: ${product.id}'),
        );
      }
      final details = response.productDetails.first;
      final purchaseParam = PurchaseParam(productDetails: details);

      final completer = Completer<PaywallResult>();
      late StreamSubscription<List<PurchaseDetails>> sub;
      sub = _iap.purchaseStream.listen(
        (purchases) async {
          for (final p in purchases) {
            if (p.productID != product.id) continue;
            await _resolvePurchase(p, product, completer, () => sub.cancel());
            if (completer.isCompleted) return;
          }
        },
        onError: (Object e, StackTrace st) {
          if (!completer.isCompleted) {
            completer.complete(PaywallErrored(error: e, stackTrace: st));
          }
        },
      );

      final ok = consumable
          ? await _iap.buyConsumable(purchaseParam: purchaseParam)
          : await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      if (!ok) {
        if (!completer.isCompleted) {
          completer.complete(
            PaywallErrored(error: StateError('Store rejected purchase')),
          );
        }
        await sub.cancel();
      }

      return completer.future;
    } catch (e, st) {
      return PaywallErrored(error: e, stackTrace: st);
    }
  }

  @override
  Future<PaywallResult> restore() async {
    try {
      final restored = <PaywallProduct>[];
      final completer = Completer<void>();
      Timer? settle;

      final sub = _iap.purchaseStream.listen((purchases) async {
        for (final p in purchases) {
          if (p.status == PurchaseStatus.restored) {
            restored.add(
              PaywallProduct(
                id: p.productID,
                displayPrice: '',
                rawPrice: 0,
                currencyCode: '',
                period: PaywallPeriod.custom,
              ),
            );
            if (p.pendingCompletePurchase) {
              await _iap.completePurchase(p);
            }
          }
        }
        settle?.cancel();
        settle = Timer(const Duration(milliseconds: 800), () {
          if (!completer.isCompleted) completer.complete();
        });
      });

      await _iap.restorePurchases();

      // Belt-and-suspenders: give the stream up to 4 s to deliver
      // restored entries, then finalize.
      unawaited(
        Future<void>.delayed(const Duration(seconds: 4)).then((_) {
          if (!completer.isCompleted) completer.complete();
        }),
      );

      await completer.future;
      await sub.cancel();
      settle?.cancel();
      return PaywallRestored(products: restored);
    } catch (e, st) {
      return PaywallErrored(error: e, stackTrace: st);
    }
  }

  Future<void> _resolvePurchase(
    PurchaseDetails p,
    PaywallProduct product,
    Completer<PaywallResult> completer,
    Future<void> Function() cancelSub,
  ) async {
    switch (p.status) {
      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        if (p.pendingCompletePurchase) {
          await _iap.completePurchase(p);
        }
        if (!completer.isCompleted) {
          completer.complete(
            PaywallPurchased(
              product: product,
              transactionId: p.purchaseID,
            ),
          );
        }
        await cancelSub();
      case PurchaseStatus.error:
        if (!completer.isCompleted) {
          completer.complete(
            PaywallErrored(
              error: p.error ?? StateError('Purchase failed'),
            ),
          );
        }
        await cancelSub();
      case PurchaseStatus.canceled:
        if (!completer.isCompleted) {
          completer.complete(const PaywallDismissed());
        }
        await cancelSub();
      case PurchaseStatus.pending:
        // Keep listening — the store will emit a terminal status soon.
        break;
    }
  }
}
