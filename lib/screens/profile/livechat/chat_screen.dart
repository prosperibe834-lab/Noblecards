import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'models/chat_message.dart';
import 'models/quick_action.dart';
import 'models/support_ticket.dart';
import 'services/support_service.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/chat_input.dart';

class ChatScreen extends StatefulWidget {
  final QuickAction initialAction;
  final String? ticketId;

  const ChatScreen({super.key, required this.initialAction, this.ticketId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final SupportService _supportService = SupportService();
  SupportTicket? _ticket;
  String? _errorMessage;
  bool _isLoading = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadTicket();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty || _ticket == null || _isSending) return;
    _controller.clear();
    _sendMessageToServer(text);
  }

  Future<void> _loadTicket() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final ticket = widget.ticketId == null
          ? await _supportService.openOrCreateTicket(widget.initialAction)
          : await _supportService.getTicket(widget.ticketId!);
      if (!mounted) return;

      setState(() {
        _ticket = ticket;
        _messages
          ..clear()
          ..addAll(ticket.messages);
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _sendMessageToServer(String text) async {
    setState(() => _isSending = true);

    try {
      final message = await _supportService.sendMessage(
        ticketId: _ticket!.id,
        message: text,
      );
      if (!mounted) return;

      setState(() {
        _messages.add(message);
        _isSending = false;
      });
      _scrollToBottom();
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
      backgroundColor: isDark
          ? const Color(0xFF0F1419)
          : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F1419) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Boxicons.bx_chevron_left,
            color: isDark ? Colors.white : Colors.black,
            size: 28,
          ),
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
              child: const Icon(
                Boxicons.bx_support,
                color: Color(0xFF00B75F),
                size: 20,
              ),
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
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00B75F),
                        shape: BoxShape.circle,
                      ),
                    ),
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
            child: _buildMessageArea(isDark),
          ),
          ChatInput(controller: _controller, onSend: _sendMessage),
        ],
      ),
    );
  }

  Widget _buildMessageArea(bool isDark) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 12),
              TextButton(onPressed: _loadTicket, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: _messages.length,
      itemBuilder: (context, index) => ChatBubble(message: _messages[index]),
    );
  }
}
