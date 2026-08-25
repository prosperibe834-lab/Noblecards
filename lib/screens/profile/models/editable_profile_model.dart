import '../../authentication/services/authentication_service.dart';

class EditableProfileModel {
  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String country;
  final String countryCode;
  final String dateOfBirth;
  final String gender;
  final String address;
  final String? photoPath;

  const EditableProfileModel({
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    required this.country,
    required this.countryCode,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    this.photoPath,
  });

  factory EditableProfileModel.initial() {
    return const EditableProfileModel(
      fullName: '',
      username: '',
      email: '',
      phone: '',
      country: '',
      countryCode: '',
      dateOfBirth: '',
      gender: '',
      address: '',
      photoPath: null,
    );
  }

  Map<String, dynamic> toApiMap() => {
        'firstName': fullName.split(' ').first,
        'lastName': fullName.split(' ').skip(1).join(' '),
        'username': username,
        'email': email,
        'phone': phone,
        'country': country,
        'countryCode': countryCode.isEmpty ? null : countryCode,
        'gender': gender,
        'dateOfBirth': dateOfBirth.isEmpty ? null : dateOfBirth,
        'address': address,
      };

  EditableProfileModel copyWith({
    String? fullName,
    String? username,
    String? email,
    String? phone,
    String? country,
    String? countryCode,
    String? dateOfBirth,
    String? gender,
    String? address,
    String? photoPath,
  }) {
    return EditableProfileModel(
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'username': username,
      'email': email,
      'phone': phone,
      'country': country,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'address': address,
      'photoPath': photoPath,
    };
  }

  factory EditableProfileModel.fromMap(Map<String, dynamic> map) {
    return EditableProfileModel(
      fullName: map['fullName'] ?? [map['firstName'], map['lastName']].where((value) => value != null && value.toString().isNotEmpty).join(' '),
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      country: map['country'] ?? '',
      countryCode: map['countryCode'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      gender: map['gender'] ?? '',
      address: map['address'] ?? '',
      photoPath: _imageUrl(map['photoPath'] ?? map['profileImageUrl']),
    );
  }

  static String? _imageUrl(Object? value) {
    if (value == null || value.toString().isEmpty) return null;
    final path = value.toString();
    return path.startsWith('/') ? '${AuthenticationService.apiBaseUrl}$path' : path;
  }
}