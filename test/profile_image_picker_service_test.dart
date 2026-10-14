import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noble_cards/screens/profile/services/image_picker_service.dart';

void main() {
  test('preserves the original dimensions and bytes of a high-resolution image', () async {
    const width = 1600;
    const height = 1200;
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    for (var x = 0; x < width; x += 8) {
      canvas.drawRect(
        ui.Rect.fromLTWH(x.toDouble(), 0, 4, height.toDouble()),
        ui.Paint()..color = x.isEven ? const ui.Color(0xFF000000) : const ui.Color(0xFFFFFFFF),
      );
    }
    final image = await recorder.endRecording().toImage(width, height);
    final imageData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    final originalBytes = imageData!.buffer.asUint8List(
      imageData.offsetInBytes,
      imageData.lengthInBytes,
    );
    int? requestedQuality = 85;
    final pickedImage = XFile.fromData(
      originalBytes,
      path: 'high-resolution.png',
      mimeType: 'image/png',
    );
    final service = ImagePickerService(
      pickImage: (source, {required imageQuality}) async {
        requestedQuality = imageQuality;
        return pickedImage;
      },
    );

    final selectedImage = await service.pickImageFromGallery();
    final codec = await ui.instantiateImageCodec(await selectedImage!.readAsBytes());
    final frame = await codec.getNextFrame();

    expect(requestedQuality, isNull);
    expect(await selectedImage.readAsBytes(), originalBytes);
    expect(frame.image.width, width);
    expect(frame.image.height, height);
    frame.image.dispose();
    codec.dispose();
  });

  test('Take Photo preserves the original image without picker re-encoding', () async {
    ImageSource? selectedSource;
    int? selectedQuality = 85;
    final bytes = Uint8List.fromList([1, 2, 3]);
    final pickedImage = XFile.fromData(bytes, path: 'photo.jpg', mimeType: 'image/jpeg');
    final service = ImagePickerService(
      pickImage: (source, {required imageQuality}) async {
        selectedSource = source;
        selectedQuality = imageQuality;
        return pickedImage;
      },
    );

    final selectedImage = await service.takePhotoWithCamera();

    expect(selectedSource, ImageSource.camera);
    expect(selectedQuality, isNull);
    expect(selectedImage, same(pickedImage));
    expect(await selectedImage!.readAsBytes(), bytes);
  });

  test('Choose from Gallery preserves the original image without picker re-encoding', () async {
    ImageSource? selectedSource;
    int? selectedQuality = 85;
    final pickedImage = XFile.fromData(
      Uint8List.fromList([1, 2, 3]),
      path: 'photo.webp',
      mimeType: 'image/webp',
    );
    final service = ImagePickerService(
      pickImage: (source, {required imageQuality}) async {
        selectedSource = source;
        selectedQuality = imageQuality;
        return pickedImage;
      },
    );

    final selectedImage = await service.pickImageFromGallery();

    expect(selectedSource, ImageSource.gallery);
    expect(selectedQuality, isNull);
    expect(selectedImage, same(pickedImage));
  });

  test('accepts JPG, PNG, and WEBP files within the existing size limit', () async {
    for (final image in [
      XFile.fromData(Uint8List.fromList([1]), path: 'photo.jpg', mimeType: 'image/jpeg'),
      XFile.fromData(Uint8List.fromList([1]), path: 'photo.png', mimeType: 'image/png'),
      XFile.fromData(Uint8List.fromList([1]), path: 'photo.webp', mimeType: 'image/webp'),
    ]) {
      final service = ImagePickerService(pickImage: (source, {required imageQuality}) async => image);
      expect(await service.pickImageFromGallery(), same(image));
    }
  });

  test('rejects unsupported types and files over 5 MB', () async {
    final unsupported = ImagePickerService(
      pickImage: (source, {required imageQuality}) async =>
          XFile.fromData(Uint8List.fromList([1]), path: 'photo.gif', mimeType: 'image/gif'),
    );
    await expectLater(
      unsupported.pickImageFromGallery(),
      throwsA(isA<Exception>()),
    );

    final oversized = ImagePickerService(
      pickImage: (source, {required imageQuality}) async => XFile.fromData(
        Uint8List(5 * 1024 * 1024 + 1),
        path: 'photo.png',
        mimeType: 'image/png',
      ),
    );
    await expectLater(
      oversized.pickImageFromGallery(),
      throwsA(isA<Exception>()),
    );
  });
}