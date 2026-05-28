import 'package:flutter/widgets.dart';

import 'paywall_adapter.dart';

/// Inherited widget that exposes the active [PaywallAdapter] to every
/// descendant variant (so CTAs and the Restore button can dispatch).
///
/// Installed automatically by `PaywallKit.show`. Variant authors don't
/// instantiate this directly.
class PaywallScope extends InheritedWidget {
  /// Creates a paywall scope.
  const PaywallScope({
    required this.adapter,
    required super.child,
    super.key,
  });

  /// The adapter to use for purchase / restore.
  final PaywallAdapter adapter;

  /// Looks up the nearest [PaywallScope].
  ///
  /// Throws if called outside a paywall route — this is a programmer
  /// error, so the failure mode is loud.
  static PaywallScope of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<PaywallScope>();
    assert(
      scope != null,
      'PaywallScope.of() called outside a paywall route. '
      'paywall_kit installs the scope inside PaywallKit.show.',
    );
    return scope!;
  }

  @override
  bool updateShouldNotify(PaywallScope oldWidget) =>
      adapter != oldWidget.adapter;
}
