import 'package:demo_task/core/widgets/component_library.dart';
import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:demo_task/presentation/work_order_status_colors.dart';
import 'package:demo_task/presentation/screens/home/widgets/home_formatters.dart';
import 'package:flutter/material.dart';

class ActiveJobsSection extends StatelessWidget {
  const ActiveJobsSection({
    super.key,
    required this.workOrders,
    required this.onWorkOrderPressed,
  });

  final List<WorkOrderModel> workOrders;
  final ValueChanged<WorkOrderModel> onWorkOrderPressed;

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

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onWorkOrderPressed(workOrders[index]),
              child: _JobSummaryCard(workOrder: workOrders[index]),
            ),
          );
        }, childCount: workOrders.length),
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
                backgroundColor: workOrderStatusBackground(workOrder.status),
                foregroundColor: workOrderStatusForeground(workOrder.status),
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
