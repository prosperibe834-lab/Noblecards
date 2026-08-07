import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
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
      setState(() {
        _allLanguages = languages;
        _filteredLanguages = languages;
        _selectedLanguage = languages.firstWhere(
          (lang) => lang.isDefault, 
          orElse: () => languages.first
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
            .where((lang) => lang.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _onLanguageSelected(LanguageModel language) {
    setState(() {
      _selectedLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1419) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Boxicons.bx_chevron_left, color: isDark ? Colors.white : Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              "Language",
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Choose your preferred language",
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
                          child: CurrentLanguageCard(language: _selectedLanguage!),
                        ),
                        const SizedBox(height: 24),
                        LanguageSearchField(onChanged: _onSearch),
                        const SizedBox(height: 32),
                        Text(
                          "All Languages",
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
                                duration: Duration(milliseconds: 300 + (index * 50).clamp(0, 500)),
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
                                  isSelected: _selectedLanguage?.id == language.id,
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