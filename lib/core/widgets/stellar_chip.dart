import 'package:flutter/material.dart';

class StellarChip extends StatelessWidget {
  const StellarChip({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    this.borderRadius = 10,
    this.textStyle,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final labelStyle = textStyle ?? Theme.of(context).textTheme.labelMedium;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: padding,
        child: Text(
          label,
          style: labelStyle?.copyWith(
            color: foregroundColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}