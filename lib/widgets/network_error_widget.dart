import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../theme/app_theme.dart';
import 'custom_button.dart';

import '../theme/app_colors.dart';

import '../theme/app_spacing.dart';

class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onRefresh;

  const NetworkErrorWidget({
    super.key,
    required this.onRetry,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Boxicons.bx_wifi_off,
                  size: 64,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'No Internet Connection',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Please check your internet connection and try again.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              CustomButton(
                text: 'Retry',
                icon: Boxicons.bx_refresh,
                onPressed: onRetry,
              ),
              const SizedBox(height: AppSpacing.sm),
              CustomButton(
                text: 'Refresh Page',
                isOutlined: true,
                onPressed: onRefresh,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
