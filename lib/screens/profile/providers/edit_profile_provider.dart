import 'dart:io';
import 'package:flutter/material.dart';
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

  EditableProfileModel get profile => _currentProfile;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

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

  void updateCountry(String value) {
    _currentProfile = _currentProfile.copyWith(country: value);
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
      final File? image = await _imagePickerService.pickImageFromGallery();
      if (image != null) {
        _currentProfile = _currentProfile.copyWith(photoPath: image.path);
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
    return false;
  }

  Future<bool> takePhotoWithCamera() async {
    try {
      final File? image = await _imagePickerService.takePhotoWithCamera();
      if (image != null) {
        _currentProfile = _currentProfile.copyWith(photoPath: image.path);
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
    return false;
  }

  void removePhoto() {
    _currentProfile = _currentProfile.copyWith(photoPath: '');
    notifyListeners();
  }

  void resetChanges() {
    _currentProfile = _initialProfile;
    notifyListeners();
  }

  Future<bool> saveChanges() async {
    if (!isFormValid) return false;

    _isSaving = true;
    notifyListeners();

    final success = await _storageService.saveProfile(_currentProfile);
    if (success) {
      _initialProfile = _currentProfile;
    }

    _isSaving = false;
    notifyListeners();
    return success;
  }
}