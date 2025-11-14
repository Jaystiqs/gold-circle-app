import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../../utils/app_styles.dart';
import '../../creators/app_mode_provider.dart';
import '../../creators/user_provider.dart';
import '../../utils/full_page_overlay.dart';
import 'post_task_request.dart';
import 'client_self_task_requests.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _clientData;

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

        // Load or create client-specific data
        final clientDoc = await _firestore.collection('clients').doc(user.uid).get();
        if (clientDoc.exists) {
          _clientData = clientDoc.data();
        } else {
          // Create client document if it doesn't exist
          await _createClientDocument(user.uid);
          final newClientDoc = await _firestore.collection('clients').doc(user.uid).get();
          _clientData = newClientDoc.data();
        }
      }

      setState(() => _isLoading = false);
    } catch (e) {
      print('Error loading user data: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createClientDocument(String uid) async {
    await _firestore.collection('clients').doc(uid).set({
      'uid': uid,
      'location': 'Accra, Ghana',
      'activeProjects': 0,
      'completedProjects': 0,
      'totalSpent': 0.0,
      'savedProviders': [],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        setState(() {
          _userData = null;
          _clientData = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logged out successfully'),
            backgroundColor: Colors.green,
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
          ),
        );
      }
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushNamed('/auth');
  }

  void _switchToProviderMode() async {
    final appModeProvider = Provider.of<AppModeCreator>(context, listen: false);

    final success = await appModeProvider.switchToCreatorMode();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Text('Switched to Provider Mode'),
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
              onPressed: isLoading ? null : _switchToProviderMode,
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
                      'Switch to Creator Mode',
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

  void _navigateToAccountSettings() {
    Navigator.of(context).pushNamed('/account-settings');
  }

  String get firstName => _userData?['firstName'] ?? '';
  String get lastName => _userData?['lastName'] ?? '';
  String get fullName => '${firstName} ${lastName}'.trim();
  String get location => _clientData?['location'] ?? 'Accra, Ghana';

  String get photoUrl {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return userProvider.firebaseUser?.photoURL ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Show loading state
        if (_isLoading && userProvider.firebaseUser != null) {
          return Scaffold(
            backgroundColor: AppStyles.backgroundWhite,
            body: Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: Lottie.asset(
                  'assets/animations/gc_main_loader.json',
                  repeat: true,
                  animate: true,
                ),
              ),
            ),
          );
        }

        // Show login prompt if not authenticated
        if (userProvider.firebaseUser == null) {
          return _buildLoginPrompt();
        }

        // Show regular profile if authenticated
        return _buildAuthenticatedProfile();
      },
    );
  }

  Widget _buildLoginPrompt() {
    return Scaffold(
      backgroundColor: AppStyles.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Log in to view profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: AppStyles.textPrimary,
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _navigateToLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyles.goldPrimary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Log in',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthenticatedProfile() {
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
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              if (userProvider.firebaseUser != null) {
                return IconButton(
                  icon: Icon(
                    PhosphorIcons.bell(),
                    color: AppStyles.textPrimary,
                  ),
                  onPressed: () {
                    // Show notifications
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppStyles.backgroundGrey,
                      image: photoUrl.isNotEmpty
                          ? DecorationImage(
                        image: NetworkImage(photoUrl),
                        fit: BoxFit.cover,
                      )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: photoUrl.isEmpty
                        ? Center(
                      child: Text(
                        firstName.isNotEmpty ? firstName[0].toUpperCase() : 'U',
                        style: AppStyles.h1.copyWith(
                            fontSize: 38,
                            color: AppStyles.textSecondary,
                            fontWeight: AppStyles.bold,
                            letterSpacing: -0.5
                        ),
                      ),
                    )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppStyles.goldPrimary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppStyles.backgroundWhite,
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        PhosphorIcons.shieldCheck(PhosphorIconsStyle.fill),
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                fullName.isNotEmpty ? fullName : 'User',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppStyles.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 0),
              Text(
                location,
                style: TextStyle(
                  fontSize: 16,
                  color: AppStyles.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 40),
              _buildActionCards(),
              const SizedBox(height: 18),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards() {
    return Column(
      children: [
        // Post a Task Request Card (TOP - White with image)
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PostTaskRequestPage(),
              ),
            );
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
                      'assets/images/tasks_lady.png',
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
                        'Post a Task Request',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppStyles.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Let providers bid on your project. Get the best offers!',
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
                      'assets/images/freelancer.png',
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
                        'Become a creator',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppStyles.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'It\'s easy to start providing services and earn extra income.',
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
    );
  }

  Widget _buildMenuButtons() {
    return Container(
      child: Column(
        children: [
          _buildMenuButton(
            icon: PhosphorIcons.clipboardText(),
            title: 'My Task Requests',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ClientSelfTaskRequestsPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildMenuButton(
            icon: PhosphorIcons.gear(),
            title: 'Account settings',
            onTap: _navigateToAccountSettings,
          ),
          const SizedBox(height: 8),
          _buildMenuButton(
            icon: PhosphorIcons.user(),
            title: 'View profile',
            onTap: () {
              // Navigate to view profile
            },
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