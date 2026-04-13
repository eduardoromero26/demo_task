import 'package:demo_task/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum StellarButtonVariant { primary, neutral, tonal }

class StellarButton extends StatelessWidget {
  const StellarButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = StellarButtonVariant.primary,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderRadius = 16,
    this.elevation,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final StellarButtonVariant variant;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    const buttonTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );

    final buttonChild = icon == null
        ? Text(label, style: buttonTextStyle)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              Text(label, style: buttonTextStyle),
            ],
          );

    switch (variant) {
      case StellarButtonVariant.primary:
        return FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: backgroundColor ?? AppTheme.primary,
            foregroundColor: foregroundColor ?? Colors.white,
            padding: padding ?? const EdgeInsets.symmetric(vertical: 14),
            elevation: elevation,
            shadowColor: AppTheme.primary.withValues(alpha: 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: buttonChild,
        );
      case StellarButtonVariant.neutral:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor ?? const Color(0xFFF0F2F8),
            foregroundColor: foregroundColor ?? const Color(0xFF111827),
            side: BorderSide.none,
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: buttonChild,
        );
      case StellarButtonVariant.tonal:
        return FilledButton.tonal(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: backgroundColor ?? AppTheme.secondary,
            foregroundColor: foregroundColor ?? Colors.white,
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: buttonChild,
        );
    }
  }
}
