import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noble_cards/screens/profile/models/editable_profile_model.dart';
import 'package:noble_cards/screens/profile/providers/edit_profile_provider.dart';
import 'package:noble_cards/screens/profile/services/image_picker_service.dart';
import 'package:noble_cards/screens/profile/services/profile_storage_service.dart';
import 'package:noble_cards/screens/profile/widgets/profile_photo_picker.dart';

class _FakeProfileStorageService extends ProfileStorageService {
  _FakeProfileStorageService(this.profile);

  EditableProfileModel profile;
  String? uploadedPhotoPath;
  bool failUpload = false;
  bool failRemove = false;
  int uploadCount = 0;
  int removeCount = 0;

  @override
  Future<EditableProfileModel> fetchProfile() async => profile;

  @override
  Future<EditableProfileModel> saveProfile(
    EditableProfileModel editedProfile, {
    XFile? image,
    bool removeImage = false,
  }) async {
    if (image != null) {
      uploadCount++;
      if (failUpload) throw Exception('Profile image upload failed.');
      profile = editedProfile.copyWith(photoPath: uploadedPhotoPath);
      return profile;
    }
    if (removeImage) {
      removeCount++;
      if (failRemove) throw Exception('Profile image removal failed.');
      profile = EditableProfileModel.fromMap({
        ...editedProfile.toMap(),
        'photoPath': null,
      });
      return profile;
    }
    profile = editedProfile;
    return profile;
  }
}

void main() {
  final initialProfile = EditableProfileModel(
    fullName: 'Test User',
    username: 'testuser',
    email: 'test@example.com',
    phone: '+1234567890',
    country: 'Testland',
    dateOfBirth: '',
    gender: '',
    address: '',
    photoPath: 'http://localhost:3000/uploads/profile/old.jpg',
  );

  test(
    'selection marks changes dirty and upload waits for Save Changes',
    () async {
      final storage = _FakeProfileStorageService(initialProfile)
        ..uploadedPhotoPath = 'http://localhost:3000/uploads/profile/new.jpg';
      final provider = EditProfileProvider(
        storageService: storage,
        imagePickerService: ImagePickerService(
          pickImage: (source, {required imageQuality}) async => XFile.fromData(
            Uint8List.fromList([1, 2, 3]),
            path: 'new.jpg',
            mimeType: 'image/jpeg',
          ),
        ),
      );
      addTearDown(provider.dispose);

      await provider.loadProfileData();
      await expectLater(provider.pickImageFromGallery(), completion(isTrue));

      expect(storage.uploadCount, 0);
      expect(provider.selectedImageBytes, isNotNull);
      expect(provider.hasChanges, isTrue);

      await expectLater(provider.saveChanges(), completion(isTrue));

      expect(storage.uploadCount, 1);
      expect(provider.profile.photoPath, storage.uploadedPhotoPath);
      expect(provider.selectedImageBytes, isNull);
      expect(provider.hasChanges, isFalse);
    },
  );

  test(
    'remove is staged and DELETE happens when Save Changes is pressed',
    () async {
      final storage = _FakeProfileStorageService(initialProfile);
      final provider = EditProfileProvider(storageService: storage);
      addTearDown(provider.dispose);

      await provider.loadProfileData();
      await expectLater(provider.removePhoto(), completion(isTrue));

      expect(storage.removeCount, 0);
      expect(provider.profile.photoPath, isEmpty);
      expect(provider.hasChanges, isTrue);

      await expectLater(provider.saveChanges(), completion(isTrue));

      expect(storage.removeCount, 1);
      expect(provider.profile.photoPath, isNull);
      expect(provider.hasChanges, isFalse);
    },
  );

  test('failed removal preserves the previously saved photo', () async {
    final storage = _FakeProfileStorageService(initialProfile)
      ..failRemove = true;
    final provider = EditProfileProvider(storageService: storage);
    addTearDown(provider.dispose);

    await provider.loadProfileData();
    await expectLater(provider.removePhoto(), completion(isTrue));
    expect(provider.profile.photoPath, isEmpty);

    await expectLater(provider.saveChanges(), completion(isFalse));

    expect(storage.removeCount, 1);
    expect(storage.profile.photoPath, initialProfile.photoPath);
    expect(provider.profile.photoPath, initialProfile.photoPath);
    expect(provider.errorMessage, 'Profile image removal failed.');
    expect(provider.hasChanges, isFalse);
  });

  test('failed save preserves the selected image for retry', () async {
    final storage = _FakeProfileStorageService(initialProfile)
      ..failUpload = true;
    final provider = EditProfileProvider(
      storageService: storage,
      imagePickerService: ImagePickerService(
        pickImage: (source, {required imageQuality}) async => XFile.fromData(
          Uint8List.fromList([1, 2, 3]),
          path: 'new.jpg',
          mimeType: 'image/jpeg',
        ),
      ),
    );
    addTearDown(provider.dispose);

    await provider.loadProfileData();
    await expectLater(provider.takePhotoWithCamera(), completion(isTrue));
    await expectLater(provider.saveChanges(), completion(isFalse));

    expect(provider.profile.photoPath, initialProfile.photoPath);
    expect(storage.profile.photoPath, initialProfile.photoPath);
    expect(provider.errorMessage, 'Profile image upload failed.');
    expect(provider.selectedImageBytes, isNull);
    expect(provider.hasChanges, isTrue);
  });

  testWidgets(
    'profile photo displays the saved image and falls back locally on failure',
    (tester) async {
      const imageUrl = 'http://localhost:3000/uploads/profile/saved-image.png';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfilePhotoPicker(photoPath: imageUrl, onTap: () {}),
          ),
        ),
      );

      BoxDecoration avatarDecoration() => tester
          .widgetList<Container>(find.byType(Container))
          .map((container) => container.decoration)
          .whereType<BoxDecoration>()
          .firstWhere(
            (decoration) =>
                decoration.shape == BoxShape.circle && decoration.image != null,
          );

      var decorationImage = avatarDecoration().image!;
      final displayedImage = decorationImage.image;
      expect(displayedImage, isA<NetworkImage>());
      expect((displayedImage as NetworkImage).url, imageUrl);
      expect(decorationImage.fit, BoxFit.cover);

      decorationImage.onError!(
        Exception('image unavailable'),
        StackTrace.current,
      );
      await tester.pump();
      expect(
        tester.widgetList<Container>(find.byType(Container)).where((container) {
          final decoration = container.decoration;
          return decoration is BoxDecoration && decoration.image != null;
        }),
        isEmpty,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfilePhotoPicker(photoPath: null, onTap: () {}),
          ),
        ),
      );
      expect(
        tester.widgetList<Container>(find.byType(Container)).where((container) {
          final decoration = container.decoration;
          return decoration is BoxDecoration && decoration.image != null;
        }),
        isEmpty,
      );
    },
  );

  test('camera permission failure does not fall back to the gallery', () async {
    final attemptedSources = <ImageSource>[];
    final provider = EditProfileProvider(
      storageService: _FakeProfileStorageService(initialProfile),
      imagePickerService: ImagePickerService(
        pickImage: (source, {required imageQuality}) async {
          attemptedSources.add(source);
          throw Exception('camera_access_denied');
        },
      ),
    );
    addTearDown(provider.dispose);

    await provider.loadProfileData();
    await expectLater(provider.takePhotoWithCamera(), completion(isFalse));

    expect(attemptedSources, [ImageSource.camera]);
    expect(
      provider.errorMessage,
      'Camera permission was denied. Please allow camera access to continue.',
    );
  });
}
