import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class SupportCard extends StatelessWidget {
  const SupportCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isDark 
              ? [const Color(0xFF0A2E1A), const Color(0xFF06180E)]
              : [const Color(0xFFE8F8F0), const Color(0xFFCFF1DF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00B75F).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi Prosper 👋',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Welcome to NobleCards Support.\nPlease choose the issue you\'re having so we\ncan connect you to the right support specialist.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ],
          ),
          Positioned(
            right: -10,
            top: -10,
            child: Icon(
              Icons.auto_awesome,
              color: const Color(0xFF00B75F).withOpacity(0.5),
              size: 24,
            ),
          ),
          Positioned(
            right: 40,
            bottom: 0,
            child: Icon(
              Icons.auto_awesome,
              color: const Color(0xFF00B75F).withOpacity(0.3),
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}