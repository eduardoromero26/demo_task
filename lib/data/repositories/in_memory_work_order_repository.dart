import 'package:demo_task/data/mocks/work_order_mocks.dart';
import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:demo_task/domain/repositories/work_order_repository.dart';

class InMemoryWorkOrderRepository implements WorkOrderRepository {
  InMemoryWorkOrderRepository({
    this.latency = const Duration(milliseconds: 2000),
    List<WorkOrderModel>? workOrders,
  }) : _workOrders = _cloneWorkOrders(workOrders ?? buildWorkOrderMocks());

  final Duration latency;
  final List<WorkOrderModel> _workOrders;

  @override
  Future<List<WorkOrderModel>> fetchWorkOrders() async {
    await Future<void>.delayed(latency);

    return _cloneWorkOrders(_workOrders);
  }

  @override
  Future<WorkOrderModel> attachPhotoToWorkOrder({
    required String workOrderId,
    required String photoPath,
  }) async {
    await Future<void>.delayed(latency);

    final index = _findWorkOrderIndex(workOrderId);

    final current = _workOrders[index];
    final updated = current.copyWith(
      photoPaths: [...current.photoPaths, photoPath],
    );
    _workOrders[index] = updated;
    return updated.copyWith();
  }

  @override
  Future<WorkOrderModel> updateWorkOrderStatus({
    required String workOrderId,
    required WorkOrderStatus newStatus,
  }) async {
    await Future<void>.delayed(latency);

    final index = _findWorkOrderIndex(workOrderId);

    final current = _workOrders[index];
    final shouldAssignCurrentUser =
        newStatus != WorkOrderStatus.pending &&
        (current.assignedTo == null || current.assignedTo!.trim().isEmpty);
    final updated = current.copyWith(
      status: newStatus,
      assignedTo: shouldAssignCurrentUser ? 'You' : current.assignedTo,
    );
    _workOrders[index] = updated;
    return updated.copyWith();
  }

  int _findWorkOrderIndex(String workOrderId) {
    final index = _workOrders.indexWhere((item) => item.id == workOrderId);
    if (index == -1) {
      throw StateError('Work order $workOrderId was not found.');
    }

    return index;
  }

  static List<WorkOrderModel> _cloneWorkOrders(
    List<WorkOrderModel> workOrders,
  ) {
    return workOrders.map((workOrder) => workOrder.copyWith()).toList();
  }
}
