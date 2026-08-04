import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noble_cards/theme/app_radius.dart';

class UploadImagePreview extends StatelessWidget {
  final File imageFile;

  const UploadImagePreview({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Image.file(imageFile, fit: BoxFit.cover, width: double.infinity, height: 140),
    );
  }
}
