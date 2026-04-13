import 'package:demo_task/domain/repositories/work_order_photo_repository.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWorkOrderPhotoRepository implements WorkOrderPhotoRepository {
  ImagePickerWorkOrderPhotoRepository({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  @override
  Future<String?> capturePhoto() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    return image?.path;
  }
}
