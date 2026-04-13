import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:equatable/equatable.dart';

enum WorkOrdersLoadStatus { initial, loading, success, failure }

const _unset = Object();

class WorkOrdersState extends Equatable {
  const WorkOrdersState({
    this.status = WorkOrdersLoadStatus.initial,
    this.workOrders = const <WorkOrderModel>[],
    this.selectedFilter,
    this.initialErrorMessage,
    this.feedbackMessage,
    this.updatingIds = const <String>[],
    this.capturingPhotoIds = const <String>[],
  });

  final WorkOrdersLoadStatus status;
  final List<WorkOrderModel> workOrders;
  final WorkOrderStatus? selectedFilter;
  final String? initialErrorMessage;
  final String? feedbackMessage;
  final List<String> updatingIds;
  final List<String> capturingPhotoIds;

  List<WorkOrderModel> get visibleWorkOrders {
    final filter = selectedFilter;
    if (filter == null) {
      return workOrders;
    }

    return workOrders.where((item) => item.status == filter).toList();
  }

  WorkOrdersState copyWith({
    WorkOrdersLoadStatus? status,
    List<WorkOrderModel>? workOrders,
    Object? selectedFilter = _unset,
    Object? initialErrorMessage = _unset,
    Object? feedbackMessage = _unset,
    List<String>? updatingIds,
    List<String>? capturingPhotoIds,
  }) {
    return WorkOrdersState(
      status: status ?? this.status,
      workOrders: workOrders ?? this.workOrders,
      selectedFilter: selectedFilter == _unset
          ? this.selectedFilter
          : selectedFilter as WorkOrderStatus?,
      initialErrorMessage: initialErrorMessage == _unset
          ? this.initialErrorMessage
          : initialErrorMessage as String?,
      feedbackMessage: feedbackMessage == _unset
          ? this.feedbackMessage
          : feedbackMessage as String?,
      updatingIds: updatingIds ?? this.updatingIds,
      capturingPhotoIds: capturingPhotoIds ?? this.capturingPhotoIds,
    );
  }

  @override
  List<Object?> get props => [
    status,
    workOrders,
    selectedFilter,
    initialErrorMessage,
    feedbackMessage,
    updatingIds,
    capturingPhotoIds,
  ];
}
