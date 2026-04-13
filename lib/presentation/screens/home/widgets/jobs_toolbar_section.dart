import 'package:demo_task/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class JobsToolbarSection extends StatelessWidget {
  const JobsToolbarSection({
    super.key,
    required this.onFilterPressed,
    required this.onNewJobPressed,
    this.selectedFilterLabel,
  });

  final VoidCallback onFilterPressed;
  final VoidCallback onNewJobPressed;
  final String? selectedFilterLabel;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _JobsToolbarHeaderDelegate(
        child: ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Jobs',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF0F172A),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: onFilterPressed,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFF0F2F8),
                        foregroundColor: const Color(0xFF111827),
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.tune_rounded, size: 18),
                      label: Text(selectedFilterLabel ?? 'Filter'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: onNewJobPressed,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: AppTheme.textPrimary,
                          elevation: 6,
                          shadowColor: AppTheme.primary.withValues(alpha: 0.2),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('New Job'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _JobsToolbarHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _JobsToolbarHeaderDelegate({required this.child});

  static const _headerHeight = 126.0;

  final Widget child;

  @override
  double get minExtent => _headerHeight;

  @override
  double get maxExtent => _headerHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _JobsToolbarHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
