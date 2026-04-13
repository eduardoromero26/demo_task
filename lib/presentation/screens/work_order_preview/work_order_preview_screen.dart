import 'dart:io';

import 'package:demo_task/core/theme/app_theme.dart';
import 'package:demo_task/core/widgets/component_library.dart';
import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:demo_task/presentation/bloc/work_orders_bloc.dart';
import 'package:demo_task/presentation/bloc/work_orders_event.dart';
import 'package:demo_task/presentation/bloc/work_orders_state.dart';
import 'package:demo_task/presentation/screens/home/widgets/home_formatters.dart';
import 'package:demo_task/presentation/screens/work_order_preview/widgets/work_order_status_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkOrderPreviewScreen extends StatelessWidget {
  const WorkOrderPreviewScreen({super.key, required this.workOrder});

  final WorkOrderModel workOrder;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkOrdersBloc, WorkOrdersState>(
      listenWhen: (previous, current) =>
          previous.feedbackMessage != current.feedbackMessage,
      listener: (context, state) {
        final message = state.feedbackMessage;
        if (message == null) {
          return;
        }

        showStellarSnackbar(context, message: message);
        context.read<WorkOrdersBloc>().add(const WorkOrdersFeedbackDismissed());
      },
      builder: (context, state) {
        final currentWorkOrder = _resolveCurrentWorkOrder(state, workOrder);
        final isUpdating = state.updatingIds.contains(currentWorkOrder.id);
        final isCapturing = state.capturingPhotoIds.contains(
          currentWorkOrder.id,
        );

        return Scaffold(
          appBar: AppBar(title: Text(currentWorkOrder.id.toUpperCase())),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StellarHeadline(
                    currentWorkOrder.title,
                    size: StellarHeadlineSize.large,
                    fontWeight: FontWeight.w800,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      StellarChip(
                        label: formatEnumName(
                          currentWorkOrder.status.name,
                        ).toUpperCase(),
                        backgroundColor: _statusBackground(
                          currentWorkOrder.status,
                        ),
                        foregroundColor: _statusForeground(
                          currentWorkOrder.status,
                        ),
                      ),
                      if (isUpdating || isCapturing)
                        const StellarChip(
                          label: 'SYNCING',
                          backgroundColor: Color(0xFFEAF7FB),
                          foregroundColor: Color(0xFF0F6D84),
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
                        if (currentWorkOrder.description != null &&
                            currentWorkOrder.description!
                                .trim()
                                .isNotEmpty) ...[
                          Text(
                            currentWorkOrder.description!,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: const Color(0xFF344054),
                                  height: 1.45,
                                ),
                          ),
                          const SizedBox(height: 18),
                        ],
                        StellarInfoRow(
                          icon: Icons.location_on_outlined,
                          text: currentWorkOrder.location,
                        ),
                        const SizedBox(height: 14),
                        StellarInfoRow(
                          icon: Icons.calendar_month_rounded,
                          text: formatDateLabel(currentWorkOrder.scheduledDate),
                        ),
                        if (hasExplicitTime(
                          currentWorkOrder.scheduledDate,
                        )) ...[
                          const SizedBox(height: 14),
                          StellarInfoRow(
                            icon: Icons.access_time_rounded,
                            text: formatTimeLabel(
                              currentWorkOrder.scheduledDate,
                            ),
                          ),
                        ],
                        if (currentWorkOrder.assignedTo != null &&
                            currentWorkOrder.assignedTo!.trim().isNotEmpty) ...[
                          const SizedBox(height: 14),
                          StellarInfoRow(
                            icon: Icons.person_outline_rounded,
                            text: currentWorkOrder.assignedTo!,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  StellarCard(
                    child: WorkOrderStatusDropdown(
                      workOrder: currentWorkOrder,
                      onStatusSelected: (nextStatus) async {
                        context.read<WorkOrdersBloc>().add(
                          WorkOrderStatusChangeRequested(
                            workOrderId: currentWorkOrder.id,
                            newStatus: nextStatus,
                          ),
                        );
                      },
                    ),
                  ),
                  if (currentWorkOrder.status == WorkOrderStatus.completed &&
                      currentWorkOrder.photoPaths.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    StellarCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const StellarHeadline(
                            'Completion photo',
                            size: StellarHeadlineSize.small,
                          ),
                          const SizedBox(height: 14),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: AspectRatio(
                              aspectRatio: 16 / 10,
                              child: Image.file(
                                File(currentWorkOrder.photoPaths.last),
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  return Container(
                                    color: const Color(0xFFEAF7FB),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.image_outlined,
                                      color: Color(0xFF6B7280),
                                      size: 32,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

WorkOrderModel _resolveCurrentWorkOrder(
  WorkOrdersState state,
  WorkOrderModel fallback,
) {
  for (final item in state.workOrders) {
    if (item.id == fallback.id) {
      return item;
    }
  }

  return fallback;
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
