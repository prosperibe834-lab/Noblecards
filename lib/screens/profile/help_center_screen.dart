import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import 'data/help_center_data.dart';
import 'widgets/app_information_card.dart';
import 'widgets/article_card.dart';
import 'widgets/contact_support_card.dart';
import 'widgets/faq_tile.dart';
import 'widgets/help_center_shimmer.dart';
import 'widgets/help_footer_card.dart';
import 'widgets/help_search_bar.dart';
import 'widgets/quick_help_card.dart';
import 'widgets/report_problem_card.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Simulate initial network fetch
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSectionHeader(String title, {bool showViewAll = true}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        if (showViewAll)
          InkWell(
            onTap: () {}, // Navigation placeholder
            child: Text(
              'View All',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Center(
        child: Column(
          children: [
            Icon(
              Boxicons.bx_search_alt,
              size: 60,
              color: isDark ? Colors.white24 : Colors.black12,
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We couldn't find anything matching your search.",
              style: TextStyle(
                color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter FAQs based on Search Query
    final filteredFaqs = HelpCenterData.faqs
        .where((faq) => faq.question.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Boxicons.bx_chevron_left,
            color: isDark ? Colors.white : Colors.black,
            size: 28,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const HelpCenterShimmer()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header Details
                    Text(
                      'Help Center',
                      style: AppTextStyles.h3.copyWith(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'How can we help you today?',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Search Bar
                    HelpSearchBar(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      onClear: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    const SizedBox(height: 24),

                    if (_searchQuery.isNotEmpty && filteredFaqs.isEmpty)
                      _buildEmptyState()
                    else ...[
                      // Quick Help Grid
                      _buildSectionHeader('Quick Help'),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: HelpCenterData.quickHelpItems.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.80,
                        ),
                        itemBuilder: (context, index) {
                          return QuickHelpCard(
                            item: HelpCenterData.quickHelpItems[index],
                          );
                        },
                      ),
                      const SizedBox(height: 32),

                      // Frequently Asked Questions
                      _buildSectionHeader('Frequently Asked Questions'),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.04),
                          ),
                        ),
                        child: Column(
                          children: List.generate(
                            _searchQuery.isEmpty ? HelpCenterData.faqs.length : filteredFaqs.length,
                            (index) {
                              final data = _searchQuery.isEmpty ? HelpCenterData.faqs : filteredFaqs;
                              return FAQTile(
                                faq: data[index],
                                isLast: index == data.length - 1,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Popular Articles
                      _buildSectionHeader('Popular Articles'),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 165,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: HelpCenterData.popularArticles.length,
                          itemBuilder: (context, index) {
                            return ArticleCard(
                              article: HelpCenterData.popularArticles[index],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Contact Support
                      _buildSectionHeader('Contact Support', showViewAll: false),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: HelpCenterData.contactSupportItems.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          return ContactSupportCard(
                            item: HelpCenterData.contactSupportItems[index],
                          );
                        },
                      ),
                      const SizedBox(height: 32),

                      // Report a Problem
                      const ReportProblemCard(),
                      const SizedBox(height: 32),

                      // App Information
                      const AppInformationCard(),
                      const SizedBox(height: 24),

                      // Footer Card
                      const HelpFooterCard(),
                      const SizedBox(height: 32),

                      // Bottom Action Button
                      InkWell(
                        onTap: () {}, // Navigation placeholder
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.success.withOpacity(0.3),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Didn't find what you're looking for?",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Contact Support',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                Boxicons.bx_chevron_right,
                                color: Colors.white,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}