import '../../authentication/services/authentication_service.dart';
import 'package:intl/intl.dart';

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

  Map<String, dynamic> toApiMap() => {
        'firstName': fullName.split(' ').first,
        'lastName': fullName.split(' ').skip(1).join(' '),
        'username': username,
        'phone': phone,
        'country': country,
        'gender': gender,
        'dateOfBirth': dateOfBirth.isEmpty ? null : _dateOfBirthForApi(dateOfBirth),
        'address': address,
      };

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
      fullName: map['fullName'] ?? [map['firstName'], map['lastName']].where((value) => value != null && value.toString().isNotEmpty).join(' '),
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      country: map['country'] ?? '',
      dateOfBirth: _dateOfBirthForDisplay(map['dateOfBirth']),
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

  static String _dateOfBirthForApi(String value) {
    final date = _parseDateOfBirth(value);
    if (date == null) throw FormatException('Invalid date of birth.');
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String _dateOfBirthForDisplay(Object? value) {
    final text = value?.toString() ?? '';
    if (text.isEmpty) return '';
    final date = _parseDateOfBirth(text);
    return date == null ? text : DateFormat('d MMMM yyyy').format(date);
  }

  static DateTime? _parseDateOfBirth(String value) {
    final text = value.trim();
    final isoDate = RegExp(r'^(\d{4})-(\d{2})-(\d{2})(?:$|T)').firstMatch(text);
    if (isoDate != null) {
      final year = int.parse(isoDate.group(1)!);
      final month = int.parse(isoDate.group(2)!);
      final day = int.parse(isoDate.group(3)!);
      final date = DateTime.utc(year, month, day);
      if (date.year == year && date.month == month && date.day == day) return date;
      return null;
    }
    try {
      return DateFormat('d MMMM yyyy').parseStrict(text, true);
    } on FormatException {
      return null;
    }
  }
}