import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:equatable/equatable.dart';

enum WorkOrdersLoadStatus { initial, loading, success, failure }

const _unset = Object();

class WorkOrdersState extends Equatable {
  const WorkOrdersState({
    this.status = WorkOrdersLoadStatus.initial,
    this.workOrders = const <WorkOrderModel>[],
    this.nextPage = 1,
    this.hasReachedEnd = false,
    this.isLoadingMore = false,
    this.selectedFilter,
    this.initialErrorMessage,
    this.paginationErrorMessage,
    this.feedbackMessage,
    this.updatingIds = const <String>[],
    this.capturingPhotoIds = const <String>[],
  });

  final WorkOrdersLoadStatus status;
  final List<WorkOrderModel> workOrders;
  final int nextPage;
  final bool hasReachedEnd;
  final bool isLoadingMore;
  final WorkOrderStatus? selectedFilter;
  final String? initialErrorMessage;
  final String? paginationErrorMessage;
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
    int? nextPage,
    bool? hasReachedEnd,
    bool? isLoadingMore,
    Object? selectedFilter = _unset,
    Object? initialErrorMessage = _unset,
    Object? paginationErrorMessage = _unset,
    Object? feedbackMessage = _unset,
    List<String>? updatingIds,
    List<String>? capturingPhotoIds,
  }) {
    return WorkOrdersState(
      status: status ?? this.status,
      workOrders: workOrders ?? this.workOrders,
      nextPage: nextPage ?? this.nextPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      selectedFilter: selectedFilter == _unset
          ? this.selectedFilter
          : selectedFilter as WorkOrderStatus?,
      initialErrorMessage: initialErrorMessage == _unset
          ? this.initialErrorMessage
          : initialErrorMessage as String?,
      paginationErrorMessage: paginationErrorMessage == _unset
          ? this.paginationErrorMessage
          : paginationErrorMessage as String?,
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
    nextPage,
    hasReachedEnd,
    isLoadingMore,
    selectedFilter,
    initialErrorMessage,
    paginationErrorMessage,
    feedbackMessage,
    updatingIds,
    capturingPhotoIds,
  ];
}
