class WithdrawCountry {
  final String id;
  final String name;
  final String currency;
  final double exchangeRate;
  final String flagInitials; // Fallback for flag
  final List<String> supportedMethodIds;

  WithdrawCountry({
    required this.id,
    required this.name,
    required this.currency,
    required this.exchangeRate,
    required this.flagInitials,
    required this.supportedMethodIds,
  });

  String get currencySymbol {
    switch (currency) {
      case 'NGN':
        return '₦';
      case 'GHS':
        return 'GH₵';
      case 'GBP':
        return '£';
      case 'USD':
        return '\$';
      case 'CAD':
        return 'C\$';
      default:
        return '';
    }
  }
}
