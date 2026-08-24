class BiometricSettingsModel {
  final bool isFaceIdAvailable;
  final bool isFingerprintAvailable;
  final bool isFaceIdEnabled;
  final bool isFingerprintEnabled;
  final bool isRememberDeviceEnabled;
  final bool isRequireForTransactionsEnabled;
  final String autoLockTime;

  const BiometricSettingsModel({
    required this.isFaceIdAvailable,
    required this.isFingerprintAvailable,
    required this.isFaceIdEnabled,
    required this.isFingerprintEnabled,
    required this.isRememberDeviceEnabled,
    required this.isRequireForTransactionsEnabled,
    required this.autoLockTime,
  });

  factory BiometricSettingsModel.initial() {
    return const BiometricSettingsModel(
      isFaceIdAvailable: false,
      isFingerprintAvailable: false,
      isFaceIdEnabled: false,
      isFingerprintEnabled: false,
      isRememberDeviceEnabled: false,
      isRequireForTransactionsEnabled: false,
      autoLockTime: '5 Minutes',
    );
  }

  BiometricSettingsModel copyWith({
    bool? isFaceIdAvailable,
    bool? isFingerprintAvailable,
    bool? isFaceIdEnabled,
    bool? isFingerprintEnabled,
    bool? isRememberDeviceEnabled,
    bool? isRequireForTransactionsEnabled,
    String? autoLockTime,
  }) {
    return BiometricSettingsModel(
      isFaceIdAvailable: isFaceIdAvailable ?? this.isFaceIdAvailable,
      isFingerprintAvailable: isFingerprintAvailable ?? this.isFingerprintAvailable,
      isFaceIdEnabled: isFaceIdEnabled ?? this.isFaceIdEnabled,
      isFingerprintEnabled: isFingerprintEnabled ?? this.isFingerprintEnabled,
      isRememberDeviceEnabled: isRememberDeviceEnabled ?? this.isRememberDeviceEnabled,
      isRequireForTransactionsEnabled:
          isRequireForTransactionsEnabled ?? this.isRequireForTransactionsEnabled,
      autoLockTime: autoLockTime ?? this.autoLockTime,
    );
  }
}