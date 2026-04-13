import 'package:demo_task/core/widgets/component_library.dart';
import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:demo_task/presentation/screens/work_order_preview/widgets/work_order_status_confirmation_dialog.dart';
import 'package:flutter/material.dart';

class WorkOrderStatusDropdown extends StatelessWidget {
  const WorkOrderStatusDropdown({
    super.key,
    required this.workOrder,
    required this.onStatusSelected,
  });

  final WorkOrderModel workOrder;
  final Future<void> Function(WorkOrderStatus nextStatus) onStatusSelected;

  @override
  Widget build(BuildContext context) {
    final currentStatus = workOrder.status;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StellarHeadline('Update status', size: StellarHeadlineSize.small),
        const SizedBox(height: 12),
        Text(
          'Select the next valid status. Blocked options stay visible so the workflow is clear.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF667085),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 16),
        StellarDropdownField<WorkOrderStatus>(
          fieldKey: const ValueKey('work-order-status-dropdown'),
          value: currentStatus,
          options: WorkOrderStatus.values
              .map(
                (status) => StellarDropdownOption<WorkOrderStatus>(
                  value: status,
                  label: _statusLabel(status),
                  enabled:
                      status == currentStatus ||
                      currentStatus.canTransitionTo(status),
                ),
              )
              .toList(),
          onChanged: (nextStatus) async {
            if (nextStatus == null || nextStatus == currentStatus) {
              return;
            }

            final confirmed = await showWorkOrderStatusConfirmationDialog(
              context,
              workOrderId: workOrder.id,
              workOrderTitle: workOrder.title,
              currentStatus: currentStatus,
              nextStatus: nextStatus,
            );

            if (!context.mounted || !confirmed) {
              return;
            }

            await onStatusSelected(nextStatus);
          },
        ),
      ],
    );
  }
}

String _statusLabel(WorkOrderStatus status) {
  switch (status) {
    case WorkOrderStatus.pending:
      return 'Pending';
    case WorkOrderStatus.inProgress:
      return 'In Progress';
    case WorkOrderStatus.completed:
      return 'Completed';
  }
}
