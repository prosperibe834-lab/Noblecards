import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/config/api_config.dart';
import '../models/deposit_model.dart';

class DepositsService {
  static String get _baseUrl => ApiConfig.baseUrl;

  final http.Client httpClient;
  final String Function() getAuthToken;

  DepositsService({required this.httpClient, required this.getAuthToken});

  Future<Deposit> createDeposit({
    required double amount,
    required String currency,
    required String paymentMethod,
    String? country,
    String? countryCode,
    String? idempotencyKey,
  }) async {
    final token = getAuthToken();

    final response = await httpClient.post(
      Uri.parse('$_baseUrl/deposits'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'amount': amount,
        'currency': currency,
        'paymentMethod': paymentMethod,
        'country': country,
        'countryCode': countryCode,
        'idempotencyKey': idempotencyKey,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create deposit: ${response.body}');
    }

    debugPrint('DEPOSIT API RESPONSE: ${response.body}');
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    debugPrint('DEPOSIT PARSED JSON: $json');
    return Deposit.fromJson(json);
  }

  Future<Deposit> createCardDeposit({
    required double amount,
    required double requestedAmount,
    required String currency,
    required String cardNumber,
    required String cvv,
    required String expiryMonth,
    required String expiryYear,
    required String cardHolderName,
    String? idempotencyKey,
  }) async {
    final token = getAuthToken();
    final response = await httpClient.post(
      Uri.parse('$_baseUrl/deposits/card'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'amount': amount,
        'requestedAmount': requestedAmount,
        'currency': currency,
        'idempotencyKey': idempotencyKey,
        'card': {
          'cardNumber': cardNumber,
          'cvv': cvv,
          'expiryMonth': expiryMonth,
          'expiryYear': expiryYear,
          'cardHolderName': cardHolderName,
        },
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create card deposit: ${response.body}');
    }

    return Deposit.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Deposit> getDeposit(String depositId) async {
    final token = getAuthToken();

    final response = await httpClient.get(
      Uri.parse('$_baseUrl/deposits/$depositId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get deposit: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Deposit.fromJson(json);
  }

  /// Check the payment status and verify with provider if needed.
  /// This is called when user taps "I Have Made The Transfer".
  Future<Deposit> verifyAndCheckDeposit(String depositId) async {
    final token = getAuthToken();

    final response = await httpClient.post(
      Uri.parse('$_baseUrl/deposits/$depositId/verify'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to verify deposit: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Deposit.fromJson(json);
  }

  Future<List<Deposit>> listDeposits({
    String? status,
    String? currency,
    String? provider,
  }) async {
    final token = getAuthToken();

    final uri = Uri.parse('$_baseUrl/deposits').replace(
      queryParameters: {
        if (status != null) 'status': status,
        if (currency != null) 'currency': currency,
        if (provider != null) 'provider': provider,
      },
    );

    final response = await httpClient.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to list deposits: ${response.body}');
    }

    final List<dynamic> json = jsonDecode(response.body) as List<dynamic>;
    return json
        .map((item) => Deposit.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
