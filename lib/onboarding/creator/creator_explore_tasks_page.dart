import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';

class CreatorExploreTasksPage extends StatelessWidget {
  final VoidCallback onContinue;

  const CreatorExploreTasksPage({
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
                  'Lots of opportunities\nto work',
                  style: AppStyles.h1.copyWith(
                    fontSize: 32,
                    color: AppStyles.textPrimary,
                    fontWeight: AppStyles.bold,
                    letterSpacing: -1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Centered content (image and subtitle)
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
                                  'assets/images/ai_funnel_1.png', // Reusing the AI funnel image
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback if image not found
                                    return Center(
                                      child: Icon(
                                        Icons.work_outline,
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
                                'Browse through available projects posted by clients and submit proposals for work that matches your skills.',
                                style: AppStyles.bodyLarge.copyWith(
                                  fontSize: 19,
                                  height: 1.5,
                                  color: AppStyles.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
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
}