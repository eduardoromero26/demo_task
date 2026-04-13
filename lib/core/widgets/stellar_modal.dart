import 'package:demo_task/core/widgets/stellar_headline.dart';
import 'package:flutter/material.dart';

class StellarModal extends StatelessWidget {
  const StellarModal({
    super.key,
    this.title,
    this.description,
    this.leading,
    required this.child,
    this.insetPadding = const EdgeInsets.symmetric(horizontal: 24),
  });

  final String? title;
  final String? description;
  final Widget? leading;
  final Widget child;
  final EdgeInsets insetPadding;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: insetPadding,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leading != null) ...[leading!, const SizedBox(height: 16)],
            if (title != null)
              StellarHeadline(
                title!,
                size: StellarHeadlineSize.small,
                fontWeight: FontWeight.w800,
              ),
            if (description != null) ...[
              if (title != null) const SizedBox(height: 10),
              Text(
                description!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF667085),
                  height: 1.45,
                ),
              ),
            ],
            if (title != null || description != null)
              const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

Future<T?> showStellarModal<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: builder,
  );
}
