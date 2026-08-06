import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';

class ImageSourceBottomSheet extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  final VoidCallback onRemoveTap;

  const ImageSourceBottomSheet({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
    required this.onRemoveTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Profile Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Boxicons.bx_camera, color: AppColors.success),
              title: Text('Take Photo', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.pop(context);
                onCameraTap();
              },
            ),
            ListTile(
              leading: const Icon(Boxicons.bx_image, color: AppColors.success),
              title: Text('Choose from Gallery', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.pop(context);
                onGalleryTap();
              },
            ),
            ListTile(
              leading: const Icon(Boxicons.bx_trash, color: AppColors.error),
              title: const Text('Remove Photo', style: TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(context);
                onRemoveTap();
              },
            ),
          ],
        ),
      ),
    );
  }
}