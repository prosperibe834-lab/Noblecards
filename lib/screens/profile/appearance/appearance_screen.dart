import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/theme_provider.dart';
import 'models/appearance_option.dart';
import 'widgets/appearance_card.dart';
import 'widgets/appearance_footer.dart';
import 'widgets/appearance_shimmer.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  ThemeOption _selectedOption = ThemeOption.system;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final themeProvider = context.read<ThemeProvider>();
    _selectedOption = _themeOptionFromMode(themeProvider.themeMode);

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  ThemeOption _themeOptionFromMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return ThemeOption.light;
      case ThemeMode.dark:
        return ThemeOption.dark;
      case ThemeMode.system:
        return ThemeOption.system;
    }
  }

  Future<void> _handleOptionTap(ThemeOption option) async {
    final themeProvider = context.read<ThemeProvider>();
    final newMode = _themeModeFromOption(option);

    if (themeProvider.themeMode == newMode) {
      return;
    }

    await themeProvider.setThemeMode(newMode);

    if (mounted) {
      setState(() {
        _selectedOption = option;
      });
    }
  }

  ThemeMode _themeModeFromOption(ThemeOption option) {
    switch (option) {
      case ThemeOption.light:
        return ThemeMode.light;
      case ThemeOption.dark:
        return ThemeMode.dark;
      case ThemeOption.system:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
      ),
      body: SafeArea(
        child: _isLoading
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: AppearanceShimmer(),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header Titles
                    Text(
                      'Appearance',
                      style: AppTextStyles.h3.copyWith(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Customize how NobleCards looks',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Section Details
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Theme',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Choose your preferred theme for the app.',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card 1: Light Mode
                    AppearanceCard(
                      option: ThemeOption.light,
                      isSelected: _selectedOption == ThemeOption.light,
                      onTap: () => _handleOptionTap(ThemeOption.light),
                      title: 'Light Mode',
                      subtitle: 'Always use light theme throughout the app.',
                      icon: Boxicons.bx_sun,
                      iconColor: Colors.orange,
                      iconBgColor: Colors.orange.withOpacity(0.12),
                    ),

                    // Card 2: Dark Mode
                    AppearanceCard(
                      option: ThemeOption.dark,
                      isSelected: _selectedOption == ThemeOption.dark,
                      onTap: () => _handleOptionTap(ThemeOption.dark),
                      title: 'Dark Mode',
                      subtitle: 'Always use dark theme throughout the app.',
                      icon: Boxicons.bx_moon,
                      iconColor: const Color(0xFF6B4EE6),
                      iconBgColor: const Color(0xFF6B4EE6).withOpacity(0.12),
                    ),

                    // Card 3: System Default
                    AppearanceCard(
                      option: ThemeOption.system,
                      isSelected: _selectedOption == ThemeOption.system,
                      onTap: () => _handleOptionTap(ThemeOption.system),
                      title: 'System Default',
                      subtitle: 'Use system theme preference.',
                      icon: Boxicons.bx_mobile_alt,
                      iconColor: AppColors.success,
                      iconBgColor: AppColors.success.withOpacity(0.12),
                      isRecommended: true,
                    ),
                    const SizedBox(height: 8),

                    // Footer Notification Card
                    const AppearanceFooter(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
      ),
    );
  }
}