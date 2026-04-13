import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:demo_task/domain/repositories/work_order_repository.dart';

class AdvanceWorkOrderStatus {
  const AdvanceWorkOrderStatus(this._repository);

  final WorkOrderRepository _repository;

  Future<WorkOrderModel> call({
    required WorkOrderModel workOrder,
    required WorkOrderStatus newStatus,
  }) {
    if (!workOrder.status.canTransitionTo(newStatus)) {
      throw StateError(
        'Cannot move ${workOrder.title} from '
        '${workOrder.status.name} to ${newStatus.name}.',
      );
    }

    return _repository.updateWorkOrderStatus(
      workOrderId: workOrder.id,
      newStatus: newStatus,
    );
  }
}
