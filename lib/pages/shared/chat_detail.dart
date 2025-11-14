import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/app_styles.dart';

// Message model
class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final bool isRead;
  final String? replyToId;
  final String? replyToText;
  final String? replyToSender;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    this.isRead = false,
    this.replyToId,
    this.replyToText,
    this.replyToSender,
  });
}

class ChatDetailPage extends StatefulWidget {
  final String threadId;
  final String otherUserName;
  final String? otherUserImage;
  final String projectDetails;

  const ChatDetailPage({
    super.key,
    required this.threadId,
    required this.otherUserName,
    this.otherUserImage,
    required this.projectDetails,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();

  ChatMessage? _replyingTo;
  bool _isComposing = false;

  // Mock messages for testing
  List<ChatMessage> _messages = [];
  final String _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? 'current_user';
  final String _otherUserId = 'other_user';

  @override
  void initState() {
    super.initState();
    _loadMockMessages();

    _messageController.addListener(() {
      setState(() {
        _isComposing = _messageController.text.trim().isNotEmpty;
      });
    });

    // Auto-scroll to bottom after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _loadMockMessages() {
    // Create some sample messages
    final now = DateTime.now();

    _messages = [
      ChatMessage(
        id: '1',
        senderId: _otherUserId,
        senderName: widget.otherUserName,
        text: 'first part',
        timestamp: now.subtract(const Duration(hours: 5)),
        isRead: true,
      ),
      ChatMessage(
        id: '2',
        senderId: _currentUserId,
        senderName: 'You',
        text: 'Yeah sure',
        timestamp: now.subtract(const Duration(hours: 4, minutes: 45)),
        isRead: true,
      ),
      ChatMessage(
        id: '3',
        senderId: _otherUserId,
        senderName: widget.otherUserName,
        text: 'I need clarification. Should I do all pages?',
        timestamp: now.subtract(const Duration(hours: 4, minutes: 45)),
        isRead: true,
      ),
      ChatMessage(
        id: '4',
        senderId: _currentUserId,
        senderName: 'You',
        text: 'Just complete the first page by 24th',
        timestamp: now.subtract(const Duration(hours: 4, minutes: 40)),
        isRead: false,
        replyToId: '3',
        replyToText: 'I need clarification. Should I do all pages?',
        replyToSender: widget.otherUserName,
      ),
      ChatMessage(
        id: '5',
        senderId: _otherUserId,
        senderName: widget.otherUserName,
        text: 'Thanks for your patience',
        timestamp: now.subtract(const Duration(hours: 4, minutes: 35)),
        isRead: true,
      ),
      ChatMessage(
        id: '6',
        senderId: _currentUserId,
        senderName: 'You',
        text: 'You\'re welcome',
        timestamp: now.subtract(const Duration(hours: 4, minutes: 30)),
        isRead: true,
        replyToId: '5',
        replyToText: 'Thanks for your patience',
        replyToSender: widget.otherUserName,
      ),
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  String _formatTimeOnly(DateTime timestamp) {
    final hour = timestamp.hour;
    final minute = timestamp.minute;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _currentUserId,
      senderName: 'You',
      text: _messageController.text.trim(),
      timestamp: DateTime.now(),
      isRead: false,
      replyToId: _replyingTo?.id,
      replyToText: _replyingTo?.text,
      replyToSender: _replyingTo?.senderName,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
      _replyingTo = null;
      _isComposing = false;
    });

    // Scroll to bottom
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

  void _startReply(ChatMessage message) {
    setState(() {
      _replyingTo = message;
    });
    _messageFocusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyingTo = null;
    });
  }

  Widget _buildMessageBubble(ChatMessage message, bool isCurrentUser) {
    return GestureDetector(
      onLongPress: () {
        _startReply(message);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Sender name and timestamp for other user's messages
            if (!isCurrentUser)
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 4),
                child: Text(
                  '${message.senderName} · Provider ${_formatTimeOnly(message.timestamp)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppStyles.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

            Row(
              mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar for other user
                if (!isCurrentUser) ...[
                  Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppStyles.backgroundGrey,
                    ),
                    child: widget.otherUserImage != null
                        ? ClipOval(
                      child: Image.network(
                        widget.otherUserImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            PhosphorIconsRegular.user,
                            color: AppStyles.textLight,
                            size: 18,
                          );
                        },
                      ),
                    )
                        : Icon(
                      PhosphorIconsRegular.user,
                      color: AppStyles.textLight,
                      size: 18,
                    ),
                  ),
                ],

                // Message bubble
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isCurrentUser
                          ? const Color(0xFF3D3D3D)
                          : const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Reply indicator
                        if (message.replyToText != null) ...[
                          Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Replying to ${message.replyToSender}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isCurrentUser
                                        ? Colors.white.withOpacity(0.7)
                                        : AppStyles.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  message.replyToText!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isCurrentUser
                                        ? Colors.white.withOpacity(0.6)
                                        : AppStyles.textLight,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Message text
                        Text(
                          message.text,
                          style: TextStyle(
                            fontSize: 15,
                            color: isCurrentUser ? Colors.white : AppStyles.textPrimary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Read receipt and timestamp for current user's messages
            if (isCurrentUser)
              Padding(
                padding: const EdgeInsets.only(top: 4, right: 12),
                child: Text(
                  message.isRead
                      ? 'Read by ${widget.otherUserName}'
                      : _formatTimeOnly(message.timestamp),
                  style: TextStyle(
                    fontSize: 11,
                    color: AppStyles.textLight,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSeparator(DateTime date) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppStyles.backgroundGrey,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIconsRegular.moon,
              size: 12,
              color: AppStyles.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              _formatDateSeparator(date),
              style: TextStyle(
                fontSize: 12,
                color: AppStyles.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateSeparator(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      final hour = date.hour;
      return 'It\'s ${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} for your Provider.';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      return days[date.weekday - 1];
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  Widget _buildReplyBar() {
    if (_replyingTo == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Replying to ${_replyingTo!.senderName}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppStyles.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _replyingTo!.text,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppStyles.textLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(PhosphorIconsRegular.x, size: 18),
            onPressed: _cancelReply,
            color: AppStyles.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Add attachment button
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                child: IconButton(
                  icon: Icon(
                    PhosphorIconsRegular.plus,
                    size: 24,
                    color: AppStyles.textSecondary,
                  ),
                  onPressed: () {
                    // Show attachment options
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Attachment feature coming soon')),
                    );
                  },
                ),
              ),

              const SizedBox(width: 8),

              // Message input field
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 100),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _messageController,
                    focusNode: _messageFocusNode,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppStyles.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Write a message...',
                      hintStyle: TextStyle(
                        color: AppStyles.textLight,
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) {
                      if (_isComposing) _sendMessage();
                    },
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Send button
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                child: IconButton(
                  icon: Icon(
                    PhosphorIconsRegular.paperPlaneRight,
                    size: 24,
                    color: _isComposing ? AppStyles.goldPrimary : AppStyles.textLight,
                  ),
                  onPressed: _isComposing ? _sendMessage : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(PhosphorIconsRegular.arrowLeft, color: AppStyles.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: GestureDetector(
          onTap: () {
            // Navigate to project/booking details
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Project details coming soon')),
            );
          },
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppStyles.backgroundGrey,
                    ),
                    child: widget.otherUserImage != null
                        ? ClipOval(
                      child: Image.network(
                        widget.otherUserImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            PhosphorIconsRegular.user,
                            color: AppStyles.textLight,
                            size: 16,
                          );
                        },
                      ),
                    )
                        : Icon(
                      PhosphorIconsRegular.user,
                      color: AppStyles.textLight,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.otherUserName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppStyles.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                widget.projectDetails,
                style: TextStyle(
                  fontSize: 11,
                  color: AppStyles.textSecondary,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Navigate to project details
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Project details coming soon')),
              );
            },
            child: Text(
              'Details',
              style: TextStyle(
                fontSize: 14,
                color: AppStyles.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isCurrentUser = message.senderId == _currentUserId;

                // Show date separator if this is the first message of a new day
                final showDateSeparator = index == 0 ||
                    (index > 0 &&
                        _messages[index - 1].timestamp.day != message.timestamp.day);

                return Column(
                  children: [
                    if (showDateSeparator)
                      _buildDateSeparator(message.timestamp),
                    _buildMessageBubble(message, isCurrentUser),
                  ],
                );
              },
            ),
          ),

          // Reply bar (if replying)
          _buildReplyBar(),

          // Message input
          _buildMessageInput(),
        ],
      ),
    );
  }
}