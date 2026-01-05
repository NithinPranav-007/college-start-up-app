import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/chat_message_model.dart';
import '../controllers/chat_controller.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomId = 'demo-room';
    final messagesState = ref.watch(chatControllerProvider(roomId));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.primaryColor,
                  child: Icon(Icons.store, color: Colors.white, size: 20),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppTheme.successColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Campus Merchant', style: TextStyle(fontSize: 16)),
                Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Video call coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: messagesState.when(
              data: (List<ChatMessageModel> messages) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Start a conversation',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Say hi to the merchant!',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  );
                }
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFF8F9FE),
                        Color(0xFFFFFFFF),
                      ],
                    ),
                  ),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == messages.length && _isTyping) {
                        return _TypingIndicator();
                      }

                      final ChatMessageModel message = messages[index];
                      final bool showAvatar = index == 0 ||
                          messages[index - 1].isMine != message.isMine;
                      final bool showTimestamp = index == messages.length - 1 ||
                          messages[index + 1].isMine != message.isMine;

                      return _MessageBubble(
                        message: message,
                        showAvatar: showAvatar,
                        showTimestamp: showTimestamp,
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object error, StackTrace stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: AppTheme.errorColor),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.attach_file,
                          color: AppTheme.primaryColor),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('File attachment coming soon!')),
                        );
                      },
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          onChanged: (value) {
                            // Simulate typing indicator
                            if (value.isNotEmpty && !_isTyping) {
                              setState(() => _isTyping = true);
                              Future.delayed(const Duration(seconds: 2), () {
                                if (mounted) {
                                  setState(() => _isTyping = false);
                                }
                              });
                            }
                          },
                          onSubmitted: (value) {
                            if (value.trim().isEmpty) return;
                            final ChatMessageModel message = ChatMessageModel(
                              id: '',
                              roomId: roomId,
                              senderId: 'me',
                              text: value,
                              sentAt: DateTime.now(),
                              isMine: true,
                            );
                            ref
                                .read(chatControllerProvider(roomId).notifier)
                                .send(message);
                            _controller.clear();
                            setState(() => _isTyping = false);
                            _scrollToBottom();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          if (_controller.text.trim().isEmpty) return;
                          final ChatMessageModel message = ChatMessageModel(
                            id: '',
                            roomId: roomId,
                            senderId: 'me',
                            text: _controller.text,
                            sentAt: DateTime.now(),
                            isMine: true,
                          );
                          ref
                              .read(chatControllerProvider(roomId).notifier)
                              .send(message);
                          _controller.clear();
                          setState(() => _isTyping = false);
                          _scrollToBottom();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.showAvatar,
    required this.showTimestamp,
  });

  final ChatMessageModel message;
  final bool showAvatar;
  final bool showTimestamp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMine && showAvatar)
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.store, color: Colors.white, size: 16),
            )
          else if (!message.isMine)
            const SizedBox(width: 32),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: message.isMine
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: message.isMine ? AppTheme.primaryGradient : null,
                    color: message.isMine ? null : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(message.isMine ? 20 : 4),
                      bottomRight: Radius.circular(message.isMine ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isMine ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                ),
                if (showTimestamp)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 12, right: 12),
                    child: Text(
                      '${message.sentAt.hour}:${message.sentAt.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (message.isMine && showAvatar)
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.accentColor,
              child: Icon(Icons.person, color: Colors.white, size: 16),
            )
          else if (message.isMine)
            const SizedBox(width: 32),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.primaryColor,
            child: Icon(Icons.store, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (index) => AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final delay = index * 0.2;
                    final value = (_controller.value - delay) % 1.0;
                    final opacity = value < 0.5 ? (value * 2) : (2 - value * 2);
                    return Opacity(
                      opacity: opacity.clamp(0.3, 1.0),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
