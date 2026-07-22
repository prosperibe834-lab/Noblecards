import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_shadow.dart';
import '../../theme/app_animation.dart';
import '../home.dart';

class OnboardingItem {
  final String title;
  final String description;
  final String imagePath;
  final List<Map<String, String>>? features;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
    this.features,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _pages = [
    OnboardingItem(
      title: "Welcome to NobleCards",
      description:
          "Buy and sell gift cards quickly, securely, and at the best market rates—all in one trusted platform.",
      imagePath: 'lib/assets/onboarding/onboarding1.png',
    ),
    OnboardingItem(
      title: "Fast, Secure & Trusted",
      description:
          "Experience lightning-fast transactions, verified trading, secure payments, and reliable customer support whenever you need it.",
      imagePath: 'lib/assets/onboarding/onboarding2.png',
      features: [
        {'title': 'Instant Trades', 'icon': 'transfer'},
        {'title': 'Secure Payments', 'icon': 'shield'},
        {'title': 'Verified Market', 'icon': 'check'},
        {'title': '24/7 Support', 'icon': 'headphone'},
      ],
    ),
    OnboardingItem(
      title: "Everything You Need to Trade Gift Cards",
      description:
          "Join thousands of users buying and selling gift cards with confidence. Fast rates, secure trading, and a seamless experience await you.",
      imagePath: 'lib/assets/onboarding/onboarding3.png',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AppAnimation.normal,
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: AppAnimation.normal,
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _finishOnboarding() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    // Theme values mapped directly from your AppColors
    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark
        ? AppColors.darkSubText
        : AppColors.lightSubText;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Ambient Orb Glow using AppColors.primary
          Positioned(
            top: -60,
            left: size.width * 0.1,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(isDark ? 0.12 : 0.22),
                    blurRadius: 90,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          // Dynamic Island / Full-Screen SafeArea Layout
          SafeArea(
            child: Column(
              children: [
                // Top Header (Logo & Skip)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _currentPage > 0
                          ? GestureDetector(
                              onTap: _previousPage,
                              child: Container(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: cardColor,
                                  border: Border.all(color: borderColor),
                                ),
                                child: Icon(
                                  Boxicons.bx_arrow_back,
                                  size: 20,
                                  color: textColor,
                                ),
                              ),
                            )
                          : Image.asset(
                              isDark
                                  ? 'lib/assets/logos/DarkModeLogo.png'
                                  : 'lib/assets/logos/LightModeLogo.png',
                              height:
                                  90,
                              fit: BoxFit
                                  .contain, 
                              errorBuilder: (context, error, stackTrace) => Text(
                                "NobleCards",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize:
                                      40, // 
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                      if (_currentPage < _pages.length - 1)
                        GestureDetector(
                          onTap: _finishOnboarding,
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: subTextColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Page View Content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Graphic Illustration Container
                            Container(
                              height: size.height * 0.32,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.xl,
                                ),
                                boxShadow: isDark
                                    ? AppShadow.dark
                                    : AppShadow.light,
                                image: DecorationImage(
                                  image: page.imagePath.startsWith('http')
                                      ? NetworkImage(page.imagePath)
                                            as ImageProvider
                                      : AssetImage(page.imagePath),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            const SizedBox(height: AppSpacing.lg),

                            // Dynamic Title
                            Text(
                              page.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                letterSpacing: -0.5,
                              ),
                            ),

                            const SizedBox(height: AppSpacing.sm),

                            // Description
                            Text(
                              page.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 14,
                                height: 1.5,
                                color: subTextColor,
                              ),
                            ),

                            // Feature Grid for Slide 2
                            if (page.features != null) ...[
                              const SizedBox(height: AppSpacing.md),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: AppSpacing.sm,
                                      mainAxisSpacing: AppSpacing.sm,
                                      childAspectRatio: 2.7,
                                    ),
                                itemCount: page.features!.length,
                                itemBuilder: (context, fIndex) {
                                  final feat = page.features![fIndex];
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cardColor,
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.sm,
                                      ),
                                      border: Border.all(color: borderColor),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(
                                            AppSpacing.xs,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.success
                                                .withOpacity(0.15),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Boxicons.bx_check,
                                            color: AppColors.success,
                                            size: 14,
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.sm),
                                        Expanded(
                                          child: Text(
                                            feat['title']!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: textColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Indicator Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: AppAnimation.normal,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 6,
                      width: _currentPage == index ? 22 : 6,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppColors.primary
                            : borderColor,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Bottom Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: _currentPage == _pages.length - 1
                      ? Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _finishOnboarding,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.full,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Get Started",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: OutlinedButton(
                                onPressed: _finishOnboarding,
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: borderColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.full,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.full,
                                ),
                              ),
                            ),
                            child: const Text(
                              "Next",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
