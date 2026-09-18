import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:boxicons/boxicons.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import 'package:noble_cards/theme/app_animation.dart';
import 'package:noble_cards/providers/exchange_rate_provider.dart';
import 'package:noble_cards/screens/TransactionPin/pin_auth_dialog.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
import 'package:noble_cards/screens/deposit_processing_screen.dart';
import 'package:noble_cards/screens/cards/models/gift_card_model.dart';
import 'package:noble_cards/screens/cards/models/gift_card_region_model.dart';
import 'package:noble_cards/screens/cards/providers/buy_provider.dart';
import 'package:noble_cards/screens/cards/providers/region_provider.dart';
import 'services/gift_card_sell_service.dart';
import 'widgets/sell_card_header.dart';
import 'widgets/card_type_selector.dart';
import 'widgets/physical_card_upload_section.dart';
import 'widgets/bulk_card_counter.dart';
import 'widgets/amount_input.dart';
import 'widgets/card_code_input.dart';
import 'widgets/sell_summary_card.dart';
import 'widgets/verification_notice.dart';
import 'widgets/submit_sell_button.dart';
import 'widgets/remove_card_button.dart';
import 'widgets/sell_loading_shimmer.dart';
import 'widgets/sell_network_error.dart';
import 'widgets/sell_empty_state.dart';
import 'widgets/region_selector_card.dart';
import 'widgets/region_bottom_sheet.dart';

class SellGiftCardScreen extends StatefulWidget {
  final GiftCardModel card;

  const SellGiftCardScreen({super.key, required this.card});

  @override
  State<SellGiftCardScreen> createState() => _SellGiftCardScreenState();
}

class _SellGiftCardScreenState extends State<SellGiftCardScreen> {
  bool _isPhysical = false;
  List<String> _availableCardTypes = const ['ecode', 'physical'];
  bool _isLoadingCardTypes = false;
  bool _sellCatalogLoaded = false;
  String? _payoutCurrency;
  String? _receiptType;
  String? _catalogSlug;
  Map<String, dynamic>? _quote;
  bool _verifiedNoticeAccepted = false;
  final bool _isLoading = false;
  bool _hasError = false;
  final bool _isEmpty = false;
  final List<CardFormData> _cards = [CardFormData()];
  final GiftCardSellService _sellService = GiftCardSellService();

  Future<void> _loadAvailableCardTypes(GiftCardRegionModel region) async {
    if (_isLoadingCardTypes) return;
    _isLoadingCardTypes = true;
    try {
      final types = await _sellService.getAvailableCardTypes(
        cardName: widget.card.name,
        cardSlug: widget.card.id,
        countryCode: region.countryCode,
      );
      if (!mounted || types == null) return;
      setState(() {
        _availableCardTypes = types;
        if (types.isNotEmpty &&
            !_availableCardTypes.contains(_isPhysical ? 'physical' : 'ecode')) {
          _isPhysical = _availableCardTypes.first == 'physical';
        }
      });
      await _loadSellConfiguration(region);
    } catch (_) {
      // Keep the existing selector available if the catalog request fails.
    } finally {
      _isLoadingCardTypes = false;
    }
  }

  Future<void> _loadSellCatalog(RegionProvider provider) async {
    if (_sellCatalogLoaded) return;
    _sellCatalogLoaded = true;
    try {
      final regions = await _sellService.getRegionsForCard(
        widget.card.name,
        cardSlug: widget.card.id,
        cardType: _isPhysical ? 'physical' : 'ecode',
        cardAmount: _calculateTotalAmount(),
      );
      if (!mounted) return;
      if (regions.isEmpty) {
        setState(() => _hasError = true);
        return;
      }
      provider.replaceRegions(regions);
      await _loadAvailableCardTypes(regions.first);
    } catch (error) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  Future<void> _loadSellConfiguration(GiftCardRegionModel region) async {
    final selectedType = _isPhysical ? 'physical' : 'ecode';
    final configuration = await _sellService.getSellConfiguration(
      cardName: widget.card.name,
      cardSlug: widget.card.id,
      countryCode: region.countryCode,
      cardType: selectedType,
    );
    if (!mounted || configuration == null) return;
    setState(() {
      _catalogSlug = configuration['slug']?.toString();
      _payoutCurrency = configuration['payoutCurrency']?.toString();
      _receiptType = configuration['receiptType']?.toString();
    });
    await _refreshQuote();
  }

  Future<void> _refreshQuote() async {
    final region = context.read<RegionProvider>().selectedRegion;
    final amount = _calculateTotalAmount();
    if (region == null || amount <= 0 || _payoutCurrency == null) return;
    try {
      final quote = await _sellService.quoteSale(
        slug: _catalogSlug ?? _slugForCard(widget.card.name),
        cardCountry: region.countryCode,
        cardType: _isPhysical ? 'physical' : 'ecode',
        receiptType: _receiptType,
        cardCurrency: region.currencyCode,
        payoutCurrency: _payoutCurrency!,
        cardAmount: amount,
      );
      if (mounted) setState(() => _quote = quote);
    } catch (_) {
      if (mounted) setState(() => _quote = null);
    }
  }

  void _showUnavailableCardType(String cardType) {
    final label = cardType == 'physical' ? 'Physical Gift Card' : 'eCode';
    final format = cardType == 'physical' ? 'Physical format' : 'an eCode';
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$label Unavailable'),
        content: Text(
          'This gift card is currently not available in $format. Please select an available card type.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  void _toggleSellType(bool isPhysical) {
    HapticFeedback.lightImpact();
    setState(() {
      _isPhysical = isPhysical;
      _quote = null;
    });
    final region = context.read<RegionProvider>().selectedRegion;
    if (region != null) _loadAvailableCardTypes(region);
    _sellCatalogLoaded = false;
    _loadSellCatalog(context.read<RegionProvider>());
  }

  void _toggleVerifiedNotice(bool value) {
    setState(() => _verifiedNoticeAccepted = value);
  }

  void _addCard() {
    HapticFeedback.lightImpact();
    setState(() => _cards.add(CardFormData()));
  }

  void _removeCard(int index) {
    if (_cards.length <= 1) return;
    HapticFeedback.lightImpact();
    setState(() => _cards.removeAt(index));
  }

  Future<void> _openRegionSelector(BuildContext context) async {
    final regionProvider = context.read<RegionProvider>();
    final buyProvider = context.read<BuyProvider>();
    final GiftCardRegionModel? pickedRegion =
        await showModalBottomSheet<GiftCardRegionModel>(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => ChangeNotifierProvider.value(
            value: regionProvider,
            child: const RegionBottomSheet(),
          ),
        );

    if (!mounted) return;
    if (pickedRegion != null) {
      buyProvider.setRegion(pickedRegion);
      await _loadAvailableCardTypes(pickedRegion);
    }
  }

  Future<void> _submit(BuildContext context) async {
    if (!_verifiedNoticeAccepted) return;

    final region = context.read<RegionProvider>().selectedRegion;
    if (region == null) {
      _showError('Select the card region before submitting.');
      return;
    }
    final invalidCard = _cards.any(
      (card) =>
          card.amount.trim().isEmpty ||
          double.tryParse(card.amount) == null ||
          (!_isPhysical && card.code.trim().isEmpty),
    );
    if (invalidCard) {
      _showError('Enter a valid amount and card code before submitting.');
      return;
    }
    final selectedCardType = _isPhysical ? 'physical' : 'ecode';
    if (!_availableCardTypes.contains(selectedCardType)) {
      _showUnavailableCardType(selectedCardType);
      return;
    }
    if (_payoutCurrency == null) {
      _showError('This gift-card combination has no supported payout rate.');
      return;
    }

    final navigator = Navigator.of(context);

    final success = await showDialog<bool>(
      context: context,
      builder: (_) => PinAuthDialog(
        onValidatePin: (pin) =>
            AuthenticationService().verifyTransactionPin(pin),
      ),
    );

    if (!mounted || success != true) return;

    HapticFeedback.mediumImpact();

    if (!mounted) return;
    final result = await navigator.push<Object?>(
      MaterialPageRoute(
        builder: (_) => DepositProcessingScreen(
          amount: 0,
          currency: 'USD',
          convertedUsd: 0,
          navigateToSubmissionReceived: true,
          onProcess: () async {
            final response = await _sellService.submitSale(
              slug: _catalogSlug ?? _slugForCard(widget.card.name),
              cardCountry: region.countryCode,
              cardType: _isPhysical ? 'physical' : 'ecode',
              cardCurrency: region.currencyCode,
              receiptType: _receiptType,
              payoutCurrency: _payoutCurrency!,
              cardAmount: _cards.fold<double>(
                0,
                (total, card) => total + double.parse(card.amount),
              ),
              cards: _cards
                  .map(
                    (card) => {
                      'amount': double.parse(card.amount),
                      if (card.code.trim().isNotEmpty) 'code': card.code.trim(),
                      if (card.frontImage != null)
                        'frontImagePath': card.frontImage!.path,
                      if (card.backImage != null)
                        'backImagePath': card.backImage!.path,
                    },
                  )
                  .toList(),
            );
            final transactionId = response['id']?.toString();
            if (transactionId == null || transactionId.isEmpty) {
              throw Exception('Sell submission did not return a sale ID.');
            }
            return transactionId;
          },
        ),
      ),
    );
    if (!mounted || result == null) return;
    _showError(result.toString().replaceFirst('Exception: ', ''));
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _displayCardCurrencyAmount(Object? value, String? cardCurrency) {
    final providerAmount = double.tryParse(value?.toString() ?? '') ?? 0;
    final selectedCurrency = cardCurrency ?? 'USD';
    final usdAmount = ExchangeRateProvider.convertToUSD(
      providerAmount,
      _payoutCurrency ?? 'USD',
    );
    final cardAmount = ExchangeRateProvider.convertFromUSD(
      usdAmount,
      selectedCurrency,
    );
    return '$selectedCurrency ${cardAmount.toStringAsFixed(2)}';
  }

  String _slugForCard(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }

  double _calculateTotalAmount() {
    return _cards.fold(0.0, (previousValue, card) {
      final amount = double.tryParse(card.amount) ?? 0.0;
      return previousValue + amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => BuyProvider())],
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Boxicons.bx_chevron_left, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Sell Gift Card',
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {},
              child: Text(
                'History',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: _isLoading
              ? const SellLoadingShimmer()
              : _hasError
              ? SellNetworkError(
                  onRetry: () => setState(() => _hasError = false),
                )
              : _isEmpty
              ? const SellEmptyState()
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SellCardHeader(
                        card: widget.card,
                        rateText: _quote == null
                            ? null
                            : _displayCardCurrencyAmount(
                                _quote!['finalRate'],
                                context.watch<RegionProvider>().selectedRegion?.currencyCode,
                              ),
                        onChange: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Builder(
                        builder: (context) {
                          context.watch<RegionProvider>();
                          if (!_sellCatalogLoaded) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                _loadSellCatalog(
                                  context.read<RegionProvider>(),
                                );
                              }
                            });
                          }
                          return RegionSelectorCard(
                            onTap: () => _openRegionSelector(context),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      CardTypeSelector(
                        isPhysical: _isPhysical,
                        onChanged: _toggleSellType,
                        availableCardTypes: _availableCardTypes,
                        onUnavailable: _showUnavailableCardType,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      BulkCardCounter(
                        quantity: _cards.length,
                        onAdd: _addCard,
                        onRemove: () => _removeCard(_cards.length - 1),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ..._cards.asMap().entries.map((entry) {
                        final index = entry.key;
                        final cardForm = entry.value;
                        return AnimatedCardForm(
                          key: ValueKey(cardForm.id),
                          index: index,
                          isPhysical: _isPhysical,
                          cardForm: cardForm,
                          onRemove: () => _removeCard(index),
                          onChanged: () {
                            setState(() {});
                            _refreshQuote();
                          },
                        );
                      }),
                      const SizedBox(height: AppSpacing.lg),
                      SellSummaryCard(
                        cardCount: _cards.length,
                        totalAmount: _calculateTotalAmount(),
                        cardCurrency:
                            context
                                .watch<RegionProvider>()
                                .selectedRegion
                                ?.currencyCode ??
                            'USD',
                        payoutCurrency: _payoutCurrency ?? 'NGN',
                        sellRate:
                            double.tryParse(
                              _quote?['finalRate']?.toString() ?? '',
                            ) ??
                            0,
                        estimatedPayout:
                            double.tryParse(
                              _quote?['estimatedPayout']?.toString() ?? '',
                            ) ??
                            0,
                        sellRateText: _quote == null
                          ? null
                          : '${_displayCardCurrencyAmount(_quote!['finalRate'], context.watch<RegionProvider>().selectedRegion?.currencyCode)} / ${context.watch<RegionProvider>().selectedRegion?.currencyCode ?? 'USD'}',
                        estimatedPayoutText: _quote == null
                          ? null
                          : _displayCardCurrencyAmount(
                            _quote!['estimatedPayout'],
                            context.watch<RegionProvider>().selectedRegion?.currencyCode,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      VerificationNotice(
                        accepted: _verifiedNoticeAccepted,
                        onChanged: _toggleVerifiedNotice,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SubmitSellButton(
                        enabled: _verifiedNoticeAccepted,
                        onTap: () => _submit(context),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class CardFormData {
  final String id;
  String amount;
  String code;
  File? frontImage;
  File? backImage;

  CardFormData({String? id})
    : id = id ?? UniqueKey().toString(),
      amount = '100',
      code = '';
}

class AnimatedCardForm extends StatelessWidget {
  final int index;
  final bool isPhysical;
  final CardFormData cardForm;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  const AnimatedCardForm({
    super.key,
    required this.index,
    required this.isPhysical,
    required this.cardForm,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppAnimation.fast,
      child: Container(
        key: ValueKey(cardForm.id),
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkCard
              : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Card #${index + 1}',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkText
                        : AppColors.lightText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                RemoveCardButton(onTap: onRemove),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AmountInput(
              initialValue: cardForm.amount,
              onChanged: (value) {
                cardForm.amount = value;
                onChanged();
              },
            ),
            const SizedBox(height: AppSpacing.md),
            CardCodeInput(
              initialValue: cardForm.code,
              onChanged: (value) {
                cardForm.code = value;
                onChanged();
              },
            ),
            if (isPhysical) ...[
              const SizedBox(height: AppSpacing.md),
              const PhysicalCardUploadSection(),
            ],
          ],
        ),
      ),
    );
  }
}
