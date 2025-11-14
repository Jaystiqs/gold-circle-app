import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _sheenController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _sheenAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller for the logo fade-in
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Animation controller for the sheen effect
    _sheenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Fade in animation for the logo
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );

    // Sheen animation that moves diagonally across the screen
    _sheenAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(
      CurvedAnimation(
        parent: _sheenController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the sheen animation immediately and repeat
    _sheenController.repeat();

    // Start the logo fade-in
    _fadeController.forward();

    // Check authentication and onboarding status after animations complete
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        _checkAuthAndOnboarding();
      }
    });
  }

  Future<void> _checkAuthAndOnboarding() async {
    // Check if user is already authenticated
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in, go to home
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/auth-wrapper');
      }
      return;
    }

    // User is not logged in, check if onboarding was completed
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding = prefs.getBool('has_completed_onboarding') ?? false;

    if (!mounted) return;

    if (hasCompletedOnboarding) {
      // Onboarding was completed before, go directly to auth
      Navigator.of(context).pushReplacementNamed('/auth');
    } else {
      // First time user, show intro page
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _sheenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF000000), // Pure black
                  Color(0xFF131313), // Slightly lighter black
                  Color(0xFF0D0D0D), // Dark black
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Animated sheen overlay
          AnimatedBuilder(
            animation: _sheenAnimation,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: const [
                      Color(0xFF000000), // Pure black
                      Color(0xFF131313), // Slightly lighter black
                      Color(0xFF0D0D0D), // Dark black
                    ],
                    stops: [
                      (_sheenAnimation.value - 0.2).clamp(0.0, 1.0),
                      _sheenAnimation.value.clamp(0.0, 1.0),
                      (_sheenAnimation.value + 0.2).clamp(0.0, 1.0),
                    ],
                  ),
                ),
              );
            },
          ),

          // Logo - fades in
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                'assets/images/GCAI_logo.png',
                width: 150,
                height: 150,
              ),
            ),
          ),
        ],
      ),
    );
  }
}