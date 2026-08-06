import 'package:flutter/material.dart';

class ArticleModel {
  final String title;
  final String subtitle;
  final IconData icon;

  const ArticleModel({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}