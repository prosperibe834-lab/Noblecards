import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:local_auth/local_auth.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';

class BiometricSetupScreen extends StatefulWidget {
  const BiometricSetupScreen({super.key});

  @override
  State<BiometricSetupScreen> createState() => _BiometricSetupScreenState();
}

class _BiometricSetupScreenState extends State<BiometricSetupScreen> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isFaceIdAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricType();
  }

  Future<void> _checkBiometricType() async {
    try {
      final List<BiometricType> available = await _auth.getAvailableBiometrics();
      if (available.contains(BiometricType.face)) {
        setState(() => _isFaceIdAvailable = true);
      } else {
        setState(() => _isFaceIdAvailable = false);
      }
    } catch (_) {
      setState(() => _isFaceIdAvailable = false);
    }
  }

  Future<void> _enableBiometrics() async {
    try {
      final bool authenticated = await _auth.authenticate(
        localizedReason: _isFaceIdAvailable
            ? 'Authenticate to enable Face ID'
            : 'Authenticate to enable Fingerprint',
        persistAcrossBackgrounding: true,
      );

      if (authenticated && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometric setup failed. Try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error triggering biometrics: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final title = _isFaceIdAvailable ? 'Enable Face ID' : 'Enable Fingerprint';
    final subtitle = _isFaceIdAvailable
        ? 'Unlock NobleCards instantly using Face ID.'
        : 'Unlock NobleCards instantly using your fingerprint.';
    final iconData = _isFaceIdAvailable ? Boxicons.bx_scan : Boxicons.bx_fingerprint;

    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Biometric Icon Container
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, size: 84, color: AppColors.primary),
              ),

              const SizedBox(height: AppSpacing.xl),

              Text(title, style: textTheme.headlineLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(subtitle, textAlign: TextAlign.center, style: textTheme.bodyMedium),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _enableBiometrics,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                child: const Text('Skip for Now', style: TextStyle(color: AppColors.lightSubText)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}