import 'package:demo_task/domain/model/work_order_page.dart';
import 'package:demo_task/domain/repositories/work_order_repository.dart';

class GetWorkOrdersPage {
  const GetWorkOrdersPage(this._repository);

  final WorkOrderRepository _repository;

  Future<WorkOrderPage> call({required int page}) {
    return _repository.fetchWorkOrders(page: page);
  }
}
