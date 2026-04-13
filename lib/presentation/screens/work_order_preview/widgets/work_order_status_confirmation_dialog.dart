import 'package:demo_task/core/theme/app_theme.dart';
import 'package:demo_task/core/widgets/component_library.dart';
import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:demo_task/presentation/screens/home/widgets/home_formatters.dart';
import 'package:flutter/material.dart';

class WorkOrderStatusConfirmationDialog extends StatelessWidget {
  const WorkOrderStatusConfirmationDialog({
    super.key,
    required this.workOrderTitle,
    required this.currentStatus,
    required this.nextStatus,
  });

  final String workOrderTitle;
  final WorkOrderStatus currentStatus;
  final WorkOrderStatus nextStatus;

  @override
  Widget build(BuildContext context) {
    return StellarModal(
      title: _dialogTitle(currentStatus, nextStatus),
      description: _dialogBody(workOrderTitle, currentStatus, nextStatus),
      child: Row(
        children: [
          Expanded(
            child: StellarButton(
              label: 'Cancel',
              onPressed: () => Navigator.of(context).pop(false),
              variant: StellarButtonVariant.neutral,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StellarButton(
              label: _confirmLabel(nextStatus),
              onPressed: () => Navigator.of(context).pop(true),
              variant: nextStatus == WorkOrderStatus.completed
                  ? StellarButtonVariant.tonal
                  : StellarButtonVariant.primary,
              backgroundColor: nextStatus == WorkOrderStatus.completed
                  ? AppTheme.tertiary
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool> showWorkOrderStatusConfirmationDialog(
  BuildContext context, {
  required String workOrderTitle,
  required WorkOrderStatus currentStatus,
  required WorkOrderStatus nextStatus,
}) async {
  final confirmed = await showStellarModal<bool>(
    context,
    builder: (_) => WorkOrderStatusConfirmationDialog(
      workOrderTitle: workOrderTitle,
      currentStatus: currentStatus,
      nextStatus: nextStatus,
    ),
  );

  return confirmed ?? false;
}

String _dialogTitle(WorkOrderStatus currentStatus, WorkOrderStatus nextStatus) {
  if (nextStatus == WorkOrderStatus.inProgress) {
    return 'Start this work order?';
  }

  if (nextStatus == WorkOrderStatus.completed) {
    return 'Mark this work order as completed?';
  }

  return 'Confirm status change';
}

String _dialogBody(
  String workOrderTitle,
  WorkOrderStatus currentStatus,
  WorkOrderStatus nextStatus,
) {
  return 'You are about to move $workOrderTitle from '
      '${formatEnumName(currentStatus.name)} to '
      '${formatEnumName(nextStatus.name)}.';
}

String _confirmLabel(WorkOrderStatus status) {
  switch (status) {
    case WorkOrderStatus.pending:
      return 'Confirm';
    case WorkOrderStatus.inProgress:
      return 'Start';
    case WorkOrderStatus.completed:
      return 'Complete';
  }
}
