import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/pin_auth_dialog.dart'; // Reusing your existing PIN dialog
import 'models/withdrawal_request_model.dart';
import 'withdraw_processing_screen.dart';

// --- ENUMS & HELPERS FOR DYNAMIC UI ---
enum WithdrawalCategory {
  bank,
  paypal,
  wise,
  skrill,
  payoneer,
  mobileMoney,
  crypto,
  debitCard,
}

class _WithdrawalMethodData {
  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  final WithdrawalCategory category;
  final WithdrawalType type;
  final bool isComingSoon;

  const _WithdrawalMethodData({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.category,
    required this.type,
    this.isComingSoon = false,
  });
}

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  // Controllers
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocus = FocusNode();

  // Form Controllers
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountHolderController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cryptoAddressController =
      TextEditingController();
  final TextEditingController _cryptoMemoController = TextEditingController();

  // State
  double _amount = 0.0;
  _WithdrawalMethodData? _selectedMethod;
  bool _saveAccount = true;

  // Dropdown States
  String? _selectedCurrency = '🇺🇸 USD — US Dollar';
  String? _selectedCryptoCoin = 'USDT';
  String? _selectedCryptoNetwork = 'TRC20';
  String? _selectedMobileProvider = 'MTN Mobile Money';

  // Constants
  final List<_WithdrawalMethodData> _methods = const [
    _WithdrawalMethodData(
      id: 'bank',
      name: 'Bank Transfer',
      subtitle: 'Local or international banks',
      icon: Boxicons.bx_building_house,
      category: WithdrawalCategory.bank,
      type: WithdrawalType.bank,
    ),
    _WithdrawalMethodData(
      id: 'paypal',
      name: 'PayPal',
      subtitle: 'Send to PayPal wallet',
      icon: Boxicons.bxl_paypal,
      category: WithdrawalCategory.paypal,
      type: WithdrawalType.paypal,
    ),
    _WithdrawalMethodData(
      id: 'wise',
      name: 'Wise',
      subtitle: 'Fast global transfers',
      icon: Boxicons.bx_globe, // using globe as placeholder for wise
      category: WithdrawalCategory.wise,
      type: WithdrawalType.bank,
    ),
    _WithdrawalMethodData(
      id: 'skrill',
      name: 'Skrill',
      subtitle: 'Withdraw to Skrill',
      icon: Boxicons.bx_wallet_alt,
      category: WithdrawalCategory.skrill,
      type: WithdrawalType.bank,
    ),
    _WithdrawalMethodData(
      id: 'payoneer',
      name: 'Payoneer',
      subtitle: 'Send to Payoneer',
      icon: Boxicons.bx_briefcase,
      category: WithdrawalCategory.payoneer,
      type: WithdrawalType.bank,
    ),
    _WithdrawalMethodData(
      id: 'mobile_money',
      name: 'Mobile Money',
      subtitle: 'Supported mobile wallets',
      icon: Boxicons.bx_mobile_alt,
      category: WithdrawalCategory.mobileMoney,
      type: WithdrawalType.bank,
    ),
    _WithdrawalMethodData(
      id: 'crypto',
      name: 'Crypto Wallet',
      subtitle: 'Withdraw using crypto',
      icon: Boxicons.bx_bitcoin,
      category: WithdrawalCategory.crypto,
      type: WithdrawalType.crypto,
    ),
    _WithdrawalMethodData(
      id: 'debit',
      name: 'Debit Card',
      subtitle: 'Instant card payout',
      icon: Boxicons.bx_credit_card,
      category: WithdrawalCategory.debitCard,
      type: WithdrawalType.bank,
      isComingSoon: true,
    ),
  ];

  final List<String> _currencies = [
    '🇺🇸 USD — US Dollar',
    '🇪🇺 EUR — Euro',
    '🇬🇧 GBP — British Pound',
    '🇳🇬 NGN — Nigerian Naira',
    '🇨🇦 CAD — Canadian Dollar',
    '🇦🇺 AUD — Australian Dollar',
    '🇦🇪 AED — UAE Dirham',
    '🇯🇵 JPY — Japanese Yen',
    '🇨🇭 CHF — Swiss Franc',
    '🇸🇬 SGD — Singapore Dollar',
    '🇬🇭 GHS — Ghanaian Cedi',
    '🇰🇪 KES — Kenyan Shilling',
    '🇲🇽 MXN — Mexican Peso',
    '🇿🇦 ZAR — South African Rand',
    '🇮🇳 INR — Indian Rupee',
    '🇨🇳 CNY — Chinese Yuan',
    '🇧🇷 BRL — Brazilian Real',
    '🇹🇷 TRY — Turkish Lira',
    '🇸🇪 SEK — Swedish Krona',
    '🇳🇴 NOK — Norwegian Krone',
  ];

  @override
  void initState() {
    super.initState();
    _selectedMethod = _methods.first;
    _amountController.addListener(_onAmountChanged);
  }

  void _onAmountChanged() {
    setState(() {
      _amount =
          double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0.0;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocus.dispose();
    _bankAccountController.dispose();
    _bankNameController.dispose();
    _accountHolderController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cryptoAddressController.dispose();
    _cryptoMemoController.dispose();
    super.dispose();
  }

  // Quick Amount Math
  void _addAmount(double value) {
    setState(() {
      _amount += value;
      _amountController.text = _amount.toStringAsFixed(0);
    });
  }

  void _setMaxAmount() {
    setState(() {
      _amount = 5420.00; // Mock Max Balance
      _amountController.text = _amount.toStringAsFixed(0);
    });
  }

  double get _fee {
    if (_amount <= 0) return 0;
    // Dynamic fee based on method
    if (_selectedMethod?.category == WithdrawalCategory.crypto)
      return 1.50; // Fixed network fee
    return 2.5 + (_amount * 0.01);
  }

  double get _exchangeRate => 1650.0; // Mock USD to NGN exchange rate

  void _processWithdrawal() async {
    if (_amount <= 0) return;

    // 1. Authenticate with existing PIN Dialog
    final bool? isAuthenticated = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => PinAuthDialog(onSuccess: (_) {}),
    );

    if (isAuthenticated != true) return;

    // 2. Build model and navigate
    final request = WithdrawalRequestModel(
      amount: _amount,
      currency: _selectedCurrency?.substring(3, 6) ?? 'USD',
      method: WithdrawalMethod(
        id: _selectedMethod!.id,
        name: _selectedMethod!.name,
        subtitle: _selectedMethod!.subtitle,
        icon: _selectedMethod!.icon,
        type: _selectedMethod!.type,
      ),
      destinationAccount: _getDestinationString(),
      accountName: _accountHolderController.text.isNotEmpty
          ? _accountHolderController.text
          : 'You',
      fee: _fee,
      netAmount: _amount - _fee,
      referenceNumber:
          'WTH-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WithdrawProcessingScreen(request: request),
        ),
      );
    }
  }

  String _getDestinationString() {
    switch (_selectedMethod?.category) {
      case WithdrawalCategory.bank:
        return _bankAccountController.text;
      case WithdrawalCategory.crypto:
        return _cryptoAddressController.text;
      case WithdrawalCategory.mobileMoney:
        return _phoneController.text;
      default:
        return _emailController.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scaffoldBg = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Withdraw Funds',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Boxicons.bx_chevron_left, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    _buildAmountInput(theme),
                    const SizedBox(height: AppSpacing.xl),
                    _buildSavedAccountsSlider(theme, isDark),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Withdrawal Method',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildMethodGrid(theme, isDark),
                    const SizedBox(height: AppSpacing.xl),
                    _buildDynamicFormContainer(theme, isDark),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
            _buildBottomSummaryAndAction(theme, isDark),
          ],
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildAmountInput(ThemeData theme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '\$',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            IntrinsicWidth(
              child: TextField(
                controller: _amountController,
                focusNode: _amountFocus,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.center,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 48,
                ),
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 48,
                    color: theme.hintColor.withValues(alpha: 0.3),
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            _buildAmountChip(theme, '+\$50', () => _addAmount(50)),
            _buildAmountChip(theme, '+\$100', () => _addAmount(100)),
            _buildAmountChip(theme, '+\$250', () => _addAmount(250)),
            _buildAmountChip(theme, '+\$500', () => _addAmount(500)),
            _buildAmountChip(theme, 'MAX', _setMaxAmount, isMax: true),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountChip(
    ThemeData theme,
    String label,
    VoidCallback onTap, {
    bool isMax = false,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isMax
        ? AppColors.primary.withValues(alpha: 0.15)
        : (isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.04));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isMax
                ? AppColors.primary.withValues(alpha: 0.3)
                : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isMax
                ? AppColors.primary
                : theme.textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }

  Widget _buildSavedAccountsSlider(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saved Accounts',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildSavedAccountCard(
                theme,
                isDark,
                'GTBank',
                '•••• 4512',
                Boxicons.bx_building_house,
                true,
              ),
              const SizedBox(width: AppSpacing.md),
              _buildSavedAccountCard(
                theme,
                isDark,
                'Binance',
                '0x7F...9A',
                Boxicons.bx_bitcoin,
                false,
              ),
              const SizedBox(width: AppSpacing.md),
              _buildSavedAccountCard(
                theme,
                isDark,
                'PayPal',
                'john@•••.com',
                Boxicons.bxl_paypal,
                false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSavedAccountCard(
    ThemeData theme,
    bool isDark,
    String name,
    String details,
    IconData icon,
    bool isDefault,
  ) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: theme.iconTheme.color),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isDefault) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'DEFAULT',
                        style: TextStyle(
                          fontSize: 9,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                details,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Icon(
            Boxicons.bx_dots_vertical_rounded,
            size: 20,
            color: theme.hintColor,
          ),
        ],
      ),
    );
  }

  Widget _buildMethodGrid(ThemeData theme, bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.4,
      ),
      itemCount: _methods.length,
      itemBuilder: (context, index) {
        final method = _methods[index];
        final isSelected = _selectedMethod?.id == method.id;

        return GestureDetector(
          onTap: method.isComingSoon
              ? null
              : () {
                  setState(() {
                    _selectedMethod = method;
                    _amountFocus
                        .unfocus(); // dismiss keyboard smoothly on method change
                  });
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08)
                  : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.05)),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                else if (!isDark)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      method.icon,
                      color: method.isComingSoon
                          ? theme.hintColor.withValues(alpha: 0.5)
                          : (isSelected
                                ? AppColors.primary
                                : theme.iconTheme.color),
                      size: 28,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      method.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: method.isComingSoon
                            ? theme.hintColor.withValues(alpha: 0.5)
                            : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      method.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: method.isComingSoon
                            ? theme.hintColor.withValues(alpha: 0.3)
                            : theme.hintColor,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                if (method.isComingSoon)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'SOON',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDynamicFormContainer(ThemeData theme, bool isDark) {
    if (_selectedMethod == null) return const SizedBox.shrink();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Container(
        key: ValueKey<String>(_selectedMethod!.id),
        child: _getFormForCategory(_selectedMethod!.category, theme, isDark),
      ),
    );
  }

  Widget _getFormForCategory(
    WithdrawalCategory category,
    ThemeData theme,
    bool isDark,
  ) {
    switch (category) {
      case WithdrawalCategory.bank:
        return _buildBankForm(theme, isDark);
      case WithdrawalCategory.paypal:
      case WithdrawalCategory.wise:
      case WithdrawalCategory.skrill:
      case WithdrawalCategory.payoneer:
        return _buildEmailForm(theme, category);
      case WithdrawalCategory.mobileMoney:
        return _buildMobileMoneyForm(theme);
      case WithdrawalCategory.crypto:
        return _buildCryptoForm(theme, isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBankForm(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(theme, 'Receiving Currency'),
        DropdownMenu<String>(
          initialSelection: _selectedCurrency,
          width: MediaQuery.of(context).size.width - (AppSpacing.lg * 2),
          enableFilter: true,
          requestFocusOnTap: true,
          menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(theme.cardColor),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          inputDecorationTheme: _dropdownInputDecoration(theme),
          onSelected: (val) => setState(() => _selectedCurrency = val),
          dropdownMenuEntries: _currencies
              .map((c) => DropdownMenuEntry(value: c, label: c))
              .toList(),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildLabel(theme, 'Country'),
        _buildTextField(theme, hint: 'e.g. Nigeria'),
        const SizedBox(height: AppSpacing.md),
        _buildLabel(theme, 'Bank Name'),
        _buildTextField(
          theme,
          controller: _bankNameController,
          hint: 'Select or type bank name',
        ),
        const SizedBox(height: AppSpacing.md),
        _buildLabel(theme, 'Account Number'),
        _buildTextField(
          theme,
          controller: _bankAccountController,
          hint: '10-12 digit account number',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildLabel(theme, 'Account Holder Name'),
        _buildTextField(
          theme,
          controller: _accountHolderController,
          hint: 'Exact name on account',
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildSaveAccountToggle(theme),
      ],
    );
  }

  Widget _buildEmailForm(ThemeData theme, WithdrawalCategory category) {
    String provider = category.name.capitalize();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(theme, '$provider Email Address'),
        _buildTextField(
          theme,
          controller: _emailController,
          hint: 'Enter your $provider email',
          keyboardType: TextInputType.emailAddress,
          icon: Boxicons.bx_envelope,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildSaveAccountToggle(theme),
      ],
    );
  }

  Widget _buildMobileMoneyForm(ThemeData theme) {
    final providers = [
      'MTN Mobile Money',
      'Telecel Cash',
      'Airtel Money',
      'Orange Money',
      'M-Pesa',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(theme, 'Country'),
        _buildTextField(theme, hint: 'e.g. Ghana'),
        const SizedBox(height: AppSpacing.md),
        _buildLabel(theme, 'Provider'),
        DropdownMenu<String>(
          initialSelection: _selectedMobileProvider,
          width: MediaQuery.of(context).size.width - (AppSpacing.lg * 2),
          inputDecorationTheme: _dropdownInputDecoration(theme),
          onSelected: (val) => setState(() => _selectedMobileProvider = val),
          dropdownMenuEntries: providers
              .map((p) => DropdownMenuEntry(value: p, label: p))
              .toList(),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildLabel(theme, 'Mobile Number'),
        _buildTextField(
          theme,
          controller: _phoneController,
          hint: '+233 54 123 4567',
          keyboardType: TextInputType.phone,
          icon: Boxicons.bx_phone,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildSaveAccountToggle(theme),
      ],
    );
  }

  Widget _buildCryptoForm(ThemeData theme, bool isDark) {
    final coins = ['USDT', 'USDC', 'BTC', 'ETH', 'BNB', 'SOL'];
    final networks = [
      'TRC20',
      'ERC20',
      'BEP20',
      'Polygon',
      'Arbitrum',
      'Optimism',
      'Solana',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(theme, 'Coin'),
                  DropdownMenu<String>(
                    initialSelection: _selectedCryptoCoin,
                    width:
                        (MediaQuery.of(context).size.width -
                            (AppSpacing.lg * 2) -
                            AppSpacing.md) /
                        2,
                    inputDecorationTheme: _dropdownInputDecoration(theme),
                    onSelected: (val) =>
                        setState(() => _selectedCryptoCoin = val),
                    dropdownMenuEntries: coins
                        .map((c) => DropdownMenuEntry(value: c, label: c))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(theme, 'Network'),
                  DropdownMenu<String>(
                    initialSelection: _selectedCryptoNetwork,
                    width:
                        (MediaQuery.of(context).size.width -
                            (AppSpacing.lg * 2) -
                            AppSpacing.md) /
                        2,
                    inputDecorationTheme: _dropdownInputDecoration(theme),
                    onSelected: (val) =>
                        setState(() => _selectedCryptoNetwork = val),
                    dropdownMenuEntries: networks
                        .map((n) => DropdownMenuEntry(value: n, label: n))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _buildLabel(theme, 'Wallet Address'),
        _buildTextField(
          theme,
          controller: _cryptoAddressController,
          hint: 'Paste address here',
          icon: Boxicons.bx_wallet,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildLabel(theme, 'Memo / Tag (Optional)'),
        _buildTextField(
          theme,
          controller: _cryptoMemoController,
          hint: 'Required for some exchanges',
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildSaveAccountToggle(theme),
      ],
    );
  }

  // --- REUSABLE FORM ELEMENTS ---

  Widget _buildLabel(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.hintColor,
        ),
      ),
    );
  }

  Widget _buildTextField(
    ThemeData theme, {
    TextEditingController? controller,
    String? hint,
    TextInputType? keyboardType,
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.hintColor.withValues(alpha: 0.5),
        ),
        prefixIcon: icon != null
            ? Icon(icon, color: theme.hintColor, size: 20)
            : null,
        filled: true,
        fillColor: theme.brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.black.withValues(alpha: 0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  InputDecorationTheme _dropdownInputDecoration(ThemeData theme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: theme.brightness == Brightness.dark
          ? Colors.white.withValues(alpha: 0.03)
          : Colors.black.withValues(alpha: 0.03),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppColors.primary.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildSaveAccountToggle(ThemeData theme) {
    return Row(
      children: [
        Switch.adaptive(
          value: _saveAccount,
          activeColor: AppColors.primary,
          onChanged: (val) => setState(() => _saveAccount = val),
        ),
        const SizedBox(width: 8),
        Text(
          'Save this account for future withdrawals',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  // --- BOTTOM SUMMARY & ACTION ---

  Widget _buildBottomSummaryAndAction(ThemeData theme, bool isDark) {
  final netAmount = _amount > _fee ? _amount - _fee : 0.0;
  final convertedAmount = netAmount * _exchangeRate;
  final showExchange = _selectedMethod?.category == WithdrawalCategory.bank && 
                       _selectedCurrency?.contains('NGN') == true;

  return Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF151515) : Colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(32), 
        topRight: Radius.circular(32),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
          blurRadius: 20,
          offset: const Offset(0, -5),
        )
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Smoothly expands when _amount > 0
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _amount > 0
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Processing Fee', style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
                        Text('\$${_fee.toStringAsFixed(2)}', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    if (showExchange) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Exchange Rate', style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
                          Text('1 USD = ₦${_exchangeRate.toStringAsFixed(0)}', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    const Divider(),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('You\'ll Receive', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Est. arrival: ${showExchange ? '1-3 Business Days' : 'Instant'}', style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                          ],
                        ),
                        Text(
                          showExchange ? '₦${convertedAmount.toStringAsFixed(2)}' : '\$${netAmount.toStringAsFixed(2)}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                )
              : const SizedBox.shrink(),
        ),

        // Action Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _amount > 0 && _selectedMethod != null ? _processWithdrawal : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    ),
  );
}
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}


