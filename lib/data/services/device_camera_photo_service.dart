import 'package:image_picker/image_picker.dart';

class DeviceCameraPhotoService {
  DeviceCameraPhotoService({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  Future<String?> capturePhotoPath() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    return image?.path;
  }
}
