import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import 'promo_indicator.dart';

class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _slides = const [
    {
      'title': 'Trade Gift Cards\nSecurely & Instantly',
      'sub': 'Best rates • Instant payments\n24/7 Support • 120+ Countries',
      'btn': 'Explore Now →'
    },
    {
      'title': 'Highest Rates Today',
      'sub': 'Updated every few seconds for top value',
      'btn': 'View Rates →'
    },
    {
      'title': 'Instant Verification',
      'sub': 'Fast secure processing within minutes',
      'btn': 'Sell Now →'
    },
    {
      'title': '24/7 Customer Support',
      'sub': 'Always online to help your trades',
      'btn': 'Contact Support →'
    },
    {
      'title': 'Global Marketplace',
      'sub': 'Thousands of cards active right now',
      'btn': 'Start Trading →'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF2D1F54), AppColors.darkCard]
                        : [const Color(0xFFEDE9FE), AppColors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: AppColors.accentViolet.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            slide['title']!,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark ? Colors.white : AppColors.lightText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            slide['sub']!,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.accentViolet,
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                            child: Text(
                              slide['btn']!,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 64,
                      color: AppColors.accentViolet.withOpacity(0.8),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        PromoIndicator(count: _slides.length, currentIndex: _currentIndex),
      ],
    );
  }
}