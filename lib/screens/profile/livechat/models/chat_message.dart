class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isRead;
  final String senderType;
  final Map<String, dynamic>? metadata;
  final List<ChatAttachment> attachments;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isRead = false,
    this.senderType = 'USER',
    this.metadata,
    this.attachments = const [],
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
      senderType: json['senderType']?.toString() ?? 'USER',
      metadata: json['metadata'] is Map ? Map<String, dynamic>.from(json['metadata'] as Map) : null,
      attachments: (json['attachments'] is List ? json['attachments'] as List : const [])
          .whereType<Map>()
          .map((attachment) => ChatAttachment.fromJson(Map<String, dynamic>.from(attachment)))
          .toList(),
    );
  }
}

class ChatAttachment {
  final String id;
  final String originalName;
  final String mimeType;
  final int sizeBytes;
  final String? publicUrl;

  const ChatAttachment({
    required this.id,
    required this.originalName,
    required this.mimeType,
    required this.sizeBytes,
    this.publicUrl,
  });

  factory ChatAttachment.fromJson(Map<String, dynamic> json) => ChatAttachment(
        id: json['id']?.toString() ?? '',
        originalName: json['originalName']?.toString() ?? 'Attachment',
        mimeType: json['mimeType']?.toString() ?? 'application/octet-stream',
        sizeBytes: (json['sizeBytes'] as num?)?.toInt() ?? 0,
        publicUrl: json['publicUrl']?.toString(),
      );
}
