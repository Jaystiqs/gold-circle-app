import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goldcircle/pages/client/services_list.dart';
import 'package:goldcircle/pages/client/portfolio_stories.dart';
import 'package:goldcircle/pages/client/client_choose_subcategories.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../utils/app_styles.dart';
import 'client_find_creators.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedCategoryIndex = 0;
  late AnimationController _glowController;

  // Categories from Firestore
  List<CategoryData> _mainCategories = [];
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _loadMainCategories();
  }

  Future<void> _loadMainCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .orderBy('sortOrder')
          .get();

      setState(() {
        _mainCategories = snapshot.docs.map((doc) {
          final data = doc.data();
          return CategoryData(
            id: doc.id,
            name: data['name'] ?? '',
            displayName: data['displayName'] ?? '',
            icon: data['icon'] ?? '',
            description: data['description'] ?? '',
            subcategoryCount: data['subcategoryCount'] ?? 0,
            imageUrl: data['image'] ?? '',
          );
        }).toList();
        _isLoadingCategories = false;
      });
    } catch (e) {
      print('Error loading categories: $e');
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  IconData _getCategoryIcon(String iconName) {
    const iconMap = {
      'paintBrush': PhosphorIconsRegular.paintBrush,
      'monitor': PhosphorIconsRegular.monitor,
      'shareNetwork': PhosphorIconsRegular.shareNetwork,
      'article': PhosphorIconsRegular.article,
    };
    return iconMap[iconName] ?? PhosphorIconsRegular.briefcase;
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundWhite,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 130.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15.0),
                          _buildProjectSection(),
                          const SizedBox(height: 24.0),
                          _buildServicesSection(),
                          _buildCreatorsSection(),
                          const SizedBox(height: 18.0),
                          _buildDiscoverSection(),
                          const SizedBox(height: 24.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildFixedHeader(),
          ],
        ),
      ),
    );
  }

  Widget _buildFixedHeader() {
    return Container(
      height: 152,
      decoration: BoxDecoration(
        color: AppStyles.backgroundWhite,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
        ),
        boxShadow: [
          BoxShadow(
            color: AppStyles.black.withOpacity(0.15),
            blurRadius: 5,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppTitle(),
          _buildSearchSection(),
        ],
      ),
    );
  }

  Widget _buildAppTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        24.0,
        24.0,
        24.0,
        16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Gold Circle',
            style: AppStyles.h1.copyWith(
                color: AppStyles.goldPrimary,
                fontWeight: AppStyles.bold,
                letterSpacing: -1.5
            ),
          ),
          GlowingButton(
            controller: _glowController,
            onTap: () {
              // Add your refer & earn logic here
              print('Refer & Earn button tapped!');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 16.0),
      child: GestureDetector(
        onTap: () {
          // Navigate to the new Find Creators page
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const FindCreatorsPage(),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppStyles.backgroundGrey,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: AppStyles.textLight.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: AppStyles.black.withOpacity(0.15),
                blurRadius: 4,
                offset: const Offset(0, 0),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  PhosphorIcons.magnifyingGlass(),
                  color: AppStyles.textBlack,
                  size: 24.0,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Find your perfect freelancer',
                  style: AppStyles.bodyLarge.copyWith(
                      color: AppStyles.textBlack,
                      letterSpacing: -0.5
                  ),
                ),
                const SizedBox(width: 8.0),
                Icon(
                  PhosphorIcons.sparkle(),
                  color: AppStyles.textBlack,
                  size: 18.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 32, 24.0, 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: AppStyles.backgroundWhite,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: Colors.grey.withOpacity(0.15), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 0),
              spreadRadius: 9,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'View your current project\'s details',
                    style: AppStyles.bodyLarge.copyWith(
                      color: AppStyles.textPrimary,
                      fontWeight: AppStyles.medium,
                      fontSize: 21,
                      height: 0.95,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        'Website creation',
                        style: AppStyles.bodyMedium.copyWith(
                          color: AppStyles.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Text(
                        '2 days',
                        style: AppStyles.bodyMedium.copyWith(
                          color: AppStyles.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Icon(
                        Icons.chevron_right,
                        color: AppStyles.textSecondary,
                        size: 16.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            Container(
              width: 85,
              height: 90,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/images/clipboard.png', height: 100,),
                  Positioned(
                    bottom: 15,
                    child: Text(
                      '90%',
                      style: TextStyle(
                        color: Colors.brown[500],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ServicesListPage(),
                ),
              );
            },
            child: Row(
              children: [
                Text(
                  'Services Available',
                  style: AppStyles.h4,
                ),
                const SizedBox(width: 8.0),
                Icon(
                  Icons.chevron_right,
                  color: AppStyles.textSecondary,
                  size: 20.0,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 190,
          child: _isLoadingCategories
              ? Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppStyles.goldPrimary),
              ),
            ),
          )
              : _mainCategories.isEmpty
              ? Center(
            child: Text(
              'No categories available',
              style: AppStyles.bodyMedium.copyWith(
                color: AppStyles.textSecondary,
              ),
            ),
          )
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            itemCount: _mainCategories.length,
            itemBuilder: (context, index) {
              final category = _mainCategories[index];
              return _buildServiceCard(category);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(CategoryData category) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ClientChooseSubcategories(
              categoryId: category.id,
              categoryName: category.name,
              categoryDisplayName: category.displayName,
            ),
          ),
        );
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: AppStyles.textLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 3,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppStyles.backgroundGrey,
                  ),
                  child: category.imageUrl.isNotEmpty
                      ? Image.network(
                    category.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          _getCategoryIcon(category.icon),
                          size: 50,
                          color: AppStyles.goldPrimary,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppStyles.goldPrimary,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                      : Center(
                    child: Icon(
                      _getCategoryIcon(category.icon),
                      size: 50,
                      color: AppStyles.goldPrimary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    category.displayName,
                    style: AppStyles.bodyMedium.copyWith(
                      color: AppStyles.textPrimary,
                      fontWeight: AppStyles.medium,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getServiceIcon(String service) {
    switch (service) {
      case 'Photography':
        return Icons.camera_alt;
      case 'Graphic Design':
        return Icons.design_services;
      case 'Video Editing':
        return Icons.videocam;
      case 'Writing':
        return Icons.edit;
      default:
        return Icons.work;
    }
  }

  Widget _buildCreatorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Text(
                'Available to work for you',
                style: AppStyles.h4,
              ),
              const SizedBox(width: 8.0),
              Icon(
                Icons.chevron_right,
                color: AppStyles.textSecondary,
                size: 20.0,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: [
              _buildProviderAvatar('Sarah Johnson', 'https://avatar.iran.liara.run/public/girl'),
              _buildProviderAvatar('Michael Chen', 'https://avatar.iran.liara.run/public/boy'),
              _buildProviderAvatar('Emily Davis', 'https://avatar.iran.liara.run/public/girl'),
              _buildProviderAvatar('James Wilson', 'https://avatar.iran.liara.run/public/boy'),
              _buildProviderAvatar('Maria Garcia', 'https://avatar.iran.liara.run/public/girl'),
              _buildProviderAvatar('David Brown', 'https://avatar.iran.liara.run/public/boy'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProviderAvatar(String name, String imageUrl) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              final allCreators = PortfolioStoriesData.getAllCreators();
              final providerIndex = allCreators.indexWhere((p) => p.name == name);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PortfolioStoriesView(
                    providers: allCreators,
                    initialProviderIndex: providerIndex >= 0 ? providerIndex : 0,
                  ),
                ),
              );
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppStyles.goldPrimary,
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppStyles.goldPrimary.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: ClipOval(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppStyles.backgroundGrey,
                        ),
                        child: Icon(
                          Icons.person,
                          color: AppStyles.textSecondary,
                          size: 30,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: Text(
              name,
              style: AppStyles.bodySmall.copyWith(
                color: AppStyles.textPrimary,
                fontWeight: AppStyles.medium,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoverSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Text(
                'Featured Offers',
                style: AppStyles.h4,
              ),
              const SizedBox(width: 8.0),
              Icon(
                Icons.chevron_right,
                color: AppStyles.textSecondary,
                size: 20.0,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 270,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: [
              _buildMomentCard(
                'Professional Logo Design',
                'GHS500 • 2 day delivery',
                Icons.code,
                const Color(0xFF2ECC71),
                const Color(0xFF27AE60),
              ),
              _buildMomentCard(
                'Complete Website UI/UX',
                'GHS2000 • 1 month delivery',
                Icons.design_services,
                const Color(0xFF3498DB),
                const Color(0xFF2980B9),
              ),
              _buildMomentCard(
                'Brand Identity Package',
                'GHS1500 • 7 day delivery',
                Icons.palette,
                const Color(0xFFE74C3C),
                const Color(0xFFC0392B),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMomentCard(String name, String profession, IconData icon, Color primaryColor, Color secondaryColor) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://placehold.co/400x500/f0f0f0/cccccc?text=Photo',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          primaryColor.withOpacity(0.3),
                          secondaryColor.withOpacity(0.3),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppStyles.textPrimary,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            profession,
            style: TextStyle(
              fontSize: 14,
              color: AppStyles.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Category Data Model
class CategoryData {
  final String id;
  final String name;
  final String displayName;
  final String icon;
  final String description;
  final int subcategoryCount;
  final String imageUrl;

  CategoryData({
    required this.id,
    required this.name,
    required this.displayName,
    required this.icon,
    required this.description,
    required this.subcategoryCount,
    required this.imageUrl,
  });
}

// Custom Glowing Button Widget
class GlowingButton extends StatelessWidget {
  final AnimationController controller;
  final VoidCallback onTap;

  const GlowingButton({
    Key? key,
    required this.controller,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Container(
            width: 110,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: SweepGradient(
                colors: [
                  const Color(0xFFD4AF37),
                  const Color(0xFFF4E8C1),
                  const Color(0xFFB8941F),
                  const Color(0xFFD4AF37),
                ],
                startAngle: controller.value * 2 * math.pi,
                endAngle: (controller.value * 2 * math.pi) + (2 * math.pi),
                transform: GradientRotation(controller.value * 2 * math.pi),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Refer & Earn',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}