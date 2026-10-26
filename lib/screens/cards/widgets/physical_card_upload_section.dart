import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import 'upload_image_box.dart';

class PhysicalCardUploadSection extends StatelessWidget {
  final File? frontImage;
  final File? backImage;
  final ValueChanged<File?>? onFrontImageChanged;
  final ValueChanged<File?>? onBackImageChanged;

  const PhysicalCardUploadSection({
    super.key,
    this.frontImage,
    this.backImage,
    this.onFrontImageChanged,
    this.onBackImageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Card Images (Front & Back)',
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Clear photo required',
              style: TextStyle(
                color: subTextColor,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: UploadImageBox(
                label: 'Front Image',
                image: frontImage,
                onImageChanged: onFrontImageChanged,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: UploadImageBox(
                label: 'Back Image',
                image: backImage,
                onImageChanged: onBackImageChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
