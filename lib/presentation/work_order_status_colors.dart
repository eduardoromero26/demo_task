import 'package:demo_task/core/theme/app_theme.dart';
import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:flutter/material.dart';

Color workOrderStatusBackground(WorkOrderStatus status) {
  switch (status) {
    case WorkOrderStatus.pending:
      return const Color(0xFFFFE7C7);
    case WorkOrderStatus.completed:
      return AppTheme.primaryTint;
    case WorkOrderStatus.inProgress:
      return const Color(0xFFD9F6FD);
  }
}

Color workOrderStatusForeground(WorkOrderStatus status) {
  switch (status) {
    case WorkOrderStatus.pending:
      return const Color(0xFF8A4300);
    case WorkOrderStatus.completed:
      return AppTheme.tertiary;
    case WorkOrderStatus.inProgress:
      return const Color(0xFF0F6D84);
  }
}
