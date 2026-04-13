import 'package:demo_task/core/widgets/component_library.dart';
import 'package:flutter/material.dart';

class StellarEmptyState extends StatelessWidget {
  const StellarEmptyState({
    super.key,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.padding = const EdgeInsets.all(24),
    this.centered = true,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final EdgeInsetsGeometry padding;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          if (actionLabel != null && onActionPressed != null) ...[
            const SizedBox(height: 12),
            StellarButton(label: actionLabel!, onPressed: onActionPressed),
          ],
        ],
      ),
    );

    return centered ? Center(child: content) : content;
  }
}
