import 'package:demo_task/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StellarInfoRow extends StatelessWidget {
  const StellarInfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor = AppTheme.primary,
    this.textColor = const Color(0xFF101828),
    this.spacing = 10,
  });

  final IconData icon;
  final String text;
  final Color iconColor;
  final Color textColor;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: iconColor),
        SizedBox(width: spacing),
        Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: textColor),
        ),
      ],
    );
  }
}
