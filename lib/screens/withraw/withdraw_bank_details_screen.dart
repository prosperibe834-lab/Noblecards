import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import 'providers/withdraw_bank_provider.dart';
import 'models/withdraw_bank_models.dart';
import 'widgets/withdraw_stepper.dart';
import 'widgets/withdraw_bank_selector_sheet.dart';
import 'withdraw_review_screen.dart';

class WithdrawBankDetailsScreen extends StatefulWidget {
  const WithdrawBankDetailsScreen({super.key});

  @override
  State<WithdrawBankDetailsScreen> createState() => _WithdrawBankDetailsScreenState();
}

class _WithdrawBankDetailsScreenState extends State<WithdrawBankDetailsScreen> {
  void _showHelpDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Need Help?", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            Text(
              "Account verification ensures your funds are sent to the correct destination. Requirements change based on the destination country.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  void _showBankSelector(BuildContext context, WithdrawBankProvider provider) {
    // Mock banks list from existing provider architecture
    final mockBanks = [
      WithdrawalBank(id: '1', name: 'GTBank', code: '058'),
      WithdrawalBank(id: '2', name: 'Access Bank', code: '044'),
      WithdrawalBank(id: '3', name: 'First Bank', code: '011'),
      WithdrawalBank(id: '4', name: 'Zenith Bank', code: '057'),
      WithdrawalBank(id: '5', name: 'UBA', code: '033'),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WithdrawBankSelectorSheet(
        banks: mockBanks,
        selectedBank: provider.selectedBank,
        onBankSelected: (bank) => provider.selectBank(bank),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WithdrawBankProvider(),
      child: Consumer<WithdrawBankProvider>(
        builder: (context, provider, child) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final textColor = isDark ? AppColors.darkText : AppColors.lightText;
          final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
          final inputColor = isDark ? AppColors.darkInput : AppColors.lightBackground;
          final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Boxicons.bx_chevron_left, color: textColor, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                "Bank Details",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Boxicons.bx_help_circle, color: textColor),
                  onPressed: _showHelpDialog,
                )
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  const WithdrawStepper(currentStep: 0),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDestinationCard(provider, cardColor, borderColor),
                          const SizedBox(height: AppSpacing.lg),
                          
                          if (provider.isVerified)
                            _buildVerifiedCard(provider, cardColor)
                          else
                            _buildDynamicForms(provider, isDark, inputColor),

                          if (provider.isVerified) ...[
                            const SizedBox(height: AppSpacing.lg),
                            _buildSaveAccountSwitch(provider, cardColor),
                          ],
                        ],
                      ),
                    ),
                  ),
                  _buildBottomButton(provider, context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDestinationCard(WithdrawBankProvider provider, Color cardColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Text(provider.destination.flag, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.destination.countryName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  "Bank Transfer",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Change",
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontFamily: "Inter"),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDynamicForms(WithdrawBankProvider provider, bool isDark, Color inputColor) {
    final country = provider.destination.countryCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (country == 'NG' || country == 'GH' || country == 'GB' || country == 'CA') ...[
          _buildFormLabel("1. Select Bank"),
          GestureDetector(
            onTap: () => _showBankSelector(context, provider),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: inputColor,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    provider.selectedBank?.name ?? "Tap to select your bank",
                    style: TextStyle(
                      fontFamily: "Inter",
                      color: provider.selectedBank != null 
                        ? (isDark ? AppColors.darkText : AppColors.lightText) 
                        : (isDark ? AppColors.darkSubText : AppColors.lightSubText),
                    ),
                  ),
                  Icon(Boxicons.bx_chevron_down, color: isDark ? AppColors.darkSubText : AppColors.lightSubText),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        if (country == 'GB' || country == 'US' || country == 'CA') ...[
           _buildFormLabel("Account Name"),
           _buildTextField(
             hint: "John Doe",
             onChanged: provider.updateAccountName,
             inputColor: inputColor,
           ),
           const SizedBox(height: AppSpacing.md),
        ],

        if (country == 'GB') ...[
           _buildFormLabel("Sort Code"),
           _buildTextField(
             hint: "00-00-00",
             onChanged: provider.updateSortCode,
             inputColor: inputColor,
           ),
           const SizedBox(height: AppSpacing.md),
        ],

        if (country == 'US') ...[
           _buildFormLabel("Routing Number"),
           _buildTextField(
             hint: "012345678",
             onChanged: provider.updateRoutingNumber,
             inputColor: inputColor,
             keyboardType: TextInputType.number,
           ),
           const SizedBox(height: AppSpacing.md),
        ],

        if (country == 'CA') ...[
           Row(
             children: [
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     _buildFormLabel("Institution Number"),
                     _buildTextField(hint: "000", onChanged: provider.updateInstitutionNumber, inputColor: inputColor),
                   ],
                 ),
               ),
               const SizedBox(width: AppSpacing.md),
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     _buildFormLabel("Transit Number"),
                     _buildTextField(hint: "00000", onChanged: provider.updateTransitNumber, inputColor: inputColor),
                   ],
                 ),
               ),
             ],
           ),
           const SizedBox(height: AppSpacing.md),
        ],

        _buildFormLabel("${country == 'NG' || country == 'GH' ? '2. ' : ''}Account Number"),
        _buildTextField(
          hint: "0123456789",
          onChanged: provider.updateAccountNumber,
          inputColor: inputColor,
          keyboardType: TextInputType.number,
          icon: Boxicons.bx_user,
        ),
      ],
    );
  }

  Widget _buildFormLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildTextField({
    required String hint, 
    required Function(String) onChanged, 
    required Color inputColor,
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: TextStyle(color: isDark ? AppColors.darkText : AppColors.lightText, fontFamily: "Inter"),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? AppColors.darkSubText : AppColors.lightSubText),
        filled: true,
        fillColor: inputColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        suffixIcon: icon != null ? Icon(icon, color: isDark ? AppColors.darkSubText : AppColors.lightSubText) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
      ),
    );
  }

  Widget _buildVerifiedCard(WithdrawBankProvider provider, Color cardColor) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Boxicons.bx_check_circle, color: AppColors.success),
              const SizedBox(width: AppSpacing.sm),
              Text(
                "Account verified successfully",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildVerifyRow("Account Name", provider.accountName),
          if (provider.selectedBank != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _buildVerifyRow("Bank", provider.selectedBank!.name),
          ],
          const SizedBox(height: AppSpacing.sm),
          _buildVerifyRow("Account Number", provider.accountNumber),
        ],
      ),
    );
  }

  Widget _buildVerifyRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildSaveAccountSwitch(WithdrawBankProvider provider, Color cardColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Save this withdrawal account", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
            Text("Save for faster withdrawals in the future", style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        Switch(
          value: provider.saveAccount,
          onChanged: provider.toggleSaveAccount,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildBottomButton(WithdrawBankProvider provider, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: (provider.isFormValid && !provider.isVerifying)
              ? () {
                  if (!provider.isVerified) {
                    provider.verifyAccount();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WithdrawReviewScreen(provider: provider),
                      ),
                    );
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            elevation: 0,
          ),
          child: provider.isVerifying
              ? const SizedBox(
                  width: 24, height: 24,
                  child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      provider.isVerified ? "Continue to Review" : "Verify Account",
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(Boxicons.bx_right_arrow_alt, color: AppColors.white),
                  ],
                ),
        ),
      ),
    );
  }
}