import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:provider/provider.dart';
import '../../../../localization/app_localizations.dart';
import '../../../../providers/language_provider.dart';
import 'models/language_model.dart';
import 'services/language_service.dart';
import 'widgets/current_language_card.dart';
import 'widgets/language_search_field.dart';
import 'widgets/language_tile.dart';
import 'widgets/language_loading_shimmer.dart';
import 'widgets/empty_language_widget.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final LanguageService _languageService = LanguageService();

  List<LanguageModel> _allLanguages = [];
  List<LanguageModel> _filteredLanguages = [];
  LanguageModel? _selectedLanguage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    final languages = await _languageService.getLanguages();
    if (mounted) {
      final activeLanguage = context.read<LanguageProvider>().currentLanguage;
      setState(() {
        _allLanguages = languages;
        _filteredLanguages = languages;
        _selectedLanguage = languages.firstWhere(
          (lang) => lang.id == activeLanguage.id,
          orElse: () => languages.firstWhere(
            (lang) => lang.isDefault,
            orElse: () => languages.first,
          ),
        );
        _isLoading = false;
      });
    }
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredLanguages = _allLanguages;
      } else {
        _filteredLanguages = _allLanguages
            .where(
              (lang) => lang.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  Future<void> _onLanguageSelected(LanguageModel language) async {
    setState(() {
      _selectedLanguage = language;
    });

    final languageProvider = context.read<LanguageProvider>();
    await languageProvider.changeLanguage(language);

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Text(language.flag, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${language.name} ${context.tr('selected', fallback: 'selected')}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF0F1A15),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF00C853), width: 0.8),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeLanguage = context.watch<LanguageProvider>().currentLanguage;
    final displayedCurrentLanguage = _selectedLanguage ?? activeLanguage;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1419) : Colors.white,
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
        title: Column(
          children: [
            Text(
              context.tr('language', fallback: "Language"),
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              context.tr(
                'choose_language',
                fallback: "Choose your preferred language",
              ),
              style: TextStyle(
                color: isDark ? Colors.white54 : Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const LanguageLoadingShimmer()
          : SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'current_language_card',
                          child: CurrentLanguageCard(
                            language: displayedCurrentLanguage,
                          ),
                        ),
                        const SizedBox(height: 24),
                        LanguageSearchField(onChanged: _onSearch),
                        const SizedBox(height: 32),
                        Text(
                          context.tr('all_languages', fallback: "All Languages"),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _filteredLanguages.isEmpty
                        ? const EmptyLanguageWidget()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            physics: const BouncingScrollPhysics(),
                            itemCount: _filteredLanguages.length,
                            itemBuilder: (context, index) {
                              final language = _filteredLanguages[index];

                              // Staggered slide animation setup
                              return TweenAnimationBuilder(
                                duration: Duration(
                                  milliseconds:
                                      300 + (index * 50).clamp(0, 500),
                                ),
                                tween: Tween<double>(begin: 0, end: 1),
                                builder: (context, double value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: Transform.translate(
                                      offset: Offset(0, 20 * (1 - value)),
                                      child: child,
                                    ),
                                  );
                                },
                                child: LanguageTile(
                                  language: language,
                                  isSelected:
                                      displayedCurrentLanguage.id == language.id,
                                  onTap: () => _onLanguageSelected(language),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
