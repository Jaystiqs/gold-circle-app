import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/app_styles.dart';
import '../../creators/user_provider.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  bool _showEmailBanner = false;
  bool _isLoading = false;
  bool _isCheckingVerification = true;

  @override
  void initState() {
    super.initState();
    _checkEmailVerificationStatus();
  }

  Future<void> _checkEmailVerificationStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() {
          _isCheckingVerification = false;
        });
      }
      return;
    }

    try {
      // Reload user data to get fresh verification status
      await user.reload();

      // Get the updated user
      final updatedUser = FirebaseAuth.instance.currentUser;

      if (mounted) {
        setState(() {
          // Only show banner if email is NOT verified
          _showEmailBanner = updatedUser != null && !updatedUser.emailVerified;
          _isCheckingVerification = false;
        });
      }
    } catch (e) {
      print('Error checking verification status: $e');
      if (mounted) {
        setState(() {
          _isCheckingVerification = false;
        });
      }
    }
  }

  Future<void> _sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Check if already verified
    await user.reload();
    final reloadedUser = FirebaseAuth.instance.currentUser;

    if (reloadedUser != null && reloadedUser.emailVerified) {
      if (mounted) {
        setState(() {
          _showEmailBanner = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  PhosphorIcons.check(),
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Your email is already verified!'),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await user.sendEmailVerification();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  PhosphorIcons.check(),
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Verification email sent! Check your inbox.'),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'too-many-requests':
          errorMessage = 'Too many requests. Please wait before trying again.';
          break;
        default:
          errorMessage = 'Failed to send verification email. Please try again.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  PhosphorIcons.warning(),
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(errorMessage),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = FirebaseAuth.instance.currentUser;
        final isEmailVerified = user?.emailVerified ?? true;

        return Scaffold(
          backgroundColor: AppStyles.backgroundWhite,
          appBar: AppBar(
            backgroundColor: AppStyles.backgroundWhite,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                PhosphorIcons.arrowLeft(),
                color: AppStyles.textPrimary,
                size: 28,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppStyles.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                if (!isEmailVerified && _showEmailBanner)
                  _buildEmailConfirmationBanner(),
                const SizedBox(height: 8),
                _buildMenuList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmailConfirmationBanner() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppStyles.backgroundGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  PhosphorIcons.envelope(),
                  size: 24,
                  color: AppStyles.textPrimary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Confirm your email address',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppStyles.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'We\'ll send a code to your inbox.',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppStyles.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  PhosphorIcons.x(),
                  color: AppStyles.textSecondary,
                  size: 24,
                ),
                onPressed: () {
                  setState(() {
                    _showEmailBanner = false;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _sendVerificationEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppStyles.textPrimary,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppStyles.textPrimary,
                  ),
                ),
              )
                  : Text(
                'Confirm email',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList() {
    return Column(
      children: [
        _buildMenuItem(
          icon: PhosphorIcons.user(),
          title: 'Personal information',
          onTap: () {
            // Navigate to personal information
          },
        ),
        _buildMenuItem(
          icon: PhosphorIcons.shield(),
          title: 'Login & security',
          onTap: () {
            // Navigate to login & security
          },
        ),
        _buildMenuItem(
          icon: PhosphorIcons.hand(),
          title: 'Privacy',
          onTap: () {
            // Navigate to privacy
          },
        ),
        _buildMenuItem(
          icon: PhosphorIcons.bell(),
          title: 'Notifications',
          onTap: () {
            // Navigate to notifications
          },
        ),
        _buildMenuItem(
          icon: PhosphorIcons.creditCard(),
          title: 'Payments',
          onTap: () {
            // Navigate to payments
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: AppStyles.textPrimary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppStyles.textPrimary,
                ),
              ),
            ),
            Icon(
              PhosphorIcons.caretRight(),
              size: 20,
              color: AppStyles.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}