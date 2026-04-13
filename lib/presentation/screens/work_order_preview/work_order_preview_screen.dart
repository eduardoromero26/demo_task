import 'package:demo_task/core/theme/app_theme.dart';
import 'package:demo_task/core/widgets/component_library.dart';
import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:demo_task/presentation/screens/home/widgets/home_formatters.dart';
import 'package:demo_task/presentation/screens/work_order_preview/widgets/work_order_status_dropdown.dart';
import 'package:flutter/material.dart';

class WorkOrderPreviewScreen extends StatelessWidget {
  const WorkOrderPreviewScreen({super.key, required this.workOrder});

  final WorkOrderModel workOrder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(workOrder.id.toUpperCase())),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StellarHeadline(
                workOrder.title,
                size: StellarHeadlineSize.large,
                fontWeight: FontWeight.w800,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  StellarChip(
                    label: formatEnumName(workOrder.status.name).toUpperCase(),
                    backgroundColor: _statusBackground(workOrder.status),
                    foregroundColor: _statusForeground(workOrder.status),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              StellarCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StellarHeadline(
                      'Overview',
                      size: StellarHeadlineSize.small,
                    ),
                    const SizedBox(height: 16),
                    if (workOrder.description != null &&
                        workOrder.description!.trim().isNotEmpty) ...[
                      Text(
                        workOrder.description!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF344054),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                    StellarInfoRow(
                      icon: Icons.location_on_outlined,
                      text: workOrder.location,
                    ),
                    const SizedBox(height: 14),
                    StellarInfoRow(
                      icon: Icons.calendar_month_rounded,
                      text: formatDateLabel(workOrder.scheduledDate),
                    ),
                    if (hasExplicitTime(workOrder.scheduledDate)) ...[
                      const SizedBox(height: 14),
                      StellarInfoRow(
                        icon: Icons.access_time_rounded,
                        text: formatTimeLabel(workOrder.scheduledDate),
                      ),
                    ],
                    if (workOrder.assignedTo != null &&
                        workOrder.assignedTo!.trim().isNotEmpty) ...[
                      const SizedBox(height: 14),
                      StellarInfoRow(
                        icon: Icons.person_outline_rounded,
                        text: workOrder.assignedTo!,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),
              StellarCard(
                child: WorkOrderStatusDropdown(
                  currentStatus: workOrder.status,
                  onStatusSelected: (nextStatus) {
                    Navigator.of(context).pop(nextStatus);
                  },
                ),
              ),
            ],
          ),
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
  }
}
