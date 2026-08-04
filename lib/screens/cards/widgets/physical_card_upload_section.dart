import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import 'upload_image_box.dart';

class PhysicalCardUploadSection extends StatelessWidget {
  const PhysicalCardUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upload Card Images', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: const [
            Expanded(child: UploadImageBox(label: 'Front Image')),
            SizedBox(width: AppSpacing.md),
            Expanded(child: UploadImageBox(label: 'Back Image')),
          ],
        ),
      ],
    );
  }
}
