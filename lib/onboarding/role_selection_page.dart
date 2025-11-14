import 'package:flutter/material.dart';
import 'package:goldcircle/onboarding/client_onboarding_flow.dart';
import 'package:goldcircle/onboarding/creator_onboarding_flow.dart';
import 'package:goldcircle/onboarding/widgets/onboarding_progressbar.dart';
import '../utils/app_styles.dart';

class RoleSelectionPage extends StatelessWidget {
  final String referralCode;

  const RoleSelectionPage({
    super.key,
    required this.referralCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar - 66% (step 2 of 3)
            OnboardingProgressBar(
              progress: 0.66,
              onBack: () => Navigator.of(context).pop(),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    const Spacer(),

                    // Logo
                    Image.asset(
                      'assets/images/GCAI_logo.png',
                      width: 100,
                      height: 100,
                    ),

                    const SizedBox(height: 48),

                    // Title
                    Text(
                      'How do you want to use\nGold Circle?',
                      style: AppStyles.h2.copyWith(
                          height: 1.2,
                          fontSize: 28,
                          color: AppStyles.textPrimary,
                          fontWeight: AppStyles.semiBold,
                          letterSpacing: -1.0
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Choose your role to get started',
                      style: AppStyles.bodyLarge.copyWith(
                        color: AppStyles.textSecondary,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const Spacer(),

                    // Client Option
                    _RoleSelectionCard(
                      title: 'I need digital services',
                      subtitle: 'Find and hire talented creators',
                      assetImage: 'assets/images/tasks_lady.png',  // Your asset path
                      color: AppStyles.accentSecondary,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ClientOnboardingFlow(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Provider Option
                    _RoleSelectionCard(
                      title: 'I offer digital services',
                      subtitle: 'Showcase your skills and get\nhired',
                      assetImage: 'assets/images/freelancer.png',  // Your asset path
                      color: AppStyles.goldPrimary,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CreatorOnboardingFlow(),
                          ),
                        );
                      },
                    ),


                    const SizedBox(height: 32),
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

class _RoleSelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String assetImage;  // Changed from IconData icon
  final Color color;
  final VoidCallback onTap;

  const _RoleSelectionCard({
    required this.title,
    required this.subtitle,
    required this.assetImage,  // Changed parameter name
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppStyles.backgroundWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppStyles.border.withOpacity(0.05),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 67,
              height: 67,
              // decoration: BoxDecoration(
              //   color: color.withOpacity(0.1),
              //   borderRadius: BorderRadius.circular(14),
              // ),
              child: Image.asset(
                assetImage,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.h5.copyWith(
                      fontWeight: AppStyles.semiBold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppStyles.bodyMedium.copyWith(
                      color: AppStyles.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Icon(
            //   Icons.arrow_forward_ios_rounded,
            //   color: AppStyles.textLight,
            //   size: 20,
            // ),
          ],
        ),
      ),
    );
  }
}