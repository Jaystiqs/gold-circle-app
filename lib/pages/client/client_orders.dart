import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../utils/app_styles.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // Sample order data
  final List<OrderItem> _orders = [
    OrderItem(
      id: '1',
      title: 'Logo Design',
      provider: 'Sarah Johnson',
      status: OrderStatus.completed,
      date: DateTime.now().subtract(const Duration(days: 3)),
      imageUrl: 'https://placehold.co/400x400/2ECC71/ffffff?text=Logo',
    ),
    OrderItem(
      id: '2',
      title: 'Website Development',
      provider: 'Michael Chen',
      status: OrderStatus.inProgress,
      date: DateTime.now().subtract(const Duration(days: 1)),
      imageUrl: 'https://placehold.co/400x400/3498DB/ffffff?text=Web',
    ),
    OrderItem(
      id: '3',
      title: 'Photography Session',
      provider: 'Emily Davis',
      status: OrderStatus.pending,
      date: DateTime.now().subtract(const Duration(hours: 6)),
      imageUrl: 'https://placehold.co/400x400/E74C3C/ffffff?text=Photo',
    ),
  ];

  Widget _buildFixedHeader() {
    return Container(
      color: AppStyles.backgroundWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppTitle(),
        ],
      ),
    );
  }

  Widget _buildAppTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        24.0,
        24.0,
        24.0,
        16.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Orders',
              style: AppStyles.h1.copyWith(
                  color: AppStyles.textPrimary,
                  fontWeight: AppStyles.bold,
                  letterSpacing: -1.5
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              PhosphorIcons.funnel(),
              color: AppStyles.textPrimary,
            ),
            onPressed: () {
              // Show filter options
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersTimeline() {
    if (_orders.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      color: AppStyles.backgroundWhite,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        children: _orders.asMap().entries.map((entry) {
          final index = entry.key;
          final order = entry.value;
          final isLast = index == _orders.length - 1;

          return _buildTimelineItem(order, isLast);
        }).toList(),
      ),
    );
  }

  Widget _buildTimelineItem(OrderItem order, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getStatusColor(order.status),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 80,
                color: AppStyles.backgroundGrey,
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        const SizedBox(width: 16),

        // Order content
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: isLast ? 0 : 24),
            child: Row(
              children: [
                // Order image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppStyles.backgroundGrey,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      order.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppStyles.backgroundGrey,
                          child: Icon(
                            PhosphorIcons.package(),
                            color: AppStyles.textLight,
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Order details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.title,
                        style: AppStyles.bodyLarge.copyWith(
                          fontWeight: AppStyles.semiBold,
                          color: AppStyles.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'by ${order.provider}',
                        style: AppStyles.bodyMedium.copyWith(
                          color: AppStyles.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(order.status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getStatusText(order.status),
                              style: AppStyles.bodySmall.copyWith(
                                color: _getStatusColor(order.status),
                                fontWeight: AppStyles.medium,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(order.date),
                            style: AppStyles.bodySmall.copyWith(
                              color: AppStyles.textLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      color: AppStyles.backgroundWhite,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Icon(
              PhosphorIcons.package(),
              size: 80,
              color: AppStyles.textLight,
            ),
            const SizedBox(height: 24),
            Text(
              'No orders yet',
              style: AppStyles.h3.copyWith(
                color: AppStyles.textSecondary,
                fontWeight: AppStyles.semiBold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'When you hire freelancers, your orders will appear here.',
              style: AppStyles.bodyMedium.copyWith(
                color: AppStyles.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildCallToAction() {
    return Container(
      color: AppStyles.backgroundWhite,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            'Start your next project',
            style: AppStyles.h2.copyWith(
              fontWeight: AppStyles.bold,
              color: AppStyles.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Find talented freelancers and bring your ideas to life.\nYour orders and project updates will show up here.',
            style: AppStyles.bodyLarge.copyWith(
              color: AppStyles.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to find providers or home page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Find Freelancers',
                style: AppStyles.bodyLarge.copyWith(
                  fontWeight: AppStyles.semiBold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.inProgress:
        return Colors.blue;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundGrey,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed header section (app title + filter button)
            _buildFixedHeader(),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildOrdersTimeline(),
                    const SizedBox(height: 8),
                    _buildCallToAction(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data models
enum OrderStatus {
  pending,
  inProgress,
  completed,
  cancelled,
}

class OrderItem {
  final String id;
  final String title;
  final String provider;
  final OrderStatus status;
  final DateTime date;
  final String imageUrl;

  OrderItem({
    required this.id,
    required this.title,
    required this.provider,
    required this.status,
    required this.date,
    required this.imageUrl,
  });
}