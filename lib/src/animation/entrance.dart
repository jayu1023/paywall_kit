import 'package:flutter/material.dart';

/// Internal: subtle fade-and-slide-up entrance applied at the top of
/// every variant body.
///
/// Independent of the `MaterialPageRoute` slide-up transition that
/// already plays when the variant is pushed — this animates content
/// *within* the variant once the route is in place, giving each screen
/// a confident "settle" beat rather than a hard cut.
class PaywallEntrance extends StatefulWidget {
  /// Creates an entrance.
  const PaywallEntrance({
    required this.child,
    this.duration = const Duration(milliseconds: 280),
    super.key,
  });

  /// The widget to animate in.
  final Widget child;

  /// Length of the fade + slide. Default tuned to feel snappy without
  /// blocking interaction.
  final Duration duration;

  @override
  State<PaywallEntrance> createState() => _PaywallEntranceState();
}

class _PaywallEntranceState extends State<PaywallEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl =
      AnimationController(vsync: this, duration: widget.duration);

  late final Animation<double> _fade =
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.04),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

  @override
  void initState() {
    super.initState();
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
