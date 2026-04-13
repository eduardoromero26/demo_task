import 'package:demo_task/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TechnicalFieldServiceAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const TechnicalFieldServiceAppBar({super.key});

  static const _stellarAssetPath = 'assets/images/stellar.png';
  static const _logoSize = 48.0;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 72,
      titleSpacing: 0,
      leadingWidth: 80,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16, top: 12, bottom: 12),
        child: SizedBox.square(
          dimension: _logoSize,
          child: Image.asset(
            _stellarAssetPath,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.handyman_rounded,
                  color: AppTheme.primary,
                ),
              );
            },
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search_rounded),
          color: AppTheme.secondary,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
            color: AppTheme.secondary,
          ),
        ),
      ],
    );
  }
}
