import 'dart:io';
import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';

class ProfilePhotoPicker extends StatelessWidget {
  final String? photoPath;
  final VoidCallback onTap;

  const ProfilePhotoPicker({
    super.key,
    required this.photoPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ImageProvider imageProvider;
    if (photoPath != null && photoPath!.isNotEmpty) {
      imageProvider = FileImage(File(photoPath!));
    } else {
      imageProvider = const NetworkImage('https://i.pravatar.cc/150?img=11');
    }

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Circular avatar container with green highlight ring
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.success,
                    width: 2.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              // Floating camera badge icon
              Positioned(
                bottom: 2,
                right: 4,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppColors.darkBackground : AppColors.white,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: const Icon(
                    Boxicons.bx_camera,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Tap to change profile photo',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'JPG, PNG or WEBP. Max size 5MB.',
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
          ),
        ),
      ],
    );
  }
}