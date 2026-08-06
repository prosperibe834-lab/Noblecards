import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import 'services/biometric_service.dart';
import 'widgets/auto_lock_bottom_sheet.dart';
import 'widgets/biometric_header_card.dart';
import 'widgets/biometric_loading_shimmer.dart';
import 'widgets/biometric_method_card.dart';
import 'widgets/security_footer_card.dart';
import 'widgets/security_setting_tile.dart';

class BiometricLoginScreen extends StatefulWidget {
  const BiometricLoginScreen({super.key});

  @override
  State<BiometricLoginScreen> createState() => _BiometricLoginScreenState();
}

class _BiometricLoginScreenState extends State<BiometricLoginScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BiometricProvider>().loadBiometricSettings();
    });
  }

  void _showAutoLockPicker(BuildContext context, BiometricProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AutoLockBottomSheet(
        selectedTime: provider.settings.autoLockTime,
        onSelect: (newTime) => provider.updateAutoLockTime(newTime),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<BiometricProvider>();
    final settings = provider.settings;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Boxicons.bx_chevron_left,
            color: isDark ? Colors.white : Colors.black,
            size: 28,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Biometric Login',
          style: AppTextStyles.h3.copyWith(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: provider.isLoading
          ? const BiometricLoadingShimmer()
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Gradient Secure Header Card
                  const BiometricHeaderCard(),
                  const SizedBox(height: 24),

                  // Section: Biometric Methods
                  Text(
                    'Biometric Methods',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Card 1: Face ID
                  BiometricMethodCard(
                    icon: Boxicons.bx_scan,
                    title: 'Face ID',
                    subtitle: 'Use Face ID to login to your account.',
                    isSupported: settings.isFaceIdAvailable,
                    isEnabled: settings.isFaceIdEnabled,
                    onToggle: provider.toggleFaceId,
                  ),

                  // Card 2: Fingerprint
                  BiometricMethodCard(
                    icon: Boxicons.bx_fingerprint,
                    title: 'Fingerprint',
                    subtitle: 'Use your fingerprint to login to your account.',
                    isSupported: settings.isFingerprintAvailable,
                    isEnabled: settings.isFingerprintEnabled,
                    onToggle: provider.toggleFingerprint,
                  ),

                  // Card 3: Remember this device
                  BiometricMethodCard(
                    icon: Boxicons.bx_mobile_alt,
                    title: 'Remember this device',
                    subtitle: 'Skip biometric login on this device for faster access.',
                    isSupported: true,
                    isEnabled: settings.isRememberDeviceEnabled,
                    onToggle: provider.toggleRememberDevice,
                    infoText:
                        'You will still need biometrics for sensitive actions like payments and withdrawals.',
                  ),
                  const SizedBox(height: 20),

                  // Section: Security Settings
                  Text(
                    'Security Settings',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Container Card for Security Settings
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.black.withOpacity(0.04),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        SecuritySettingTile(
                          title: 'Require Biometric for Transactions',
                          subtitle:
                              'Always verify biometric for payments, withdrawals and sensitive actions.',
                          switchValue: settings.isRequireForTransactionsEnabled,
                          onSwitchChanged: provider.toggleRequireForTransactions,
                        ),
                        Divider(
                          height: 1,
                          color: isDark ? Colors.white10 : Colors.grey.shade200,
                        ),
                        SecuritySettingTile(
                          title: 'Auto Lock Time',
                          subtitle:
                              'Set the time after which the app will require biometric login again.',
                          trailingText: settings.autoLockTime,
                          onTap: () => _showAutoLockPicker(context, provider),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bottom Security Priority Card
                  const SecurityFooterCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}