import '../models/editable_profile_model.dart';
import '../../authentication/services/authentication_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfileStorageService {
  final AuthenticationService _auth = AuthenticationService();

  Future<EditableProfileModel> fetchProfile() async {
    final user = await _auth.getUserProfile(_auth.currentUser?.id ?? 'current');
    if (user == null) throw Exception('Profile could not be found.');
    return EditableProfileModel.fromMap(user);
  }

  Future<EditableProfileModel> saveProfile(EditableProfileModel profile, {XFile? image}) async {
    final result = await _auth.saveUserProfile(
      userId: _auth.currentUser?.id ?? 'current',
      profileData: profile.toApiMap(),
      image: image,
      removeImage: profile.photoPath == '',
    );
    return EditableProfileModel.fromMap(result);
  }
}