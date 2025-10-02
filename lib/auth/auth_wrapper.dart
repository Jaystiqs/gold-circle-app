import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:goldcircle/providers/user_provider.dart';
import '../app_styles.dart';
import 'consolidated_auth.dart';
import '../bottom_navigation.dart';
import 'email_verification.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _authDismissed = false;
  bool _hasShownVerification = false;
  bool _hasShownAuth = false;

  void _navigateToAuth() {
    if (_hasShownAuth) return; // Prevent multiple auth screens

    setState(() {
      _hasShownAuth = true;
    });

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ConsolidatedAuthPage(),
        fullscreenDialog: true,
      ),
    ).then((_) {
      // Auth was dismissed/closed
      setState(() {
        _authDismissed = true;
        _hasShownAuth = false;
      });
    });
  }

  void _showVerificationPage() {
    if (_hasShownVerification) return; // Prevent multiple verification screens

    setState(() {
      _hasShownVerification = true;
    });

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EmailVerificationPage(),
        fullscreenDialog: true,
      ),
    ).then((_) {
      // Verification page was dismissed
      setState(() {
        _hasShownVerification = false;
      });
    });
  }

  void _handleUserStateChange(UserProvider userProvider) {
    final userState = userProvider.userState;

    // Reset flags when user state changes significantly
    if (userProvider.firebaseUser != null) {
      setState(() {
        _authDismissed = false; // Reset dismissal if user logs in
      });
    }

    // Handle different user states
    switch (userState) {
      case UserState.loading:
      // Do nothing - show loading in build method
        break;

      case UserState.unauthenticated:
      // No user - show auth if not dismissed and not already showing
        if (!_authDismissed && !_hasShownAuth) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _navigateToAuth();
          });
        }
        break;

      case UserState.unverified:
      // User exists but not verified - show verification if not already showing
        if (!_hasShownVerification) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showVerificationPage();
          });
        }
        break;

      case UserState.authenticated:
      // User is fully authenticated - reset navigation flags
        setState(() {
          _hasShownAuth = false;
          _hasShownVerification = false;
        });
        break;

      case UserState.error:
      // Handle error state - could show error dialog or retry mechanism
        debugPrint('UserProvider error: ${userProvider.errorMessage}');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Handle auth state changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleUserStateChange(userProvider);
        });

        // Show loading while initializing
        if (userProvider.userState == UserState.loading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppStyles.goldPrimary),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Loading...',
                    style: AppStyles.bodyMedium.copyWith(
                      color: AppStyles.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Show error state with retry option
        if (userProvider.userState == UserState.error) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Something went wrong',
                      style: AppStyles.h4.copyWith(
                        color: AppStyles.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userProvider.errorMessage ?? 'Unknown error occurred',
                      style: AppStyles.bodyMedium.copyWith(
                        color: AppStyles.textLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        userProvider.refreshUserData();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Always show BottomNavigation as base
        // The user state determines what content is shown
        return BottomNavigation(
          onShowAuth: _navigateToAuth,
          isLoggedIn: userProvider.isLoggedIn,
        );
      },
    );
  }
}
