import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class LoadingPlaceholder extends StatelessWidget {
  const LoadingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: CircularProgressIndicator(color: AppColors.accentViolet),
      ),
    );
  }
}