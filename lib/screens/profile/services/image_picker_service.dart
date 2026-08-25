import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  static const int maxFileSizeBytes = 5 * 1024 * 1024; // 5 MB

  Future<XFile?> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (pickedFile == null) return null;
    return _validate(pickedFile);
  }

  Future<XFile?> takePhotoWithCamera() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (pickedFile == null) return null;
    return _validate(pickedFile);
  }

  Future<XFile> _validate(XFile image) async {
    final extension = image.name.split('.').last.toLowerCase();
    final mimeType = image.mimeType?.toLowerCase();
    final validExtension = ['jpg', 'jpeg', 'png', 'webp'].contains(extension);
    final validMimeType = mimeType == null || ['image/jpeg', 'image/png', 'image/webp'].contains(mimeType);
    if (!validExtension || !validMimeType) {
      throw Exception('Please select a JPG, PNG, or WEBP image.');
    }
    if ((await image.length()) > maxFileSizeBytes) {
      throw Exception('Selected image exceeds the 5MB size limit.');
    }
    return image;
  }
}