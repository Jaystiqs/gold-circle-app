import 'package:flutter/material.dart';
import 'package:goldcircle/onboarding/welcome_screen.dart';
import '../utils/app_styles.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final TextEditingController _referralController = TextEditingController();

  @override
  void dispose() {
    _referralController.dispose();
    super.dispose();
  }

  void _getStarted() {
    // Navigate to welcome page (with progress)
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WelcomePage(
          referralCode: _referralController.text.trim(),
        ),
      ),
    );
  }

  void _logIn() {
    // Navigate to auth page
    Navigator.of(context).pushNamed('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo
              Image.asset(
                'assets/images/full_logo.png',
                width: 150,
                height: 150,
              ),

              const Spacer(flex: 3),

              // Get Started Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _getStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.goldPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Get Started',
                    style: AppStyles.button.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 4),


              TextButton(onPressed: _logIn,
                child:
                Text(
                  'Log In',
                  style: AppStyles.button.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.5,
                    color: AppStyles.textPrimary,
                  ),
                ),
              ),
              // // Log In Button
              // SizedBox(
              //   width: double.infinity,
              //   height: 56,
              //   child: OutlinedButton(
              //     onPressed: _logIn,
              //     style: OutlinedButton.styleFrom(
              //       foregroundColor: AppStyles.textPrimary,
              //       side: BorderSide(
              //         color: AppStyles.border.withOpacity(0.3),
              //         width: 1.5,
              //       ),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(28),
              //       ),
              //     ),
              //     child: Text(
              //       'LOG IN',
              //       style: AppStyles.button.copyWith(
              //         fontSize: 15,
              //         fontWeight: FontWeight.w600,
              //         letterSpacing: 1.2,
              //         color: AppStyles.textSecondary,
              //       ),
              //     ),
              //   ),
              // ),

              const SizedBox(height: 32),

              // Terms Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppStyles.bodySmall.copyWith(
                      color: AppStyles.textPrimary,
                      fontSize: 11,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(text: 'By continuing, you agree to our '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: AppStyles.textPrimary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: '\nand '),
                      TextSpan(
                        text: 'Terms of Use',
                        style: TextStyle(
                          color: AppStyles.textPrimary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}