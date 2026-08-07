import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'models/chat_message.dart';
import 'models/quick_action.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/chat_input.dart';

class ChatScreen extends StatefulWidget {
  final QuickAction initialAction;

  const ChatScreen({super.key, required this.initialAction});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = true;

  @override
  void initState() {
    super.initState();
    // Simulate initial support response
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: widget.initialAction.autoMessage,
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
          _isTyping = false;
        });
      }
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add(
        ChatMessage(
          text: _controller.text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
    });
    
    _controller.clear();
    _scrollToBottom();

    // Simulate agent reply
    setState(() => _isTyping = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: 'Thanks for the information. An agent is reviewing your request.',
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
          _isTyping = false;
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1419) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F1419) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Boxicons.bx_chevron_left, color: isDark ? Colors.white : Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF00B75F).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Boxicons.bx_support, color: Color(0xFF00B75F), size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Support Agent',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Row(
                  children: [
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF00B75F), shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(left: 16, top: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E252D) : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Agent is typing...',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    ),
                  );
                }
                return ChatBubble(message: _messages[index]);
              },
            ),
          ),
          ChatInput(
            controller: _controller,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}