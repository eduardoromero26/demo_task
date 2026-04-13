import 'package:bloc/bloc.dart';
import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:demo_task/domain/repositories/work_order_photo_repository.dart';
import 'package:demo_task/domain/repositories/work_order_repository.dart';
import 'package:demo_task/domain/usecases/advance_work_order_status.dart';
import 'package:demo_task/presentation/bloc/work_orders_event.dart';
import 'package:demo_task/presentation/bloc/work_orders_state.dart';

class WorkOrdersBloc extends Bloc<WorkOrdersEvent, WorkOrdersState> {
  WorkOrdersBloc({
    required WorkOrderRepository workOrderRepository,
    required WorkOrderPhotoRepository workOrderPhotoRepository,
    required AdvanceWorkOrderStatus advanceWorkOrderStatus,
  }) : _workOrderRepository = workOrderRepository,
       _workOrderPhotoRepository = workOrderPhotoRepository,
       _advanceWorkOrderStatus = advanceWorkOrderStatus,
       super(const WorkOrdersState()) {
    on<WorkOrdersStarted>(_onStarted);
    on<WorkOrdersFilterChanged>(_onFilterChanged);
    on<WorkOrderPhotoCaptureRequested>(_onPhotoCaptureRequested);
    on<WorkOrderStatusChangeRequested>(_onStatusChangeRequested);
    on<WorkOrdersFeedbackDismissed>(_onFeedbackDismissed);
  }

  final WorkOrderRepository _workOrderRepository;
  final WorkOrderPhotoRepository _workOrderPhotoRepository;
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
        initialErrorMessage: null,
        feedbackMessage: null,
        updatingIds: const <String>[],
        capturingPhotoIds: const <String>[],
      ),
    );

    try {
      final workOrders = await _workOrderRepository.fetchWorkOrders();
      emit(
        state.copyWith(
          status: WorkOrdersLoadStatus.success,
          workOrders: workOrders,
          initialErrorMessage: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: WorkOrdersLoadStatus.failure,
          workOrders: const <WorkOrderModel>[],
          initialErrorMessage: 'Unable to load work orders. Please retry.',
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

  Future<void> _onPhotoCaptureRequested(
    WorkOrderPhotoCaptureRequested event,
    Emitter<WorkOrdersState> emit,
  ) async {
    if (state.capturingPhotoIds.contains(event.workOrderId)) {
      return;
    }

    emit(
      state.copyWith(
        capturingPhotoIds: [...state.capturingPhotoIds, event.workOrderId],
      ),
    );

    try {
      final photoPath = await _workOrderPhotoRepository.capturePhoto();

      if (photoPath == null) {
        emit(
          state.copyWith(
            capturingPhotoIds: state.capturingPhotoIds
                .where((id) => id != event.workOrderId)
                .toList(),
          ),
        );
        return;
      }

      final updated = await _workOrderRepository.attachPhotoToWorkOrder(
        workOrderId: event.workOrderId,
        photoPath: photoPath,
      );

      final updatedWorkOrders = state.workOrders
          .map((item) => item.id == updated.id ? updated : item)
          .toList();

      emit(
        state.copyWith(
          workOrders: updatedWorkOrders,
          capturingPhotoIds: state.capturingPhotoIds
              .where((id) => id != event.workOrderId)
              .toList(),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          capturingPhotoIds: state.capturingPhotoIds
              .where((id) => id != event.workOrderId)
              .toList(),
          feedbackMessage: 'Unable to attach a photo right now.',
        ),
      );
    }
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
          feedbackMessage:
              '${updated.title} updated to ${_statusLabel(updated.status)}.',
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

String _statusLabel(WorkOrderStatus status) {
  switch (status) {
    case WorkOrderStatus.pending:
      return 'Pending';
    case WorkOrderStatus.inProgress:
      return 'In Progress';
    case WorkOrderStatus.completed:
      return 'Completed';
  }
}
