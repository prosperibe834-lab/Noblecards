import 'chat_message.dart';

class SupportTicket {
  final String id;
  final String subject;
  final String category;
  final String status;
  final String priority;
  final List<ChatMessage> messages;

  const SupportTicket({
    required this.id,
    required this.subject,
    required this.category,
    required this.status,
    required this.priority,
    required this.messages,
  });

  factory SupportTicket.fromJson(
    Map<String, dynamic> json, {
    required String currentUserId,
  }) {
    final rawMessages = json['messages'];

    return SupportTicket(
      id: json['id']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      category: json['category']?.toString() ?? 'GENERAL',
      status: json['status']?.toString() ?? 'OPEN',
      priority: json['priority']?.toString() ?? 'MEDIUM',
      messages: rawMessages is List
          ? rawMessages
              .whereType<Map<String, dynamic>>()
              .map(
                (message) => ChatMessage.fromJson(
                  message,
                  currentUserId: currentUserId,
                ),
              )
              .toList()
          : const [],
    );
  }
}