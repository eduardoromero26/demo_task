import 'package:equatable/equatable.dart';

enum WorkOrderStatus { pending, scheduled, inProgress, blocked, completed }

enum WorkOrderPriority { low, medium, high }

extension WorkOrderStatusX on WorkOrderStatus {
  List<WorkOrderStatus> get allowedTransitions {
    switch (this) {
      case WorkOrderStatus.pending:
        return const [WorkOrderStatus.scheduled, WorkOrderStatus.blocked];
      case WorkOrderStatus.scheduled:
        return const [WorkOrderStatus.inProgress, WorkOrderStatus.blocked];
      case WorkOrderStatus.inProgress:
        return const [WorkOrderStatus.completed, WorkOrderStatus.blocked];
      case WorkOrderStatus.blocked:
        return const [WorkOrderStatus.scheduled, WorkOrderStatus.inProgress];
      case WorkOrderStatus.completed:
        return const [];
    }
  }

  bool canTransitionTo(WorkOrderStatus nextStatus) {
    return allowedTransitions.contains(nextStatus);
  }
}

class WorkOrderModel extends Equatable {
  const WorkOrderModel({
    required this.id,
    required this.title,
    required this.status,
    required this.priority,
    required this.location,
    required this.scheduledDate,
    this.description,
    this.assignedTo,
  });

  final String id;
  final String title;
  final String? description;
  final String location;
  final DateTime scheduledDate;
  final String? assignedTo;
  final WorkOrderStatus status;
  final WorkOrderPriority priority;

  WorkOrderModel copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    DateTime? scheduledDate,
    String? assignedTo,
    WorkOrderStatus? status,
    WorkOrderPriority? priority,
  }) {
    return WorkOrderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      assignedTo: assignedTo ?? this.assignedTo,
      status: status ?? this.status,
      priority: priority ?? this.priority,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    location,
    scheduledDate,
    assignedTo,
    status,
    priority,
  ];
}
