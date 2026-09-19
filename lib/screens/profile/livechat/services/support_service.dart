import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../authentication/services/authentication_service.dart';
import '../models/chat_message.dart';
import '../models/quick_action.dart';
import '../models/support_ticket.dart';

class SupportApiException implements Exception {
  final int statusCode;
  final String message;

  const SupportApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}

class SupportService {
  final AuthenticationService authenticationService;
  final http.Client httpClient;

  SupportService({
    AuthenticationService? authenticationService,
    http.Client? httpClient,
  })  : authenticationService = authenticationService ?? AuthenticationService(),
        httpClient = httpClient ?? http.Client();

  Future<SupportTicket> openOrCreateTicket(QuickAction action) async {
    final currentUserId = await _currentUserId();
    final tickets = await listTickets(currentUserId: currentUserId);
    final existing = tickets.where((ticket) {
      return ticket.subject == action.title &&
          ticket.category == _categoryFor(action) &&
          ticket.status != 'RESOLVED' &&
          ticket.status != 'CLOSED';
    }).firstOrNull;

    if (existing != null) return existing;

    return createTicket(
      action: action,
      currentUserId: currentUserId,
    );
  }

  Future<List<SupportTicket>> listTickets({String? currentUserId}) async {
    final userId = currentUserId ?? await _currentUserId();
    final data = await _request('GET', '/support/tickets');

    if (data is! List) {
      throw const SupportApiException(500, 'Support tickets could not be loaded.');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(
          (ticket) => SupportTicket.fromJson(
            ticket,
            currentUserId: userId,
          ),
        )
        .toList();
  }

  Future<SupportTicket> createTicket({
    required QuickAction action,
    required String currentUserId,
  }) async {
    final data = await _request(
      'POST',
      '/support/tickets',
      body: {
        'subject': action.title,
        'category': _categoryFor(action),
        'priority': _priorityFor(action),
        'message': 'I need help with ${action.title}.',
      },
    );

    if (data is! Map<String, dynamic>) {
      throw const SupportApiException(500, 'Support ticket could not be created.');
    }

    return SupportTicket.fromJson(data, currentUserId: currentUserId);
  }

  Future<SupportTicket> getTicket(String ticketId) async {
    final currentUserId = await _currentUserId();
    final data = await _request('GET', '/support/tickets/$ticketId');

    if (data is! Map<String, dynamic>) {
      throw const SupportApiException(500, 'Support ticket could not be loaded.');
    }

    return SupportTicket.fromJson(data, currentUserId: currentUserId);
  }

  Future<ChatMessage> sendMessage({
    required String ticketId,
    required String message,
  }) async {
    final currentUserId = await _currentUserId();
    final data = await _request(
      'POST',
      '/support/tickets/$ticketId/messages',
      body: {'message': message},
    );

    if (data is! Map<String, dynamic>) {
      throw const SupportApiException(500, 'Message could not be sent.');
    }

    return ChatMessage.fromJson(data, currentUserId: currentUserId);
  }

  Future<String> _currentUserId() async {
    final currentUser = authenticationService.currentUser;
    if (currentUser != null) return currentUser.id;

    final profile = await authenticationService.getUserProfile('');
    final userId = profile?['id']?.toString();
    if (userId == null || userId.isEmpty) {
      throw const SupportApiException(401, 'Your login session has expired. Please log in again.');
    }
    return userId;
  }

  Future<dynamic> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final token = await authenticationService.getAccessToken();
    if (token == null || token.isEmpty) {
      throw const SupportApiException(401, 'Your login session has expired. Please log in again.');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final uri = Uri.parse('${AuthenticationService.apiBaseUrl}$path');
    final response = method == 'POST'
        ? await httpClient.post(uri, headers: headers, body: jsonEncode(body ?? {}))
        : await httpClient.get(uri, headers: headers);

    dynamic data;
    try {
      data = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body);
    } catch (_) {
      data = null;
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = data is Map<String, dynamic>
          ? data['message']?.toString()
          : null;
      throw SupportApiException(
        response.statusCode,
        message ?? 'Support request failed. Please try again.',
      );
    }

    return data;
  }

  String _categoryFor(QuickAction action) {
    switch (action.title) {
      case 'Buy Gift Card':
      case 'Sell Gift Card':
        return 'GIFT_CARD';
      case 'Wallet & Deposit':
      case 'Payments':
        return 'PAYMENT';
      case 'Withdrawal':
        return 'WITHDRAWAL';
      case 'Verification (KYC)':
      case 'Security':
      case 'Report Scam':
        return 'ACCOUNT';
      default:
        return 'GENERAL';
    }
  }

  String _priorityFor(QuickAction action) {
    switch (action.title) {
      case 'Report Scam':
        return 'URGENT';
      case 'Security':
      case 'Withdrawal':
      case 'Payments':
        return 'HIGH';
      default:
        return 'MEDIUM';
    }
  }
}