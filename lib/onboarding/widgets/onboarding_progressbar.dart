import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';

class OnboardingProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final VoidCallback? onBack;

  const OnboardingProgressBar({
    super.key,
    required this.progress,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Centered progress bar
          Center(
            child: SizedBox(
              width: 120, // Short fixed width - adjust as needed
              child: Stack(
                children: [
                  // Background bar
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Progress bar
                  FractionallySizedBox(
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppStyles.goldPrimary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Back button positioned on the left, vertically centered
          if (onBack != null)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: AppStyles.textPrimary),
                onPressed: onBack,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
        ],
      ),
    );
  }
}