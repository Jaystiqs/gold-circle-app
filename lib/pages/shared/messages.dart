import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../utils/app_styles.dart';
import 'chat_detail.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'In-Progress', 'Completed', 'Support'];

  // Sample message data matching the design
  final List<MessageThread> _messages = [
    MessageThread(
      id: '2',
      participants: ['Maria' ],
      lastMessage: 'Thanks for confirming! I\'ll update soon.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isUnread: false,
      propertyImage: 'https://avatar.iran.liara.run/public/girl',
      details: 'Project confirmed • Graphic Design • 2 days',
      hasAction: false,
      category: 'in-progress',
    ),
    MessageThread(
      id: '3',
      participants: ['Support Team'],
      lastMessage: 'Your refund has been processed successfully.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isUnread: false,
      propertyImage: null,
      details: 'Case #12345 • Refund processed',
      hasAction: false,
      category: 'support',
    ),
  ];

  List<MessageThread> get _filteredMessages {
    if (_selectedFilterIndex == 0) return _messages; // All
    final filterCategory = _filters[_selectedFilterIndex].toLowerCase();
    return _messages.where((message) => message.category == filterCategory).toList();
  }

  Widget _buildFixedHeader() {
    return Container(
      color: AppStyles.backgroundWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppTitle(),
          _buildFilterSection(),
        ],
      ),
    );
  }

  Widget _buildAppTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        24.0,
        24.0,
        16.0,
        16.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Messages',
              style: AppStyles.h1.copyWith(
                  color: AppStyles.textPrimary,
                  fontWeight: AppStyles.bold,
                  letterSpacing: -1.5
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              PhosphorIcons.magnifyingGlass(),
              color: AppStyles.textPrimary,
            ),
            onPressed: () {
              // Show search
            },
          ),
          IconButton(
            icon: Icon(
              PhosphorIcons.gear(),
              color: AppStyles.textPrimary,
            ),
            onPressed: () {
              // Show settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
      child: _buildFilterTabs(),
    );
  }

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.asMap().entries.map((entry) {
          final index = entry.key;
          final filter = entry.value;
          final isSelected = index == _selectedFilterIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilterIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppStyles.textPrimary : AppStyles.backgroundGrey,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                filter,
                style: AppStyles.bodyMedium.copyWith(
                  color: isSelected ? Colors.white : AppStyles.textPrimary,
                  fontWeight: isSelected ? AppStyles.semiBold : AppStyles.medium,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMessagesList() {
    final filteredMessages = _filteredMessages;

    if (filteredMessages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                PhosphorIcons.chatCircle(),
                size: 64,
                color: AppStyles.textLight,
              ),
              const SizedBox(height: 16),
              Text(
                'No messages yet',
                style: AppStyles.h4.copyWith(color: AppStyles.textSecondary),
              ),
              const SizedBox(height: 8),
              Text(
                'You\'ll see your messages here',
                style: AppStyles.bodyMedium.copyWith(color: AppStyles.textLight),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredMessages.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final message = filteredMessages[index];
        return _buildMessageTile(message);
      },
    );
  }

  Widget _buildMessageTile(MessageThread message) {
    return InkWell(
      onTap: () {
        // Navigate to individual chat
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailPage(
              threadId: message.id,
              otherUserName: message.participants.first,
              otherUserImage: message.propertyImage,
              projectDetails: message.details,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Main avatar image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: AppStyles.backgroundGrey,
              ),
              child: message.propertyImage != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  message.propertyImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppStyles.backgroundGrey,
                      child: Icon(
                        PhosphorIcons.house(),
                        color: AppStyles.textLight,
                        size: 24,
                      ),
                    );
                  },
                ),
              )
                  : Icon(
                PhosphorIcons.headset(),
                color: AppStyles.textLight,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Message content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message.participants.join(', '),
                          style: AppStyles.bodyLarge.copyWith(
                            fontWeight: AppStyles.semiBold,
                            color: AppStyles.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatTimestamp(message.timestamp),
                        style: AppStyles.bodyMedium.copyWith(
                          color: AppStyles.textLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.lastMessage,
                    style: AppStyles.bodyMedium.copyWith(
                      color: message.isUnread ? AppStyles.textPrimary : AppStyles.textSecondary,
                      fontWeight: message.isUnread ? AppStyles.medium : AppStyles.regular,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (message.isUnread)
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          message.details,
                          style: AppStyles.bodySmall.copyWith(
                            color: AppStyles.textLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (message.hasAction) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppStyles.textPrimary),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        message.actionText!,
                        style: AppStyles.bodySmall.copyWith(
                          color: AppStyles.textPrimary,
                          fontWeight: AppStyles.medium,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      final hour = timestamp.hour;
      final minute = timestamp.minute;
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '${displayHour}:${minute.toString().padLeft(2, '0')} $period';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed header section (app title + filters)
            _buildFixedHeader(),

            Expanded(
              child: _buildMessagesList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Data model for message threads
class MessageThread {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final DateTime timestamp;
  final bool isUnread;
  final String? propertyImage;
  final String details;
  final bool hasAction;
  final String? actionText;
  final String category;

  MessageThread({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.timestamp,
    required this.isUnread,
    this.propertyImage,
    required this.details,
    required this.hasAction,
    this.actionText,
    required this.category,
  });
}
