import 'package:flutter/material.dart';

class StellarCard extends StatelessWidget {
  const StellarCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color = Colors.white,
    this.borderRadius = 24,
    this.boxShadow = const [
      BoxShadow(
        color: Color(0x140F172A),
        blurRadius: 28,
        offset: Offset(0, 12),
      ),
    ],
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final double borderRadius;
  final List<BoxShadow> boxShadow;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}