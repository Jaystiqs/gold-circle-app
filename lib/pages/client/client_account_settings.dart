import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../app_styles.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  bool _showEmailBanner = true;

  @override
  Widget build(BuildContext context) {
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
            if (_showEmailBanner) _buildEmailConfirmationBanner(),
            const SizedBox(height: 8),
            _buildMenuList(),
          ],
        ),
      ),
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
              onPressed: () {
                // Handle email confirmation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppStyles.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
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