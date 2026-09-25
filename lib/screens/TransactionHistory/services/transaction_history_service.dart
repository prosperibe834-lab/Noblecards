import '../models/transaction_history_model.dart';

class TransactionHistoryService {
  // Simulates fetching data from the NestJS backend
  Future<List<TransactionHistoryModel>> fetchTransactions() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    
    return [
      TransactionHistoryModel(
        id: '1',
        type: TransactionType.deposit,
        method: 'Bank Transfer',
        date: DateTime(2025, 4, 28, 10, 24),
        amount: 250.00,
        status: TransactionStatus.completed,
      ),
      TransactionHistoryModel(
        id: '2',
        type: TransactionType.withdrawal,
        method: 'Mobile Money',
        date: DateTime(2025, 4, 27, 16, 15),
        amount: 100.00,
        status: TransactionStatus.completed,
      ),
      TransactionHistoryModel(
        id: '3',
        type: TransactionType.deposit,
        method: 'Bank Transfer',
        date: DateTime(2025, 4, 26, 11, 30),
        amount: 500.00,
        status: TransactionStatus.completed,
      ),
      TransactionHistoryModel(
        id: '4',
        type: TransactionType.withdrawal,
        method: 'USDT (TRC20)',
        date: DateTime(2025, 4, 24, 21, 12),
        amount: 200.00,
        status: TransactionStatus.completed,
      ),
      TransactionHistoryModel(
        id: '5',
        type: TransactionType.deposit,
        method: 'Credit Card',
        date: DateTime(2025, 4, 22, 14, 45),
        amount: 150.00,
        status: TransactionStatus.completed,
      ),
      TransactionHistoryModel(
        id: '6',
        type: TransactionType.withdrawal,
        method: 'Bank Transfer',
        date: DateTime(2025, 4, 20, 9, 00),
        amount: 1250.00,
        status: TransactionStatus.pending,
      ),
    ];
  }
}