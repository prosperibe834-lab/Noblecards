import 'package:flutter/material.dart';

class ArticleModel {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? content;
  final String readTime;
  final String category;

  const ArticleModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.content,
    this.readTime = '3 min read',
    this.category = 'General',
  });
}

