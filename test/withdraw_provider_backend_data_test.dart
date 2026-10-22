import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
import 'package:noble_cards/screens/withraw/providers/withdraw_provider.dart';
import 'package:noble_cards/screens/withraw/widgets/withdraw_summary_card.dart';

class FakeWithdrawalAuthenticationService extends AuthenticationService {
  FakeWithdrawalAuthenticationService({
    this.quoteRequest,
    this.previewRequest,
    this.balances = const [
      {'currency': 'USD', 'availableBalance': '500.00'},
    ],
  });

  final List<dynamic> balances;
  Future<Map<String, dynamic>> Function(Map<String, dynamic>)? quoteRequest;
  Future<Map<String, dynamic>> Function(Map<String, dynamic>)? previewRequest;
  final List<Map<String, dynamic>> requestedQuotes = [];
  final List<Map<String, dynamic>> requestedPreviews = [];

  @override
  Future<List<dynamic>> authenticatedGetList(String path) async {
    expect(path, '/wallet/balances');
    return balances;
  }

  @override
  Future<Map<String, dynamic>> authenticatedPost(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final request = body ?? <String, dynamic>{};
    if (path == '/withdrawals/quotes/preview') {
      requestedPreviews.add(request);
      return previewRequest!(request);
    }
    expect(path, '/withdrawals/quotes');
    requestedQuotes.add(request);
    return quoteRequest!(request);
  }
}

Map<String, dynamic> quoteFor(Map<String, dynamic> request) {
  final amount = double.parse(request['sourceAmount'] as String);
  final rate = switch (request['destinationCurrencyCode']) {
    'GBP' => 0.75,
    'USD' => 1.0,
    'CAD' => 1.35,
    _ => 1.0,
  };
  final providerFee = amount * 0.02;
  final nobleCardsFee = amount * 0.01;
  final totalFee = providerFee + nobleCardsFee;
  final destinationFee = totalFee * rate;
  final grossDestinationAmount = amount * rate;
  return {
    'id': 'quote-${request['sourceAmount']}',
    'sourceAmount': request['sourceAmount'],
    'countryCode': request['countryCode'],
    'destinationCurrency': request['destinationCurrencyCode'],
    'paymentMethod': request['paymentMethod'],
    'fxRate': rate.toString(),
    'grossDestinationAmount': grossDestinationAmount.toStringAsFixed(2),
    'providerFee': providerFee.toStringAsFixed(2),
    'nobleCardsFee': nobleCardsFee.toStringAsFixed(2),
    'totalFee': totalFee.toStringAsFixed(2),
    'destinationFee': destinationFee.toStringAsFixed(2),
    'recipientAmount': (grossDestinationAmount - destinationFee)
        .toStringAsFixed(2),
    'status': 'ACTIVE',
    'usable': true,
    'expiresAt': DateTime.now()
        .add(const Duration(minutes: 5))
        .toIso8601String(),
  };
}

Map<String, dynamic> previewFor(Map<String, dynamic> request) {
  final amount = double.parse(request['sourceAmount'] as String);
  final rate = switch (request['destinationCurrencyCode']) {
    'GBP' => 0.75,
    'USD' => 1.0,
    'CAD' => 1.35,
    _ => 1.0,
  };
  final nobleCardsFee = amount * 0.03;
  final transferSourceAmount = amount - nobleCardsFee;
  final transferAmount = transferSourceAmount * rate;
  final countryCode = request['countryCode'] as String;

  final providerFeeAmount = switch (countryCode) {
    'GB' => '35.00',
    'US' => '40.00',
    _ => null,
  };
  final providerFeeUsdEquivalent = switch (countryCode) {
    'GB' => '46.67',
    'US' => '40.00',
    _ => null,
  };
  final estimatedTotalCostsUsd = switch (countryCode) {
    'GB' => '49.67',
    'US' => '43.00',
    _ => null,
  };
  final estimatedRecipientAmount = switch (countryCode) {
    'GB' => (transferAmount - 35.0).toStringAsFixed(2),
    'US' => (transferAmount - 40.0).toStringAsFixed(2),
    _ => null,
  };
  final providerFeeStatus = switch (countryCode) {
    'GB' || 'US' => 'ESTIMATED',
    _ => 'NO_RECORD',
  };
  final providerFeeType = switch (countryCode) {
    'GB' || 'US' => 'value',
    _ => null,
  };
  final providerFeeMessage = switch (countryCode) {
    'GB' =>
      'Published indicative fee (GBP 35 bank transfer per Flutterwave pricing). Not an API-confirmed fee; live payouts disabled.',
    'US' =>
      'Published indicative fee (USD 40 bank transfer per Flutterwave pricing). Subject to account confirmation; live payouts disabled.',
    _ =>
      'Canada (CAD) bank transfers are not currently supported by our payout integration.',
  };

  return {
    'previewContractVersion': 2,
    'sourceCurrency': 'USD',
    'sourceAmount': amount.toStringAsFixed(2),
    'countryCode': request['countryCode'],
    'destinationCurrency': request['destinationCurrencyCode'],
    'paymentMethod': request['paymentMethod'],
    'fxRate': rate.toString(),
    'estimatedGrossDestinationAmount': (amount * rate).toStringAsFixed(2),
    'estimatedTransferAmount': transferAmount.toStringAsFixed(2),
    'estimatedTransferSourceAmountUsd': transferSourceAmount.toStringAsFixed(2),
    'nobleCardsFeeUsd': nobleCardsFee.toStringAsFixed(2),
    'nobleCardsFeePercent': '3',
    'providerFeeAmount': providerFeeAmount,
    'providerFeeCurrency': request['destinationCurrencyCode'],
    'providerFeeType': providerFeeType,
    'providerFeeUsdEquivalent': providerFeeUsdEquivalent,
    'providerFeeStatus': providerFeeStatus,
    'providerFeeMessage': providerFeeMessage,
    'providerFeeFundingCurrency': request['destinationCurrencyCode'],
    'estimatedTotalCostsUsd': estimatedTotalCostsUsd,
    'estimatedRecipientAmount': estimatedRecipientAmount,
    'recipientAmount': null,
    'payoutEnabled': false,
    'isIndicativePreview': true,
    'exchangeRateSource': 'FLUTTERWAVE_V3',
    'rateRetrievedAt': DateTime.now().toUtc().toIso8601String(),
  };
}

void main() {
  test('loads the actual USD balance and backend quote', () async {
    final auth = FakeWithdrawalAuthenticationService(
      quoteRequest: (request) async => quoteFor(request),
    );
    final provider = WithdrawProvider(authService: auth);

    await provider.reloadData();

    expect(provider.availableBalance, 500);
    expect(provider.hasQuote, isTrue);
    expect(provider.exchangeRate, 1);
    expect(provider.withdrawalFee, 3);
    expect(provider.amountReceived, 97);
    expect(auth.requestedQuotes.single['countryCode'], 'NG');
    expect(auth.requestedQuotes.single['destinationCurrencyCode'], 'NGN');

    provider.dispose();
  });

  testWidgets('returns indicative pre-fee estimates for GBP, USD, and CAD', (
    tester,
  ) async {
    final auth = FakeWithdrawalAuthenticationService(
      previewRequest: (request) async => previewFor(request),
    );
    final provider = WithdrawProvider(authService: auth);
    await provider.reloadData();
    final existingQuoteRequests = auth.requestedQuotes.length;

    final expected = <String, (String, double, double, String, String)>{
      'GB': ('GBP', 0.75, 75.0, '£', 'GBP'),
      'US': ('USD', 1.0, 100.0, r'$', 'USD'),
      'CA': ('CAD', 1.35, 135.0, 'C\$', 'CAD'),
    };
    for (final entry in expected.entries) {
      provider.selectCountry(
        provider.supportedCountries.firstWhere(
          (country) => country.id == entry.key,
        ),
      );
      await provider.refreshIndicativePreviewNow();

      expect(provider.hasQuote, isFalse, reason: entry.key);
      expect(provider.isIndicativePreview, isTrue, reason: entry.key);
      expect(auth.requestedPreviews.last['countryCode'], entry.key);
      expect(
        auth.requestedPreviews.last['destinationCurrencyCode'],
        entry.value.$1,
      );
      expect(provider.indicativeExchangeRate, entry.value.$2);
      expect(provider.indicativeConvertedAmount, entry.value.$3);
      expect(provider.indicativeNobleCardsFee, 3);
      expect(provider.indicativeNobleCardsFeePercent, 3);
      expect(provider.indicativeTransferAmount, entry.value.$3 * 0.97);
      expect(
        provider.indicativeProviderFeeType,
        entry.key == 'CA' ? isNull : 'value',
      );
      expect(provider.quoteId, isNull);
      expect(provider.providerFee, isNull);
      expect(provider.amountReceived, isNull);
      expect(auth.requestedQuotes, hasLength(existingQuoteRequests));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: WithdrawSummaryCard(provider: provider)),
        ),
      );
      expect(find.text('Withdrawal Summary (Estimate)'), findsOneWidget);
      expect(find.text('Destination before fees'), findsOneWidget);
      expect(
        find.text(
          '${entry.value.$5} ${entry.value.$4}${entry.value.$3.toStringAsFixed(2)} (before fees)',
        ),
        findsOneWidget,
      );
      expect(find.text('Flutterwave provider fee'), findsOneWidget);
      if (entry.key != 'CA') {
        expect(
          find.text(
            entry.key == 'GB'
                ? '35.00 GBP (Published Indicative)'
                : '40.00 USD (Published Indicative)',
          ),
          findsOneWidget,
        );
      }
      expect(find.text('NobleCards fee (3%)'), findsOneWidget);
      expect(find.text(r'$3.00 USD'), findsOneWidget);
      if (entry.key == 'CA') {
        expect(find.text('Not confirmed'), findsNWidgets(3));
      } else {
        expect(
          find.text(
            entry.key == 'GB'
                ? r'$49.67 USD (Indicative)'
                : r'$43.00 USD (Indicative)',
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            entry.key == 'GB'
                ? 'GBP £37.75 (Indicative)'
                : r'USD $57.00 (Indicative)',
          ),
          findsOneWidget,
        );
      }
      expect(find.text('Indicative recipient amount'), findsOneWidget);
      expect(find.text('Estimate Only — Payouts Disabled'), findsOneWidget);
      expect(
        find.textContaining('Live payouts to this destination are disabled'),
        findsOneWidget,
      );
      if (entry.key == 'CA') {
        expect(
          find.textContaining(
            'Canada (CAD) bank transfers are not currently supported',
          ),
          findsOneWidget,
        );
      } else if (entry.key == 'GB') {
        expect(
          find.textContaining('Published indicative fee (GBP 35'),
          findsOneWidget,
        );
      } else {
        expect(
          find.textContaining('Published indicative fee (USD 40'),
          findsOneWidget,
        );
      }
    }

    provider.dispose();
  });

  test(
    'rejects a legacy backend preview contract with a restart explanation',
    () async {
      final auth = FakeWithdrawalAuthenticationService(
        previewRequest: (request) async => {
          ...previewFor(request),
          'previewContractVersion': null,
        },
      );
      final provider = WithdrawProvider(authService: auth);

      await provider.reloadData();
      provider.selectCountry(
        provider.supportedCountries.firstWhere((country) => country.id == 'GB'),
      );
      await provider.refreshIndicativePreviewNow();

      expect(provider.isIndicativePreview, isFalse);
      expect(
        provider.dataError,
        contains('backend withdrawal preview is outdated'),
      );

      provider.dispose();
    },
  );

  test(
    'preserves a clear backend error when a quote cannot be created',
    () async {
      final auth = FakeWithdrawalAuthenticationService(
        quoteRequest: (_) async =>
            throw Exception('WITHDRAWAL_FEE_CONFIGURATION_MISSING'),
      );
      final provider = WithdrawProvider(authService: auth);

      await provider.reloadData();

      expect(provider.hasQuote, isFalse);
      expect(provider.dataError, 'WITHDRAWAL_FEE_CONFIGURATION_MISSING');
      provider.dispose();
    },
  );

  test(
    'method change invalidates the quote for the previous selection',
    () async {
      final auth = FakeWithdrawalAuthenticationService(
        quoteRequest: (request) async => quoteFor(request),
      );
      final provider = WithdrawProvider(authService: auth);
      await provider.reloadData();
      expect(provider.hasQuote, isTrue);

      provider.selectMethod(
        provider.allMethods.firstWhere((method) => method.id == 'momo'),
      );

      expect(provider.hasQuote, isFalse);
      expect(provider.isQuoteLoading, isTrue);
      provider.dispose();
    },
  );

  test('a late response cannot replace the quote for a newer amount', () async {
    final responses = <Completer<Map<String, dynamic>>>[];
    final auth = FakeWithdrawalAuthenticationService(
      quoteRequest: (_) {
        final response = Completer<Map<String, dynamic>>();
        responses.add(response);
        return response.future;
      },
    );
    final provider = WithdrawProvider(authService: auth);

    final firstRequest = provider.reloadData();
    await Future<void>.delayed(Duration.zero);
    expect(responses, hasLength(1));

    provider.setAmount('200.00');
    final secondRequest = provider.refreshQuoteNow();
    await Future<void>.delayed(Duration.zero);
    expect(responses, hasLength(2));

    responses[1].complete(quoteFor(auth.requestedQuotes[1]));
    await secondRequest;
    responses[0].complete(quoteFor(auth.requestedQuotes[0]));
    await firstRequest;

    expect(provider.hasQuote, isTrue);
    expect(provider.convertedAmount, 200);
    expect(auth.requestedQuotes.last['sourceAmount'], '200.00');
    provider.dispose();
  });

  test(
    'rejects quote data that does not match selected currency and method',
    () async {
      final auth = FakeWithdrawalAuthenticationService(
        quoteRequest: (request) async {
          final quote = quoteFor(request);
          quote['destinationCurrency'] = 'USD';
          quote['paymentMethod'] = 'MOBILE_MONEY';
          return quote;
        },
      );
      final provider = WithdrawProvider(authService: auth);

      await provider.reloadData();

      expect(provider.hasQuote, isFalse);
      expect(provider.quoteId, isNull);
      expect(provider.dataError, isNotNull);
      provider.dispose();
    },
  );

  group('indicative preview clock tolerance and error formatting', () {
    test(
      'formatErrorMessage preserves clean exception message without string corruption',
      () {
        expect(
          WithdrawProvider.formatErrorMessage(
            const FormatException(
              'The backend returned an invalid indicative estimate.',
            ),
          ),
          'The backend returned an invalid indicative estimate.',
        );
        expect(
          WithdrawProvider.formatErrorMessage(
            Exception('WITHDRAWAL_FEE_CONFIGURATION_MISSING'),
          ),
          'WITHDRAWAL_FEE_CONFIGURATION_MISSING',
        );
        expect(
          WithdrawProvider.formatErrorMessage('Network connection lost'),
          'Network connection lost',
        );
      },
    );

    test(
      'accepts estimate with normal client/server clock skew (1 minute future)',
      () async {
        final auth = FakeWithdrawalAuthenticationService(
          previewRequest: (request) async => {
            ...previewFor(request),
            'rateRetrievedAt': DateTime.now()
                .add(const Duration(minutes: 1))
                .toUtc()
                .toIso8601String(),
          },
        );
        final provider = WithdrawProvider(authService: auth);
        await provider.reloadData();
        provider.selectCountry(
          provider.supportedCountries.firstWhere(
            (country) => country.id == 'GB',
          ),
        );
        await provider.refreshPricingNow();

        expect(provider.isIndicativePreview, isTrue);
        expect(provider.dataError, isNull);
        provider.dispose();
      },
    );

    test(
      'rejects estimate with future clock drift beyond allowed window (> 5 minutes)',
      () async {
        final auth = FakeWithdrawalAuthenticationService(
          previewRequest: (request) async => {
            ...previewFor(request),
            'rateRetrievedAt': DateTime.now()
                .add(const Duration(minutes: 6))
                .toUtc()
                .toIso8601String(),
          },
        );
        final provider = WithdrawProvider(authService: auth);
        await provider.reloadData();
        provider.selectCountry(
          provider.supportedCountries.firstWhere(
            (country) => country.id == 'GB',
          ),
        );
        await provider.refreshPricingNow();

        expect(provider.isIndicativePreview, isFalse);
        expect(
          provider.dataError,
          'The backend returned an invalid indicative estimate.',
        );
        provider.dispose();
      },
    );

    test(
      'rejects estimate with stale timestamp older than allowed window (> 15 minutes)',
      () async {
        final auth = FakeWithdrawalAuthenticationService(
          previewRequest: (request) async => {
            ...previewFor(request),
            'rateRetrievedAt': DateTime.now()
                .subtract(const Duration(minutes: 16))
                .toUtc()
                .toIso8601String(),
          },
        );
        final provider = WithdrawProvider(authService: auth);
        await provider.reloadData();
        provider.selectCountry(
          provider.supportedCountries.firstWhere(
            (country) => country.id == 'GB',
          ),
        );
        await provider.refreshPricingNow();

        expect(provider.isIndicativePreview, isFalse);
        expect(
          provider.dataError,
          'The backend returned an invalid indicative estimate.',
        );
        provider.dispose();
      },
    );

    test('rejects genuinely invalid estimate payloads', () async {
      final invalidCases =
          <String, Map<String, dynamic> Function(Map<String, dynamic>)>{
            'mismatched country': (p) => {...p, 'countryCode': 'US'},
            'mismatched source amount': (p) => {...p, 'sourceAmount': '50.00'},
            'non-positive fx rate': (p) => {...p, 'fxRate': '0.0'},
            'inconsistent total costs': (p) => {
              ...p,
              'estimatedTotalCostsUsd': '99.99',
            },
            'mismatched destination currency': (p) => {
              ...p,
              'destinationCurrency': 'EUR',
            },
          };

      for (final entry in invalidCases.entries) {
        final auth = FakeWithdrawalAuthenticationService(
          previewRequest: (request) async => entry.value(previewFor(request)),
        );
        final provider = WithdrawProvider(authService: auth);
        await provider.reloadData();
        provider.selectCountry(
          provider.supportedCountries.firstWhere(
            (country) => country.id == 'GB',
          ),
        );
        await provider.refreshPricingNow();

        expect(
          provider.isIndicativePreview,
          isFalse,
          reason: 'Failed to reject ${entry.key}',
        );
        expect(
          provider.dataError,
          'The backend returned an invalid indicative estimate.',
          reason: 'Incorrect error message for ${entry.key}',
        );
        provider.dispose();
      }
    });
  });
}
