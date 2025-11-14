import 'package:flutter/material.dart';
import 'package:goldcircle/bottom_navigation_client.dart';
import 'package:provider/provider.dart';
import 'package:goldcircle/creators/user_provider.dart';
import 'package:goldcircle/creators/app_mode_provider.dart';
import '../bottom_navigation_creator.dart';
import '../utils/app_styles.dart';
import 'consolidated_auth.dart';
import 'email_verification.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _authDismissed = false;
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
      // SKIP EMAIL VERIFICATION - treat as authenticated
      // User exists but not verified - just let them into the app
        setState(() {
          _hasShownAuth = false;
        });
        break;

      case UserState.authenticated:
      // User is fully authenticated - reset navigation flags
        setState(() {
          _hasShownAuth = false;
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
    return Consumer2<UserProvider, AppModeCreator>(
      builder: (context, userProvider, appModeProvider, child) {
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

        // Choose navigation based on app mode
        if (appModeProvider.isCreatorMode) {
          return CreatorBottomNavigation(
            onShowAuth: _navigateToAuth,
            isLoggedIn: userProvider.isLoggedIn,
          );
        } else {
          return BottomNavigation(
            onShowAuth: _navigateToAuth,
            isLoggedIn: userProvider.isLoggedIn,
          );
        }
      },
    );
  }
}