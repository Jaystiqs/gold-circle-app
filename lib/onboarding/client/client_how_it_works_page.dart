import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';

class ClientHowItWorksPage extends StatelessWidget {
  final VoidCallback onContinue;

  const ClientHowItWorksPage({
    super.key,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Fixed Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
          child: Text(
            'How it works',
            style: AppStyles.h1.copyWith(
              fontSize: 32,
              color: AppStyles.textPrimary,
              fontWeight: AppStyles.bold,
              letterSpacing: -1.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 28,),
        // Scrollable Timeline
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 32),

                // Step 1
                _buildTimelineStep(
                  stepNumber: '1',
                  title: 'You tell us what you need',
                  description: 'Share your project details and requirements with us',
                  isLast: false,
                ),

                // Step 2
                _buildTimelineStep(
                  stepNumber: '2',
                  title: 'We find the best matches',
                  description: 'Our AI connects you with top-rated creators',
                  isLast: false,
                ),

                // Step 3
                _buildTimelineStep(
                  stepNumber: '3',
                  title: 'You choose who to work with',
                  description: 'Review profiles and select the perfect fit for your project',
                  isLast: true,
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
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.textBlack,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineStep({
    required String stepNumber,
    required String title,
    required String description,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            // Circle with number
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppStyles.goldPrimary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  stepNumber,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Connecting line
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppStyles.goldPrimary.withOpacity(0.3),
                ),
              ),
          ],
        ),

        const SizedBox(width: 20),

        // Content
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 24, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppStyles.textBlack,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 8),

                // Description
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppStyles.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}