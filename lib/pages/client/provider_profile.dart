import 'package:flutter/material.dart';
import 'package:goldcircle/pages/client/provider_offer.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../app_styles.dart';

class ProviderProfilePage extends StatefulWidget {
  final String providerId;

  const ProviderProfilePage({
    super.key,
    required this.providerId,
  });

  @override
  State<ProviderProfilePage> createState() => _ProviderProfilePageState();
}

class _ProviderProfilePageState extends State<ProviderProfilePage> {
  bool _isLiked = false;

  // Mock provider data
  final _provider = ProviderData(
    id: '1',
    name: 'Sarah Johnson',
    title: 'Professional Photographer',
    location: 'Accra, Ghana',
    imageUrl: 'https://avatar.iran.liara.run/public/girl',
    rating: 4.9,
    reviewCount: 127,
    completedProjects: 156,
    responseTime: '1 hour',
    bio: 'Award-winning photographer specializing in portrait, event, and commercial photography. With over 8 years of experience, I bring creative vision and technical expertise to every project.',
    skills: [
      'Portrait Photography',
      'Event Photography',
      'Photo Editing',
      'Commercial Photography',
      'Product Photography',
    ],
    languages: ['English', 'French'],
    education: [
      Education(
        degree: 'Bachelor of Fine Arts',
        institution: 'University of Ghana',
        year: '2015',
      ),
      Education(
        degree: 'Photography Certification',
        institution: 'New York Film Academy',
        year: '2017',
      ),
    ],
    startingPrice: 500,
    isVerified: true,
    tier: 'Gold',
    portfolio: [
      PortfolioItem(
        id: '1',
        title: 'Wedding Portfolio',
        imageUrl: 'https://placehold.co/400x500/f0f0f0/cccccc?text=Wedding',
        category: 'Events',
      ),
      PortfolioItem(
        id: '2',
        title: 'Corporate Headshots',
        imageUrl: 'https://placehold.co/400x500/e8e8e8/999999?text=Headshots',
        category: 'Commercial',
      ),
      PortfolioItem(
        id: '3',
        title: 'Product Photography',
        imageUrl: 'https://placehold.co/400x500/f5f5f5/aaaaaa?text=Products',
        category: 'Commercial',
      ),
      PortfolioItem(
        id: '4',
        title: 'Fashion Editorial',
        imageUrl: 'https://placehold.co/400x500/ececec/bbbbbb?text=Fashion',
        category: 'Portrait',
      ),
    ],
    offers: [
      ServiceOffer(
        id: '1',
        title: 'Wedding Photography Package',
        description: 'Complete wedding coverage with 8 hours of shooting, edited photos, and online gallery',
        price: 2500,
        duration: '8 hours',
        deliverables: '300+ edited photos',
      ),
      ServiceOffer(
        id: '2',
        title: 'Corporate Headshots',
        description: 'Professional headshots for your team, includes basic retouching',
        price: 150,
        duration: '30 minutes',
        deliverables: '5 edited photos',
      ),
      ServiceOffer(
        id: '3',
        title: 'Product Photography',
        description: 'High-quality product photos for e-commerce or marketing materials',
        price: 500,
        duration: '2 hours',
        deliverables: '20 edited photos',
      ),
      ServiceOffer(
        id: '4',
        title: 'Event Coverage',
        description: 'Full event photography coverage for corporate or social events',
        price: 1200,
        duration: '4 hours',
        deliverables: '200+ edited photos',
      ),
    ],
    reviews: [
      Review(
        id: '1',
        clientName: 'Michael Chen',
        clientImage: 'https://avatar.iran.liara.run/public/boy',
        rating: 5.0,
        comment: 'Sarah exceeded all expectations! Her creativity and professionalism made our wedding photos absolutely stunning. Highly recommend!',
        date: DateTime.now().subtract(const Duration(days: 15)),
        projectType: 'Wedding Photography',
      ),
      Review(
        id: '2',
        clientName: 'Emily Davis',
        clientImage: 'https://avatar.iran.liara.run/public/girl',
        rating: 5.0,
        comment: 'Working with Sarah was an absolute pleasure. She captured the essence of our brand perfectly in the product photos.',
        date: DateTime.now().subtract(const Duration(days: 32)),
        projectType: 'Product Photography',
      ),
      Review(
        id: '3',
        clientName: 'James Wilson',
        clientImage: 'https://avatar.iran.liara.run/public/boy',
        rating: 4.8,
        comment: 'Great photographer with excellent attention to detail. The corporate headshots came out professional and polished.',
        date: DateTime.now().subtract(const Duration(days: 45)),
        projectType: 'Corporate Photography',
      ),
    ],
  );

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
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              PhosphorIcons.shareNetwork(),
              color: AppStyles.textPrimary,
            ),
            onPressed: () {
              // Share profile
            },
          ),
          IconButton(
            icon: Icon(
              _isLiked ? PhosphorIconsFill.pushPin : PhosphorIcons.pushPin(),
              color: _isLiked ? Colors.red : AppStyles.textPrimary,
            ),
            onPressed: () {
              setState(() {
                _isLiked = !_isLiked;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
            const SizedBox(height: 24),
            _buildVerificationSection(),
            const SizedBox(height: 24),
            _buildBioSection(),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(),
            ),
            const SizedBox(height: 32),
            _buildAboutSection(),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(),
            ),
            const SizedBox(height: 32),
            _buildPortfolioSection(),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(),
            ),
            const SizedBox(height: 32),
            _buildOffersSection(),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(),
            ),
            const SizedBox(height: 32),
            _buildReviewsSection(),
            const SizedBox(height: 100), // Space for bottom bar
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image with Badge
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(_provider.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (_provider.isVerified)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 24),
          // Stats Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatRow(
                  '${_provider.reviewCount}',
                  'Reviews',
                ),
                const Divider(height: 24),
                _buildStatRow(
                  '${_provider.rating}★',
                  'Rating',
                ),
                const Divider(height: 24),
                _buildStatRow(
                  _provider.tier,
                  'Tier',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String value, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: AppStyles.h4.copyWith(
            fontWeight: AppStyles.bold,
          ),
        ),
        Text(
          label,
          style: AppStyles.bodyMedium.copyWith(
            color: AppStyles.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _provider.name,
            style: AppStyles.h2.copyWith(
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
                _provider.title,
                style: AppStyles.bodyMedium.copyWith(
                  color: AppStyles.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          // const SizedBox(height: 16),
          // Row(
          //   children: [
          //     Icon(
          //       PhosphorIcons.shieldCheck(),
          //       size: 20,
          //       color: AppStyles.textPrimary,
          //     ),
          //     const SizedBox(width: 8),
          //     Text(
          //       'Verified',
          //       style: AppStyles.bodyLarge.copyWith(
          //         fontWeight: AppStyles.semiBold,
          //         decoration: TextDecoration.underline,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildBioSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _provider.bio,
            style: AppStyles.bodyLarge.copyWith(
              color: AppStyles.textPrimary,
              height: 1.6,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              // Show full bio
            },
            child: Text(
              'Read more',
              style: AppStyles.bodyLarge.copyWith(
                fontWeight: AppStyles.semiBold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills',
            style: AppStyles.h5.copyWith(
              fontWeight: AppStyles.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _provider.skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppStyles.backgroundGrey,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppStyles.border),
                ),
                child: Text(
                  skill,
                  style: AppStyles.bodyMedium.copyWith(
                    color: AppStyles.textPrimary,
                    fontWeight: AppStyles.medium,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          Text(
            'Languages',
            style: AppStyles.h5.copyWith(
              fontWeight: AppStyles.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: _provider.languages.map((language) {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppStyles.backgroundGrey,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppStyles.border),
                ),
                child: Text(
                  language,
                  style: AppStyles.bodyMedium.copyWith(
                    color: AppStyles.textPrimary,
                    fontWeight: AppStyles.medium,
                  ),
                ),
              );
            }).toList(),
          ),
          // const SizedBox(height: 32),
          // Text(
          //   'Education',
          //   style: AppStyles.h5.copyWith(
          //     fontWeight: AppStyles.bold,
          //   ),
          // ),
          // const SizedBox(height: 12),
          // Padding(
          //   padding: const EdgeInsets.only(left: 0),
          //   child: SizedBox(
          //     height: 100,
          //     child: PageView.builder(
          //       controller: PageController(viewportFraction: 0.75),
          //       itemCount: _provider.education.length,
          //       padEnds: false,
          //       itemBuilder: (context, index) {
          //         return Padding(
          //           padding: const EdgeInsets.only(right: 16),
          //           child: _buildEducationItem(_provider.education[index]),
          //         );
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildPortfolioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '${_provider.name} worked on',
            style: AppStyles.h4.copyWith(
              fontWeight: AppStyles.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: SizedBox(
            height: 280,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.75),
              itemCount: _provider.portfolio.length,
              padEnds: false,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _buildPortfolioItem(_provider.portfolio[index]),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPortfolioItem(PortfolioItem item) {
    return GestureDetector(
      onTap: () {
        // Show full portfolio item
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppStyles.backgroundGrey,
                    child: Icon(
                      PhosphorIcons.image(),
                      size: 40,
                      color: AppStyles.textLight,
                    ),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: AppStyles.semiBold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.category,
                      style: AppStyles.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOffersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '${_provider.name}\'s offers',
            style: AppStyles.h4.copyWith(
              fontWeight: AppStyles.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: SizedBox(
            height: 200,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.85),
              itemCount: _provider.offers.length,
              padEnds: false,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _buildOfferItem(_provider.offers[index]),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOfferItem(ServiceOffer offer) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProviderOfferPage(
              offerId: offer.id,
              providerId: widget.providerId,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppStyles.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    offer.title,
                    style: AppStyles.h5.copyWith(
                      fontWeight: AppStyles.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppStyles.goldPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'GH₵${offer.price}',
                    style: AppStyles.bodyMedium.copyWith(
                      color: AppStyles.textPrimary,
                      fontWeight: AppStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              offer.description,
              style: AppStyles.bodyMedium.copyWith(
                color: AppStyles.textSecondary,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            const Divider(height: 24),
            Row(
              children: [
                Icon(
                  PhosphorIcons.clock(),
                  size: 16,
                  color: AppStyles.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  offer.duration,
                  style: AppStyles.bodySmall.copyWith(
                    color: AppStyles.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  PhosphorIcons.package(),
                  size: 16,
                  color: AppStyles.textSecondary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    offer.deliverables,
                    style: AppStyles.bodySmall.copyWith(
                      color: AppStyles.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '${_provider.name}\'s reviews',
            style: AppStyles.h4.copyWith(
              fontWeight: AppStyles.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: SizedBox(
            height: 200,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.75),
              itemCount: _provider.reviews.length,
              padEnds: false,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _buildReviewItem(_provider.reviews[index]),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // Show all reviews
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: AppStyles.textPrimary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Show more reviews',
                style: AppStyles.button.copyWith(
                  color: AppStyles.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewItem(Review review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(review.clientImage),
              backgroundColor: AppStyles.backgroundGrey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                review.clientName,
                style: AppStyles.bodyLarge.copyWith(
                  fontWeight: AppStyles.semiBold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ...List.generate(5, (index) {
              return Icon(
                PhosphorIcons.star(PhosphorIconsStyle.fill),
                size: 14,
                color: AppStyles.textPrimary,
              );
            }),
            const SizedBox(width: 8),
            Text(
              '· ${_formatDate(review.date)}',
              style: AppStyles.bodyMedium.copyWith(
                color: AppStyles.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppStyles.bodyMedium.copyWith(
                color: AppStyles.textPrimary,
                height: 1.5,
              ),
              children: [
                TextSpan(text: review.comment),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationItem(Education education) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppStyles.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppStyles.backgroundGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              PhosphorIcons.graduationCap(),
              size: 24,
              color: AppStyles.textPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  education.degree,
                  style: AppStyles.bodyMedium.copyWith(
                    fontWeight: AppStyles.semiBold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  education.institution,
                  style: AppStyles.bodySmall.copyWith(
                    color: AppStyles.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            education.year,
            style: AppStyles.bodySmall.copyWith(
              color: AppStyles.textSecondary,
              fontWeight: AppStyles.medium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Starting from',
                  style: AppStyles.bodySmall.copyWith(
                    color: AppStyles.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'GH₵${_provider.startingPrice}',
                  style: AppStyles.h5.copyWith(
                    fontWeight: AppStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to booking/contact
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyles.backgroundWhite,
                        foregroundColor: AppStyles.textPrimary,  // Changed to match the border
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: AppStyles.textLight),  // Border goes here
                        elevation: 0,
                      ),
                      child: Text(
                        'Message',
                        style: AppStyles.button.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to booking/contact
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyles.goldPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Hire',
                        style: AppStyles.button.copyWith(
                          color: Colors.white,
                        ),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
}

// Data models
class ProviderData {
  final String id;
  final String name;
  final String title;
  final String location;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final int completedProjects;
  final String responseTime;
  final String bio;
  final List<String> skills;
  final List<String> languages;
  final List<Education> education;
  final double startingPrice;
  final List<PortfolioItem> portfolio;
  final List<ServiceOffer> offers;
  final List<Review> reviews;
  final bool isVerified;
  final String tier;

  ProviderData({
    required this.id,
    required this.name,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.completedProjects,
    required this.responseTime,
    required this.bio,
    required this.skills,
    required this.languages,
    required this.education,
    required this.startingPrice,
    required this.portfolio,
    required this.offers,
    required this.reviews,
    required this.isVerified,
    required this.tier,
  });
}

class PortfolioItem {
  final String id;
  final String title;
  final String imageUrl;
  final String category;

  PortfolioItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.category,
  });
}

class ServiceOffer {
  final String id;
  final String title;
  final String description;
  final double price;
  final String duration;
  final String deliverables;

  ServiceOffer({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.deliverables,
  });
}

class Review {
  final String id;
  final String clientName;
  final String clientImage;
  final double rating;
  final String comment;
  final DateTime date;
  final String projectType;

  Review({
    required this.id,
    required this.clientName,
    required this.clientImage,
    required this.rating,
    required this.comment,
    required this.date,
    required this.projectType,
  });
}

class Education {
  final String degree;
  final String institution;
  final String year;

  Education({
    required this.degree,
    required this.institution,
    required this.year,
  });
}