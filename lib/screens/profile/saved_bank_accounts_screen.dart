import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_text_styles.dart';
import '../../../localization/app_localizations.dart';
import '../authentication/services/authentication_service.dart';
import '../withraw/models/withdraw_bank_models.dart';
import '../../widgets/loading_shimmer.dart';

class SavedBankAccountsScreen extends StatefulWidget {
  const SavedBankAccountsScreen({super.key});

  @override
  State<SavedBankAccountsScreen> createState() => _SavedBankAccountsScreenState();
}

class _SavedBankAccountsScreenState extends State<SavedBankAccountsScreen> {
  final AuthenticationService _authService = AuthenticationService();
  List<SavedBeneficiary> _beneficiaries = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBeneficiaries();
  }

  Future<void> _loadBeneficiaries() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _authService.authenticatedGet('/withdrawals/beneficiaries');
      final list = response['beneficiaries'];
      if (list is List) {
        _beneficiaries = list
            .whereType<Map>()
            .map((item) => SavedBeneficiary.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      } else {
        _beneficiaries = [];
      }
    } catch (error) {
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteBeneficiary(SavedBeneficiary beneficiary) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: MediaQuery.of(context).padding.bottom + 24,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Boxicons.bx_trash, color: AppColors.error, size: 30),
              ),
              const SizedBox(height: 16),
              Text(
                'Delete Bank Account?',
                style: AppTextStyles.h3.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to remove ${beneficiary.institutionName} (${beneficiary.maskedAccount}) from your saved accounts?',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyText2.copyWith(
                  color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: Text(
                        context.tr('cancel', fallback: 'Cancel'),
                        style: TextStyle(
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (confirmed != true) return;

    try {
      await _authService.authenticatedDelete('/withdrawals/beneficiaries/${beneficiary.id}');
      setState(() {
        _beneficiaries.removeWhere((b) => b.id == beneficiary.id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${beneficiary.institutionName} account removed successfully.'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _openAddBankAccountModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddBankAccountSheet(
        onAccountAdded: () => _loadBeneficiaries(),
      ),
    );
  }

  String _countryFlag(String countryCode) {
    switch (countryCode.toUpperCase()) {
      case 'NG':
        return '🇳🇬';
      case 'GH':
        return '🇬🇭';
      case 'US':
        return '🇺🇸';
      case 'GB':
        return '🇬🇧';
      case 'CA':
        return '🇨🇦';
      case 'KE':
        return '🇰🇪';
      case 'ZA':
        return '🇿🇦';
      default:
        return '🏦';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Boxicons.bx_arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr('bank_accounts', fallback: 'Bank Accounts'),
          style: AppTextStyles.h2.copyWith(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Boxicons.bx_plus, color: AppColors.primary, size: 28),
            onPressed: _openAddBankAccountModal,
            tooltip: 'Add Bank Account',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadBeneficiaries,
        color: AppColors.primary,
        child: _isLoading
            ? _buildShimmer()
            : _errorMessage != null
                ? _buildErrorState()
                : _beneficiaries.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        itemCount: _beneficiaries.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final item = _beneficiaries[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                              border: Border.all(
                                color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(AppRadius.md),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        _countryFlag(item.countryCode),
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.institutionName,
                                            style: AppTextStyles.bodyText1.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item.accountHolderName.isNotEmpty
                                                ? item.accountHolderName
                                                : 'Primary Account',
                                            style: AppTextStyles.bodyText2.copyWith(
                                              color: subTextColor,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Boxicons.bx_trash,
                                        color: AppColors.error,
                                        size: 20,
                                      ),
                                      onPressed: () => _deleteBeneficiary(item),
                                      tooltip: 'Delete',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(AppRadius.sm),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            item.maskedAccount,
                                            style: TextStyle(
                                              fontFamily: 'monospace',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          InkWell(
                                            onTap: () {
                                              Clipboard.setData(
                                                ClipboardData(text: item.maskedAccount.replaceAll('•', '').trim()),
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Account number copied'),
                                                  duration: Duration(seconds: 1),
                                                ),
                                              );
                                            },
                                            child: Icon(
                                              Boxicons.bx_copy,
                                              size: 16,
                                              color: subTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.success.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(AppRadius.xs),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Boxicons.bx_check_circle,
                                              color: AppColors.success,
                                              size: 12,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              item.currency.isNotEmpty ? item.currency : 'Active',
                                              style: const TextStyle(
                                                color: AppColors.success,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ElevatedButton.icon(
            onPressed: _openAddBankAccountModal,
            icon: const Icon(Boxicons.bx_plus, size: 20),
            label: const Text(
              'Add New Bank Account',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (_, _) => const LoadingShimmer(
        width: double.infinity,
        height: 120,
        borderRadius: AppRadius.lg,
      ),
    );
  }

  Widget _buildEmptyState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Boxicons.bxs_bank,
                color: AppColors.primary,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Saved Bank Accounts',
              style: AppTextStyles.h3.copyWith(
                color: isDark ? AppColors.darkText : AppColors.lightText,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add a bank account to receive withdrawals swiftly and securely.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText2.copyWith(
                color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _openAddBankAccountModal,
              icon: const Icon(Boxicons.bx_plus),
              label: const Text('Add Bank Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Boxicons.bx_error_circle, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Failed to load bank accounts.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.error),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadBeneficiaries,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddBankAccountSheet extends StatefulWidget {
  final VoidCallback onAccountAdded;
  const _AddBankAccountSheet({required this.onAccountAdded});

  @override
  State<_AddBankAccountSheet> createState() => _AddBankAccountSheetState();
}

class _AddBankAccountSheetState extends State<_AddBankAccountSheet> {
  final AuthenticationService _authService = AuthenticationService();
  final TextEditingController _accountNumberController = TextEditingController();

  List<WithdrawalBank> _banks = [];
  WithdrawalBank? _selectedBank;
  String _selectedCountry = 'NG';
  String _selectedCurrency = 'NGN';
  bool _isLoadingBanks = true;
  bool _isVerifying = false;
  bool _isSaving = false;
  String? _resolvedAccountName;
  String? _verificationError;

  final List<Map<String, String>> _countries = [
    {'code': 'NG', 'currency': 'NGN', 'name': 'Nigeria 🇳🇬'},
    {'code': 'GH', 'currency': 'GHS', 'name': 'Ghana 🇬🇭'},
    {'code': 'KE', 'currency': 'KES', 'name': 'Kenya 🇰🇪'},
    {'code': 'ZA', 'currency': 'ZAR', 'name': 'South Africa 🇿🇦'},
    {'code': 'US', 'currency': 'USD', 'name': 'United States 🇺🇸'},
    {'code': 'GB', 'currency': 'GBP', 'name': 'United Kingdom 🇬🇧'},
  ];

  @override
  void initState() {
    super.initState();
    _loadBanks();
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    super.dispose();
  }

  Future<void> _loadBanks() async {
    setState(() {
      _isLoadingBanks = true;
      _selectedBank = null;
      _resolvedAccountName = null;
      _verificationError = null;
    });

    try {
      final response = await _authService.authenticatedGet(
        '/withdrawals/banks?countryCode=$_selectedCountry&currencyCode=$_selectedCurrency',
      );
      final rawList = response['banks'];
      if (rawList is List) {
        _banks = rawList.map((e) {
          final m = Map<String, dynamic>.from(e as Map);
          return WithdrawalBank(
            id: m['id']?.toString() ?? '',
            name: m['name']?.toString() ?? '',
            code: m['code']?.toString() ?? '',
            logoUrl: m['logoUrl']?.toString(),
            hasBranches: m['hasBranches'] == true,
          );
        }).toList();
        if (_banks.isNotEmpty) {
          _selectedBank = _banks.first;
        }
      }
    } catch (_) {
      _banks = [];
    } finally {
      if (mounted) {
        setState(() => _isLoadingBanks = false);
      }
    }
  }

  Future<void> _verifyAccount() async {
    final account = _accountNumberController.text.trim();
    if (account.length < 8 || _selectedBank == null) return;

    setState(() {
      _isVerifying = true;
      _verificationError = null;
      _resolvedAccountName = null;
    });

    try {
      final res = await _authService.authenticatedPost(
        '/withdrawals/beneficiaries/verify',
        body: {
          'countryCode': _selectedCountry,
          'currencyCode': _selectedCurrency,
          'institutionCode': _selectedBank!.code,
          'accountNumber': account,
          'method': 'BANK_TRANSFER',
        },
      );
      if (res['accountHolderName'] != null) {
        _resolvedAccountName = res['accountHolderName'].toString();
      } else {
        _resolvedAccountName = 'Verified Account';
      }
    } catch (e) {
      _verificationError = e.toString().replaceFirst('Exception: ', '');
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  Future<void> _saveAccount() async {
    final account = _accountNumberController.text.trim();
    if (account.isEmpty || _selectedBank == null) return;

    setState(() => _isSaving = true);
    try {
      await _authService.authenticatedPost(
        '/withdrawals/beneficiaries',
        body: {
          'countryCode': _selectedCountry,
          'currencyCode': _selectedCurrency,
          'method': 'BANK_TRANSFER',
          'type': 'BANK_ACCOUNT',
          'institutionCode': _selectedBank!.code,
          'institutionName': _selectedBank!.name,
          'accountNumber': account,
          'accountHolderName': _resolvedAccountName ?? 'Account Holder',
          'saveAccount': true,
        },
      );
      if (mounted) {
        widget.onAccountAdded();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bank account saved successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;
    final inputBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + bottomInset + 20,
      ),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Add Bank Account',
              style: AppTextStyles.h3.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Country Selector
            Text('Country', style: TextStyle(color: subTextColor, fontSize: 13)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: inputBg,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCountry,
                  isExpanded: true,
                  dropdownColor: cardBg,
                  items: _countries.map((c) {
                    return DropdownMenuItem<String>(
                      value: c['code'],
                      child: Text(
                        c['name']!,
                        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val == null) return;
                    final found = _countries.firstWhere((c) => c['code'] == val);
                    setState(() {
                      _selectedCountry = val;
                      _selectedCurrency = found['currency']!;
                    });
                    _loadBanks();
                  },
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Bank Selector
            Text('Select Bank', style: TextStyle(color: subTextColor, fontSize: 13)),
            const SizedBox(height: 6),
            _isLoadingBanks
                ? const LoadingShimmer(width: double.infinity, height: 48, borderRadius: AppRadius.md)
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: inputBg,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<WithdrawalBank>(
                        value: _selectedBank,
                        isExpanded: true,
                        dropdownColor: cardBg,
                        hint: Text('Choose your bank', style: TextStyle(color: subTextColor)),
                        items: _banks.map((b) {
                          return DropdownMenuItem<WithdrawalBank>(
                            value: b,
                            child: Text(
                              b.name,
                              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (bank) {
                          setState(() {
                            _selectedBank = bank;
                            _resolvedAccountName = null;
                            _verificationError = null;
                          });
                          if (_accountNumberController.text.trim().length >= 8) {
                            _verifyAccount();
                          }
                        },
                      ),
                    ),
                  ),
            const SizedBox(height: 14),

            // Account Number Input
            Text('Account Number', style: TextStyle(color: subTextColor, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: _accountNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, letterSpacing: 1.1),
              decoration: InputDecoration(
                hintText: 'Enter 10-digit account number',
                hintStyle: TextStyle(color: subTextColor.withValues(alpha: 0.6), letterSpacing: 0),
                filled: true,
                fillColor: inputBg,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: _isVerifying
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                        )
                      : const Icon(Boxicons.bx_check_circle, color: AppColors.primary),
                  onPressed: _verifyAccount,
                ),
              ),
              onChanged: (val) {
                if (val.length >= 10) {
                  _verifyAccount();
                }
              },
            ),

            if (_resolvedAccountName != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  children: [
                    const Icon(Boxicons.bx_user_check, color: AppColors.success, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _resolvedAccountName!,
                        style: const TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (_verificationError != null) ...[
              const SizedBox(height: 10),
              Text(
                _verificationError!,
                style: const TextStyle(color: AppColors.error, fontSize: 12),
              ),
            ],

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                elevation: 0,
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text(
                      'Save Bank Account',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
