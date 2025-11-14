import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';

class CreatorBenefitsPage extends StatelessWidget {
  final VoidCallback onContinue;

  const CreatorBenefitsPage({
    super.key,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              // Title at top
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0),
                child: Text(
                  'Get matched with the\nright clients',
                  style: AppStyles.h1.copyWith(
                    height: 1.2,
                    fontSize: 32,
                    fontWeight: AppStyles.bold,
                    color: AppStyles.textPrimary,
                    letterSpacing: -1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Centered content (image and description)
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Image placeholder
                              Container(
                                width: double.infinity,
                                height: 200,
                                child: Image.asset(
                                  'assets/images/ai_system.png', // Reusing the AI system image
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback if image not found
                                    return Center(
                                      child: Icon(
                                        Icons.connect_without_contact,
                                        size: 80,
                                        color: AppStyles.goldPrimary.withOpacity(0.5),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 44),

                              // Description
                              Text(
                                'Gold Circle\'s intelligent AI matches you with clients looking for your specific skills and experience level.',
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
                    );
                  },
                ),
              ),
            ],
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

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppStyles.goldPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 22,
            color: AppStyles.goldPrimary,
          ),
        ),

        const SizedBox(width: 14),

        // Text content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppStyles.textBlack,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: AppStyles.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}