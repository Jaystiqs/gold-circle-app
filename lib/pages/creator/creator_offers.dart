import 'package:flutter/material.dart';
import 'package:goldcircle/pages/creator/post_offer.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../utils/app_styles.dart';

class CreatorOffersPage extends StatefulWidget {
  const CreatorOffersPage({super.key});

  @override
  State<CreatorOffersPage> createState() => _CreatorOffersPageState();
}

class _CreatorOffersPageState extends State<CreatorOffersPage> {
  // Mock data - replace with actual Firestore query later
  final List<dynamic> _offers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadOffers();
  }

  Future<void> _loadOffers() async {
    setState(() => _isLoading = true);

    // TODO: Load offers from Firestore
    // final user = FirebaseAuth.instance.currentUser;
    // if (user != null) {
    //   final snapshot = await FirebaseFirestore.instance
    //       .collection('offers')
    //       .where('providerId', isEqualTo: user.uid)
    //       .orderBy('createdAt', descending: true)
    //       .get();
    //
    //   _offers = snapshot.docs;
    // }

    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToCreateOffer() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PostOfferPage(),
      ),
    );

    // Refresh offers list if an offer was created
    if (result == true) {
      _loadOffers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundWhite,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _offers.isEmpty
            ? _buildEmptyState()
            : _buildOffersList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Offers',
            style: AppStyles.h1.copyWith(
              color: AppStyles.textPrimary,
              fontWeight: AppStyles.bold,
              letterSpacing: -1.5,
            ),
          ),
          const Spacer(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppStyles.goldPrimary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    PhosphorIconsRegular.briefcase,
                    size: 80,
                    color: AppStyles.goldPrimary,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'No offers yet',
                  style: AppStyles.h3.copyWith(
                    fontWeight: AppStyles.bold,
                    color: AppStyles.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Create your first offer to start\nreceiving bookings from clients',
                  textAlign: TextAlign.center,
                  style: AppStyles.bodyLarge.copyWith(
                    color: AppStyles.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _navigateToCreateOffer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.textPrimary,
                    foregroundColor: AppStyles.goldPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        PhosphorIcons.tag(PhosphorIconsStyle.bold),
                        size: 20,
                        color: AppStyles.backgroundWhite,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Create An Offer',
                        style: AppStyles.button.copyWith(
                          color: AppStyles.backgroundWhite,
                          fontWeight: AppStyles.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildOffersList() {
    // TODO: Implement offers list view
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Offers',
                style: AppStyles.h1.copyWith(
                  color: AppStyles.textPrimary,
                  fontWeight: AppStyles.bold,
                  letterSpacing: -1.5,
                ),
              ),
              IconButton(
                onPressed: _navigateToCreateOffer,
                icon: Icon(
                  PhosphorIconsRegular.plus,
                  color: AppStyles.goldPrimary,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: _offers.length,
              itemBuilder: (context, index) {
                // TODO: Build offer card
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}