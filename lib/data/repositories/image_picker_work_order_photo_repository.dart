import 'package:demo_task/data/services/device_camera_photo_service.dart';
import 'package:demo_task/domain/repositories/work_order_photo_repository.dart';

class ImagePickerWorkOrderPhotoRepository implements WorkOrderPhotoRepository {
  ImagePickerWorkOrderPhotoRepository(this._cameraPhotoService);

  final DeviceCameraPhotoService _cameraPhotoService;

  @override
  Future<String?> capturePhoto() {
    return _cameraPhotoService.capturePhotoPath();
  }
}
