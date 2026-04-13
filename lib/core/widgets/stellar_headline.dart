import 'package:demo_task/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum StellarHeadlineSize { large, medium, small }

class StellarHeadline extends StatelessWidget {
  const StellarHeadline(
    this.text, {
    super.key,
    this.size = StellarHeadlineSize.medium,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final StellarHeadlineSize size;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final baseStyle = switch (size) {
      StellarHeadlineSize.large => Theme.of(context).textTheme.headlineMedium,
      StellarHeadlineSize.medium => Theme.of(context).textTheme.titleLarge,
      StellarHeadlineSize.small => Theme.of(context).textTheme.titleMedium,
    };

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: baseStyle?.copyWith(
        color: color ?? AppTheme.textPrimary,
        fontWeight: fontWeight ?? FontWeight.w700,
      ),
    );
  }
}
