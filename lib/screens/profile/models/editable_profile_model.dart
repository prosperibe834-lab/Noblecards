class EditableProfileModel {
  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String country;
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
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    this.photoPath,
  });

  factory EditableProfileModel.initial() {
    return const EditableProfileModel(
      fullName: 'Prosper Ibe',
      username: 'prosperibe',
      email: 'prosperibe@gmail.com',
      phone: '+234 810 234 5678',
      country: 'Nigeria',
      dateOfBirth: '12 July 2001',
      gender: 'Male',
      address: 'Lagos, Nigeria',
      photoPath: null,
    );
  }

  EditableProfileModel copyWith({
    String? fullName,
    String? username,
    String? email,
    String? phone,
    String? country,
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
      fullName: map['fullName'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      country: map['country'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      gender: map['gender'] ?? '',
      address: map['address'] ?? '',
      photoPath: map['photoPath'],
    );
  }
}