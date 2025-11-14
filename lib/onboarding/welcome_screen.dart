import 'package:flutter/material.dart';
import 'package:goldcircle/onboarding/role_selection_page.dart';
import 'package:goldcircle/onboarding/widgets/onboarding_progressbar.dart';
import '../utils/app_styles.dart';

class WelcomePage extends StatelessWidget {
  final String referralCode;

  const WelcomePage({
    super.key,
    required this.referralCode,
  });

  void _continue(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoleSelectionPage(
          referralCode: referralCode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar - 33% (step 1 of 3)
            OnboardingProgressBar(
              progress: 0.33,
              onBack: () => Navigator.of(context).pop(),
            ),

            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    const SizedBox(height: 48),

                    // Welcome Title
                    Text(
                      'Welcome',
                      style: AppStyles.h1.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 28,
                        color: AppStyles.textBlack,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    // Subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Gold Circle AI connects talented creators with clients who need their expertise.',
                        style: AppStyles.bodyLarge.copyWith(
                          color: AppStyles.textSecondary,
                          height: 1.3,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const Spacer(),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => _continue(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyles.goldPrimary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Continue',
                          style: AppStyles.button.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),
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