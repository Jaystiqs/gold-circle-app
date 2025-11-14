import 'package:flutter/material.dart';
import 'package:goldcircle/utils/app_styles.dart';

class FullPageLoadingOverlay extends StatelessWidget {
  final String message;
  final String? subtitle;

  const FullPageLoadingOverlay({
    super.key,
    required this.message,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated loading indicator
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(AppStyles.goldPrimary),
                ),
              ),
              const SizedBox(height: 32),

              // Main message
              Text(
                message,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppStyles.textPrimary,
                  letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),

              if (subtitle != null) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppStyles.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Show a full-page loading overlay with improved timing
  static Future<T?> show<T>({
    required BuildContext context,
    required String message,
    String? subtitle,
    required Future<T> Function() task,
  }) async {
    // Show the overlay
    final overlayRoute = PageRouteBuilder(
      opaque: false,
      barrierDismissible: false,
      barrierColor: Colors.white,
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: FullPageLoadingOverlay(
            message: message,
            subtitle: subtitle,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
    );

    Navigator.of(context).push(overlayRoute);

    T? result;
    try {
      // Execute the task
      result = await task();

      // IMPROVED: Add a small delay to ensure UI stabilizes before dismissing
      await Future.delayed(const Duration(milliseconds: 150));

    } catch (error) {
      print('❌ Task failed in overlay: $error');
      rethrow;
    } finally {
      // Ensure overlay is dismissed
      if (context.mounted) {
        // Add small delay before dismissing to prevent jarring UI changes
        await Future.delayed(const Duration(milliseconds: 100));
        Navigator.of(context).pop();
      }
    }

    return result;
  }
}