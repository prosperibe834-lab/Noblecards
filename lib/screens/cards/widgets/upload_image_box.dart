import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import 'upload_image_preview.dart';

class UploadImageBox extends StatefulWidget {
  final String label;

  const UploadImageBox({super.key, required this.label});

  @override
  State<UploadImageBox> createState() => _UploadImageBoxState();
}

class _UploadImageBoxState extends State<UploadImageBox> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    HapticFeedback.lightImpact();
  }

  void _removeImage() {
    HapticFeedback.lightImpact();
    setState(() => _selectedImage = null);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return GestureDetector(
      onTap: _pickImage,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightInput,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: borderColor),
        ),
        child: _selectedImage == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, color: AppColors.primary, size: 32),
                  const SizedBox(height: AppSpacing.sm),
                  Text(widget.label, style: TextStyle(color: isDark ? AppColors.darkSubText : AppColors.lightSubText)),
                ],
              )
              : Stack(
                children: [
                  UploadImagePreview(imageFile: _selectedImage!),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: _removeImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.error),
                        child: const Icon(Icons.close, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
