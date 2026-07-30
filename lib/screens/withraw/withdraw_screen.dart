import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/withdrawal_step_indicator.dart';
import '../../widgets/withdrawal_summary_card.dart';
import '../../models/withdrawal_models.dart';
import 'withdraw_confirmation_screen.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  int _currentStep = 0;

  // Master State Data
  CurrencyOption _selectedCurrency = const CurrencyOption(
    code: 'NGN', name: 'Nigerian Naira', flag: '🇳🇬', rateToUsd: 1650.0,
  );

  WithdrawalMethodModel? _selectedMethod;
  SavedAccountModel? _selectedAccount;
  double _amount = 100.0;
  bool _saveAccountToggle = true;

  // New Account Controllers
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final List<CurrencyOption> _currencies = const [
    CurrencyOption(code: 'NGN', name: 'Nigerian Naira', flag: '🇳🇬', rateToUsd: 1650.0),
    CurrencyOption(code: 'USD', name: 'US Dollar', flag: '🇺🇸', rateToUsd: 1.0),
    CurrencyOption(code: 'GBP', name: 'British Pound', flag: '🇬🇧', rateToUsd: 0.78),
    CurrencyOption(code: 'EUR', name: 'Euro', flag: '🇪🇺', rateToUsd: 0.91),
    CurrencyOption(code: 'CAD', name: 'Canadian Dollar', flag: '🇨🇦', rateToUsd: 1.36),
    CurrencyOption(code: 'KES', name: 'Kenyan Shilling', flag: '🇰🇪', rateToUsd: 129.0),
    CurrencyOption(code: 'GHS', name: 'Ghanaian Cedi', flag: '🇬🇭', rateToUsd: 15.5),
  ];

  final List<WithdrawalMethodModel> _methods = const [
    WithdrawalMethodModel(
      id: 'bank',
      title: 'Bank Account',
      description: 'Fast direct bank transfer. Arrives in minutes.',
      icon: Boxicons.bx_building_house,
      estimatedTime: 'Instant - 5 Mins',
      badge: 'POPULAR',
      supportedCurrencies: ['NGN', 'USD', 'GBP', 'EUR', 'CAD', 'KES', 'GHS'],
    ),
    WithdrawalMethodModel(
      id: 'paypal',
      title: 'PayPal Account',
      description: 'Instant transfer to your PayPal wallet.',
      icon: Boxicons.bx_wallet,
      estimatedTime: 'Instant',
      supportedCurrencies: ['USD', 'EUR', 'GBP', 'CAD'],
    ),
    WithdrawalMethodModel(
      id: 'wise',
      title: 'Wise Transfer',
      description: 'Low cost global payout to your Wise account.',
      icon: Boxicons.bx_globe,
      estimatedTime: '1 Business Day',
      badge: 'LOW FEES',
      supportedCurrencies: ['USD', 'GBP', 'EUR', 'CAD'],
    ),
    WithdrawalMethodModel(
      id: 'momo',
      title: 'Mobile Money',
      description: 'Receive directly into your mobile money wallet.',
      icon: Boxicons.bx_mobile_alt,
      estimatedTime: 'Instant',
      supportedCurrencies: ['NGN', 'KES', 'GHS'],
    ),
  ];

  final List<SavedAccountModel> _savedAccounts = [
    SavedAccountModel(
      id: 'acc_1',
      title: 'Access Bank',
      details: '•••••••• 7821 (John Doe)',
      methodId: 'bank',
      isDefault: true,
    ),
    SavedAccountModel(
      id: 'acc_2',
      title: 'PayPal Wallet',
      details: 'john.doe@example.com',
      methodId: 'paypal',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedMethod = _methods.first;
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _accountNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  List<WithdrawalMethodModel> get _availableMethods {
    return _methods
        .where((m) => m.supportedCurrencies.contains(_selectedCurrency.code))
        .toList();
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    } else {
      // Navigate to Review / Confirmation
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WithdrawConfirmationScreen(
            currency: _selectedCurrency,
            method: _selectedMethod!,
            accountDetails: _selectedAccount?.details ?? _getEnteredAccountDetails(),
            amountUsd: _amount,
            feeUsd: 2.50,
          ),
        ),
      );
    }
  }

  String _getEnteredAccountDetails() {
    if (_selectedMethod?.id == 'bank') {
      return "${_bankNameController.text} • ${_accountNumberController.text}";
    } else if (_selectedMethod?.id == 'momo') {
      return "${_phoneController.text} (Mobile Money)";
    }
    return _emailController.text;
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Boxicons.bx_arrow_back),
          onPressed: _prevStep,
        ),
        title: Text(
          "Withdraw Funds",
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: WithdrawalStepIndicator(currentStep: _currentStep),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildCurrentStepView(theme, subTextColor),
                ),
              ),
            ),
            _buildBottomBar(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepView(ThemeData theme, Color subTextColor) {
    switch (_currentStep) {
      case 0:
        return _buildStep1Currency(theme, subTextColor);
      case 1:
        return _buildStep2Method(theme, subTextColor);
      case 2:
        return _buildStep3Accounts(theme, subTextColor);
      case 3:
        return _buildStep4Amount(theme, subTextColor);
      default:
        return const SizedBox.shrink();
    }
  }

  // STEP 1: Currency Selection
  Widget _buildStep1Currency(ThemeData theme, Color subTextColor) {
    return Column(
      key: const ValueKey(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Withdraw Currency",
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          "Choose the currency you would like to withdraw in.",
          style: theme.textTheme.bodyMedium?.copyWith(color: subTextColor),
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<CurrencyOption>(
          value: _selectedCurrency,
          decoration: InputDecoration(
            labelText: "Target Currency",
            prefixIcon: const Icon(Boxicons.bx_globe),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: _currencies.map((c) {
            return DropdownMenuItem(
              value: c,
              child: Text("${c.flag}  ${c.code} - ${c.name}"),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _selectedCurrency = val;
                final available = _availableMethods;
                if (!available.contains(_selectedMethod)) {
                  _selectedMethod = available.isNotEmpty ? available.first : null;
                }
              });
            }
          },
        ),
        const SizedBox(height: 24),
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Current Exchange Rate", style: theme.textTheme.bodyMedium?.copyWith(color: subTextColor)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text("Live", style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "1 USD = ${_selectedCurrency.code} ${_selectedCurrency.rateToUsd.toStringAsFixed(2)}",
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(height: 12),
              Text(
                "You are withdrawing in ${_selectedCurrency.name} (${_selectedCurrency.code}).",
                style: theme.textTheme.bodySmall?.copyWith(color: subTextColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // STEP 2: Method Selection
  Widget _buildStep2Method(ThemeData theme, Color subTextColor) {
    final available = _availableMethods;

    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Withdrawal Method",
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          "Methods available for ${_selectedCurrency.name}.",
          style: theme.textTheme.bodyMedium?.copyWith(color: subTextColor),
        ),
        const SizedBox(height: 20),
        ...available.map((method) {
          final isSelected = _selectedMethod?.id == method.id;
          return GestureDetector(
            onTap: () => setState(() => _selectedMethod = method),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(method.icon, color: theme.primaryColor),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(method.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                              if (method.badge != null) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    method.badge!,
                                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(method.description, style: theme.textTheme.bodySmall?.copyWith(color: subTextColor)),
                          const SizedBox(height: 4),
                          Text(
                            "Arrival: ${method.estimatedTime}",
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Radio<String>(
                      value: method.id,
                      groupValue: _selectedMethod?.id,
                      onChanged: (_) => setState(() => _selectedMethod = method),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // STEP 3: Account Selection / Add New
  Widget _buildStep3Accounts(ThemeData theme, Color subTextColor) {
    final relevantAccounts = _savedAccounts.where((a) => a.methodId == _selectedMethod?.id).toList();

    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Destination Account",
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          "Choose a saved account or enter new details.",
          style: theme.textTheme.bodyMedium?.copyWith(color: subTextColor),
        ),
        const SizedBox(height: 20),
        if (relevantAccounts.isNotEmpty) ...[
          Text("Saved Accounts", style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...relevantAccounts.map((acc) {
            final isSelected = _selectedAccount?.id == acc.id;
            return GestureDetector(
              onTap: () => setState(() => _selectedAccount = acc),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GlassCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Icon(Boxicons.bx_check_circle, color: isSelected ? theme.primaryColor : subTextColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(acc.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(acc.details, style: TextStyle(color: subTextColor, fontSize: 12)),
                          ],
                        ),
                      ),
                      if (acc.isVerified)
                        const Icon(Boxicons.bxs_badge_check, color: AppColors.success, size: 18),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
        ],
        Text("Enter New Payout Details", style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (_selectedMethod?.id == 'bank') ...[
          TextField(
            controller: _bankNameController,
            decoration: const InputDecoration(labelText: "Bank Name", prefixIcon: Icon(Boxicons.bx_building)),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _accountNumberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Account Number", prefixIcon: Icon(Boxicons.bx_hash)),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _accountNameController,
            decoration: const InputDecoration(labelText: "Account Holder Name", prefixIcon: Icon(Boxicons.bx_user)),
          ),
        ] else if (_selectedMethod?.id == 'momo') ...[
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: "Mobile Number", prefixIcon: Icon(Boxicons.bx_phone)),
          ),
        ] else ...[
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: "Account Email", prefixIcon: Icon(Boxicons.bx_envelope)),
          ),
        ],
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text("Save account for future withdrawals", style: TextStyle(fontSize: 13)),
          value: _saveAccountToggle,
          onChanged: (val) => setState(() => _saveAccountToggle = val),
        ),
      ],
    );
  }

  // STEP 4: Amount Entry
  Widget _buildStep4Amount(ThemeData theme, Color subTextColor) {
    return Column(
      key: const ValueKey(3),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Withdrawal Amount",
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          "Specify the amount in USD to withdraw.",
          style: theme.textTheme.bodyMedium?.copyWith(color: subTextColor),
        ),
        const SizedBox(height: 24),
        TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            prefixText: "\$ ",
            labelText: "Amount (USD)",
            helperText: "Min: \$10.00  •  Max: \$10,000.00",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (val) {
            final parsed = double.tryParse(val);
            if (parsed != null) setState(() => _amount = parsed);
          },
        ),
        const SizedBox(height: 24),
        WithdrawalSummaryCard(
          amountUsd: _amount,
          rate: _selectedCurrency.rateToUsd,
          currencyCode: _selectedCurrency.code,
          feeUsd: 2.50,
          estimatedArrival: _selectedMethod?.estimatedTime ?? 'Instant',
        ),
      ],
    );
  }

  Widget _buildBottomBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: _nextStep,
          child: Text(
            _currentStep == 3 ? "Review Withdrawal" : "Continue",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}