import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../models/quick_help_model.dart';
import '../../cards/buy_gift_cards_catalog_screen.dart';
import '../../cards/sell_gift_cards_catalog_screen.dart';
import '../../wallet_screen.dart';
import '../../withraw/withdraw_screen.dart';
import '../security_pin/change_transaction_pin_screen.dart';
import '../personal_information_screen.dart';
import '../account_level_screen.dart';
import '../appearance/appearance_screen.dart';

class QuickHelpCard extends StatelessWidget {
  final QuickHelpModel item;

  const QuickHelpCard({super.key, required this.item});

  void _handleNavigation(BuildContext context) {
    Widget target;
    final title = item.title.toLowerCase();

    if (title.contains('buy')) {
      target = const BuyGiftCardsCatalogScreen();
    } else if (title.contains('sell')) {
      target = const SellGiftCardsCatalogScreen();
    } else if (title.contains('wallet')) {
      target = const WalletScreen();
    } else if (title.contains('withdrawal')) {
      target = const WithdrawScreen();
    } else if (title.contains('security') || title.contains('pin')) {
      target = const ChangeTransactionPinScreen();
    } else if (title.contains('account') && !title.contains('setting')) {
      target = const PersonalInformationScreen();
    } else if (title.contains('verification') || title.contains('kyc')) {
      target = const AccountLevelScreen();
    } else {
      target = const AppearanceScreen();
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => target),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleNavigation(context),
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.primary.withOpacity(0.1),
          highlightColor: AppColors.primary.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(isDark ? 0.15 : 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: AppColors.primary, size: 22),
                ),
                const SizedBox(height: 12),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
