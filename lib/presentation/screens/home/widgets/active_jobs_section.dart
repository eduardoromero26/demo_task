import 'package:demo_task/core/theme/app_theme.dart';
import 'package:demo_task/core/widgets/component_library.dart';
import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:demo_task/presentation/screens/home/widgets/home_formatters.dart';
import 'package:flutter/material.dart';

class ActiveJobsSection extends StatelessWidget {
  const ActiveJobsSection({
    super.key,
    required this.workOrders,
    required this.isLoadingMore,
    required this.paginationErrorMessage,
    required this.onRetryPage,
  });

  final List<WorkOrderModel> workOrders;
  final bool isLoadingMore;
  final String? paginationErrorMessage;
  final VoidCallback onRetryPage;

  @override
  Widget build(BuildContext context) {
    if (workOrders.isEmpty) {
      return const SliverToBoxAdapter(
        child: StellarEmptyState(
          message: 'No work orders match the current filter.',
          padding: EdgeInsets.fromLTRB(22, 24, 22, 32),
        ),
      );
    }

    final hasFooter = isLoadingMore || paginationErrorMessage != null;
    final itemCount = workOrders.length + (hasFooter ? 1 : 0);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index >= workOrders.length) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: isLoadingMore
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _PaginationRetryCard(
                      message: paginationErrorMessage!,
                      onRetryPage: onRetryPage,
                    ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: _JobSummaryCard(workOrder: workOrders[index]),
          );
        }, childCount: itemCount),
      ),
    );
  }
}

class _JobSummaryCard extends StatelessWidget {
  const _JobSummaryCard({required this.workOrder});

  final WorkOrderModel workOrder;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final showTime = hasExplicitTime(workOrder.scheduledDate);

    return StellarCard(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StellarChip(
                label: workOrder.id.toUpperCase(),
                backgroundColor: const Color(0xFFF2F4F7),
                foregroundColor: const Color(0xFF344054),
                borderRadius: 4,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                textStyle: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              StellarChip(
                label: formatEnumName(workOrder.status.name).toUpperCase(),
                backgroundColor: _statusBackground(workOrder.status),
                foregroundColor: _statusForeground(workOrder.status),
                textStyle: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            workOrder.title,
            style: textTheme.headlineSmall?.copyWith(
              fontSize: 22,
              height: 1.2,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF101828),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            workOrder.location,
            style: textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF344054),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 18,
            runSpacing: 12,
            children: [
              StellarInfoRow(
                icon: Icons.calendar_month_rounded,
                text: formatDateLabel(workOrder.scheduledDate),
              ),
              if (showTime)
                StellarInfoRow(
                  icon: Icons.access_time_filled_rounded,
                  text: formatTimeLabel(workOrder.scheduledDate),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaginationRetryCard extends StatelessWidget {
  const _PaginationRetryCard({
    required this.message,
    required this.onRetryPage,
  });

  final String message;
  final VoidCallback onRetryPage;

  @override
  Widget build(BuildContext context) {
    return StellarCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(18),
      boxShadow: const [],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
          const SizedBox(height: 12),
          StellarButton(
            label: 'Retry page',
            onPressed: onRetryPage,
            variant: StellarButtonVariant.tonal,
          ),
        ],
      ),
    );
  }
}

Color _statusBackground(WorkOrderStatus status) {
  switch (status) {
    case WorkOrderStatus.pending:
      return const Color(0xFFFFE7C7);
    case WorkOrderStatus.completed:
      return AppTheme.primaryTint;
    case WorkOrderStatus.inProgress:
      return const Color(0xFFD9F6FD);
    case WorkOrderStatus.scheduled:
      return const Color(0xFFE7F7F5);
    case WorkOrderStatus.blocked:
      return const Color(0xFFFDE7E4);
  }
}

Color _statusForeground(WorkOrderStatus status) {
  switch (status) {
    case WorkOrderStatus.pending:
      return const Color(0xFF8A4300);
    case WorkOrderStatus.completed:
      return AppTheme.tertiary;
    case WorkOrderStatus.inProgress:
      return const Color(0xFF0F6D84);
    case WorkOrderStatus.scheduled:
      return const Color(0xFF0B5F55);
    case WorkOrderStatus.blocked:
      return const Color(0xFFB42318);
  }
}
