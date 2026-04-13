import 'package:demo_task/core/widgets/component_library.dart';
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
                StellarHeadline(
                  'Active Jobs',
                  size: StellarHeadlineSize.large,
                  color: const Color(0xFF0F172A),
                  fontWeight: FontWeight.w800,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    StellarButton(
                      label: selectedFilterLabel ?? 'Filter',
                      icon: Icons.tune_rounded,
                      onPressed: onFilterPressed,
                      variant: StellarButtonVariant.neutral,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StellarButton(
                        label: 'New Job',
                        icon: Icons.add_rounded,
                        onPressed: onNewJobPressed,
                        elevation: 6,
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
