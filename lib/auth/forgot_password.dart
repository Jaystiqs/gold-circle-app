import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../utils/app_styles.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _errorMessage = '';
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();

    // Add listener to rebuild UI when email text changes
    _emailController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendPasswordResetEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      setState(() {
        _emailSent = true;
      });

    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email address.';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests. Please try again later.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection.';
          break;
        default:
          errorMessage = 'Failed to send reset email. Please try again.';
      }

      setState(() {
        _errorMessage = errorMessage;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildSuccessView() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),

          // Success Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
              size: 48,
              color: Colors.green.shade600,
            ),
          ),

          const SizedBox(height: 32),

          Text(
            'Check your email',
            style: AppStyles.h2.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppStyles.bodyLarge.copyWith(
                color: AppStyles.textSecondary,
                height: 1.5,
              ),
              children: [
                const TextSpan(
                  text: 'We sent a password reset link to\n',
                ),
                TextSpan(
                  text: _emailController.text.trim(),
                  style: AppStyles.bodyLarge.copyWith(
                    color: AppStyles.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Center(
            child: Text('Expires in 1 hour.',
                    style: AppStyles.bodyMedium.copyWith(
                      color: Colors.blue.shade700,
                      height: 1.4,
                    ),
            ),
          ),

          // Container(
          //   padding: const EdgeInsets.all(16),
          //   decoration: BoxDecoration(
          //     color: Colors.blue.shade50,
          //     borderRadius: BorderRadius.circular(12),
          //     border: Border.all(color: Colors.blue.shade200),
          //   ),
          //   child: Row(
          //     children: [
          //       Icon(
          //         PhosphorIcons.info(),
          //         color: Colors.blue.shade700,
          //         size: 20,
          //       ),
          //       const SizedBox(width: 12),
          //       Expanded(
          //         child: Text(
          //           'Click the link in the email to reset your password. The link will expire in 1 hour.',
          //           style: AppStyles.bodyMedium.copyWith(
          //             color: Colors.blue.shade700,
          //             height: 1.4,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          const SizedBox(height: 40),

          // Back to Login Button
          SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.goldPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'Back to login',
                style: AppStyles.button.copyWith(color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // // Resend Option
          // Center(
          //   child: Column(
          //     children: [
          //       Text(
          //         'Didn\'t receive the email?',
          //         style: AppStyles.bodyMedium.copyWith(
          //           color: AppStyles.textSecondary,
          //         ),
          //       ),
          //       const SizedBox(height: 8),
          //       TextButton(
          //         onPressed: () {
          //           setState(() {
          //             _emailSent = false;
          //             _errorMessage = '';
          //           });
          //         },
          //         child: Text(
          //           'Try another email',
          //           style: AppStyles.bodyMedium.copyWith(
          //             color: AppStyles.textPrimary,
          //             fontWeight: FontWeight.w600,
          //             decoration: TextDecoration.underline,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildEmailForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),

        Text(
          'Reset your password',
          style: AppStyles.h2.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.left,
        ),

        const SizedBox(height: 16),

        Text(
          'Enter your email address and we\'ll send you a link to reset your password.',
          style: AppStyles.bodyLarge.copyWith(
            color: AppStyles.textSecondary,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 32),

        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          style: AppStyles.bodyLarge,
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: AppStyles.bodyMedium.copyWith(color: AppStyles.textLight),
            hintText: 'Enter your email',
            hintStyle: AppStyles.bodyLarge.copyWith(color: AppStyles.textLight),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppStyles.textPrimary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppStyles.textPrimary, width: 0.8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppStyles.textPrimary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.all(16),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!EmailValidator.validate(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
          onFieldSubmitted: (_) => _emailController.text.isNotEmpty ? _sendPasswordResetEmail() : null,
        ),

        const SizedBox(height: 24),

        SizedBox(
          height: 48,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_isLoading || _emailController.text.isEmpty)
                ? null
                : _sendPasswordResetEmail,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyles.goldPrimary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppStyles.textLight.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Text(
              'Send reset link',
              style: AppStyles.button.copyWith(color: Colors.white),
            ),
          ),
        ),

        const SizedBox(height: 24),

        Center(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Back to login',
              style: AppStyles.bodyMedium.copyWith(
                color: AppStyles.textPrimary,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    if (_errorMessage.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
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
                size: 20,
              ),
              const SizedBox(width: 8),
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
        ),
      ],
    );
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Show success view or email form based on state
                if (_emailSent) _buildSuccessView() else _buildEmailForm(),

                // Error message
                if (!_emailSent) _buildErrorMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}