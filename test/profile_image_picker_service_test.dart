import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noble_cards/screens/profile/services/image_picker_service.dart';

void main() {
  test('Take Photo uses the camera source', () async {
    ImageSource? selectedSource;
    int? selectedQuality;
    final service = ImagePickerService(
      pickImage: (source, {required imageQuality}) async {
        selectedSource = source;
        selectedQuality = imageQuality;
        return null;
      },
    );

    await service.takePhotoWithCamera();

    expect(selectedSource, ImageSource.camera);
    expect(selectedQuality, 85);
  });

  test('Choose from Gallery uses the gallery source', () async {
    ImageSource? selectedSource;
    int? selectedQuality;
    final service = ImagePickerService(
      pickImage: (source, {required imageQuality}) async {
        selectedSource = source;
        selectedQuality = imageQuality;
        return null;
      },
    );

    await service.pickImageFromGallery();

    expect(selectedSource, ImageSource.gallery);
    expect(selectedQuality, 85);
  });
}