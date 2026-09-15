import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
import 'package:noble_cards/screens/withraw/models/withdraw_bank_models.dart';
import 'package:noble_cards/screens/withraw/providers/withdraw_bank_provider.dart';
import 'package:noble_cards/screens/withraw/withdraw_bank_details_screen.dart';

class FakeAuthenticationService extends AuthenticationService {
  FakeAuthenticationService(this.banks);

  final List<Map<String, dynamic>> banks;
  final List<String> requests = [];

  @override
  Future<Map<String, dynamic>> authenticatedGet(String path) async {
    requests.add(path);
    return {'banks': banks};
  }
}

WithdrawalDestination destination(String countryCode, String currency) {
  return WithdrawalDestination(
    countryCode: countryCode,
    countryName: countryCode == 'GH' ? 'Ghana' : 'Nigeria',
    currency: currency,
    flag: countryCode == 'GH' ? '🇬🇭' : '🇳🇬',
  );
}

Future<WithdrawBankProvider> loadProvider({
  required WithdrawalDestination destination,
  required FakeAuthenticationService authService,
}) async {
  final provider = WithdrawBankProvider(
    authService: authService,
    destination: destination,
  );
  await provider.loadBanks();
  return provider;
}

void main() {
  test(
    'Nigeria bank list uses the NG bank route and returns Nigerian banks',
    () async {
      final auth = FakeAuthenticationService([
        {'id': 'ng-1', 'code': '044', 'name': 'Access Bank'},
      ]);
      final provider = await loadProvider(
        destination: destination('NG', 'NGN'),
        authService: auth,
      );

      expect(provider.banks.map((bank) => bank.name), ['Access Bank']);
      expect(
        auth.requests.last,
        contains('countryCode=NG&currencyCode=NGN&method=BANK_TRANSFER'),
      );
    },
  );

  test(
    'Ghana bank list uses the GH bank route and does not display Nigerian banks',
    () async {
      final auth = FakeAuthenticationService([
        {'id': 'gh-1', 'code': 'GH001', 'name': 'Ghana Bank'},
      ]);
      final provider = await loadProvider(
        destination: destination('GH', 'GHS'),
        authService: auth,
      );

      expect(provider.banks.map((bank) => bank.name), ['Ghana Bank']);
      expect(provider.banks.any((bank) => bank.name == 'Access Bank'), isFalse);
      expect(
        auth.requests.last,
        contains('countryCode=GH&currencyCode=GHS&method=BANK_TRANSFER'),
      );
    },
  );

  testWidgets('Nigeria shows Select Bank before selection', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: WithdrawBankDetailsScreen(
          destination: destination('NG', 'NGN'),
          paymentMethod: 'BANK_TRANSFER',
          sourceAmount: 100,
          authService: FakeAuthenticationService([]),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Select Bank'), findsOneWidget);
  });

  testWidgets('Ghana shows the same Select Bank UI before selection', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: WithdrawBankDetailsScreen(
          destination: destination('GH', 'GHS'),
          paymentMethod: 'BANK_TRANSFER',
          sourceAmount: 100,
          authService: FakeAuthenticationService([]),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1. Bank'), findsOneWidget);
    expect(find.text('Select Bank'), findsOneWidget);
    expect(find.text('Tap to select your bank'), findsNothing);
  });
}
