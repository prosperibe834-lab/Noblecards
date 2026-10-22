import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
import 'package:noble_cards/screens/withraw/models/withdraw_bank_models.dart';
import 'package:noble_cards/screens/withraw/models/withdrawal_transaction_model.dart';
import 'package:noble_cards/screens/withraw/providers/withdraw_bank_provider.dart';
import 'package:noble_cards/screens/withraw/withdraw_bank_details_screen.dart';
import 'package:noble_cards/screens/withraw/withdraw_success_screen.dart';
import 'package:noble_cards/screens/withraw/withdrawal_receipt_screen.dart';

class _FakeAuthService extends AuthenticationService {
  final Map<String, dynamic> beneficiariesResponse;
  final Map<String, dynamic> banksResponse;

  _FakeAuthService({
    required this.beneficiariesResponse,
    required this.banksResponse,
  });

  @override
  Future<Map<String, dynamic>> authenticatedGet(String path) async {
    if (path.contains('/withdrawals/beneficiaries')) {
      return beneficiariesResponse;
    }
    if (path.contains('/withdrawals/banks')) {
      return banksResponse;
    }
    return {};
  }
}

void main() {
  test('SavedBeneficiary parses properly from JSON', () {
    final json = {
      'id': 'ben-1',
      'countryCode': 'NG',
      'currency': 'NGN',
      'method': 'BANK_TRANSFER',
      'institutionName': 'ACCESS BANK NIGERIA',
      'providerBankCode': '044',
      'accountHolderName': 'Alexis Sanchez',
      'accountLast4': '0040',
      'verificationStatus': 'VERIFIED',
    };

    final ben = SavedBeneficiary.fromJson(json);
    expect(ben.id, 'ben-1');
    expect(ben.countryCode, 'NG');
    expect(ben.institutionName, 'ACCESS BANK NIGERIA');
    expect(ben.accountHolderName, 'Alexis Sanchez');
    expect(ben.maskedAccount, '•••• 0040');
    expect(ben.isVerified, isTrue);
  });

  testWidgets(
    'WithdrawBankDetailsScreen renders saved accounts and allows 1-tap selection',
    (tester) async {
      final fakeAuth = _FakeAuthService(
        beneficiariesResponse: {
          'beneficiaries': [
            {
              'id': 'ben-1',
              'countryCode': 'NG',
              'currency': 'NGN',
              'method': 'BANK_TRANSFER',
              'institutionName': 'ACCESS BANK NIGERIA',
              'providerBankCode': '044',
              'accountHolderName': 'Alexis Sanchez',
              'accountLast4': '0040',
              'verificationStatus': 'VERIFIED',
            },
          ],
        },
        banksResponse: {
          'banks': [
            {'id': '044', 'name': 'ACCESS BANK NIGERIA', 'code': '044'},
          ],
        },
      );

      final destination = WithdrawalDestination(
        countryCode: 'NG',
        countryName: 'Nigeria',
        currency: 'NGN',
        flag: '🇳🇬',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: WithdrawBankDetailsScreen(
            destination: destination,
            paymentMethod: 'BANK_TRANSFER',
            sourceAmount: 100,
            authService: fakeAuth,
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Saved Accounts'), findsOneWidget);
      expect(find.text('ACCESS BANK NIGERIA'), findsOneWidget);
      expect(find.text('Alexis Sanchez'), findsOneWidget);
      expect(find.textContaining('0040'), findsOneWidget);
      expect(find.text('Proceed to Review'), findsOneWidget);

      // Switch to manual mode
      await tester.ensureVisible(find.text('Use another bank account'));
      await tester.tap(find.text('Use another bank account'));
      await tester.pumpAndSettle();

      expect(find.text('Select Bank'), findsOneWidget);
      expect(find.text('Saved accounts available'), findsOneWidget);

      // Switch back to saved mode
      await tester.tap(find.text('Select Saved'));
      await tester.pumpAndSettle();

      expect(find.text('Saved Accounts'), findsOneWidget);
      expect(find.text('Proceed to Review'), findsOneWidget);
    },
  );

  testWidgets(
    'WithdrawSuccessScreen enables View Receipt and Done buttons',
    (tester) async {
      final tx = WithdrawalTransactionModel(
        amount: 100,
        sourceAmount: 100,
        sourceCurrency: 'USD',
        destinationAmount: 133441.64,
        destinationCurrency: 'NGN',
        currency: 'NGN',
        exchangeRate: 1334.42,
        fee: 8006.50,
        method: 'Bank Transfer',
        destinationCountry: 'Nigeria',
        countryFlag: '🇳🇬',
        destinationBank: 'ACCESS BANK NIGERIA',
        destinationAccountMasked: '•••• 0040',
        referenceId: 'WD-TEST-REF',
        timestamp: DateTime.now(),
        status: 'SUCCESSFUL',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: WithdrawSuccessScreen(transaction: tx),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Withdrawal Successful!'), findsOneWidget);
      expect(find.text('View Receipt'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);

      // Tap View Receipt opens receipt screen
      await tester.ensureVisible(find.text('View Receipt'));
      await tester.tap(find.text('View Receipt'));
      await tester.pumpAndSettle();

      expect(find.byType(WithdrawalReceiptScreen), findsOneWidget);
    },
  );
}
