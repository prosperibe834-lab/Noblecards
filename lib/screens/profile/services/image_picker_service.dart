import 'package:image_picker/image_picker.dart';

typedef ImagePickOverride = Future<XFile?> Function(
  ImageSource source, {
  required int imageQuality,
});

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  final ImagePickOverride? _pickImageOverride;

  ImagePickerService({ImagePickOverride? pickImage})
    : _pickImageOverride = pickImage;

  static const int maxFileSizeBytes = 5 * 1024 * 1024; // 5 MB

  Future<XFile?> pickImageFromGallery() async {
    final pickedFile = await _pickImage(ImageSource.gallery);
    if (pickedFile == null) return null;
    return _validate(pickedFile);
  }

  Future<XFile?> takePhotoWithCamera() async {
    final pickedFile = await _pickImage(ImageSource.camera);
    if (pickedFile == null) return null;
    return _validate(pickedFile);
  }

  Future<XFile?> _pickImage(ImageSource source) {
    final override = _pickImageOverride;
    if (override != null) {
      return override(source, imageQuality: 85);
    }
    return _picker.pickImage(source: source, imageQuality: 85);
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