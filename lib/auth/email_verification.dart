import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../utils/app_styles.dart';

class EmailVerificationPage extends StatefulWidget {
  final String? email;

  const EmailVerificationPage({super.key, this.email});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool _isResending = false;
  bool _isCheckingVerification = false;
  String _errorMessage = '';
  String _successMessage = '';

  String get userEmail {
    return widget.email ?? FirebaseAuth.instance.currentUser?.email ?? '';
  }

  @override
  void initState() {
    super.initState();
    print('🚀 EmailVerificationPage initialized');
    print('📧 Auto-sending verification email...');
    // Automatically send verification email when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resendVerificationEmail();
    });
  }

  Future<void> _checkEmailVerification() async {
    print('🔍 Checking email verification status...');

    setState(() {
      _isCheckingVerification = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print('❌ No current user found');
        setState(() {
          _errorMessage = 'No user found. Please sign in again.';
        });
        return;
      }

      print('🔄 Reloading user profile...');
      // Use reload() to refresh the user's profile data including emailVerified
      await user.reload();

      // Also refresh the ID token to ensure everything is synced
      await user.getIdToken(true);

      // Small delay to ensure the refresh is processed
      await Future.delayed(const Duration(milliseconds: 500));

      // Get the refreshed user after reload
      final refreshedUser = FirebaseAuth.instance.currentUser;

      print('✨ User profile reloaded. Checking verification status...');
      print('📧 Email verified: ${refreshedUser?.emailVerified ?? 'unknown'}');

      if (refreshedUser?.emailVerified == true) {
        print('🎉 Email verification successful!');
        print('🏠 Navigating to home page...');

        setState(() {
          _successMessage = 'Email verified successfully!';
        });

        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        }
      } else {
        print('⏳ Email not yet verified');
        setState(() {
          _errorMessage = 'Email not yet verified. Please check your email and try again.';
        });
      }
    } catch (e) {
      print('❌ Error in _checkEmailVerification: $e');
      print('   Error type: ${e.runtimeType}');
      setState(() {
        _errorMessage = 'Error checking verification status. Please try again.';
      });
    } finally {
      print('🔍 Email verification check completed');
      if (mounted) {
        setState(() {
          _isCheckingVerification = false;
        });
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    print('📧 Starting email verification send process...');
    print('📧 Target email: $userEmail');

    setState(() {
      _isResending = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      // Explicit null check
      if (user == null) {
        print('❌ No current user found - cannot send verification email');
        setState(() {
          _errorMessage = 'No user session found. Please sign in again.';
        });
        return;
      }

      print('📧 Current user: ${user.uid}');
      print('📧 User email: ${user.email}');
      print('📧 User email verified status: ${user.emailVerified}');

      // Check if email is already verified
      if (user.emailVerified) {
        print('✅ Email is already verified');
        setState(() {
          _successMessage = 'Your email is already verified!';
        });
        return;
      }

      // Reload user to get latest verification status
      await user.reload();
      final reloadedUser = FirebaseAuth.instance.currentUser;

      if (reloadedUser?.emailVerified == true) {
        print('✅ Email was already verified (discovered after reload)');
        setState(() {
          _successMessage = 'Your email is already verified!';
        });
        return;
      }

      // Send verification email
      await user.sendEmailVerification();

      print('✅ Verification email sent successfully to: ${user.email}');
      print('📧 Please check your email inbox and spam folder');

      setState(() {
        _successMessage = 'Verification email sent successfully!';
      });

    } on FirebaseAuthException catch (e) {
      print('❌ FirebaseAuthException occurred:');
      print('   Error code: ${e.code}');
      print('   Error message: ${e.message}');

      String errorMessage;
      switch (e.code) {
        case 'too-many-requests':
          errorMessage = 'Too many requests. Please wait a few minutes before trying again.';
          print('⚠️  Rate limit exceeded - user needs to wait');
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'User not found. Please sign in again.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your internet connection.';
          break;
        default:
          errorMessage = 'Failed to send verification email: ${e.message}';
          print('⚠️  Firebase auth error: ${e.code}');
      }

      setState(() {
        _errorMessage = errorMessage;
      });
    } catch (e) {
      print('❌ Unexpected error occurred:');
      print('   Error: $e');
      print('   Error type: ${e.runtimeType}');

      setState(() {
        _errorMessage = 'Failed to send verification email. Please try again.';
      });
    } finally {
      print('📧 Email verification send process completed');
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  Widget _buildMessage() {
    if (_successMessage.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Row(
          children: [
            Icon(
              PhosphorIcons.checkCircle(),
              color: Colors.green.shade700,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _successMessage,
                style: AppStyles.bodyMedium.copyWith(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Icon(
              PhosphorIcons.warningCircle(),
              color: Colors.red.shade700,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _errorMessage,
                style: AppStyles.bodyMedium.copyWith(
                  color: Colors.red.shade700,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(PhosphorIcons.arrowLeft()),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppStyles.textPrimary,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              Text(
                'Check your email',
                style: AppStyles.h2.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              RichText(
                text: TextSpan(
                  style: AppStyles.bodyLarge.copyWith(
                    color: AppStyles.textSecondary,
                  ),
                  children: [
                    const TextSpan(text: 'We sent a verification link to '),
                    TextSpan(
                      text: userEmail,
                      style: AppStyles.bodyLarge.copyWith(
                        color: AppStyles.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      PhosphorIcons.envelope(),
                      color: Colors.blue.shade700,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Click the link in the email to verify your account, then come back and tap "I\'ve verified my email".',
                        style: AppStyles.bodyMedium.copyWith(
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Black verification button without icon
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isCheckingVerification ? null : _checkEmailVerification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.blackSoft,
                    foregroundColor: AppStyles.backgroundWhite,
                    disabledBackgroundColor: AppStyles.textLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: _isCheckingVerification
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Text(
                    'I\'ve verified my email',
                    style: AppStyles.button.copyWith(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Resend email option
              Center(
                child: Column(
                  children: [
                    Text(
                      'Didn\'t get an email?',
                      style: AppStyles.bodyMedium.copyWith(
                        color: AppStyles.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _isResending ? null : _resendVerificationEmail,
                      child: Text(
                        _isResending ? 'Sending...' : 'Send again',
                        style: AppStyles.bodyMedium.copyWith(
                          color: AppStyles.textPrimary,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Success/Error messages
              _buildMessage(),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}