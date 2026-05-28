import '../core/paywall_product.dart';
import '../core/paywall_result.dart';
import 'paywall_adapter.dart';

/// No-op adapter for design / preview / test contexts.
///
/// Every [buy] succeeds immediately with [PaywallPurchased]. [restore]
/// returns an empty [PaywallRestored]. This is the default when
/// `PaywallKit.show` is called without an `adapter:` argument — useful
/// when you handle purchases yourself in `onPurchaseSuccess`, or when
/// you just want to preview the UI.
class PreviewAdapter extends PaywallAdapter {
  /// Creates a preview adapter.
  const PreviewAdapter();

  @override
  Future<PaywallResult> buy(PaywallProduct product) async {
    return PaywallPurchased(product: product);
  }

  @override
  Future<PaywallResult> restore() async {
    return const PaywallRestored(products: []);
  }
}
