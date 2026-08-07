import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser 
              ? const Color(0xFF00B75F) 
              : (isDark ? const Color(0xFF1E252D) : Colors.grey.shade100),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isUser ? 16 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: message.isUser 
                    ? Colors.white 
                    : (isDark ? Colors.white : Colors.black87),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}",
                  style: TextStyle(
                    fontSize: 10,
                    color: message.isUser 
                        ? Colors.white70 
                        : (isDark ? Colors.white54 : Colors.black54),
                  ),
                ),
                if (message.isUser) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead ? Boxicons.bx_check_double : Boxicons.bx_check,
                    size: 14,
                    color: Colors.white70,
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}