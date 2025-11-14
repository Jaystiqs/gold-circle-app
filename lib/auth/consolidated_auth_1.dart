import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../utils/app_styles.dart';
import 'forgot_password.dart';

enum AuthStep {
  emailEntry,
  loginPassword,
  signupDetails,
}

class ConsolidatedAuthPage extends StatefulWidget {
  const ConsolidatedAuthPage({super.key});

  @override
  State<ConsolidatedAuthPage> createState() => _ConsolidatedAuthPageState();
}

class _ConsolidatedAuthPageState extends State<ConsolidatedAuthPage> {
  AuthStep _currentStep = AuthStep.emailEntry;

  // Form controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  DateTime? _selectedBirthDate;
  final _formKey = GlobalKey<FormState>();

  // State variables
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String _errorMessage = '';
  bool _isExistingUser = false;

  @override
  void initState() {
    super.initState();

    // Add listeners to rebuild UI when text fields change
    _emailController.addListener(() {
      setState(() {});
    });

    _passwordController.addListener(() {
      setState(() {});
    });

    _firstNameController.addListener(() {
      setState(() {});
    });

    _lastNameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _checkUserExists() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Check the user_emails collection for email existence
      final DocumentSnapshot emailDoc = await FirebaseFirestore.instance
          .collection('user_emails')
          .doc(_emailController.text.trim().toLowerCase())
          .get();

      if (emailDoc.exists) {
        // Email exists, user should login
        setState(() {
          _isExistingUser = true;
          _currentStep = AuthStep.loginPassword;
        });
      } else {
        // Email is available, user can sign up
        setState(() {
          _isExistingUser = false;
          _currentStep = AuthStep.signupDetails;
        });
      }

    } on FirebaseException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'permission-denied':
          errorMessage = 'Permission denied. Please try again.';
          break;
        case 'unavailable':
          errorMessage = 'Service temporarily unavailable. Please try again.';
          break;
        default:
          errorMessage = 'Error checking email. Please try again.';
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

  // Add this method to test your Firestore rules after the fix
  Future<void> _testFirestoreRules() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print('❌ No authenticated user for testing');
      return;
    }

    try {
      print('🧪 Testing Firestore rules...');

      // Test 1: Create a user document
      print('📝 Test 1: Creating user document...');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .set({
        'email': 'test@example.com',
        'firstName': 'Test',
        'lastName': 'User',
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('✅ User document created successfully');

      // Test 2: Create an email document
      print('📧 Test 2: Creating email document...');
      await FirebaseFirestore.instance
          .collection('user_emails')
          .doc('test@example.com')
          .set({
        'userId': currentUser.uid,
        'exists': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('✅ Email document created successfully');

      // Test 3: Read the documents back
      print('📖 Test 3: Reading documents...');
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      print('✅ User document read: ${userDoc.exists}');

      final emailDoc = await FirebaseFirestore.instance
          .collection('user_emails')
          .doc('test@example.com')
          .get();
      print('✅ Email document read: ${emailDoc.exists}');

      // Clean up test documents
      print('🧹 Cleaning up test documents...');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .delete();
      await FirebaseFirestore.instance
          .collection('user_emails')
          .doc('test@example.com')
          .delete();
      print('✅ Test completed successfully!');

    } catch (e) {
      print('❌ Firestore rules test failed: $e');
    }
  }

  Future<void> _deleteUserEmailRecord(String email) async {
    try {
      await FirebaseFirestore.instance
          .collection('user_emails')
          .doc(email.toLowerCase())
          .delete();
    } catch (e) {
      print('Error deleting email record: $e');
    }
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      //TODO -- TEST // Call this method after successful login to test:
      await _testFirestoreRules();

      // For login, go directly to main app (not email verification)
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);

        // Alternative: Navigator.of(context).pop(); if you want to go back to previous screen
      }

    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'user-not-found':
          errorMessage = 'No account found with this email.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many failed attempts. Please try again later.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection.';
          break;
        default:
          errorMessage = 'Login failed. Please try again.';
      }

      setState(() {
        _errorMessage = errorMessage;
      });
    } catch (e) {
      // Handle the pigeon interface error
      setState(() {
        _errorMessage = 'Authentication error. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check age requirement
    if (_selectedBirthDate == null) {
      setState(() {
        _errorMessage = 'Please select your date of birth.';
      });
      return;
    }

    final age = DateTime.now().difference(_selectedBirthDate!).inDays / 365.25;
    if (age < 18) {
      setState(() {
        _errorMessage = 'You must be at least 18 years old to sign up.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    bool registrationSuccessful = false;

    try {
      // Create the user account
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      print('✅ User created successfully: ${userCredential.user?.uid}');

      // Update the user's display name (should work with updated packages)
      final fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';
      await userCredential.user?.updateDisplayName(fullName);
      print('✅ Display name updated: $fullName');

      // Small delay to ensure auth state propagates to Firestore
      await Future.delayed(const Duration(milliseconds: 300));

      // Create user document in Firestore
      if (userCredential.user != null) {
        await _createUserDocument(userCredential.user!);
        print('✅ User document created successfully');
      }

      // Mark registration as successful BEFORE navigation
      registrationSuccessful = true;
      print('✅ Registration completed successfully!');

      // Navigate to email verification
      if (mounted) {
        // Navigator.of(context).pushNamedAndRemoveUntil('/email-verification', (route) => false);
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      }

    } on FirebaseAuthException catch (e) {
      print('❌ FirebaseAuthException: ${e.code} - ${e.message}');

      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'Password is too weak. Please choose a stronger password.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists with this email.';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection.';
          break;
        default:
          errorMessage = 'Signup failed: ${e.message ?? "Please try again."}';
      }

      setState(() {
        _errorMessage = errorMessage;
      });
    } on FirebaseException catch (e) {
      print('❌ FirebaseException during document creation: ${e.code} - ${e.message}');

      // If Firestore document creation fails, clean up the Auth user
      try {
        await FirebaseAuth.instance.currentUser?.delete();
        print('✅ Cleaned up auth user after Firestore failure');
      } catch (deleteError) {
        print('⚠️ Could not delete auth user: $deleteError');
      }

      setState(() {
        _errorMessage = 'Failed to complete registration. Please try again.';
      });
    } catch (e, stackTrace) {
      print('❌ Unexpected error during signup: $e');
      print('📍 Stack trace: $stackTrace');

      // Only show error if registration wasn't successful
      if (!registrationSuccessful) {
        // Check if user was partially created
        if (FirebaseAuth.instance.currentUser != null) {
          print('⚠️ User was created but something failed - likely Firestore permissions');
          // Try one more time to create the documents
          try {
            await _createUserDocument(FirebaseAuth.instance.currentUser!);
            print('✅ Retry successful - proceeding to verification');
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil('/email-verification', (route) => false);
              return;
            }
          } catch (retryError) {
            print('❌ Retry failed: $retryError');
          }
        }

        if (mounted) {
          setState(() {
            _errorMessage = 'Registration error. Please try again.';
          });
        }
      } else {
        print('⚠️ Error occurred after successful registration - ignoring');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _createUserDocument(User user) async {
    print('📝 Starting _createUserDocument for user: ${user.uid}');

    try {
      // Prepare user data with role structure
      final userData = {
        'email': _emailController.text.trim().toLowerCase(),
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'fullName': '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
        'birthDate': _selectedBirthDate != null ? Timestamp.fromDate(_selectedBirthDate!) : null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'emailVerified': false,

        // Role structure
        'currentRole': 'client', // Default to client mode
        'activeRoles': ['client'], // Client role is activated by default
        'preferences': {
          'defaultRole': 'client',
        },
      };

      // Create user document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userData);

      print('✅ User document created in Firestore');

      // Create email tracking document
      final emailData = {
        'userId': user.uid,
        'exists': true,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('user_emails')
          .doc(_emailController.text.trim().toLowerCase())
          .set(emailData);

      print('✅ Email document created in Firestore');

      // Create initial client profile (activated by default)
      await _createInitialClientProfile(user.uid);

    } on FirebaseException catch (e) {
      print('❌ Firestore Error:');
      print('   Code: ${e.code}');
      print('   Message: ${e.message}');

      if (e.code == 'permission-denied') {
        print('🔍 Permission denied - Check these:');
        print('   1. User UID: ${user.uid}');
        print('   2. User is authenticated: ${FirebaseAuth.instance.currentUser != null}');
        print('   3. Firestore rules allow write to users/${user.uid}');
      }

      rethrow;
    }
  }

  Future<void> _createInitialClientProfile(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('clients').doc(uid).set({
        'uid': uid,
        'preferences': {},
        'savedProviders': [],
        'activeProjects': [],
        'isActive': true,
        'location': 'Accra, Ghana',
        'activeOrders': 0,
        'completedOrders': 0,
        'totalSpent': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Initial client profile created');
    } catch (e) {
      print('⚠️ Error creating initial client profile: $e');
      // Don't rethrow - client profile creation is not critical for signup
    }
  }

  void _goBack() {
    setState(() {
      _currentStep = AuthStep.emailEntry;
      _passwordController.clear();
      _firstNameController.clear();
      _lastNameController.clear();
      _selectedBirthDate = null;
      _errorMessage = '';
      _isPasswordVisible = false;
    });
  }

  Widget _buildEmailEntry() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),

        Text(
          'Sign in to Gold Circle',
          style: AppStyles.h3.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.left,
        ),

        const SizedBox(height: 40),

        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          style: AppStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Email',
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
          onFieldSubmitted: (_) => _emailController.text.isNotEmpty ? _checkUserExists() : null,
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 48,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_isLoading || _emailController.text.isEmpty) ? null : _checkUserExists,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyles.goldPrimary,
              foregroundColor: AppStyles.backgroundWhite,
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
              'Continue',
              style: AppStyles.button.copyWith(color: Colors.white),
            ),
          ),
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(child: Divider(color: AppStyles.border)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'or',
                style: AppStyles.bodyMedium.copyWith(color: AppStyles.textLight),
              ),
            ),
            Expanded(child: Divider(color: AppStyles.border)),
          ],
        ),

        const SizedBox(height: 24),

        //// Social login buttons
        // _buildSocialButton(
        //   icon: PhosphorIcons.deviceMobile(),
        //   text: 'Continue with Phone',
        //   onTap: () {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(content: Text('Phone authentication coming soon!')),
        //     );
        //   },
        // ),

        const SizedBox(height: 12),

        _buildSocialButton(
          icon: PhosphorIcons.googleLogo(),
          text: 'Continue with Google',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Google Sign-In coming soon!')),
            );
          },
        ),

        const SizedBox(height: 12),

        _buildSocialButton(
          icon: PhosphorIcons.appleLogo(),
          text: 'Continue with Apple',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Apple Sign-In coming soon!')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoginPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),

        Text(
          'Log in',
          style: AppStyles.h3.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.left,
        ),

        const SizedBox(height: 32),

        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          textInputAction: TextInputAction.done,
          style: AppStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Password',
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
            suffixIcon: TextButton(
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              child: Text(
                _isPasswordVisible ? 'Hide' : 'Show',
                style: AppStyles.bodyMedium.copyWith(
                  color: AppStyles.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
          onFieldSubmitted: (_) => _passwordController.text.isNotEmpty ? _signIn() : null,
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 48,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_isLoading || _passwordController.text.isEmpty) ? null : _signIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyles.goldPrimary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppStyles.textLight,
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
              'Continue',
              style: AppStyles.button.copyWith(color: Colors.white),
            ),
          ),
        ),

        const SizedBox(height: 24),

        Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ForgotPasswordPage(),
                ),
              );
            },
            child: Text(
              'Forgot password',
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

  String _getPasswordStrength() {
    final password = _passwordController.text;
    if (password.isEmpty) return '';

    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    switch (score) {
      case 0:
      case 1:
        return 'weak';
      case 2:
      case 3:
        return 'fair';
      case 4:
        return 'good';
      case 5:
        return 'excellent';
      default:
        return '';
    }
  }

  Color _getPasswordStrengthColor() {
    switch (_getPasswordStrength()) {
      case 'weak':
        return Colors.red;
      case 'fair':
        return Colors.orange;
      case 'good':
        return Colors.blue;
      case 'excellent':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppStyles.goldPrimary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppStyles.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  String _formatBirthDate() {
    if (_selectedBirthDate == null) return '';

    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    return '${months[_selectedBirthDate!.month - 1]} ${_selectedBirthDate!.day}, ${_selectedBirthDate!.year}';
  }

  Widget _buildSignupDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // const SizedBox(height: 40),

        Text(
          'Finish signing up',
          style: AppStyles.h2.copyWith(
            // fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.left,
        ),

        const SizedBox(height: 32),

        // Legal name section
        Text(
          'Legal name',
          style: AppStyles.h4.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 16),

        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppStyles.textPrimary, width: 0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  controller: _firstNameController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  style: AppStyles.bodyLarge,
                  decoration: InputDecoration(
                    labelText: 'First name on ID',
                    labelStyle: AppStyles.bodySmall.copyWith(color: AppStyles.textLight),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                height: 1,
                color: AppStyles.textPrimary,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  controller: _lastNameController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  style: AppStyles.bodyLarge,
                  decoration: InputDecoration(
                    labelText: 'Last name on ID',
                    labelStyle: AppStyles.bodySmall.copyWith(color: AppStyles.textLight),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        RichText(
          text: TextSpan(
            style: AppStyles.bodySmall.copyWith(color: AppStyles.textLight),
            children: [
              const TextSpan(text: 'Make sure this matches the name on your government ID.'),
              // TextSpan(
              //   text: 'preferred first name',
              //   style: AppStyles.bodySmall.copyWith(
              //     color: AppStyles.textPrimary,
              //     decoration: TextDecoration.underline,
              //   ),
              // ),
              // const TextSpan(text: '.'),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Date of birth section
        Text(
          'Date of birth',
          style: AppStyles.h4.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 16),

        GestureDetector(
          onTap: _selectBirthDate,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppStyles.textPrimary, width: 0.8),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Birthdate',
                        style: AppStyles.bodySmall.copyWith(color: AppStyles.textLight),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedBirthDate != null ? _formatBirthDate() : 'Select date',
                        style: AppStyles.bodyLarge.copyWith(
                          color: _selectedBirthDate != null ? AppStyles.textPrimary : AppStyles.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  PhosphorIcons.caretDown(),
                  color: AppStyles.textLight,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'To sign up, you need to be at least 18. Your birthday won\'t be shared with other people who use Gold Circle.',
          style: AppStyles.bodySmall.copyWith(color: AppStyles.textLight),
        ),

        const SizedBox(height: 32),

        // Email section (read-only, showing the email from previous step)
        Text(
          'Email',
          style: AppStyles.h4.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppStyles.textPrimary, width: 0.8),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email',
                style: AppStyles.bodySmall.copyWith(color: AppStyles.textLight),
              ),
              const SizedBox(height: 4),
              Text(
                _emailController.text,
                style: AppStyles.bodyLarge.copyWith(color: AppStyles.textPrimary),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'We\'ll email you project details and receipts.',
          style: AppStyles.bodySmall.copyWith(color: AppStyles.textLight),
        ),

        const SizedBox(height: 32),

        // Password section
        Text(
          'Password',
          style: AppStyles.h4.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          textInputAction: TextInputAction.done,
          style: AppStyles.bodyLarge,
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: AppStyles.bodySmall.copyWith(color: AppStyles.textLight),
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
              borderSide: BorderSide(color: AppStyles.textPrimary, width: 2),
            ),
            suffixIcon: TextButton(
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              child: Text(
                _isPasswordVisible ? 'Hide' : 'Show',
                style: AppStyles.bodyMedium.copyWith(
                  color: AppStyles.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          onFieldSubmitted: (_) => _canSignUp() ? _signUp() : null,
        ),

        if (_passwordController.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                PhosphorIcons.check(),
                color: _getPasswordStrengthColor(),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Password strength: ${_getPasswordStrength()}',
                style: AppStyles.bodySmall.copyWith(
                  color: _getPasswordStrengthColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: 32),

        // Signup button
        SizedBox(
          height: 48,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_isLoading || !_canSignUp()) ? null : _signUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyles.goldPrimary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppStyles.textLight,
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
              'Agree and continue',
              style: AppStyles.button.copyWith(color: Colors.white),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Terms and conditions
        RichText(
          text: TextSpan(
            style: AppStyles.bodySmall.copyWith(color: AppStyles.textLight),
            children: [
              const TextSpan(text: 'By selecting Agree and continue, I agree to Gold Circle\'s '),
              TextSpan(
                text: 'Terms of Service',
                style: AppStyles.bodySmall.copyWith(
                  color: AppStyles.textPrimary,
                  decoration: TextDecoration.underline,
                ),
              ),
              // const TextSpan(text: ', '),
              // TextSpan(
              //   text: 'Payments Terms of Service',
              //   style: AppStyles.bodySmall.copyWith(
              //     color: AppStyles.textPrimary,
              //     decoration: TextDecoration.underline,
              //   ),
              // ),
              const TextSpan(text: ' and acknowledge the '),
              TextSpan(
                text: 'Privacy Policy',
                style: AppStyles.bodySmall.copyWith(
                  color: AppStyles.textPrimary,
                  decoration: TextDecoration.underline,
                ),
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
      ],
    );
  }

  bool _canSignUp() {
    return _firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _selectedBirthDate != null;
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppStyles.border, width: 0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          foregroundColor: AppStyles.textPrimary,
          backgroundColor: Colors.white,
        ),
        icon: Icon(icon, size: 20),
        label: Text(
          text,
          style: AppStyles.button.copyWith(
            color: AppStyles.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
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
        leading: _currentStep != AuthStep.emailEntry
            ? IconButton(
          icon: Icon(PhosphorIcons.arrowLeft()),
          onPressed: _goBack,
        )
            : IconButton(
          icon: Icon(PhosphorIcons.x()),
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
                // Content based on current step
                if (_currentStep == AuthStep.emailEntry) _buildEmailEntry(),
                if (_currentStep == AuthStep.loginPassword) _buildLoginPassword(),
                if (_currentStep == AuthStep.signupDetails) _buildSignupDetails(),

                // Error message
                _buildErrorMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}