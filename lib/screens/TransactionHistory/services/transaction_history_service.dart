import '../../authentication/services/authentication_service.dart';
import '../models/transaction_history_model.dart';

class TransactionHistoryService {
  final AuthenticationService _authentication;

  TransactionHistoryService({AuthenticationService? authentication})
    : _authentication = authentication ?? AuthenticationService();

  Future<List<TransactionHistoryModel>> fetchTransactions() async {
    final responses = await Future.wait([
      _authentication.authenticatedGetList('/deposits'),
      _authentication.authenticatedGetList('/withdrawals'),
    ]);

    final transactions = <TransactionHistoryModel>[];
    transactions.addAll(mapBackendTransactions(responses[0]));
    transactions.addAll(mapBackendTransactions(responses[1]));
    transactions.sort((left, right) => right.date.compareTo(left.date));

    return transactions;
  }

  Future<Map<String, dynamic>> fetchDepositDetails(String depositId) {
    return _fetchDetails('/deposits', depositId);
  }

  Future<Map<String, dynamic>> fetchWithdrawalDetails(String withdrawalId) {
    return _fetchDetails('/withdrawals', withdrawalId);
  }

  Future<Map<String, dynamic>> _fetchDetails(String endpoint, String id) async {
    if (id.trim().isEmpty) {
      throw const FormatException('Transaction record has no ID.');
    }
    return _authentication.authenticatedGet('$endpoint/${Uri.encodeComponent(id)}');
  }

  static List<TransactionHistoryModel> mapBackendTransactions(List<dynamic> rawItems) {
    final mapped = <TransactionHistoryModel>[];

    for (final rawItem in rawItems) {
      if (rawItem is! Map) {
        throw const FormatException('Transaction response contained a non-object record.');
      }
      final item = Map<String, dynamic>.from(rawItem);
      final hasWithdrawalFields = item.containsKey('sourceAmount') || item.containsKey('sourceCurrencyCode');
      if (hasWithdrawalFields) {
        mapped.add(_mapWithdrawal(item));
        continue;
      }
      mapped.add(_mapDeposit(item));
    }

    mapped.sort((left, right) => right.date.compareTo(left.date));
    return mapped;
  }

  static TransactionHistoryModel _mapDeposit(Map<String, dynamic> item) {
    final rawStatus = (item['status'] ?? item['transaction']?['status'] ?? 'PENDING').toString();
    final currency = (item['currency'] ?? item['currencyCode'] ?? 'USD').toString().toUpperCase();
    final usdAmount = item['netAmount'] ?? item['amount'];
    if (item['netAmount'] == null && currency != 'USD') {
      throw FormatException('Deposit response has no USD netAmount for $currency.');
    }
    final amount = _parseAmount(usdAmount);
    final method = _methodLabel(
      item['paymentMethod'] ?? item['provider'] ?? item['method'] ?? 'Bank Transfer',
    );
    final date = _parseDate(item['createdAt'] ?? item['updatedAt']);

    return TransactionHistoryModel(
      id: (item['id'] ?? '').toString(),
      type: TransactionType.deposit,
      method: method,
      date: date,
      amount: amount,
      status: _mapStatus(rawStatus),
      currency: 'USD',
    );
  }

  static TransactionHistoryModel _mapWithdrawal(Map<String, dynamic> item) {
    final rawStatus = (item['status'] ?? item['transaction']?['status'] ?? 'PENDING').toString();
    final currency = (item['currency'] ?? item['destinationCurrency'] ?? item['destinationCurrencyCode'] ?? item['sourceCurrencyCode'] ?? 'USD').toString().toUpperCase();
    final amount = _parseAmount(item['sourceAmount'] ?? item['amount'] ?? item['destinationAmount'] ?? 0);
    final method = _methodLabel(item['paymentMethod'] ?? item['provider'] ?? item['method'] ?? 'Bank Transfer');
    final date = _parseDate(item['createdAt'] ?? item['updatedAt']);

    return TransactionHistoryModel(
      id: (item['id'] ?? '').toString(),
      type: TransactionType.withdrawal,
      method: method,
      date: date,
      amount: amount,
      status: _mapStatus(rawStatus),
      currency: currency,
    );
  }

  static DateTime _parseDate(Object? value) {
    final raw = value?.toString();
    final parsed = raw == null || raw.isEmpty ? null : DateTime.tryParse(raw);
    if (parsed == null) {
      throw FormatException('Transaction record has an invalid createdAt date: $value');
    }
    return parsed;
  }

  static double _parseAmount(Object? value) {
    if (value == null) {
      throw const FormatException('Transaction record has no amount.');
    }
    if (value is num) return value.toDouble();
    final numeric = value.toString().replaceAll(',', '').trim();
    final parsed = double.tryParse(numeric);
    if (parsed == null) {
      throw FormatException('Transaction record has an invalid amount: $value');
    }
    return parsed;
  }

  static TransactionStatus _mapStatus(String rawStatus) {
    switch (rawStatus.toUpperCase()) {
      case 'SUCCESSFUL':
      case 'COMPLETED':
        return TransactionStatus.completed;
      case 'PROCESSING':
        return TransactionStatus.processing;
      case 'PENDING':
        return TransactionStatus.pending;
      case 'FAILED':
      case 'REJECTED':
        return TransactionStatus.failed;
      case 'CANCELLED':
      case 'CANCELED':
        return TransactionStatus.cancelled;
      default:
        return TransactionStatus.pending;
    }
  }

  static String _methodLabel(String raw) {
    final normalized = raw.toString().trim();
    if (normalized.isEmpty) return 'Bank Transfer';

    switch (normalized.toUpperCase()) {
      case 'BANK_TRANSFER':
        return 'Bank Transfer';
      case 'CARD':
        return 'Card';
      case 'MOBILE_MONEY':
        return 'Mobile Money';
      case 'USSD':
        return 'USSD';
      case 'APPLE_PAY':
        return 'Apple Pay';
      case 'GOOGLE_PAY':
        return 'Google Pay';
      case 'WISE':
        return 'Wise';
      case 'WALLET_TRANSFER':
        return 'Wallet Transfer';
      case 'FLUTTERWAVE':
        return 'Flutterwave';
      default:
        return normalized;
    }
  }
}