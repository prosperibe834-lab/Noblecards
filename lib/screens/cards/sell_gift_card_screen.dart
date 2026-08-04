import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:boxicons/boxicons.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import 'package:noble_cards/theme/app_animation.dart';
import 'package:noble_cards/widgets/pin_auth_dialog.dart';
import 'package:noble_cards/screens/deposit_processing_screen.dart';
import 'package:noble_cards/screens/cards/models/gift_card_model.dart';
import 'package:noble_cards/screens/cards/models/gift_card_region_model.dart';
import 'package:noble_cards/screens/cards/providers/buy_provider.dart';
import 'package:noble_cards/screens/cards/providers/region_provider.dart';
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
  bool _verifiedNoticeAccepted = false;
  final bool _isLoading = false;
  bool _hasError = false;
  final bool _isEmpty = false;
  final List<CardFormData> _cards = [CardFormData()];

  void _toggleSellType(bool isPhysical) {
    HapticFeedback.lightImpact();
    setState(() => _isPhysical = isPhysical);
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
    final GiftCardRegionModel? pickedRegion = await showModalBottomSheet<GiftCardRegionModel>(
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
    }
  }

  Future<void> _submit(BuildContext context) async {
    if (!_verifiedNoticeAccepted) return;

    final navigator = Navigator.of(context);

    final success = await showDialog<bool>(
      context: context,
      builder: (_) => PinAuthDialog(
        onSuccess: (pin) {
          navigator.pop(true);
        },
      ),
    );

    if (!mounted || success != true) return;

    HapticFeedback.mediumImpact();

    await navigator.push(
      MaterialPageRoute(
        builder: (_) => const DepositProcessingScreen(
          amount: 0,
          currency: 'USD',
          convertedUsd: 0,
          returnToPreviousScreen: true,
        ),
      ),
    );
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
    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BuyProvider()),
        ChangeNotifierProvider(create: (_) => RegionProvider()),
      ],
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
            style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {},
              child: Text('History', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        body: SafeArea(
          child: _isLoading
              ? const SellLoadingShimmer()
              : _hasError
                  ? SellNetworkError(onRetry: () => setState(() => _hasError = false))
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
                                onChange: () => Navigator.pushNamed(context, '/gift_card_details_screen'),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Builder(
                                builder: (context) => RegionSelectorCard(onTap: () => _openRegionSelector(context)),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              CardTypeSelector(isPhysical: _isPhysical, onChanged: _toggleSellType),
                              const SizedBox(height: AppSpacing.lg),
                              BulkCardCounter(quantity: _cards.length, onAdd: _addCard, onRemove: () => _removeCard(_cards.length - 1)),
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
                                );
                              }),
                              const SizedBox(height: AppSpacing.lg),
                              SellSummaryCard(cardCount: _cards.length, totalAmount: _calculateTotalAmount()),
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
        amount = '',
        code = '';
}

class AnimatedCardForm extends StatelessWidget {
  final int index;
  final bool isPhysical;
  final CardFormData cardForm;
  final VoidCallback onRemove;

  const AnimatedCardForm({super.key, required this.index, required this.isPhysical, required this.cardForm, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppAnimation.fast,
      child: Container(
        key: ValueKey(cardForm.id),
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : AppColors.white,
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
                Text('Card #${index + 1}', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkText : AppColors.lightText, fontSize: 16, fontWeight: FontWeight.w700)),
                RemoveCardButton(onTap: onRemove),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const AmountInput(),
            const SizedBox(height: AppSpacing.md),
            const CardCodeInput(),
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
