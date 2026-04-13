import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:demo_task/domain/repositories/work_order_repository.dart';

class AttachWorkOrderPhoto {
  const AttachWorkOrderPhoto(this._repository);

  final WorkOrderRepository _repository;

  Future<WorkOrderModel> call({
    required String workOrderId,
    required String photoPath,
  }) {
    return _repository.attachPhotoToWorkOrder(
      workOrderId: workOrderId,
      photoPath: photoPath,
    );
  }
}
