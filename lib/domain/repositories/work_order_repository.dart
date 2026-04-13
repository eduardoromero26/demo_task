import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:demo_task/domain/model/work_order_page.dart';

abstract class WorkOrderRepository {
  Future<WorkOrderPage> fetchWorkOrders({required int page});

  Future<WorkOrderModel> updateWorkOrderStatus({
    required String workOrderId,
    required WorkOrderStatus newStatus,
  });
}
