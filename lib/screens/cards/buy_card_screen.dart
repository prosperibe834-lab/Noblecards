import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:boxicons/boxicons.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import 'package:noble_cards/widgets/pin_auth_dialog.dart';
import 'package:noble_cards/screens/deposit_processing_screen.dart';

import 'models/gift_card_model.dart';
import 'models/gift_card_region_model.dart';
import 'providers/buy_provider.dart';
import 'providers/region_provider.dart';
import 'widgets/buy_card_header.dart';
import 'widgets/rate_info_card.dart';
import 'widgets/amount_input_card.dart';
import 'widgets/quantity_selector.dart';
import 'widgets/payment_method_card.dart';
import 'widgets/order_summary_card.dart';
import 'widgets/continue_payment_button.dart';
import 'widgets/region_bottom_sheet.dart';
import 'widgets/region_selector_card.dart';

class BuyCardScreen extends StatelessWidget {
  final GiftCardModel card;

  const BuyCardScreen({super.key, required this.card});

  Future<void> _handlePayment(BuildContext context) async {
    final navigator = Navigator.of(context);

    final success = await showDialog<bool>(
      context: context,
      builder: (_) => PinAuthDialog(
        onSuccess: (pin) {
          navigator.pop(true);
        },
      ),
    );

    if (!context.mounted || success != true) return;

    HapticFeedback.mediumImpact();
    if (!context.mounted) return;

    await Navigator.push(
      context,
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

  Future<void> _openRegionSelector(BuildContext context) async {
    final buyProvider = context.read<BuyProvider>();

    final regionProvider = context.read<RegionProvider>();
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

    if (pickedRegion != null) {
      buyProvider.setRegion(pickedRegion);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
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
            'Buy Gift Card',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Boxicons.bx_headphone, color: textColor),
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuyCardHeader(card: card),
                const SizedBox(height: AppSpacing.md),
                Builder(
                  builder: (context) => RegionSelectorCard(
                    onTap: () => _openRegionSelector(context),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const RateInfoCard(),
                const SizedBox(height: AppSpacing.lg),
                const AmountInputCard(),
                const SizedBox(height: AppSpacing.lg),
                const QuantitySelector(),
                const SizedBox(height: AppSpacing.lg),
                const PaymentMethodCard(),
                const SizedBox(height: AppSpacing.lg),
                const OrderSummaryCard(),
                const SizedBox(height: 100), // padding for bottom button
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Builder(
            builder: (ctx) =>
                ContinuePaymentButton(onPressed: () => _handlePayment(ctx)),
          ),
        ),
      ),
    );
  }
}
