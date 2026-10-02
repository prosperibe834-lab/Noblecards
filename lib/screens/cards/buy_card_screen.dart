import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:boxicons/boxicons.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import 'package:noble_cards/screens/TransactionPin/pin_auth_dialog.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
import 'package:noble_cards/screens/deposit_processing_screen.dart';
import 'package:noble_cards/screens/cards/buy_receipt_screen.dart';

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
    final buyProvider = context.read<BuyProvider>();
    final region = context.read<RegionProvider>().selectedRegion;

    if (region == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a supported country first.')),
      );
      return;
    }
    final amount = buyProvider.amount;
    final quantity = buyProvider.quantity;
    final minimum = double.tryParse(region.minimumAmount);
    final maximum = double.tryParse(region.maximumAmount);
    final denominations = region.availableDenominations
        .map((value) => double.tryParse(value))
        .whereType<double>()
        .toList();
    if (amount <= 0 ||
        (minimum != null && amount < minimum) ||
        (maximum != null && amount > maximum) ||
        (denominations.isNotEmpty && !denominations.contains(amount))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a supported gift-card amount.')),
      );
      return;
    }

    await buyProvider.refreshQuote();
    if (!context.mounted) return;
    if (!buyProvider.hasCurrentQuote) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            buyProvider.quoteError ??
                'Buy pricing is currently unavailable. Please try again.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (buyProvider.selectedRegion?.id != region.id ||
        buyProvider.amount != amount ||
        buyProvider.quantity != quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'The selected product or country changed. Review the quote and try again.',
          ),
        ),
      );
      return;
    }
    final customerPriceUsd = buyProvider.totalToPay!;

    final success = await showDialog<bool>(
      context: context,
      builder: (_) => PinAuthDialog(
        onValidatePin: (pin) =>
            AuthenticationService().verifyTransactionPin(pin),
      ),
    );

    if (!context.mounted || success != true) return;

    try {
      HapticFeedback.mediumImpact();
      if (!context.mounted) return;

      final result = await navigator.push<Object?>(
        MaterialPageRoute(
          builder: (_) => DepositProcessingScreen(
            amount: customerPriceUsd,
            currency: 'USD',
            convertedUsd: customerPriceUsd,
            onProcessTransaction: () =>
                AuthenticationService().authenticatedPost(
                  '/gift-cards/buy',
                  body: {
                    'productId': card.id,
                    'countryCode': region.countryCode,
                    'currencyCode': region.currencyCode,
                    'amount': amount,
                    'quantity': quantity,
                  },
                ),
            transactionResultBuilder: (response) => BuyReceiptScreen(
              transactionId: response['id']?.toString() ?? '',
            ),
          ),
        ),
      );
      if (result != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.toString().replaceFirst('Exception: ', '')),
          ),
        );
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is Exception
                ? error.toString()
                : 'Unable to place your purchase right now.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _openRegionSelector(BuildContext context) async {
    final buyProvider = context.read<BuyProvider>();

    final regionProvider = context.read<RegionProvider>();
    final GiftCardRegionModel? pickedRegion =
        await showModalBottomSheet<GiftCardRegionModel>(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => ChangeNotifierProvider.value(
            value: regionProvider,
            child: const RegionBottomSheet(rateLabel: 'Buy'),
          ),
        );

    if (pickedRegion != null) {
      buyProvider.setRegion(pickedRegion);
      context.read<RegionProvider>().selectRegion(pickedRegion);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    GiftCardRegionModel? initialRegion;
    for (final region in card.supportedRegions) {
      if (region.countryCode == card.countryCode &&
          region.currencyCode == card.currency) {
        initialRegion = region;
        break;
      }
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BuyProvider(card: card, initialRegion: initialRegion),
        ),
        ChangeNotifierProvider(
          create: (_) => RegionProvider(
            loadInitialRegions: false,
            initialRegions: card.supportedRegions,
            initialRegion: initialRegion,
          ),
        ),
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
