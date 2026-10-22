import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
import 'package:noble_cards/screens/withraw/models/withdraw_bank_models.dart';
import 'package:noble_cards/screens/withraw/providers/withdraw_bank_provider.dart';

class FakeBankAuthenticationService extends AuthenticationService {
  FakeBankAuthenticationService({required this.getHandler, this.postResponse});

  final Future<Map<String, dynamic>> Function(String path) getHandler;
  final Map<String, dynamic>? postResponse;
  final List<String> getPaths = [];
  final List<String> postPaths = [];
  final List<Map<String, dynamic>> postBodies = [];

  @override
  Future<Map<String, dynamic>> authenticatedGet(String path) {
    getPaths.add(path);
    return getHandler(path);
  }

  @override
  Future<Map<String, dynamic>> authenticatedPost(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    postPaths.add(path);
    postBodies.add(body ?? <String, dynamic>{});
    return postResponse ?? {};
  }
}

WithdrawalDestination nigeria() => WithdrawalDestination(
  countryCode: 'NG',
  countryName: 'Nigeria',
  currency: 'NGN',
  flag: '',
);

WithdrawalDestination ghana() => WithdrawalDestination(
  countryCode: 'GH',
  countryName: 'Ghana',
  currency: 'GHS',
  flag: '',
);

WithdrawalDestination destination(String countryCode, String currency) =>
    WithdrawalDestination(
      countryCode: countryCode,
      countryName: countryCode,
      currency: currency,
      flag: '',
    );

void main() {
  test('maps manual bank-detail routes to their matching currencies', () async {
    for (final route in [('GB', 'GBP'), ('US', 'USD'), ('CA', 'CAD')]) {
      final auth = FakeBankAuthenticationService(
        getHandler: (path) async => {'banks': []},
      );
      final provider = WithdrawBankProvider(
        authService: auth,
        destination: destination(route.$1, route.$2),
      );
      await Future<void>.delayed(Duration.zero);

      expect(provider.destination.countryCode, route.$1);
      expect(provider.destination.currency, route.$2);
      expect(provider.isManualDetailsOnly, isTrue);
      expect(auth.getPaths, isEmpty);
      provider.dispose();
    }
  });

  test(
    'validates UK manual bank details and saves without claiming verification',
    () async {
      final auth = FakeBankAuthenticationService(
        getHandler: (path) async => {'banks': []},
        postResponse: {'id': 'beneficiary-uk-1'},
      );
      final provider = WithdrawBankProvider(
        authService: auth,
        destination: destination('GB', 'GBP'),
      );
      await Future<void>.delayed(Duration.zero);

      provider.updateAccountName('Jane Doe');
      provider.updateInstitutionName('Example Bank');
      provider.updateAccountNumber('00123456');
      provider.updateSortCode('12-34-56');
      provider.updateAccountType('personal');
      provider.updateStreetNumber('1');
      provider.updateStreetName('Example Street');
      provider.updateCity('London');
      provider.updateState('Greater London');
      provider.updatePostalCode('SW1A 1AA');
      provider.updateTransferReason('Personal transfer');
      expect(provider.isFormValid, isTrue);

      provider.updateSortCode('12345');
      expect(provider.isFormValid, isFalse);
      provider.updateSortCode('12-34-56');
      await provider.saveManualBeneficiaryDetails();

      expect(auth.postPaths.single, '/withdrawals/beneficiaries');
      expect(auth.postBodies.single['countryCode'], 'GB');
      expect(auth.postBodies.single['currencyCode'], 'GBP');
      expect(auth.postBodies.single['sortCode'], '12-34-56');
      expect(auth.postBodies.single['transferReason'], 'Personal transfer');
      expect(provider.manualDetailsSaved, isTrue);
      expect(provider.isVerified, isFalse);
      provider.dispose();
    },
  );

  test(
    'validates US routing and provider-documented international fields',
    () async {
      final auth = FakeBankAuthenticationService(
        getHandler: (path) async => {'banks': []},
      );
      final provider = WithdrawBankProvider(
        authService: auth,
        destination: destination('US', 'USD'),
      );
      await Future<void>.delayed(Duration.zero);

      provider.updateAccountName('Jane Doe');
      provider.updateInstitutionName('Example Bank');
      provider.updateAccountNumber('1234567890');
      provider.updateRoutingNumber('12345678');
      provider.updateSwiftCode('ABCDEF12');
      provider.updateAccountType('checking');
      provider.updateStreetNumber('1');
      provider.updateStreetName('Example Street');
      provider.updateCity('New York');
      provider.updateState('NY');
      provider.updatePostalCode('10001');
      expect(provider.isFormValid, isFalse);

      provider.updateRoutingNumber('123456789');
      expect(provider.isFormValid, isTrue);
      provider.dispose();
    },
  );

  test(
    'validates Canadian identifiers but keeps CAD payout details unverified',
    () async {
      final auth = FakeBankAuthenticationService(
        getHandler: (path) async => {'banks': []},
        postResponse: {'id': 'beneficiary-ca-1'},
      );
      final provider = WithdrawBankProvider(
        authService: auth,
        destination: destination('CA', 'CAD'),
      );
      await Future<void>.delayed(Duration.zero);

      provider.updateAccountName('Jane Doe');
      provider.updateInstitutionName('Example Bank');
      provider.updateAccountNumber('0012345678');
      provider.updateInstitutionNumber('12');
      provider.updateTransitNumber('1234');
      provider.updateStreetNumber('1');
      provider.updateStreetName('Example Street');
      provider.updateCity('Toronto');
      provider.updateState('ON');
      provider.updatePostalCode('M5V 2T6');
      expect(provider.isFormValid, isFalse);

      provider.updateInstitutionNumber('123');
      provider.updateTransitNumber('12345');
      expect(provider.isFormValid, isTrue);
      await provider.saveManualBeneficiaryDetails();
      expect(provider.manualDetailsSaved, isTrue);
      expect(provider.isVerified, isFalse);
      expect(
        provider.manualPayoutNotice,
        contains('CAD payout is not yet enabled'),
      );
      provider.dispose();
    },
  );

  test(
    'country switch prevents a stale bank response replacing Ghana banks',
    () async {
      final nigeriaResponse = Completer<Map<String, dynamic>>();
      final ghanaResponse = Completer<Map<String, dynamic>>();
      final auth = FakeBankAuthenticationService(
        getHandler: (path) => path.contains('countryCode=NG')
            ? nigeriaResponse.future
            : ghanaResponse.future,
      );
      final provider = WithdrawBankProvider(
        authService: auth,
        destination: nigeria(),
      );
      await Future<void>.delayed(Duration.zero);

      provider.setDestination(ghana());
      expect(provider.banks, isEmpty);
      await Future<void>.delayed(Duration.zero);
      expect(auth.getPaths, hasLength(2));
      expect(
        auth.getPaths,
        contains(
          '/withdrawals/banks?countryCode=GH&currencyCode=GHS&method=BANK_TRANSFER',
        ),
      );

      ghanaResponse.complete({
        'banks': [
          {
            'id': 'bank-gh-501',
            'code': 'GH-01',
            'name': 'Ghana Bank',
            'hasBranches': true,
          },
        ],
      });
      await Future<void>.delayed(Duration.zero);
      nigeriaResponse.complete({
        'banks': [
          {'id': 'bank-ng-44', 'code': '044', 'name': 'Access Bank'},
        ],
      });
      await Future<void>.delayed(Duration.zero);

      expect(provider.banks.single.code, 'GH-01');
      expect(provider.banks.single.hasBranches, isTrue);
      expect(provider.isLoadingBanks, isFalse);
      provider.dispose();
    },
  );

  test('loads and selects a real Ghana provider branch code', () async {
    final auth = FakeBankAuthenticationService(
      getHandler: (path) async {
        if (path.contains('/branches')) {
          return {
            'branches': [
              {'id': 'branch-id-1', 'code': 'BR-01', 'name': 'Accra Central'},
            ],
          };
        }
        return {
          'banks': [
            {
              'id': 'bank-provider-id',
              'code': 'GH-01',
              'name': 'Ghana Bank',
              'hasBranches': true,
            },
          ],
        };
      },
    );
    final provider = WithdrawBankProvider(
      authService: auth,
      destination: ghana(),
    );
    await Future<void>.delayed(Duration.zero);

    provider.selectBank(provider.banks.single);
    await Future<void>.delayed(Duration.zero);

    expect(
      auth.getPaths.last,
      '/withdrawals/banks/bank-provider-id/branches'
      '?countryCode=GH&currencyCode=GHS',
    );
    expect(provider.branches.single.code, 'BR-01');
    provider.updateAccountNumber('0012345678');
    expect(provider.isFormValid, isFalse);

    provider.selectBranch(provider.branches.single);
    expect(provider.isFormValid, isTrue);
    provider.dispose();
  });

  test(
    'surfaces bank load errors and retries without a fake bank list',
    () async {
      var attempts = 0;
      final auth = FakeBankAuthenticationService(
        getHandler: (path) async {
          attempts++;
          if (attempts == 1) throw StateError('provider unavailable');
          return {
            'banks': [
              {'id': '44', 'code': '044', 'name': 'Access Bank'},
            ],
          };
        },
      );
      final provider = WithdrawBankProvider(
        authService: auth,
        destination: nigeria(),
      );
      await Future<void>.delayed(Duration.zero);

      expect(provider.banks, isEmpty);
      expect(provider.bankError, contains('provider unavailable'));

      await provider.loadBanks();
      expect(provider.bankError, isNull);
      expect(provider.banks.single.code, '044');
      provider.dispose();
    },
  );

  test(
    'surfaces provider HTTP status safely in the existing error state',
    () async {
      final auth = FakeBankAuthenticationService(
        getHandler: (path) async {
          throw Exception(
            'PAYOUT_PROVIDER_REQUEST_FAILED: Flutterwave GET /banks/NG '
            'returned HTTP 400: An error occurred',
          );
        },
      );
      final provider = WithdrawBankProvider(
        authService: auth,
        destination: nigeria(),
      );
      await Future<void>.delayed(Duration.zero);

      expect(
        provider.bankErrorMessage,
        'Flutterwave bank request failed (HTTP 400): An error occurred',
      );
      provider.dispose();
    },
  );

  test(
    'does not accept an account name without confirmed verification status',
    () async {
      final auth = FakeBankAuthenticationService(
        getHandler: (path) async => {
          'banks': [
            {'id': '44', 'code': '044', 'name': 'Access Bank'},
          ],
        },
        postResponse: {'accountHolderName': 'Unverified Name'},
      );
      final provider = WithdrawBankProvider(
        authService: auth,
        destination: nigeria(),
      );
      await Future<void>.delayed(Duration.zero);
      provider.selectBank(provider.banks.single);
      provider.updateAccountNumber('0012345678');

      await expectLater(provider.verifyAccount(), throwsException);
      expect(provider.isVerified, isFalse);
      provider.dispose();
    },
  );

  test(
    'submits the selected provider bank code rather than its display name',
    () async {
      final auth = FakeBankAuthenticationService(
        getHandler: (path) async => {
          'banks': [
            {'id': 'provider-bank-id', 'code': '044', 'name': 'Access Bank'},
          ],
        },
        postResponse: {
          'verified': true,
          'verificationStatus': 'VERIFIED',
          'accountHolderName': 'Account Holder',
        },
      );
      final provider = WithdrawBankProvider(
        authService: auth,
        destination: nigeria(),
      );
      await Future<void>.delayed(Duration.zero);
      provider.selectBank(provider.banks.single);
      provider.updateAccountNumber('0012345678');

      await provider.verifyAccount();

      expect(auth.postPaths.single, '/withdrawals/beneficiaries/verify');
      expect(auth.postBodies.single['institutionCode'], '044');
      expect(auth.postBodies.single['institutionName'], 'Access Bank');
      provider.dispose();
    },
  );
}
