import 'package:demo_task/core/theme/app_theme.dart';
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
        child: Padding(
          padding: EdgeInsets.fromLTRB(22, 24, 22, 32),
          child: Center(
            child: Text('No work orders match the current filter.'),
          ),
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

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Text(
                      workOrder.id.toUpperCase(),
                      style: textTheme.labelMedium?.copyWith(
                        color: const Color(0xFF344054),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: _statusBackground(workOrder.status),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    child: Text(
                      formatEnumName(workOrder.status.name).toUpperCase(),
                      style: textTheme.labelMedium?.copyWith(
                        color: _statusForeground(workOrder.status),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
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
                _InlineMeta(
                  icon: Icons.calendar_month_rounded,
                  text: formatDateLabel(workOrder.scheduledDate),
                ),
                if (showTime)
                  _InlineMeta(
                    icon: Icons.access_time_filled_rounded,
                    text: formatTimeLabel(workOrder.scheduledDate),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineMeta extends StatelessWidget {
  const _InlineMeta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: AppTheme.primary),
        const SizedBox(width: 10),
        Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF101828)),
        ),
      ],
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: onRetryPage,
              child: const Text('Retry page'),
            ),
          ],
        ),
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
