import 'package:demo_task/core/widgets/stellar_headline.dart';
import 'package:flutter/material.dart';

class StellarBottomSheet extends StatelessWidget {
  const StellarBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 8, 20, 20),
  });

  final String? title;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                StellarHeadline(title!, size: StellarHeadlineSize.medium),
                const SizedBox(height: 12),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}

Future<T?> showStellarBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool showDragHandle = true,
  Color backgroundColor = Colors.white,
}) {
  return showModalBottomSheet<T>(
    context: context,
    showDragHandle: showDragHandle,
    backgroundColor: backgroundColor,
    builder: builder,
  );
}
