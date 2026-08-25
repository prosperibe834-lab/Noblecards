import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../models/editable_profile_model.dart';
import '../services/image_picker_service.dart';
import '../services/profile_storage_service.dart';

class EditProfileProvider extends ChangeNotifier {
  final ProfileStorageService _storageService = ProfileStorageService();
  final ImagePickerService _imagePickerService = ImagePickerService();

  EditableProfileModel _initialProfile = EditableProfileModel.initial();
  EditableProfileModel _currentProfile = EditableProfileModel.initial();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;

  EditableProfileModel get profile => _currentProfile;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  Uint8List? get selectedImageBytes => _selectedImageBytes;

  bool get isFormValid {
    if (_currentProfile.fullName.trim().length < 2) return false;
    if (_currentProfile.username.trim().length < 3) return false;
    if (!_currentProfile.email.contains('@') || !_currentProfile.email.contains('.')) return false;
    if (_currentProfile.phone.trim().length < 7) return false;
    return true;
  }

  bool get hasChanges {
    return _currentProfile.fullName != _initialProfile.fullName ||
        _currentProfile.username != _initialProfile.username ||
        _currentProfile.email != _initialProfile.email ||
        _currentProfile.phone != _initialProfile.phone ||
        _currentProfile.country != _initialProfile.country ||
        _currentProfile.dateOfBirth != _initialProfile.dateOfBirth ||
        _currentProfile.gender != _initialProfile.gender ||
        _currentProfile.address != _initialProfile.address ||
        _currentProfile.photoPath != _initialProfile.photoPath;
  }

  Future<void> loadProfileData() async {
    _isLoading = true;
    _errorMessage = null;
    _selectedImage = null;
    _selectedImageBytes = null;
    notifyListeners();

    try {
      _initialProfile = await _storageService.fetchProfile();
      _currentProfile = _initialProfile;
    } catch (e) {
      _errorMessage = 'Failed to load profile data.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateFullName(String value) {
    _currentProfile = _currentProfile.copyWith(fullName: value);
    notifyListeners();
  }

  void updateUsername(String value) {
    _currentProfile = _currentProfile.copyWith(username: value);
    notifyListeners();
  }

  void updateEmail(String value) {
    _currentProfile = _currentProfile.copyWith(email: value);
    notifyListeners();
  }

  void updatePhone(String value) {
    _currentProfile = _currentProfile.copyWith(phone: value);
    notifyListeners();
  }

  void updateCountry(String value, {String? countryCode}) {
    _currentProfile = _currentProfile.copyWith(country: value, countryCode: countryCode);
    notifyListeners();
  }

  void updateDateOfBirth(String value) {
    _currentProfile = _currentProfile.copyWith(dateOfBirth: value);
    notifyListeners();
  }

  void updateGender(String value) {
    _currentProfile = _currentProfile.copyWith(gender: value);
    notifyListeners();
  }

  void updateAddress(String value) {
    _currentProfile = _currentProfile.copyWith(address: value);
    notifyListeners();
  }

  Future<bool> pickImageFromGallery() async {
    try {
      final image = await _imagePickerService.pickImageFromGallery();
      if (image != null) {
        _selectedImage = image;
        _selectedImageBytes = await image.readAsBytes();
        _currentProfile = _currentProfile.copyWith(photoPath: image.path);
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = _friendlyImageError(e);
      notifyListeners();
    }
    return false;
  }

  Future<bool> takePhotoWithCamera() async {
    try {
      final image = await _imagePickerService.takePhotoWithCamera();
      if (image != null) {
        _selectedImage = image;
        _selectedImageBytes = await image.readAsBytes();
        _currentProfile = _currentProfile.copyWith(photoPath: image.path);
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = _friendlyImageError(e);
      notifyListeners();
    }
    return false;
  }

  void removePhoto() {
    _selectedImage = null;
    _selectedImageBytes = null;
    _currentProfile = _currentProfile.copyWith(photoPath: '');
    notifyListeners();
  }

  void resetChanges() {
    _selectedImage = null;
    _selectedImageBytes = null;
    _currentProfile = _initialProfile;
    notifyListeners();
  }

  Future<bool> saveChanges() async {
    if (!isFormValid) return false;

    _isSaving = true;
    notifyListeners();

    try {
      _currentProfile = await _storageService.saveProfile(_currentProfile, image: _selectedImage);
      _selectedImage = null;
      _selectedImageBytes = null;
      _initialProfile = _currentProfile;
    } catch (e) {
      _errorMessage = 'Unable to save your profile photo. Please try again.';
      _isSaving = false;
      notifyListeners();
      return false;
    }

    _isSaving = false;
    notifyListeners();
    return true;
  }

  String _friendlyImageError(Object error) {
    final message = error.toString().toLowerCase();
    if (message.contains('cancel') || message.contains('pickedfile')) return '';
    if (message.contains('permission')) return 'Please allow photo access to continue.';
    if (message.contains('camera')) return 'The camera is unavailable on this device.';
    if (message.contains('unsupported operation') || message.contains('_namespace')) return 'Photo selection is unavailable on this device.';
    if (message.contains('5mb')) return 'Selected image exceeds the 5MB size limit.';
    if (message.contains('jpg') || message.contains('png') || message.contains('webp')) return 'Please select a JPG, PNG, or WEBP image.';
    return 'Unable to select that image. Please try again.';
  }
}