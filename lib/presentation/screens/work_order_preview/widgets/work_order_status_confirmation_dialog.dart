import 'dart:io';

import 'package:demo_task/core/theme/app_theme.dart';
import 'package:demo_task/core/widgets/component_library.dart';
import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:demo_task/presentation/bloc/work_orders_bloc.dart';
import 'package:demo_task/presentation/bloc/work_orders_event.dart';
import 'package:demo_task/presentation/bloc/work_orders_state.dart';
import 'package:demo_task/presentation/screens/home/widgets/home_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkOrderStatusConfirmationDialog extends StatelessWidget {
  const WorkOrderStatusConfirmationDialog({
    super.key,
    required this.workOrderId,
    required this.workOrderTitle,
    required this.currentStatus,
    required this.nextStatus,
  });

  final String workOrderId;
  final String workOrderTitle;
  final WorkOrderStatus currentStatus;
  final WorkOrderStatus nextStatus;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkOrdersBloc, WorkOrdersState>(
      builder: (context, state) {
        final workOrder = _findWorkOrder(state, workOrderId);
        final isCapturing = state.capturingPhotoIds.contains(workOrderId);
        final hasPhoto = workOrder?.photoPaths.isNotEmpty ?? false;
        final canConfirm =
            !isCapturing &&
            (nextStatus != WorkOrderStatus.completed || hasPhoto);
        final showsCompletionPhotoFlow =
            nextStatus == WorkOrderStatus.completed;

        return StellarModal(
          title: _dialogTitle(currentStatus, nextStatus),
          description: _dialogBody(workOrderTitle, currentStatus, nextStatus),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showsCompletionPhotoFlow) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4FBFD),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFD0EDF7)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Completion requires at least one photo.',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: const Color(0xFF0F1728),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        hasPhoto
                            ? '${workOrder!.photoPaths.length} ${workOrder.photoPaths.length == 1 ? 'photo attached' : 'photos attached'}.'
                            : 'Add a photo from the device camera before completing this work order.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF667085),
                          height: 1.45,
                        ),
                      ),
                      if (hasPhoto) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.file(
                              File(workOrder!.photoPaths.last),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) {
                                return Container(
                                  color: const Color(0xFFEAF7FB),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.image_outlined,
                                    color: Color(0xFF6B7280),
                                    size: 28,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Row(
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
                      label: _actionLabel(
                        nextStatus,
                        isCapturing: isCapturing,
                        hasPhoto: hasPhoto,
                      ),
                      onPressed: _actionHandler(
                        context,
                        nextStatus: nextStatus,
                        workOrderId: workOrderId,
                        isCapturing: isCapturing,
                        canConfirm: canConfirm,
                        hasPhoto: hasPhoto,
                      ),
                      variant: showsCompletionPhotoFlow && hasPhoto
                          ? StellarButtonVariant.tonal
                          : StellarButtonVariant.primary,
                      backgroundColor: showsCompletionPhotoFlow && hasPhoto
                          ? AppTheme.tertiary
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

VoidCallback? _actionHandler(
  BuildContext context, {
  required WorkOrderStatus nextStatus,
  required String workOrderId,
  required bool isCapturing,
  required bool canConfirm,
  required bool hasPhoto,
}) {
  if (nextStatus != WorkOrderStatus.completed) {
    return canConfirm ? () => Navigator.of(context).pop(true) : null;
  }

  if (isCapturing) {
    return null;
  }

  if (!hasPhoto) {
    return () {
      context.read<WorkOrdersBloc>().add(
        WorkOrderPhotoCaptureRequested(workOrderId: workOrderId),
      );
    };
  }

  return canConfirm ? () => Navigator.of(context).pop(true) : null;
}

String _actionLabel(
  WorkOrderStatus status, {
  required bool isCapturing,
  required bool hasPhoto,
}) {
  if (status != WorkOrderStatus.completed) {
    return _confirmLabel(status);
  }

  if (isCapturing) {
    return 'Opening Camera';
  }

  return hasPhoto ? 'Complete' : 'Take Photo';
}

Future<bool> showWorkOrderStatusConfirmationDialog(
  BuildContext context, {
  required String workOrderId,
  required String workOrderTitle,
  required WorkOrderStatus currentStatus,
  required WorkOrderStatus nextStatus,
}) async {
  final confirmed = await showStellarModal<bool>(
    context,
    builder: (_) => WorkOrderStatusConfirmationDialog(
      workOrderId: workOrderId,
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

WorkOrderModel? _findWorkOrder(WorkOrdersState state, String workOrderId) {
  for (final workOrder in state.workOrders) {
    if (workOrder.id == workOrderId) {
      return workOrder;
    }
  }

  return null;
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
