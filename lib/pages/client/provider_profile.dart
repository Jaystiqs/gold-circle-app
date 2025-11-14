import 'package:flutter/material.dart';
import 'package:goldcircle/pages/client/client_creator_offer.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../utils/app_styles.dart';

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

  // Mock provider data - Social Media Marketer
  final _provider = ProviderData(
    id: '1',
    name: 'Kwame Asante',
    title: 'Digital Marketing Strategist',
    location: 'Accra, Ghana',
    imageUrl: 'https://avatar.iran.liara.run/public/boy',
    rating: 4.8,
    reviewCount: 89,
    completedProjects: 142,
    responseTime: '2 hours',
    bio: 'Results-driven social media marketer with 6+ years of experience helping businesses grow their online presence. Specialized in creating viral content, managing ad campaigns, and building engaged communities that convert. I\'ve helped 100+ brands increase their ROI through strategic digital marketing.',
    skills: [
      'Social Media Strategy',
      'Facebook & Instagram Ads',
      'Content Creation',
      'Google Ads',
      'TikTok Marketing',
      'Email Marketing',
      'SEO Optimization',
      'Analytics & Reporting',
      'Brand Development',
      'Influencer Marketing',
    ],
    languages: ['English', 'Twi', 'French'],
    education: [
      Education(
        degree: 'MBA in Digital Marketing',
        institution: 'GIMPA Business School',
        year: '2020',
      ),
      Education(
        degree: 'Google Ads Certification',
        institution: 'Google Skillshop',
        year: '2023',
      ),
      Education(
        degree: 'Facebook Blueprint Certified',
        institution: 'Meta Business',
        year: '2022',
      ),
    ],
    startingPrice: 800,
    isVerified: true,
    tier: 'Gold',
    portfolio: [
      PortfolioItem(
        id: '1',
        title: 'Restaurant Chain Campaign',
        imageUrl: 'https://placehold.co/400x500/f0f0f0/cccccc?text=Campaign',
        category: 'Food & Beverage',
      ),
      PortfolioItem(
        id: '2',
        title: 'Fashion Brand Launch',
        imageUrl: 'https://placehold.co/400x500/e8e8e8/999999?text=Fashion',
        category: 'E-commerce',
      ),
      PortfolioItem(
        id: '3',
        title: 'Tech Startup Growth',
        imageUrl: 'https://placehold.co/400x500/f5f5f5/aaaaaa?text=Tech',
        category: 'Technology',
      ),
      PortfolioItem(
        id: '4',
        title: 'Real Estate Social Media',
        imageUrl: 'https://placehold.co/400x500/ececec/bbbbbb?text=RealEstate',
        category: 'Real Estate',
      ),
      PortfolioItem(
        id: '5',
        title: 'Beauty Brand Instagram',
        imageUrl: 'https://placehold.co/400x500/e0e0e0/888888?text=Beauty',
        category: 'Beauty & Cosmetics',
      ),
    ],
    offers: [
      ServiceOffer(
        id: '1',
        title: 'Complete Social Media Management',
        description: 'Full management of 3 social media platforms including content creation, posting schedule, engagement, and monthly analytics reports',
        price: 3500,
        duration: '30 days',
        deliverables: '30 posts, 15 stories, weekly reports',
      ),
      ServiceOffer(
        id: '2',
        title: 'Social Media Audit & Strategy',
        description: 'Comprehensive analysis of your current social media presence with detailed strategy roadmap for growth',
        price: 1200,
        duration: '5 days',
        deliverables: 'Audit report, strategy document, content calendar',
      ),
      ServiceOffer(
        id: '3',
        title: 'Facebook & Instagram Ad Campaign',
        description: 'Setup and manage targeted ad campaigns to increase sales and brand awareness (ad spend not included)',
        price: 2000,
        duration: '14 days',
        deliverables: 'Ad creatives, campaign setup, optimization',
      ),
      ServiceOffer(
        id: '4',
        title: 'Content Creation Package',
        description: 'Professional content creation for your brand including graphics, videos, and copywriting',
        price: 1500,
        duration: '7 days',
        deliverables: '20 designed posts, 5 reels/videos, captions',
      ),
    ],
    reviews: [
      Review(
        id: '1',
        clientName: 'Abena Mensah',
        clientImage: 'https://avatar.iran.liara.run/public/girl',
        rating: 5.0,
        comment: 'Kwame transformed our social media presence completely! Our engagement increased by 300% and we\'ve seen a 45% boost in sales from social media. His strategies are data-driven and really work!',
        date: DateTime(2025, 10, 5), // 10 days ago
        projectType: 'Social Media Management',
      ),
      Review(
        id: '2',
        clientName: 'Joseph Osei',
        clientImage: 'https://avatar.iran.liara.run/public/boy',
        rating: 5.0,
        comment: 'The Facebook ad campaign Kwame created for our restaurant was incredible. We got 500+ new customers in just 2 weeks. His targeting was spot-on and the ROI exceeded our expectations.',
        date: DateTime(2025, 9, 20), // 25 days ago
        projectType: 'Facebook Ads Campaign',
      ),
      Review(
        id: '3',
        clientName: 'Grace Adjei',
        clientImage: 'https://avatar.iran.liara.run/public/girl',
        rating: 4.8,
        comment: 'Professional, creative, and results-oriented. Kwame helped us build a strong brand identity on social media. Our followers grew from 2K to 15K in 3 months!',
        date: DateTime(2025, 8, 15), // 2 months ago
        projectType: 'Brand Development',
      ),
      Review(
        id: '4',
        clientName: 'Emmanuel Darko',
        clientImage: 'https://avatar.iran.liara.run/public/boy',
        rating: 5.0,
        comment: 'Best investment for our e-commerce business! The content strategy and influencer partnerships Kwame arranged drove massive traffic to our store.',
        date: DateTime(2025, 7, 10), // 3 months ago
        projectType: 'E-commerce Marketing',
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
                      color: AppStyles.goldPrimary,
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
          const SizedBox(height: 32),
          Text(
            'Education',
            style: AppStyles.h5.copyWith(
              fontWeight: AppStyles.bold,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: SizedBox(
              height: 100,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.75),
                itemCount: _provider.education.length,
                padEnds: false,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _buildEducationItem(_provider.education[index]),
                  );
                },
              ),
            ),
          ),
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
            builder: (context) => CreatorOfferPage(
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
                    'GHS${offer.price}',
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
                  'GHS${_provider.startingPrice}',
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
                        foregroundColor: AppStyles.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: AppStyles.textLight),
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

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return '1 day ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 60) {
      return '1 month ago';
    } else if (difference.inDays < 90) {
      return '2 months ago';
    } else if (difference.inDays < 120) {
      return '3 months ago';
    } else if (difference.inDays < 150) {
      return '4 months ago';
    } else if (difference.inDays < 180) {
      return '5 months ago';
    } else if (difference.inDays < 365) {
      return '6 months ago';
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