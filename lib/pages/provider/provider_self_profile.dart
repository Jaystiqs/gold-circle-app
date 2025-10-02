import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../app_styles.dart';
import '../../providers/user_provider.dart';

class ProviderSelfProfilePage extends StatefulWidget {
  const ProviderSelfProfilePage({super.key});

  @override
  State<ProviderSelfProfilePage> createState() => _ProviderSelfProfilePageState();
}

class _ProviderSelfProfilePageState extends State<ProviderSelfProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _providerData;

  @override
  void initState() {
    super.initState();
    _loadProviderData();
  }

  Future<void> _loadProviderData() async {
    setState(() => _isLoading = true);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.firebaseUser;

      if (user != null) {
        // Load user data
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        _userData = userDoc.data();

        // Load or create provider-specific data
        final providerDoc = await _firestore.collection('providers').doc(user.uid).get();
        if (providerDoc.exists) {
          _providerData = providerDoc.data();
        } else {
          // Create provider document if it doesn't exist
          await _createProviderDocument(user.uid);
          final newProviderDoc = await _firestore.collection('providers').doc(user.uid).get();
          _providerData = newProviderDoc.data();
        }
      }

      setState(() => _isLoading = false);
    } catch (e) {
      print('Error loading provider data: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createProviderDocument(String uid) async {
    await _firestore.collection('providers').doc(uid).set({
      'uid': uid,
      'title': '',
      'bio': '',
      'location': 'Accra, Ghana',
      'skills': [],
      'languages': ['English'],
      'education': [],
      'portfolio': [],
      'offers': [],
      'rating': 0.0,
      'reviewCount': 0,
      'completedJobs': 0,
      'activeJobs': 0,
      'earnings': 0.0,
      'startingPrice': 0.0,
      'isVerified': false,
      'tier': 'Silver',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  String get firstName => _userData?['firstName'] ?? '';
  String get lastName => _userData?['lastName'] ?? '';
  String get fullName => '${firstName} ${lastName}'.trim();
  String get email => _userData?['email'] ?? '';
  String get phoneNumber => _userData?['phoneNumber'] ?? '';
  String get title => _providerData?['title'] ?? 'Professional';
  String get bio => _providerData?['bio'] ?? '';
  String get location => _providerData?['location'] ?? 'Accra, Ghana';
  double get rating => (_providerData?['rating'] ?? 0).toDouble();
  int get reviewCount => _providerData?['reviewCount'] ?? 0;
  int get completedJobs => _providerData?['completedJobs'] ?? 0;
  int get activeJobs => _providerData?['activeJobs'] ?? 0;
  double get earnings => (_providerData?['earnings'] ?? 0).toDouble();
  bool get isVerified => _providerData?['isVerified'] ?? false;
  String get tier => _providerData?['tier'] ?? 'Silver';

  // Get photo URL from Firebase Auth
  String get photoUrl {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return userProvider.firebaseUser?.photoURL ?? '';
  }

  Future<void> _updateProfile(String fname, String lname, String providerTitle, String phone, String loc, String providerBio) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.firebaseUser;

      if (user == null) return;

      // Update Firebase Auth display name
      await user.updateDisplayName('$fname $lname');

      // Update Firestore user document
      await _firestore.collection('users').doc(user.uid).update({
        'firstName': fname,
        'lastName': lname,
        'fullName': '$fname $lname',
        'phoneNumber': phone,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update provider document
      await _firestore.collection('providers').doc(user.uid).update({
        'title': providerTitle,
        'bio': providerBio,
        'location': loc,
      });

      // Reload data
      await _loadProviderData();

      // Refresh user provider
      await userProvider.refreshUserData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppStyles.backgroundWhite,
        body: Center(
          child: CircularProgressIndicator(
            color: AppStyles.goldPrimary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppStyles.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppStyles.backgroundWhite,
        elevation: 0,
        title: Text(
          'My Profile',
          style: AppStyles.h4.copyWith(
            fontWeight: AppStyles.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              PhosphorIcons.gear(),
              color: AppStyles.textPrimary,
            ),
            onPressed: () => _showSettings(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildPerformanceStats(),
            const SizedBox(height: 24),
            _buildQuickActions(),
            const SizedBox(height: 32),
            _buildMenuSection(),
            const SizedBox(height: 32),
            _buildLogoutButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
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
                ),
                child: photoUrl.isEmpty
                    ? Center(
                  child: Text(
                    firstName.isNotEmpty ? firstName[0].toUpperCase() : 'P',
                    style: AppStyles.h1.copyWith(
                      color: AppStyles.textSecondary,
                      fontWeight: AppStyles.bold,
                    ),
                  ),
                )
                    : null,
              ),
              if (isVerified)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              Positioned(
                right: -4,
                top: -4,
                child: GestureDetector(
                  onTap: () => _editProfile(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppStyles.goldPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Icon(
                      PhosphorIcons.pencil(),
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            fullName.isNotEmpty ? fullName : 'Provider',
            style: AppStyles.h3.copyWith(
              fontWeight: AppStyles.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                PhosphorIcons.medal(),
                size: 16,
                color: AppStyles.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                title.isNotEmpty ? title : 'Professional',
                style: AppStyles.bodyMedium.copyWith(
                  color: AppStyles.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppStyles.goldPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppStyles.goldPrimary),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  PhosphorIcons.star(PhosphorIconsStyle.fill),
                  size: 16,
                  color: AppStyles.goldPrimary,
                ),
                const SizedBox(width: 6),
                Text(
                  '$tier Tier',
                  style: AppStyles.bodySmall.copyWith(
                    color: AppStyles.goldPrimary,
                    fontWeight: AppStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                PhosphorIcons.mapPin(),
                size: 16,
                color: AppStyles.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                location,
                style: AppStyles.bodyMedium.copyWith(
                  color: AppStyles.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppStyles.goldPrimary, AppStyles.goldPrimary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppStyles.goldPrimary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                PhosphorIcons.chartLine(),
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Performance Overview',
                style: AppStyles.h5.copyWith(
                  color: Colors.white,
                  fontWeight: AppStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildPerfStatItem(
                  rating > 0 ? rating.toStringAsFixed(1) : '0.0',
                  'Rating',
                  PhosphorIcons.star(PhosphorIconsStyle.fill),
                ),
              ),
              Expanded(
                child: _buildPerfStatItem(
                  '$reviewCount',
                  'Reviews',
                  PhosphorIcons.chatCircle(),
                ),
              ),
              Expanded(
                child: _buildPerfStatItem(
                  '$completedJobs',
                  'Completed',
                  PhosphorIcons.checkCircle(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerfStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppStyles.h5.copyWith(
            color: Colors.white,
            fontWeight: AppStyles.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppStyles.bodySmall.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                PhosphorIcons.lightning(),
                color: AppStyles.textPrimary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Quick Actions',
                style: AppStyles.bodyLarge.copyWith(
                  fontWeight: AppStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Active Jobs',
                  '$activeJobs',
                  PhosphorIcons.briefcase(),
                      () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Earnings',
                  'GH₵${earnings.toInt()}',
                  PhosphorIcons.wallet(),
                      () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, String value, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppStyles.backgroundGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppStyles.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24, color: AppStyles.textPrimary),
            const SizedBox(height: 12),
            Text(
              value,
              style: AppStyles.h5.copyWith(
                fontWeight: AppStyles.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppStyles.bodySmall.copyWith(
                color: AppStyles.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      children: [
        _buildMenuItem(
          PhosphorIcons.user(),
          'Edit Profile',
              () => _editProfile(),
        ),
        _buildMenuItem(
          PhosphorIcons.briefcase(),
          'My Services & Offers',
              () {},
        ),
        _buildMenuItem(
          PhosphorIcons.images(),
          'Portfolio',
              () {},
        ),
        _buildMenuItem(
          PhosphorIcons.calendar(),
          'Availability',
              () {},
        ),
        _buildMenuItem(
          PhosphorIcons.creditCard(),
          'Payment Settings',
              () {},
        ),
        _buildMenuItem(
          PhosphorIcons.chartBar(),
          'Analytics',
              () {},
        ),
        _buildMenuItem(
          PhosphorIcons.star(),
          'Reviews',
              () {},
        ),
        _buildMenuItem(
          PhosphorIcons.bell(),
          'Notifications',
              () {},
        ),
        _buildMenuItem(
          PhosphorIcons.shieldCheck(),
          'Privacy & Security',
              () {},
        ),
        _buildMenuItem(
          PhosphorIcons.question(),
          'Help & Support',
              () {},
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppStyles.backgroundGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 22,
                color: AppStyles.textPrimary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppStyles.bodyLarge.copyWith(
                  fontWeight: AppStyles.medium,
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

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => _handleLogout(),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: const BorderSide(color: Colors.red),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                PhosphorIcons.signOut(),
                color: Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                'Logout',
                style: AppStyles.button.copyWith(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditProviderProfileSheet(
        firstName: firstName,
        lastName: lastName,
        title: title,
        phoneNumber: phoneNumber,
        location: location,
        bio: bio,
        onSave: (fname, lname, providerTitle, phone, loc, providerBio) {
          _updateProfile(fname, lname, providerTitle, phone, loc, providerBio);
        },
      ),
    );
  }

  void _showSettings() {
    // Navigate to settings page
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await FirebaseAuth.instance.signOut();
      // UserProvider will handle navigation through AuthWrapper
    }
  }
}

// Edit Provider Profile Bottom Sheet
class EditProviderProfileSheet extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String title;
  final String phoneNumber;
  final String location;
  final String bio;
  final Function(String, String, String, String, String, String) onSave;

  const EditProviderProfileSheet({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.title,
    required this.phoneNumber,
    required this.location,
    required this.bio,
    required this.onSave,
  });

  @override
  State<EditProviderProfileSheet> createState() => _EditProviderProfileSheetState();
}

class _EditProviderProfileSheetState extends State<EditProviderProfileSheet> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _titleController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
    _titleController = TextEditingController(text: widget.title);
    _phoneController = TextEditingController(text: widget.phoneNumber);
    _locationController = TextEditingController(text: widget.location);
    _bioController = TextEditingController(text: widget.bio);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _titleController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Profile',
                    style: AppStyles.h4.copyWith(
                      fontWeight: AppStyles.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(PhosphorIcons.x()),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(PhosphorIcons.user()),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(PhosphorIcons.user()),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Professional Title',
                  prefixIcon: Icon(PhosphorIcons.medal()),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(PhosphorIcons.phone()),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  prefixIcon: Icon(PhosphorIcons.mapPin()),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  prefixIcon: Icon(PhosphorIcons.textAlignLeft()),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSave(
                      _firstNameController.text,
                      _lastNameController.text,
                      _titleController.text,
                      _phoneController.text,
                      _locationController.text,
                      _bioController.text,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.goldPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: AppStyles.button.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}