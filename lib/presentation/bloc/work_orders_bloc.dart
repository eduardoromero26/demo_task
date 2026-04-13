import 'package:bloc/bloc.dart';
import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:demo_task/domain/usecases/advance_work_order_status.dart';
import 'package:demo_task/domain/usecases/get_work_orders_page.dart';
import 'package:demo_task/presentation/bloc/work_orders_event.dart';
import 'package:demo_task/presentation/bloc/work_orders_state.dart';

class WorkOrdersBloc extends Bloc<WorkOrdersEvent, WorkOrdersState> {
  WorkOrdersBloc({
    required GetWorkOrdersPage getWorkOrdersPage,
    required AdvanceWorkOrderStatus advanceWorkOrderStatus,
  }) : _getWorkOrdersPage = getWorkOrdersPage,
       _advanceWorkOrderStatus = advanceWorkOrderStatus,
       super(const WorkOrdersState()) {
    on<WorkOrdersStarted>(_onStarted);
    on<WorkOrdersNextPageRequested>(_onNextPageRequested);
    on<WorkOrdersRetryNextPageRequested>(_onRetryNextPageRequested);
    on<WorkOrdersFilterChanged>(_onFilterChanged);
    on<WorkOrderStatusChangeRequested>(_onStatusChangeRequested);
    on<WorkOrdersFeedbackDismissed>(_onFeedbackDismissed);
  }

  final GetWorkOrdersPage _getWorkOrdersPage;
  final AdvanceWorkOrderStatus _advanceWorkOrderStatus;

  Future<void> _onStarted(
    WorkOrdersStarted event,
    Emitter<WorkOrdersState> emit,
  ) async {
    if (state.status == WorkOrdersLoadStatus.loading) {
      return;
    }

    emit(
      state.copyWith(
        status: WorkOrdersLoadStatus.loading,
        workOrders: event.forceRefresh
            ? const <WorkOrderModel>[]
            : state.workOrders,
        nextPage: 1,
        hasReachedEnd: false,
        initialErrorMessage: null,
        paginationErrorMessage: null,
        feedbackMessage: null,
        isLoadingMore: false,
        updatingIds: const <String>[],
      ),
    );

    try {
      final page = await _getWorkOrdersPage(page: 1);
      emit(
        state.copyWith(
          status: WorkOrdersLoadStatus.success,
          workOrders: page.items,
          nextPage: 2,
          hasReachedEnd: !page.hasMore,
          initialErrorMessage: null,
          paginationErrorMessage: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: WorkOrdersLoadStatus.failure,
          workOrders: const <WorkOrderModel>[],
          initialErrorMessage: 'Unable to load page 1. Please retry.',
        ),
      );
    }
  }

  Future<void> _onNextPageRequested(
    WorkOrdersNextPageRequested event,
    Emitter<WorkOrdersState> emit,
  ) async {
    await _loadNextPage(emit);
  }

  Future<void> _onRetryNextPageRequested(
    WorkOrdersRetryNextPageRequested event,
    Emitter<WorkOrdersState> emit,
  ) async {
    await _loadNextPage(emit);
  }

  Future<void> _loadNextPage(Emitter<WorkOrdersState> emit) async {
    if (state.status != WorkOrdersLoadStatus.success ||
        state.hasReachedEnd ||
        state.isLoadingMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, paginationErrorMessage: null));

    try {
      final page = await _getWorkOrdersPage(page: state.nextPage);
      emit(
        state.copyWith(
          isLoadingMore: false,
          workOrders: [...state.workOrders, ...page.items],
          nextPage: state.nextPage + 1,
          hasReachedEnd: !page.hasMore,
          paginationErrorMessage: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoadingMore: false,
          paginationErrorMessage:
              'Page ${state.nextPage} failed. Loaded items are preserved.',
        ),
      );
    }
  }

  void _onFilterChanged(
    WorkOrdersFilterChanged event,
    Emitter<WorkOrdersState> emit,
  ) {
    emit(state.copyWith(selectedFilter: event.filter));
  }

  Future<void> _onStatusChangeRequested(
    WorkOrderStatusChangeRequested event,
    Emitter<WorkOrdersState> emit,
  ) async {
    if (state.updatingIds.contains(event.workOrderId)) {
      return;
    }

    final workOrder = state.workOrders.firstWhere(
      (item) => item.id == event.workOrderId,
      orElse: () =>
          throw StateError('Work order ${event.workOrderId} not found.'),
    );

    emit(
      state.copyWith(
        updatingIds: [...state.updatingIds, event.workOrderId],
        feedbackMessage: null,
      ),
    );

    try {
      final updated = await _advanceWorkOrderStatus(
        workOrder: workOrder,
        newStatus: event.newStatus,
      );

      final updatedWorkOrders = state.workOrders
          .map((item) => item.id == updated.id ? updated : item)
          .toList();

      emit(
        state.copyWith(
          workOrders: updatedWorkOrders,
          updatingIds: state.updatingIds
              .where((id) => id != event.workOrderId)
              .toList(),
          feedbackMessage: '${updated.title} moved to ${updated.status.name}.',
        ),
      );
    } on StateError catch (error) {
      emit(
        state.copyWith(
          updatingIds: state.updatingIds
              .where((id) => id != event.workOrderId)
              .toList(),
          feedbackMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          updatingIds: state.updatingIds
              .where((id) => id != event.workOrderId)
              .toList(),
          feedbackMessage: 'Unable to update the work order right now.',
        ),
      );
    }
  }

  void _onFeedbackDismissed(
    WorkOrdersFeedbackDismissed event,
    Emitter<WorkOrdersState> emit,
  ) {
    emit(state.copyWith(feedbackMessage: null));
  }
}
