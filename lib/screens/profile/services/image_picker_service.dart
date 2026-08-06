import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  static const int maxFileSizeBytes = 5 * 1024 * 1024; // 5 MB

  Future<File?> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (pickedFile == null) return null;

    final file = File(pickedFile.path);
    final size = await file.length();
    if (size > maxFileSizeBytes) {
      throw Exception('Selected image exceeds the 5MB size limit.');
    }
    return file;
  }

  Future<File?> takePhotoWithCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (pickedFile == null) return null;

    final file = File(pickedFile.path);
    final size = await file.length();
    if (size > maxFileSizeBytes) {
      throw Exception('Captured image exceeds the 5MB size limit.');
    }
    return file;
  }
}