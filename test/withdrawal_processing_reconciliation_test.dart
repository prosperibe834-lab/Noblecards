import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
import 'package:noble_cards/screens/withraw/models/withdrawal_transaction_model.dart';
import 'package:noble_cards/screens/withraw/withdraw_processing_screen.dart';
import 'package:noble_cards/screens/withraw/withdraw_success_screen.dart';

class _UncertainExecutionAuthenticationService extends AuthenticationService {
  final List<String> postPaths = [];
  final List<String> getPaths = [];

  @override
  Future<Map<String, dynamic>> authenticatedPost(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    postPaths.add(path);
    if (path.endsWith('/execute')) {
      throw TimeoutException('Provider response timed out');
    }
    if (path.endsWith('/reconcile')) {
      return {'status': 'SUCCESSFUL'};
    }
    throw StateError('Unexpected POST path: $path');
  }

  @override
  Future<Map<String, dynamic>> authenticatedGet(String path) async {
    getPaths.add(path);
    return {'status': 'PROCESSING'};
  }
}

void main() {
  testWidgets(
    'uncertain execution reconciles status without submitting another payout',
    (tester) async {
      final authService = _UncertainExecutionAuthenticationService();
      final transaction = WithdrawalTransactionModel(
        amount: 50,
        sourceAmount: 50,
        sourceCurrency: 'USD',
        destinationAmount: 49.5,
        destinationCurrency: 'USD',
        currency: 'USD',
        method: 'Bank Transfer',
        destinationCountry: 'United Kingdom',
        countryFlag: '',
        destinationBank: 'Barclays',
        destinationAccountMasked: '****1234',
        referenceId: 'WD-REF-1',
        timestamp: DateTime.utc(2026, 6, 14),
        status: 'UNDER_REVIEW',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: WithdrawProcessingScreen(
            transaction: transaction,
            withdrawalId: 'withdrawal-1',
            authService: authService,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(authService.postPaths, [
        '/withdrawals/withdrawal-1/execute',
        '/withdrawals/withdrawal-1/reconcile',
      ]);
      expect(authService.getPaths, ['/withdrawals/withdrawal-1']);
      expect(find.byType(WithdrawSuccessScreen), findsOneWidget);
      expect(find.text('Withdrawal Successful!'), findsOneWidget);
    },
  );
}
