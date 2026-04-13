import 'package:demo_task/core/theme/app_theme.dart';
import 'package:demo_task/core/widgets/component_library.dart';
import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:demo_task/presentation/bloc/work_orders_bloc.dart';
import 'package:demo_task/presentation/bloc/work_orders_event.dart';
import 'package:demo_task/presentation/bloc/work_orders_state.dart';
import 'package:demo_task/presentation/screens/home/widgets/active_jobs_section.dart';
import 'package:demo_task/presentation/screens/home/widgets/dashboard_bottom_navigation.dart';
import 'package:demo_task/presentation/screens/home/widgets/home_formatters.dart';
import 'package:demo_task/presentation/screens/home/widgets/jobs_toolbar_section.dart';
import 'package:demo_task/presentation/screens/home/widgets/technical_field_service_app_bar.dart';
import 'package:demo_task/presentation/screens/work_order_preview/work_order_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TechnicalFieldServiceAppBar(),
      bottomNavigationBar: const DashboardBottomNavigation(),
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
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == WorkOrdersLoadStatus.failure &&
              state.workOrders.isEmpty) {
            return _InitialErrorView(message: state.initialErrorMessage);
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 280) {
                context.read<WorkOrdersBloc>().add(
                  const WorkOrdersNextPageRequested(),
                );
              }

              return false;
            },
            child: CustomScrollView(
              slivers: [
                JobsToolbarSection(
                  selectedFilterLabel: state.selectedFilter == null
                      ? null
                      : formatEnumName(state.selectedFilter!.name),
                  onFilterPressed: () => _showFilterSheet(
                    context,
                    selectedFilter: state.selectedFilter,
                  ),
                  onNewJobPressed: () => _showPlaceholderSnackBar(
                    context,
                    'Mock action: create job',
                  ),
                ),
                ActiveJobsSection(
                  workOrders: state.visibleWorkOrders,
                  isLoadingMore: state.isLoadingMore,
                  paginationErrorMessage: state.paginationErrorMessage,
                  onWorkOrderPressed: (workOrder) =>
                      _openWorkOrderPreview(context, workOrder),
                  onRetryPage: () {
                    context.read<WorkOrdersBloc>().add(
                      const WorkOrdersRetryNextPageRequested(),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
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
    return StellarEmptyState(
      message: message ?? 'Unable to load work orders.',
      actionLabel: 'Try again',
      onActionPressed: () {
        context.read<WorkOrdersBloc>().add(const WorkOrdersStarted());
      },
    );
  }
}

void _showPlaceholderSnackBar(BuildContext context, String message) {
  showStellarSnackbar(context, message: message);
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
