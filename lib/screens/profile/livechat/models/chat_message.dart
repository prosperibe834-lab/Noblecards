class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isRead;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(
    Map<String, dynamic> json, {
    required String currentUserId,
  }) {
    final createdAt = DateTime.tryParse(json['createdAt']?.toString() ?? '');

    return ChatMessage(
      text: json['body']?.toString() ?? '',
      isUser: json['userId']?.toString() == currentUserId,
      timestamp: (createdAt ?? DateTime.now()).toLocal(),
    );
  }
}
