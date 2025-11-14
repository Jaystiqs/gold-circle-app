import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../utils/app_styles.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final Color? iconColor;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onActionPressed,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: (iconColor ?? AppStyles.textLight).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: iconColor ?? AppStyles.textLight,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppStyles.bodyLarge.copyWith(
                color: AppStyles.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: AppStyles.bodyMedium.copyWith(
                  color: AppStyles.textLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onActionPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onActionPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.goldPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  actionText!,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Pre-configured empty states for common scenarios
class WishlistEmptyState extends StatelessWidget {
  final VoidCallback? onBrowse;

  const WishlistEmptyState({
    super.key,
    this.onBrowse,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: PhosphorIcons.heart(),
      title: 'Your wishlist is empty',
      subtitle: 'Save items you love to access them later',
      actionText: onBrowse != null ? 'Browse Items' : null,
      onActionPressed: onBrowse,
      iconColor: Colors.red.shade300,
    );
  }
}

class SearchEmptyState extends StatelessWidget {
  final String searchQuery;

  const SearchEmptyState({
    super.key,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: PhosphorIcons.magnifyingGlass(),
      title: 'No results found',
      subtitle: 'Try adjusting your search for "$searchQuery"',
    );
  }
}

class JobsEmptyState extends StatelessWidget {
  final VoidCallback? onRefresh;

  const JobsEmptyState({
    super.key,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: PhosphorIcons.briefcase(),
      title: 'No jobs available',
      subtitle: 'Check back later for new opportunities',
      actionText: onRefresh != null ? 'Refresh' : null,
      onActionPressed: onRefresh,
    );
  }
}

class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: PhosphorIcons.bell(),
      title: 'No notifications yet',
      subtitle: 'We\'ll notify you when something important happens',
    );
  }
}

class MessagesEmptyState extends StatelessWidget {
  final VoidCallback? onStartConversation;

  const MessagesEmptyState({
    super.key,
    this.onStartConversation,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: PhosphorIcons.chatCircle(),
      title: 'No messages yet',
      subtitle: 'Start a conversation to connect with others',
      actionText: onStartConversation != null ? 'Start Chat' : null,
      onActionPressed: onStartConversation,
    );
  }
}

class OrdersEmptyState extends StatelessWidget {
  final VoidCallback? onBrowse;

  const OrdersEmptyState({
    super.key,
    this.onBrowse,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: PhosphorIcons.shoppingCart(),
      title: 'No orders yet',
      subtitle: 'Your order history will appear here',
      actionText: onBrowse != null ? 'Start Shopping' : null,
      onActionPressed: onBrowse,
    );
  }
}

class NetworkErrorState extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorState({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: PhosphorIcons.wifiSlash(),
      title: 'Connection Error',
      subtitle: 'Please check your internet connection and try again',
      actionText: onRetry != null ? 'Try Again' : null,
      onActionPressed: onRetry,
      iconColor: Colors.orange.shade400,
    );
  }
}

class GenericErrorState extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const GenericErrorState({
    super.key,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: PhosphorIcons.warningCircle(),
      title: 'Something went wrong',
      subtitle: message ?? 'An unexpected error occurred. Please try again.',
      actionText: onRetry != null ? 'Try Again' : null,
      onActionPressed: onRetry,
      iconColor: Colors.red.shade400,
    );
  }
}