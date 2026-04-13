import 'package:demo_task/domain/repositories/work_order_photo_repository.dart';

class CaptureWorkOrderPhoto {
  const CaptureWorkOrderPhoto(this._repository);

  final WorkOrderPhotoRepository _repository;

  Future<String?> call() {
    return _repository.capturePhoto();
  }
}
