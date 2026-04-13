import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:equatable/equatable.dart';

sealed class WorkOrdersEvent extends Equatable {
  const WorkOrdersEvent();

  @override
  List<Object?> get props => const [];
}

class WorkOrdersStarted extends WorkOrdersEvent {
  const WorkOrdersStarted({this.forceRefresh = false});

  final bool forceRefresh;

  @override
  List<Object?> get props => [forceRefresh];
}

class WorkOrdersNextPageRequested extends WorkOrdersEvent {
  const WorkOrdersNextPageRequested();
}

class WorkOrdersRetryNextPageRequested extends WorkOrdersEvent {
  const WorkOrdersRetryNextPageRequested();
}

class WorkOrdersFilterChanged extends WorkOrdersEvent {
  const WorkOrdersFilterChanged(this.filter);

  final WorkOrderStatus? filter;

  @override
  List<Object?> get props => [filter];
}

class WorkOrderStatusChangeRequested extends WorkOrdersEvent {
  const WorkOrderStatusChangeRequested({
    required this.workOrderId,
    required this.newStatus,
  });

  final String workOrderId;
  final WorkOrderStatus newStatus;

  @override
  List<Object?> get props => [workOrderId, newStatus];
}

class WorkOrdersFeedbackDismissed extends WorkOrdersEvent {
  const WorkOrdersFeedbackDismissed();
}
