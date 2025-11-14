import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../utils/app_styles.dart';

class ClientNotificationsPage extends StatelessWidget {
  final VoidCallback onContinue;

  const ClientNotificationsPage({
    super.key,
    required this.onContinue,
  });

  Future<void> _handleNotificationPermission(BuildContext context) async {
    // Request notification permission
    final status = await Permission.notification.request();

    if (status.isGranted) {
      // Permission granted, continue to next page
      onContinue();
    } else if (status.isDenied) {
      // Permission denied, but still continue (user can enable later)
      onContinue();
    } else if (status.isPermanentlyDenied) {
      // Show dialog to open settings
      _showSettingsDialog(context);
    } else {
      // For other statuses, just continue
      onContinue();
    }
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Permission'),
        content: const Text(
          'Notifications are permanently disabled. Please enable them in your device settings to stay updated.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onContinue();
            },
            child: const Text('Skip'),
          ),
          ElevatedButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
              onContinue();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyles.textBlack,
              foregroundColor: Colors.white,
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Title
                Text(
                  'Stay Updated',
                  style: AppStyles.h1.copyWith(
                    fontSize: 32,
                    fontWeight: AppStyles.bold,
                    color: AppStyles.textPrimary,
                    letterSpacing: -1.0,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // Lottie Animation
                SizedBox(
                  width: 280,
                  height: 280,
                  child: Lottie.asset(
                    'assets/animations/bell.json',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback icon if Lottie file not found
                      return Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppStyles.goldPrimary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.notifications_active,
                            size: 64,
                            color: AppStyles.goldPrimary,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 48),

                // Description
                Text(
                  'Get notified about new matches, messages, and updates on your tasks.',
                  style: AppStyles.bodyLarge.copyWith(
                    fontSize: 19,
                    height: 1.5,
                    color: AppStyles.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),

        // Fixed Continue Button
        Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: AppStyles.backgroundWhite,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _handleNotificationPermission(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.textBlack,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Enable Notifications',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: onContinue,
                child: Text(
                  'Skip for now',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppStyles.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefit({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppStyles.goldPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppStyles.goldPrimary,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: AppStyles.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}