import 'package:demo_task/domain/model/work_order_model.dart';

abstract class WorkOrderRepository {
  Future<List<WorkOrderModel>> fetchWorkOrders();

  Future<WorkOrderModel> attachPhotoToWorkOrder({
    required String workOrderId,
    required String photoPath,
  });

  Future<WorkOrderModel> updateWorkOrderStatus({
    required String workOrderId,
    required WorkOrderStatus newStatus,
  });
}
