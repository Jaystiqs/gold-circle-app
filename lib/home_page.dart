import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:goldcircle/pages/client/services_list.dart';
import 'package:goldcircle/pages/client/portfolio_stories.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'app_styles.dart';
import 'pages/client/find_providers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedCategoryIndex = 0;
  late AnimationController _glowController;

  final List<String> _categories = ['Creative', 'Design', 'Writing'];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
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
                          _buildProvidersSection(),
                          const SizedBox(height: 18.0),
                          _buildDiscoverSection(),
                          const SizedBox(height: 24.0), // Add some bottom padding
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
      height: 150,
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
          // Navigate to the new Find Providers page
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const FindProvidersPage(),
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
              mainAxisAlignment: MainAxisAlignment.center, // Add this
              children: [
                Icon(
                  PhosphorIcons.magnifyingGlass(),
                  color: AppStyles.textBlack,
                  size: 24.0,
                ),
                const SizedBox(width: 8.0),
                Text( // Remove Expanded wrapper
                  'Find your perfect freelancer',
                  style: AppStyles.bodyLarge.copyWith(
                      color: AppStyles.textBlack,
                      letterSpacing: -0.5
                  )
                  ,
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
                      fontSize: 23,
                      height: 0.95,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        'Photography',
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
                  Image.asset('assets/icons/clipboard.png', height: 100,),
                  // Percentage text at bottom
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
          child: GestureDetector( // Make the header clickable
            onTap: () {
              // Navigate to Services page
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
          height: 190, // Increased height to accommodate text
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: [
              _buildServiceCard(
                'Photography',
                '5 available',
                'https://placehold.co/400',
                AppStyles.info,
              ),
              _buildServiceCard(
                'Graphic Design',
                'Coming soon',
                'assets/design.jpg',
                AppStyles.success,
              ),
              _buildServiceCard(
                'Video Editing',
                'Coming soon',
                'assets/video.jpg',
                AppStyles.error,
              ),
              _buildServiceCard(
                'Writing',
                'Coming soon',
                'assets/writing.jpg',
                const Color(0xFF9B59B6),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(String title, String subtitle, String imagePath, Color color) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
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
                child: Image.network(
                  'https://placeholders.io/400/400/${title}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        _getServiceIcon(title),
                        size: 50,
                        color: AppStyles.textWhite.withOpacity(0.3),
                      ),
                    );
                  },
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
                  title,
                  style: AppStyles.bodyMedium.copyWith(
                    color: AppStyles.textPrimary,
                    fontWeight: AppStyles.medium,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                // Text(
                //   subtitle,
                //   style: AppStyles.bodyMedium.copyWith(
                //     color: AppStyles.textSecondary,
                //   ),
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                // ),
              ],
            ),
          ),
        ],
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

  Widget _buildProvidersSection() {
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
              // Navigate to portfolio stories view
              final allProviders = PortfolioStoriesData.getAllProviders();
              final providerIndex = allProviders.indexWhere((p) => p.name == name);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PortfolioStoriesView(
                    providers: allProviders,
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
                padding: const EdgeInsets.all(3.0), // Space between gold border and image
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
                'GH₵500 • 2 day delivery',
                Icons.code,
                const Color(0xFF2ECC71),
                const Color(0xFF27AE60),
              ),
              _buildMomentCard(
                'Complete Website UI/UX',
                'GH₵2000 • 1 month delivery',
                Icons.design_services,
                const Color(0xFF3498DB),
                const Color(0xFF2980B9),
              ),
              _buildMomentCard(
                'Brand Identity Package',
                'GH₵1500 • 7 day delivery',
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
          // Image container
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

          // Name/Title
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

          // Profession/Subtitle
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
              borderRadius: BorderRadius.circular(10), // Updated to 10
              gradient: SweepGradient(
                colors: [
                  const Color(0xFFD4AF37), // Gold
                  const Color(0xFFF4E8C1), // Light Gold
                  const Color(0xFFB8941F), // Dark Gold
                  const Color(0xFFD4AF37), // Gold (back to start)
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
                borderRadius: BorderRadius.circular(8), // Updated to 8 (10 - 2px margin)
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