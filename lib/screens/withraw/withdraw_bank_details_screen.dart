import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../authentication/services/authentication_service.dart';
import 'models/withdraw_bank_models.dart';
import 'providers/withdraw_bank_provider.dart';
import 'widgets/withdraw_stepper.dart';
import 'widgets/withdraw_bank_selector_sheet.dart';
import 'withdraw_review_screen.dart';

class WithdrawBankDetailsScreen extends StatefulWidget {
  final WithdrawalDestination destination;
  final String paymentMethod;
  final double sourceAmount;
  final String? initialQuoteId;
  final AuthenticationService? authService;

  const WithdrawBankDetailsScreen({
    super.key,
    required this.destination,
    required this.paymentMethod,
    required this.sourceAmount,
    this.initialQuoteId,
    this.authService,
  });

  @override
  State<WithdrawBankDetailsScreen> createState() =>
      _WithdrawBankDetailsScreenState();
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
    if (provider.isLoadingBanks || provider.banks.isEmpty) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WithdrawBankSelectorSheet(
        banks: provider.banks,
        selectedBank: provider.selectedBank,
        onBankSelected: (bank) => provider.selectBank(bank),
      ),
    );
  }

  void _showBranchSelector(
    BuildContext context,
    WithdrawBankProvider provider,
  ) {
    if (provider.isLoadingBranches || provider.branches.isEmpty) return;
    final branches = provider.branches
        .map(
          (branch) => WithdrawalBank(
            id: branch.id,
            name: branch.name,
            code: branch.code,
          ),
        )
        .toList();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WithdrawBankSelectorSheet(
        banks: branches,
        selectedBank: provider.selectedBranch == null
            ? null
            : WithdrawalBank(
                id: provider.selectedBranch!.id,
                name: provider.selectedBranch!.name,
                code: provider.selectedBranch!.code,
              ),
        title: "Select Branch",
        subtitle: "Provider branch code",
        onBankSelected: (branch) => provider.selectBranch(
          WithdrawalBranch(id: branch.id, name: branch.name, code: branch.code),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WithdrawBankProvider(
        authService: widget.authService,
        destination: widget.destination,
        paymentMethod: widget.paymentMethod,
        sourceAmount: widget.sourceAmount,
        initialQuoteId: widget.initialQuoteId,
      )..loadSavedBeneficiaries(),
      child: Consumer<WithdrawBankProvider>(
        builder: (context, provider, child) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final textColor = isDark ? AppColors.darkText : AppColors.lightText;
          final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
          final inputColor = isDark
              ? AppColors.darkInput
              : AppColors.lightBackground;
          final borderColor = isDark
              ? AppColors.darkBorder
              : AppColors.lightBorder;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Boxicons.bx_chevron_left,
                  color: textColor,
                  size: 28,
                ),
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
                ),
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
                          _buildDestinationCard(
                            provider,
                            cardColor,
                            borderColor,
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          if (provider.isLoadingBeneficiaries) ...[
                            _buildLoadingBeneficiariesShimmer(),
                          ] else if (provider.hasSavedBeneficiaries &&
                              !provider.useManualAccount) ...[
                            _buildSavedBeneficiariesSection(
                              provider,
                              isDark,
                              cardColor,
                              borderColor,
                              textColor,
                            ),
                          ] else ...[
                            if (provider.hasSavedBeneficiaries)
                              _buildBackToSavedAccountsBanner(
                                provider,
                                isDark,
                                cardColor,
                                borderColor,
                              ),
                            if (provider.isVerified)
                              _buildVerifiedCard(provider, cardColor)
                            else
                              _buildDynamicForms(provider, isDark, inputColor),

                            if (provider.isVerified) ...[
                              const SizedBox(height: AppSpacing.lg),
                              _buildSaveAccountSwitch(provider, cardColor),
                            ],
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

  Widget _buildDestinationCard(
    WithdrawBankProvider provider,
    Color cardColor,
    Color borderColor,
  ) {
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
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
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
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontFamily: "Inter",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicForms(
    WithdrawBankProvider provider,
    bool isDark,
    Color inputColor,
  ) {
    final country = provider.destination.countryCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (country == 'NG' || country == 'GH') ...[
          _buildFormLabel("1. Bank"),
          GestureDetector(
            onTap: provider.isLoadingBanks || provider.banks.isEmpty
                ? null
                : () => _showBankSelector(context, provider),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: inputColor,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    provider.selectedBank?.name ?? "Select Bank",
                    style: TextStyle(
                      fontFamily: "Inter",
                      color: provider.selectedBank != null
                          ? (isDark ? AppColors.darkText : AppColors.lightText)
                          : (isDark
                                ? AppColors.darkSubText
                                : AppColors.lightSubText),
                    ),
                  ),
                  Icon(
                    Boxicons.bx_chevron_down,
                    color: isDark
                        ? AppColors.darkSubText
                        : AppColors.lightSubText,
                  ),
                ],
              ),
            ),
          ),
          if (provider.isLoadingBanks)
            const Padding(
              padding: EdgeInsets.only(top: AppSpacing.sm),
              child: LinearProgressIndicator(),
            )
          else if (provider.bankError != null)
            Row(
              children: [
                Expanded(
                  child: Text(
                    provider.bankErrorMessage,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                TextButton(
                  onPressed: provider.loadBanks,
                  child: const Text("Retry"),
                ),
              ],
            )
          else if (provider.banks.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                "No banks are currently available.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: AppSpacing.md),
        ],

        if (country == 'GH' && provider.selectedBank?.hasBranches == true) ...[
          _buildFormLabel("2. Branch"),
          GestureDetector(
            onTap: provider.isLoadingBranches || provider.branches.isEmpty
                ? null
                : () => _showBranchSelector(context, provider),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: inputColor,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      provider.selectedBranch?.name ?? "Select Branch",
                      style: TextStyle(
                        fontFamily: "Inter",
                        color: provider.selectedBranch != null
                            ? (isDark
                                  ? AppColors.darkText
                                  : AppColors.lightText)
                            : (isDark
                                  ? AppColors.darkSubText
                                  : AppColors.lightSubText),
                      ),
                    ),
                  ),
                  Icon(
                    Boxicons.bx_chevron_down,
                    color: isDark
                        ? AppColors.darkSubText
                        : AppColors.lightSubText,
                  ),
                ],
              ),
            ),
          ),
          if (provider.isLoadingBranches)
            const Padding(
              padding: EdgeInsets.only(top: AppSpacing.sm),
              child: LinearProgressIndicator(),
            )
          else if (provider.branchError != null)
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Unable to load branches. Check your connection and retry.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                TextButton(
                  onPressed: provider.loadBranches,
                  child: const Text("Retry"),
                ),
              ],
            )
          else if (provider.branches.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                "No branches are currently available for this bank.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: AppSpacing.md),
        ],

        if (country == 'GB' || country == 'US' || country == 'CA') ...[
          _buildFormLabel("Beneficiary Full Name"),
          _buildTextField(
            hint: "John Doe",
            onChanged: provider.updateAccountName,
            inputColor: inputColor,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildFormLabel("Bank Name"),
          _buildTextField(
            hint: "Enter bank name",
            onChanged: provider.updateInstitutionName,
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
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildAccountTypeField(
            value: provider.accountType,
            values: const ['personal', 'corporate'],
            onChanged: provider.updateAccountType,
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
          _buildFormLabel("SWIFT Code"),
          _buildTextField(
            hint: "8 or 11 characters",
            onChanged: provider.updateSwiftCode,
            inputColor: inputColor,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildAccountTypeField(
            value: provider.accountType,
            values: const ['checking', 'depository'],
            onChanged: provider.updateAccountType,
            inputColor: inputColor,
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
                    _buildTextField(
                      hint: "000",
                      onChanged: provider.updateInstitutionNumber,
                      inputColor: inputColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormLabel("Transit Number"),
                    _buildTextField(
                      hint: "00000",
                      onChanged: provider.updateTransitNumber,
                      inputColor: inputColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(
              "Canadian bank identifiers are collected for your beneficiary record only; CAD payout is not enabled.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],

        _buildFormLabel(
          "${country == 'NG' || country == 'GH' ? (provider.selectedBank?.hasBranches == true ? '3. ' : '2. ') : ''}Account Number",
        ),
        _buildTextField(
          hint: "0123456789",
          onChanged: provider.updateAccountNumber,
          inputColor: inputColor,
          keyboardType: TextInputType.number,
          icon: Boxicons.bx_user,
        ),
        if (country == 'GH') ...[
          const SizedBox(height: AppSpacing.md),
          _buildFormLabel(
            "${provider.selectedBank?.hasBranches == true ? '4. ' : '3. '}Beneficiary Name",
          ),
          _buildTextField(
            hint: "Flutterwave Developers",
            onChanged: provider.updateAccountName,
            inputColor: inputColor,
          ),
        ],
        if (country == 'GB' || country == 'US' || country == 'CA') ...[
          const SizedBox(height: AppSpacing.md),
          _buildFormLabel("Beneficiary Address"),
          _buildTextField(
            hint: "Street number",
            onChanged: provider.updateStreetNumber,
            inputColor: inputColor,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildTextField(
            hint: "Street name",
            onChanged: provider.updateStreetName,
            inputColor: inputColor,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildTextField(
            hint: "City",
            onChanged: provider.updateCity,
            inputColor: inputColor,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildTextField(
            hint: country == 'GB' ? "County / state" : "State / province",
            onChanged: provider.updateState,
            inputColor: inputColor,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildTextField(
            hint: country == 'CA' ? "Postal code (A1A 1A1)" : "Postal code",
            onChanged: provider.updatePostalCode,
            inputColor: inputColor,
          ),
          if (country == 'GB') ...[
            const SizedBox(height: AppSpacing.md),
            _buildFormLabel("Reason for Transfer"),
            _buildTextField(
              hint: "Enter transfer reason",
              onChanged: provider.updateTransferReason,
              inputColor: inputColor,
            ),
          ],
          if (provider.manualDetailsSaved) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              provider.manualPayoutNotice,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildAccountTypeField({
    required String value,
    required List<String> values,
    required ValueChanged<String> onChanged,
    required Color inputColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DropdownButtonFormField<String>(
      initialValue: values.contains(value) ? value : null,
      decoration: InputDecoration(
        labelText: "Account Type",
        filled: true,
        fillColor: inputColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
      ),
      dropdownColor: Theme.of(context).cardColor,
      style: TextStyle(
        color: isDark ? AppColors.darkText : AppColors.lightText,
        fontFamily: "Inter",
      ),
      items: values
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item[0].toUpperCase() + item.substring(1)),
            ),
          )
          .toList(),
      onChanged: (selected) {
        if (selected != null) onChanged(selected);
      },
    );
  }

  Widget _buildFormLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
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
      style: TextStyle(
        color: isDark ? AppColors.darkText : AppColors.lightText,
        fontFamily: "Inter",
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
        ),
        filled: true,
        fillColor: inputColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        suffixIcon: icon != null
            ? Icon(
                icon,
                color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
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
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildSaveAccountSwitch(
    WithdrawBankProvider provider,
    Color cardColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Save this withdrawal account",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              "Save for faster withdrawals in the future",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
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

  Widget _buildBottomButton(
    WithdrawBankProvider provider,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: (provider.isFormValid && !provider.isVerifying)
              ? () async {
                  try {
                    if (provider.selectedSavedBeneficiary != null &&
                        !provider.useManualAccount) {
                      await _saveAndContinue(provider, context);
                    } else if (provider.isManualDetailsOnly) {
                      await _saveAndContinue(provider, context);
                    } else if (!provider.isVerified) {
                      await provider.verifyAccount();
                    } else {
                      await _saveAndContinue(provider, context);
                    }
                  } catch (error) {
                    if (!context.mounted) return;
                    final friendly = error.toString().replaceFirst(
                      'Exception: ',
                      '',
                    );
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(friendly)));
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
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      provider.selectedSavedBeneficiary != null &&
                              !provider.useManualAccount
                          ? "Proceed to Review"
                          : (provider.isManualDetailsOnly || provider.isVerified
                              ? "Continue to Review"
                              : "Verify Account"),
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(
                      Boxicons.bx_right_arrow_alt,
                      color: AppColors.white,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSavedBeneficiariesSection(
    WithdrawBankProvider provider,
    bool isDark,
    Color cardColor,
    Color borderColor,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Boxicons.bx_bookmark_heart,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  "Saved Accounts",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: provider.switchToManualAccount,
              icon: const Icon(
                Boxicons.bx_plus,
                size: 16,
                color: AppColors.primary,
              ),
              label: const Text(
                "New Bank",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ...provider.savedBeneficiaries.map((beneficiary) {
          final isSelected =
              provider.selectedSavedBeneficiary?.id == beneficiary.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: InkWell(
              onTap: () async {
                provider.selectSavedBeneficiary(beneficiary);
                await _saveAndContinue(provider, context);
              },
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : borderColor,
                    width: isSelected ? 2.0 : 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : (isDark
                                ? AppColors.darkInput
                                : AppColors.lightBackground),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Boxicons.bxs_bank,
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.darkSubText
                                : AppColors.lightSubText),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  beneficiary.institutionName,
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (beneficiary.isVerified)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    "Verified",
                                    style: TextStyle(
                                      color: AppColors.success,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            beneficiary.accountHolderName,
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.darkSubText
                                  : AppColors.lightSubText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "${beneficiary.maskedAccount} • ${beneficiary.currency}",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.darkSubText
                                  : AppColors.lightSubText,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(
                      isSelected
                          ? Boxicons.bxs_check_circle
                          : Boxicons.bx_circle,
                      color: isSelected
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.darkSubText.withValues(alpha: 0.5)
                              : AppColors.lightSubText.withValues(alpha: 0.5)),
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: AppSpacing.xs),
        OutlinedButton.icon(
          onPressed: provider.switchToManualAccount,
          icon: const Icon(Boxicons.bx_plus_circle, size: 18),
          label: const Text(
            "Use another bank account",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: isDark ? AppColors.darkText : AppColors.lightText,
            side: BorderSide(color: borderColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 4),
            minimumSize: const Size(double.infinity, 44),
          ),
        ),
      ],
    );
  }

  Widget _buildBackToSavedAccountsBanner(
    WithdrawBankProvider provider,
    bool isDark,
    Color cardColor,
    Color borderColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(Boxicons.bx_bookmark, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              "Saved accounts available",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
          ),
          TextButton(
            onPressed: provider.switchToSavedAccounts,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 32),
            ),
            child: const Text(
              "Select Saved",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingBeneficiariesShimmer() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Text(
            "Checking saved accounts...",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAndContinue(
    WithdrawBankProvider provider,
    BuildContext context,
  ) async {
    try {
      await provider.saveBeneficiary();
      await provider.createQuote();
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WithdrawReviewScreen(provider: provider),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }
}
