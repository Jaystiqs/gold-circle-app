import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../../utils/app_styles.dart';
import '../../creators/user_provider.dart';
import '../../creators/app_mode_provider.dart';
import '../../utils/full_page_overlay.dart';

class ProviderSelfProfilePage extends StatefulWidget {
  const ProviderSelfProfilePage({super.key});

  @override
  State<ProviderSelfProfilePage> createState() => _ProviderSelfProfilePageState();
}

class _ProviderSelfProfilePageState extends State<ProviderSelfProfilePage> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _providerData;

  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Initialize button entrance animation
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _buttonScaleAnimation = CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeOutBack,
    );

    // Start the animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _buttonAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.firebaseUser;

      if (user != null) {
        // Load user data
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        _userData = userDoc.data();

        // Load provider-specific data
        final providerDoc = await _firestore.collection('creators').doc(user.uid).get();
        _providerData = providerDoc.data();
      }

      setState(() => _isLoading = false);
    } catch (e) {
      print('Error loading user data: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        setState(() {
          _userData = null;
          _providerData = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logged out successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print('Error logging out: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _switchToClientMode() async {
    final appModeProvider = Provider.of<AppModeCreator>(context, listen: false);

    final success = await appModeProvider.switchToClientMode();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Text('Switched to Client Mode'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  appModeProvider.errorMessage ?? 'Failed to switch mode',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Widget _buildFloatingActionButton() {
    return ScaleTransition(
      scale: _buttonScaleAnimation,
      child: Consumer<AppModeCreator>(
        builder: (context, appModeProvider, child) {
          final isLoading = appModeProvider.isLoading;

          return Container(
            margin: const EdgeInsets.only(bottom: 0),
            child: ElevatedButton(
              onPressed: isLoading ? null : _switchToClientMode,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade900,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                  );
                },
                child: isLoading
                    ? SizedBox(
                  key: const ValueKey('loading'),
                  width: 28,
                  height: 28,
                  child: Lottie.asset(
                    'assets/animations/gc_main_loader.json',
                    repeat: true,
                    animate: true,
                  ),
                )
                    : Row(
                  key: const ValueKey('button'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      PhosphorIcons.arrowsLeftRight(),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Switch to Client Mode',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String get firstName => _userData?['firstName'] ?? '';
  String get lastName => _userData?['lastName'] ?? '';
  String get fullName => '${firstName} ${lastName}'.trim();
  int get totalJobs => _providerData?['totalJobs'] ?? 0;
  int get completedJobs => _providerData?['completedJobs'] ?? 0;
  double get rating => (_providerData?['rating'] ?? 0.0).toDouble();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Show loading state
        if (_isLoading && userProvider.firebaseUser != null) {
          return Scaffold(
            backgroundColor: AppStyles.backgroundWhite,
            body: Center(
              child: Container(
                height: 70,
                child: Center(
                  child: Lottie.asset(
                    'assets/animations/gc_main_loader.json',
                    repeat: true,
                    animate: true,
                  ),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppStyles.backgroundWhite,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildProfileHeader(),
                        _buildStats(),
                        _buildActionCards(),
                        _buildMenuButtons(),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: _buildFloatingActionButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppStyles.backgroundWhite,
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 16.0, 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Profile',
              style: AppStyles.h1.copyWith(
                color: AppStyles.textPrimary,
                fontWeight: AppStyles.bold,
                letterSpacing: -1.5,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              PhosphorIcons.bell(),
              color: AppStyles.textPrimary,
            ),
            onPressed: () {
              // Show notifications
            },
          ),
          const SizedBox(width: 8),
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppStyles.backgroundGrey,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    firstName.isNotEmpty ? firstName[0].toUpperCase() : 'P',
                    style: AppStyles.h1.copyWith(
                      fontSize: 20,
                      color: AppStyles.textSecondary,
                      fontWeight: AppStyles.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   bottom: 0,
              //   right: 0,
              //   child: Container(
              //     width: 18,
              //     height: 18,
              //     decoration: BoxDecoration(
              //       color: AppStyles.goldPrimary,
              //       shape: BoxShape.circle,
              //       border: Border.all(
              //         color: AppStyles.backgroundWhite,
              //         width: 2,
              //       ),
              //     ),
              //     child: Icon(
              //       PhosphorIcons.briefcase(PhosphorIconsStyle.fill),
              //       color: Colors.white,
              //       size: 8,
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          // Stack(
          //   children: [
          //     Container(
          //       width: 90,
          //       height: 90,
          //       decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: AppStyles.backgroundGrey,
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.black.withOpacity(0.2),
          //             blurRadius: 20,
          //             offset: const Offset(0, 0),
          //           ),
          //         ],
          //       ),
          //       child: Center(
          //         child: Text(
          //           firstName.isNotEmpty ? firstName[0].toUpperCase() : 'P',
          //           style: AppStyles.h1.copyWith(
          //             fontSize: 38,
          //             color: AppStyles.textSecondary,
          //             fontWeight: AppStyles.bold,
          //             letterSpacing: -0.5,
          //           ),
          //         ),
          //       ),
          //     ),
          //     Positioned(
          //       bottom: 0,
          //       right: 0,
          //       child: Container(
          //         width: 40,
          //         height: 30,
          //         decoration: BoxDecoration(
          //           color: AppStyles.goldPrimary,
          //           shape: BoxShape.circle,
          //           border: Border.all(
          //             color: AppStyles.backgroundWhite,
          //             width: 3,
          //           ),
          //         ),
          //         child: Icon(
          //           PhosphorIcons.briefcase(PhosphorIconsStyle.fill),
          //           color: Colors.white,
          //           size: 15,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 24),
          Text(
            fullName.isNotEmpty ? fullName : 'Provider',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppStyles.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                size: 20,
                color: Colors.amber,
              ),
              const SizedBox(width: 4),
              Text(
                rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 16,
                  color: AppStyles.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '•',
                style: TextStyle(
                  fontSize: 16,
                  color: AppStyles.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'response in 15 hours',
                style: TextStyle(
                  fontSize: 16,
                  color: AppStyles.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppStyles.textLight.withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total Jobs', totalJobs.toString()),
          Container(
            width: 1,
            height: 40,
            color: AppStyles.borderMedium,
          ),
          _buildStatItem('Completed', completedJobs.toString()),
          // Container(
          //   width: 1,
          //   height: 40,
          //   color: AppStyles.borderLight,
          // ),
          // _buildStatItem('Rating', rating.toStringAsFixed(1)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppStyles.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppStyles.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCards() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Post a Task Request Card (TOP - White with image)
          InkWell(
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => const PostTaskRequestPage(),
              //   ),
              // );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppStyles.goldPrimary,
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/showcase.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Update Your Showcase',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppStyles.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Its easy to show clients your past work with your showcase.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppStyles.textSecondary,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Become a Provider Card (BOTTOM - White)
          InkWell(
            onTap: () {
              // Navigate to provider registration/onboarding
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/build_profile.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Build Your Profile',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppStyles.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Your profile shows clients what you can do for them.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppStyles.textSecondary,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButtons() {
    return Container(
      child: Column(
        children: [
          _buildMenuButton(
            icon: PhosphorIcons.gear(),
            title: 'Account settings',
            onTap: () {},
          ),
          const SizedBox(height: 8),
          _buildMenuButton(
            icon: PhosphorIcons.userCircle(),
            title: 'Edit provider profile',
            onTap: () {},
          ),
          const SizedBox(height: 8),
          _buildMenuButton(
            icon: PhosphorIcons.money(),
            title: 'Earnings & Payments',
            onTap: () {},
          ),
          const SizedBox(height: 8),
          _buildMenuButton(
            icon: PhosphorIcons.trophy(),
            title: 'Rewards & achievements',
            onTap: () {},
          ),
          const SizedBox(height: 24),
          Divider(
            color: AppStyles.textSecondary.withOpacity(0.2),
            thickness: 1,
          ),
          const SizedBox(height: 16),
          _buildMenuButton(
            icon: PhosphorIcons.signOut(),
            title: 'Logout',
            onTap: _handleLogout,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isDestructive ? Colors.red : AppStyles.textPrimary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: isDestructive ? Colors.red : AppStyles.textPrimary,
                ),
              ),
            ),
            Icon(
              PhosphorIcons.caretRight(),
              size: 20,
              color: isDestructive
                  ? Colors.red.withOpacity(0.6)
                  : AppStyles.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}