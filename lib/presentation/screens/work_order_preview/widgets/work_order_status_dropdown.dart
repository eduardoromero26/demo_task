import 'package:demo_task/core/theme/app_theme.dart';
import 'package:demo_task/core/widgets/component_library.dart';
import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:flutter/material.dart';

class WorkOrderStatusDropdown extends StatelessWidget {
  const WorkOrderStatusDropdown({
    super.key,
    required this.currentStatus,
    required this.onStatusSelected,
  });

  final WorkOrderStatus currentStatus;
  final ValueChanged<WorkOrderStatus> onStatusSelected;

  @override
  Widget build(BuildContext context) {
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
        DropdownButtonFormField<WorkOrderStatus>(
          key: const ValueKey('work-order-status-dropdown'),
          value: currentStatus,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppTheme.secondary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.primary, width: 1.4),
            ),
          ),
          items: WorkOrderStatus.values.map((status) {
            final isEnabled =
                status == currentStatus ||
                currentStatus.canTransitionTo(status);

            return DropdownMenuItem<WorkOrderStatus>(
              value: status,
              enabled: isEnabled,
              child: Opacity(
                opacity: isEnabled ? 1 : 0.45,
                child: Text(
                  isEnabled
                      ? _statusLabel(status)
                      : '${_statusLabel(status)} (Locked)',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (nextStatus) {
            if (nextStatus == null || nextStatus == currentStatus) {
              return;
            }

            onStatusSelected(nextStatus);
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
