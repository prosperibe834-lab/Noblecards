import 'dart:async';

import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _imagePicker = ImagePicker();
  SupportTicket? _ticket;
  String? _errorMessage;
  bool _isLoading = true;
  bool _isSending = false;
  Timer? _messagePollTimer;
  bool _messagePollInFlight = false;

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
      _startMessagePolling();
      _scrollToBottom();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  void _startMessagePolling() {
    _messagePollTimer?.cancel();
    _messagePollTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _refreshTicketMessages(),
    );
  }

  Future<void> _refreshTicketMessages() async {
    if (!mounted || _ticket == null || _isLoading || _messagePollInFlight) return;
    _messagePollInFlight = true;
    try {
      final ticket = await _supportService.getTicket(_ticket!.id);
      if (!mounted) return;
      setState(() {
        _ticket = ticket;
        _messages
          ..clear()
          ..addAll(ticket.messages);
      });
    } catch (_) {
      // Keep the current conversation visible; the next poll or reopen retries.
    } finally {
      _messagePollInFlight = false;
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

  Future<void> _uploadImage(ImageSource source) async {
    try {
      final file = await _imagePicker.pickImage(source: source);
      if (file != null) await _uploadFile(file);
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _pickDocument() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'txt'],
      );
      if (result.isEmpty) return;
      await _uploadPlatformFile(result.first);
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _pickAudio() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'ogg', 'webm'],
      );
      if (result.isEmpty) return;
      await _uploadPlatformFile(result.first);
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _uploadPlatformFile(PlatformFile file) async {
    final upload = XFile.fromData(await file.readAsBytes(), name: file.name);
    await _uploadFile(upload);
  }

  Future<void> _uploadFile(XFile file) async {
    if (_ticket == null) return;
    setState(() => _isSending = true);
    try {
      final message = await _supportService.uploadAttachment(
        ticketId: _ticket!.id,
        file: file,
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
      _showError(error);
    }
  }

  Future<void> _sendLocation() async {
    if (_ticket == null) return;
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw Exception('Location services are disabled.');
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw Exception('Location permission was denied.');
      }
      final position = await Geolocator.getCurrentPosition();
      setState(() => _isSending = true);
      final message = await _supportService.sendLocation(
        ticketId: _ticket!.id,
        latitude: position.latitude,
        longitude: position.longitude,
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
      _showError(error);
    }
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
  }

  Future<void> _showChatMenu() async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Clear Chat'),
              onTap: () => Navigator.pop(context, 'clear'),
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
    if (action != 'clear' || !mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat?'),
        content: const Text('Your messages will be hidden from this chat. Support history will be preserved.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Clear Chat')),
        ],
      ),
    );
    if (confirmed != true || _ticket == null) return;
    try {
      await _supportService.clearTicket(_ticket!.id);
      await _loadTicket();
    } catch (error) {
      _showError(error);
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
    _messagePollTimer?.cancel();
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
        actions: [
          IconButton(
            icon: Icon(
              Boxicons.bx_dots_horizontal_rounded,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: _showChatMenu,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageArea(isDark),
          ),
          ChatInput(
            controller: _controller,
            onSend: _sendMessage,
            onGallery: () => _uploadImage(ImageSource.gallery),
            onCamera: () => _uploadImage(ImageSource.camera),
            onDocument: _pickDocument,
            onAudio: _pickAudio,
            onLocation: _sendLocation,
          ),
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
