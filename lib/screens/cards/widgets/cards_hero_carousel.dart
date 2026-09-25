import 'dart:async';
import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_animation.dart';
import '../../../theme/app_shadow.dart';

class CardsHeroCarousel extends StatefulWidget {
  const CardsHeroCarousel({Key? key}) : super(key: key);

  @override
  State<CardsHeroCarousel> createState() => _CardsHeroCarouselState();
}

class _CardsHeroCarouselState extends State<CardsHeroCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _slides = [
    {
      "tag": "Global Gift Cards",
      "headline": "4,000+\nCards Worldwide",
      "sub": "Discover your favorite brands from around the world.",
      "colors": [AppColors.primary, AppColors.secondary],
      "icon": Boxicons.bx_globe
    },
    {
      "tag": "Better Rates. Faster Access.",
      "headline": "More Value\nEvery Time",
      "sub": "Shop popular gift cards with transparent pricing and instant access.",
      "colors": [AppColors.primaryDark, AppColors.info],
      "icon": Boxicons.bx_trending_up
    },
    {
      "tag": "One Powerful Marketplace",
      "headline": "Buy & Sell\nWith Confidence",
      "sub": "Discover global brands or turn unused gift cards into value.",
      "colors": [AppColors.primary, AppColors.accentViolet],
      "icon": Boxicons.bx_check_shield
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % _slides.length;
        _pageController.animateToPage(
          nextPage,
          duration: AppAnimation.slow,
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              _startTimer(); // Reset timer on manual swipe
            },
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              return _buildSlide(_slides[index]);
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_slides.length, (index) {
            return AnimatedContainer(
              duration: AppAnimation.normal,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _currentPage == index ? 24 : 6,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.primary
                    : AppColors.lightSubText.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSlide(Map<String, dynamic> slide) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: LinearGradient(
          colors: slide["colors"],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? AppShadow.dark
            : AppShadow.light,
      ),
      child: Stack(
        children: [
          // Abstract background icon to act as visual element
          Positioned(
            right: -20,
            top: 10,
            child: Icon(
              slide["icon"],
              size: 120,
              color: Colors.white.withOpacity(0.15),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                slide["tag"],
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                slide["headline"],
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const Spacer(),
              Text(
                slide["sub"],
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Boxicons.bx_right_arrow_alt,
                  color: Colors.white,
                  size: 20,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}