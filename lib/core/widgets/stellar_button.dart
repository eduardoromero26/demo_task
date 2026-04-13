import 'package:demo_task/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum StellarButtonVariant { primary, neutral, tonal }

class _StellarButtonColors {
  const _StellarButtonColors({
    required this.background,
    required this.foreground,
  });

  final Color background;
  final Color foreground;
}

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
    final colors = _resolveColors();
    final style =
        ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? colors.background,
          foregroundColor: foregroundColor ?? colors.foreground,
          disabledBackgroundColor: (backgroundColor ?? colors.background)
              .withValues(alpha: 0.45),
          disabledForegroundColor: (foregroundColor ?? colors.foreground)
              .withValues(alpha: 0.75),
          padding: padding ?? _resolvePadding(),
          elevation:
              elevation ?? (variant == StellarButtonVariant.primary ? 0 : 0),
          shadowColor: AppTheme.primary.withValues(alpha: 0.2),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          iconSize: 18,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ).copyWith(
          overlayColor: WidgetStatePropertyAll(
            (foregroundColor ?? colors.foreground).withValues(alpha: 0.08),
          ),
        );

    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon),
        label: Text(label),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: Text(label),
    );
  }

  EdgeInsetsGeometry _resolvePadding() {
    switch (variant) {
      case StellarButtonVariant.primary:
        return const EdgeInsets.symmetric(vertical: 14, horizontal: 16);
      case StellarButtonVariant.neutral:
        return const EdgeInsets.symmetric(horizontal: 18, vertical: 14);
      case StellarButtonVariant.tonal:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }
  }

  _StellarButtonColors _resolveColors() {
    switch (variant) {
      case StellarButtonVariant.primary:
        return const _StellarButtonColors(
          background: AppTheme.primary,
          foreground: Colors.white,
        );
      case StellarButtonVariant.neutral:
        return const _StellarButtonColors(
          background: Color(0xFFF0F2F8),
          foreground: Color(0xFF111827),
        );
      case StellarButtonVariant.tonal:
        return const _StellarButtonColors(
          background: AppTheme.secondary,
          foreground: Colors.white,
        );
    }
  }
}
