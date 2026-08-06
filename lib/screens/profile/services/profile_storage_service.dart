import '../models/editable_profile_model.dart';

class ProfileStorageService {
  Future<EditableProfileModel> fetchProfile() async {
    // Simulate network latency / local disk fetch
    await Future.delayed(const Duration(milliseconds: 600));
    return EditableProfileModel.initial();
  }

  Future<bool> saveProfile(EditableProfileModel profile) async {
    // Simulate API persistence
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }
}