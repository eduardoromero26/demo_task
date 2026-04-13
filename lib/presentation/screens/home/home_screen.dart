import 'package:demo_task/core/theme/app_theme.dart';
import 'package:demo_task/core/widgets/component_library.dart';
import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:demo_task/presentation/bloc/work_orders_bloc.dart';
import 'package:demo_task/presentation/bloc/work_orders_event.dart';
import 'package:demo_task/presentation/bloc/work_orders_state.dart';
import 'package:demo_task/presentation/screens/home/widgets/active_jobs_section.dart';
import 'package:demo_task/presentation/screens/home/widgets/home_formatters.dart';
import 'package:demo_task/presentation/screens/work_order_preview/work_order_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _HomeAppBar(),
      bottomNavigationBar: const _HomeBottomNavigation(),
      body: BlocConsumer<WorkOrdersBloc, WorkOrdersState>(
        listener: (context, state) {
          final message = state.feedbackMessage;
          if (message == null) {
            return;
          }

          if (!(ModalRoute.of(context)?.isCurrent ?? true)) {
            return;
          }

          showStellarSnackbar(context, message: message);

          context.read<WorkOrdersBloc>().add(
            const WorkOrdersFeedbackDismissed(),
          );
        },
        builder: (context, state) {
          if (state.status == WorkOrdersLoadStatus.loading &&
              state.workOrders.isEmpty) {
            return const _InitialLoadingView();
          }

          if (state.status == WorkOrdersLoadStatus.failure &&
              state.workOrders.isEmpty) {
            return _InitialErrorView(message: state.initialErrorMessage);
          }

          return CustomScrollView(
            slivers: [
              _JobsToolbarSection(
                selectedFilterLabel: state.selectedFilter == null
                    ? null
                    : formatEnumName(state.selectedFilter!.name),
                onFilterPressed: () => _showFilterSheet(
                  context,
                  selectedFilter: state.selectedFilter,
                ),
                onNewJobPressed: () => showStellarSnackbar(
                  context,
                  message: 'Mock action: create job',
                ),
              ),
              ActiveJobsSection(
                workOrders: state.visibleWorkOrders,
                onWorkOrderPressed: (workOrder) =>
                    _openWorkOrderPreview(context, workOrder),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar();

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
          icon: const Icon(Icons.notifications_none_rounded),
          color: AppTheme.secondary,
        ),
      ],
    );
  }
}

class _HomeBottomNavigation extends StatelessWidget {
  const _HomeBottomNavigation();

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: 0,
      onDestinationSelected: (_) {},
      height: 78,
      indicatorColor: Colors.transparent,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontFamily: AppTheme.fontFamily,
          fontSize: 11,
          color: selected ? AppTheme.primary : const Color(0xFF8C8C8C),
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        );
      }),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.calendar_month_rounded, color: Color(0xFF8C8C8C)),
          selectedIcon: Icon(
            Icons.calendar_month_rounded,
            color: AppTheme.primary,
          ),
          label: 'Work Orders',
        ),
        NavigationDestination(
          icon: Icon(Icons.history_rounded, color: Color(0xFF8C8C8C)),
          selectedIcon: Icon(Icons.history_rounded, color: AppTheme.secondary),
          label: 'History',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_rounded, color: Color(0xFF8C8C8C)),
          selectedIcon: Icon(Icons.settings_rounded, color: AppTheme.secondary),
          label: 'Settings',
        ),
      ],
    );
  }
}

class _JobsToolbarSection extends StatelessWidget {
  const _JobsToolbarSection({
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
                const StellarHeadline(
                  'Active Jobs',
                  size: StellarHeadlineSize.large,
                  color: Color(0xFF0F172A),
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

Future<void> _openWorkOrderPreview(
  BuildContext context,
  WorkOrderModel workOrder,
) async {
  await Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (_) => WorkOrderPreviewScreen(workOrder: workOrder),
    ),
  );
}

class _InitialErrorView extends StatelessWidget {
  const _InitialErrorView({required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message ?? 'Unable to load work orders.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                context.read<WorkOrdersBloc>().add(const WorkOrdersStarted());
              },
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InitialLoadingView extends StatelessWidget {
  const _InitialLoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14004C55),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(18),
              child: Image.asset(
                'assets/images/stellar_ico.jpg',
                filterQuality: FilterQuality.none,
              ),
            ),
            const SizedBox(height: 24),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            const SizedBox(height: 14),
            Text(
              'Loading Stellar...',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppTheme.tertiary),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showFilterSheet(
  BuildContext context, {
  required WorkOrderStatus? selectedFilter,
}) {
  return showStellarBottomSheet<void>(
    context,
    builder: (sheetContext) {
      return StellarBottomSheet(
        title: 'Filter jobs',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('All jobs'),
              trailing: selectedFilter == null
                  ? const Icon(Icons.check, color: AppTheme.primary)
                  : null,
              onTap: () {
                context.read<WorkOrdersBloc>().add(
                  const WorkOrdersFilterChanged(null),
                );
                Navigator.of(sheetContext).pop();
              },
            ),
            ...WorkOrderStatus.values.map(
              (status) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(formatEnumName(status.name)),
                trailing: selectedFilter == status
                    ? const Icon(Icons.check, color: AppTheme.primary)
                    : null,
                onTap: () {
                  context.read<WorkOrdersBloc>().add(
                    WorkOrdersFilterChanged(status),
                  );
                  Navigator.of(sheetContext).pop();
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
