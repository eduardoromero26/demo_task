import 'package:equatable/equatable.dart';

enum WorkOrderStatus { pending, inProgress, completed }

extension WorkOrderStatusX on WorkOrderStatus {
  List<WorkOrderStatus> get allowedTransitions {
    switch (this) {
      case WorkOrderStatus.pending:
        return const [WorkOrderStatus.inProgress];
      case WorkOrderStatus.inProgress:
        return const [WorkOrderStatus.completed];
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
    required this.location,
    required this.scheduledDate,
    this.description,
    this.assignedTo,
    this.photoPaths = const <String>[],
  });

  final String id;
  final String title;
  final String? description;
  final String location;
  final DateTime scheduledDate;
  final String? assignedTo;
  final WorkOrderStatus status;
  final List<String> photoPaths;

  WorkOrderModel copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    DateTime? scheduledDate,
    String? assignedTo,
    WorkOrderStatus? status,
    List<String>? photoPaths,
  }) {
    return WorkOrderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      assignedTo: assignedTo ?? this.assignedTo,
      status: status ?? this.status,
      photoPaths: photoPaths ?? this.photoPaths,
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
    photoPaths,
  ];
}
